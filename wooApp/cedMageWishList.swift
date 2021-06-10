/**
 * CedCommerce
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the End User License Agreement (EULA)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://cedcommerce.com/license-agreement.txt
 *
 * @category  Ced
 * @package   MageNative
 * @author    CedCommerce Core Team <connect@cedcommerce.com >
 * @copyright Copyright CEDCOMMERCE (http://cedcommerce.com/)
 * @license      http://cedcommerce.com/license-agreement.txt
 */

import UIKit

class mageWooWishList: mageBaseViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var mainWishtable: UITableView!
    
    @IBOutlet weak var emptyImageView: UIImageView!
    
    var wishListdata = [[String:String]]()
    var selectedQty = "1" 
    var currencySymbol = String()
    override func viewDidLoad() {
        //--edited10May   self.tracking(name: "wishlist");
        super.viewDidLoad()
        mainWishtable.delegate = self
        mainWishtable.dataSource = self
        getWishData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
        self.updateBadge()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return wishListdata.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "wishLabel") as? mageWooWishCell
            cell?.totalItems.text = "Total Items : ".localized+String(wishListdata.count);
            return cell!
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "wishCell") as? mageWooWishCell {
            let product = wishListdata[indexPath.row]
            cell.productName.text = product["productName"]
            if let imageUrl = product["productImage"] {
                /*if let userdefaults = UserDefaults.standard.value(forKey: "themeSettings") as? [String:String]
                {
                    if let placeholderImage = userdefaults["ced_theme_product_placeholder_image"]
                    {
                        cell.productimage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(url: URL(string: placeholderImage)))
                    }
                    else
                    {
                        cell.productimage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
                    }
                    
                }*/
                cell.productimage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(contentsOfFile: wooSetting.productPlaceholder))
                
                
            }
            cell.deleteFromWish.tag=Int(product["productId"]!)!
            /*if(product["regularPrice"] != "")
            {
                cell.regularPrice.text = product["regularPrice"]!;
            }*/
            if let productPrice = product["productPrice"]
            {
                cell.regularPrice.text = productPrice;
            }
            if(product["salePrice"] != "" && product["salePrice"] != nil)
            {
                if let regularPrice = product["regularPrice"]
                {
                    let offerPrice=NSMutableAttributedString(string: regularPrice);
                    offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                    cell.compareAt.attributedText=offerPrice
                    //cell?.regularPrice.text = regularPrice;
                }
            }
            else
            {
                let offerPrice=NSMutableAttributedString(string: "");
                offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                cell.compareAt.attributedText=offerPrice
            }
            if(product["sale"] != "")
            {
                let min_price = product["product_price_min"];
                let max_price = product["product_price_max"];
                let min_reg_price = product["product_price_min_reg"];
                let max_reg_price = product["product_price_max_reg"];
                if(min_price != max_price)
                {
                    cell.regularPrice.text = product["currencySymbol"]!+min_price!+" - "+product["currencySymbol"]!+max_price!
                }
                else if(product["sale"] == "true" && min_reg_price == max_reg_price)
                {
                    cell.regularPrice.text = product["currencySymbol"]!+min_price!+" - "+product["currencySymbol"]!+max_reg_price!
                }
                else
                {
                    cell.regularPrice.text = product["currencySymbol"]!+min_price!
                }
                let offerPrice=NSMutableAttributedString(string: "");
                offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                cell.compareAt.attributedText=offerPrice
            }
            cell.deleteFromWish.addTarget(self, action: #selector(wishButtonPressed(_:)), for: .touchUpInside);
            
            cell.outOfStockLabel.text = "OUT OF STOCK!"
            cell.outOfStockLabel.font = mageWooCommon.setCustomFont(type: .medium, size: 12.0)
            if let stockStatus = product["stockLabel"]
            {
                if stockStatus == "false"
                {
                    cell.outOfStockLabel.isHidden = false
                    cell.outOfStockLabel.backgroundColor = wooSetting.themeColor
                    cell.outOfStockLabel.backgroundColor?.withAlphaComponent(0.6)
                    cell.outOfStockLabel.alpha = 0.7
                    cell.outOfStockLabel.textColor = UIColor.white
                }
                else
                {
                    cell.outOfStockLabel.isHidden = true
                    cell.outOfStockLabel.backgroundColor = UIColor.clear                    
                }
            }
            
            cell.qtyView.productQty.text = "1"
            cell.qtyView.productQty.delegate = self
            cell.qtyView.superView.layer.cornerRadius=15
            cell.qtyView.incrementButton.clipsToBounds = true;
            cell.qtyView.superView.backgroundColor = .clear
            cell.qtyView.incrementButton.tag = indexPath.row
            cell.qtyView.decrementButon.tag = indexPath.row
            
            cell.qtyView.incrementButton.addTarget(self, action: #selector(incrementProductQty(_:)), for: .touchUpInside)
            cell.qtyView.decrementButon.addTarget(self, action: #selector(decrementProductQty(_:)), for: .touchUpInside)
            cell.addToCartButton.tag = indexPath.row
            cell.addToCartButton.addTarget(self, action: #selector(addTocart(sender:)), for: .touchUpInside)
            cell.addToCartButton.setThemeColor()
            cell.addToCartButton.setTitleColor(wooSetting.textColor, for: .normal)
            cell.addToCartButton.layer.cornerRadius = 5.0
            cell.cellView.cardView();
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
           // return 95
            return 150
        }
        return 140
    }
    
    func getWishData(){
        print("HelloWishList")
        wishListdata = [[String:String]]()
        if let user = User().getLoginUser() {
            print(user)
            cedMageLoaders.addDefaultLoader(me: self)
            mageRequets.sendHttpRequest(endPoint: "mobiconnect/fetch_user_wishlist", method: "POST",params: ["user-id":user["userId"]!], controller: self, completionHandler: {
                data,url,error in
                if let data = data {
                    cedMageLoaders.removeLoadingIndicator(me: self)
                    if let json = try? JSON(data:data){
                        print(json)
                        if json["status"].stringValue == "200ok" {
                            for product in json["wishlist"].arrayValue {
                                var product_price_min = "";
                                var product_price_max = "";
                                var product_price_min_reg = "";
                                var product_price_max_reg = "";
                                //if(product["product_price_min"])
                                var salePrice = "";
                                var sale = ""
                                var productPrice = ""
                                if(product["sale"].exists())
                                {
                                    sale = product["sale"].stringValue
                                    product_price_min = product["product_price_min"].stringValue;
                                    product_price_max = product["product_price_max"].stringValue;
                                    product_price_min_reg = product["product_price_min_reg"].stringValue;
                                    product_price_max_reg = product["product_price_max_reg"].stringValue;
                                }
                                else
                                {
                                    productPrice = product["product_price"].stringValue
                                }
                                if(product["sale_price"].exists())
                                {
                                    salePrice = product["sale_price"].stringValue;
                                }
                                self.wishListdata.append(["productId":product["product_id"].stringValue,"productName":product["product_name"].stringValue,"productImage":product["product_image"].stringValue,"regularPrice":product["regular_price"].stringValue,"currencySymbol":product["currency_symbol"].stringValue,"productPrice":productPrice,"salePrice":salePrice,"product_price_min":product_price_min,"product_price_max":product_price_max,"product_price_min_reg":product_price_min_reg,"product_price_max_reg":product_price_max_reg,"sale":sale, "stockLabel":product["is_in_stock"].stringValue])
                            }
                            
                            self.mainWishtable.reloadData()
                            self.emptyImageView.isHidden=true;
                            if(self.wishListdata.count == 0)
                            {
                                self.emptyImageView.isHidden=false;
                                self.mainWishtable.isHidden=true;
                            }
                        }
                        else
                        {
                            self.emptyImageView.isHidden=false;
                            self.mainWishtable.isHidden=true;
                        }
                    }
                    
                }
            })
        }
    }
    
    @objc func wishButtonPressed(_ sender: UIButton){
        let tag=String(sender.tag)
        if User().getLoginUser() != nil {
            //let id=user["userId"]!
            
            User().wooAddToWishList(productId: tag, control: self, completion: {
                data in
                if let data = data {
                    if let json = try? JSON(data:data)
                    {
                        print(json)
                        if let jsonData=json["message"].string{
                            if jsonData=="Product removed from wishlist"{
                                //sender.setImage(UIImage(named: "wishempty"), for: .normal)
                                self.view.makeToast(jsonData, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                                mageWooCommon.delay(delay: 2.0, closure: {
                                    self.getWishData();
                                })
                            }
                            else if jsonData=="Product added to wishlist"
                            {
                                //sender.setImage(UIImage(named: "wishfilled"), for: .normal)
                                self.view.makeToast(jsonData, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                            }
                        }
                    }
                    
                    
                    
                }
            })
            
        }
        else{
            parent?.view.makeToast("Please Login First...!".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1)
        {
            let productId=wishListdata[indexPath.row]["productId"]
            let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
            viewControl.productId = productId!
            self.navigationController?.pushViewController(viewControl, animated: true)
        }
        
    }
    
}


extension mageWooWishList
{
    @objc func incrementProductQty(_ sender:UIButton){
        print("incrementProductQty")
        print(sender.tag)
        if let outerView = sender.superview?.superview?.superview as? ProductQtyView
        {
            //print(outerView.productQty.text)
            if(outerView.productQty.text == ""){
                outerView.productQty.text = String("1");
                return;
            }
            
            if(outerView.productQty.text != ""){
                var currentQty = Int(outerView.productQty.text!)!;
                currentQty = currentQty+1;
                
                outerView.productQty.text = String(currentQty);
            }
            selectedQty=outerView.productQty.text!
            print(selectedQty)
        }
    }
    
    @objc func decrementProductQty(_ sender:UIButton){
        print("decrementProductQty")
        print(sender.tag)
        if let outerView = sender.superview?.superview?.superview as? ProductQtyView
        {
            //print(outerView.productQty.text)
            if(outerView.productQty.text != "" && outerView.productQty.text != "1"){
                var currentQty = Int(outerView.productQty.text!)!;
                currentQty = currentQty-1;
                outerView.productQty.text = String(currentQty);
            }
            selectedQty=outerView.productQty.text!
            print(selectedQty)
            
        }
    }
    
    @objc func addTocart(sender:UIButton) {
        print("addTocart clicked")
        let index = sender.tag
        print(index)
       
        print("type = \(wishListdata[index])")
        //        print(selectedQty)
        if(wishListdata[index]["productType"]=="variable")
        {
            let data=wishListdata[index]
            let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
            viewControl.productId = data["productId"]!
            self.navigationController?.pushViewController(viewControl, animated: true)
            return;
        }
        else
        {
            var params = Dictionary<String, String>()
            params["product_id"] = wishListdata[index]["productId"]!
            params["qty"]        = selectedQty
            if let user = User().getLoginUser() {
                params["customer_id"] = user["userId"]
            }
            else{
                if let cartId = UserDefaults.standard.value(forKey: "cart_id")
                {
                    params["cart_id"] = cartId as? String
                }
            }
            
            mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/addtocart",method: "POST", params:params, controller: self, completionHandler: {
                data,url,error in
                if let data = data {
                    if let json  = try? JSON(data:data)
                    {
                        print(json)
                        if(json["cart_id"]["success"].stringValue == "true")
                        {
                            self.view.makeToast(json["cart_id"]["message"].stringValue, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                            UserDefaults.standard.setValue(json["cart_id"]["cart_id"].stringValue, forKey: "cart_id")
                            if let cartCount = UserDefaults.standard.value(forKey: "CartQuantity") as? String
                            {
                                let qtyCount = Int(cartCount)! + Int(json["cart_id"]["items_count"].stringValue)!;
                                UserDefaults.standard.setValue(String(qtyCount), forKey: "CartQuantity");
                            }
                            else
                            {
                                let qtyCount = json["cart_id"]["items_count"].stringValue;
                                UserDefaults.standard.setValue(qtyCount, forKey: "CartQuantity");
                            }
                            UserDefaults.standard.synchronize()
                            self.updateBadge();
                        }
                        else
                        {
                            self.view.makeToast(json["cart_id"]["message"].stringValue, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                        }
                    }
                }
            })
        }
    }
}
