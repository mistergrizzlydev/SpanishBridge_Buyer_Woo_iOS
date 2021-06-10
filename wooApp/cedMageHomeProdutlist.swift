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

class mageHomeProdutlist: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITextFieldDelegate {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productCollection: UICollectionView!
    var productsData = [[String:String]]()
    var parent = UIViewController()
    var title = String();
    var selectedQty = "1"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func reloadData()
    {
        productCollection.delegate = self
        productCollection.dataSource = self
        productCollection.reloadData();
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productsCell", for: indexPath) as? cedMageHomeCollectionCell
        let data  = productsData[indexPath.row]
        if(title == "BEST SELLING".localized)
        {
            if let imageUrl = data["productImage"] {
                //print("my imageUrl = \(imageUrl)")
            if imageUrl != ""
            {
                cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(contentsOfFile:wooSetting.productPlaceholder))
            }
            else
            {
                cell?.productImageView.image = UIImage(contentsOfFile:wooSetting.productPlaceholder)
            }
                
                cell?.productName.text=data["productName"]
               /* if(product["sale"] == "true")
                {
                    cell.saleTagLabel.isHidden = false;
                }
                else
                {
                    cell.saleTagLabel.isHidden = true;
                }*/
                if let productPrice = data["productPrice"]
                {
                    cell?.productPrice.text = productPrice;
                }
                if(data["salePrice"] != "" && data["salePrice"] != nil)
                {
                    //cell.saleTagLabel.isHidden = false;
                    if let regularPrice = data["regularPrice"]
                    {
                        let offerPrice=NSMutableAttributedString(string: regularPrice);
                        offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                        cell?.regularPrice.attributedText=offerPrice
                        //cell?.regularPrice.text = regularPrice;
                    }
                }
                else
                {
                   // cell.saleTagLabel.isHidden = true;
                    let offerPrice=NSMutableAttributedString(string: "");
                    offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                    cell?.regularPrice.attributedText=offerPrice
                }
                if(data["sale"] != "" && data["sale"] != nil)
                {
                    let min_price = data["product_price_min"];
                    let max_price = data["product_price_max"];
                    let min_reg_price = data["product_price_min_reg"];
                    let max_reg_price = data["product_price_max_reg"];
                    if(min_price != max_price)
                    {
                       // cell.saleTagLabel.isHidden = false;
                        cell?.productPrice.text = data["currencySymbol"]!+min_price!+" - "+data["currencySymbol"]!+max_price!
                    }
                    else if(data["sale"] == "true" && min_reg_price == max_reg_price)
                    {
                       // cell?.saleTagLabel.isHidden = false;
                        cell?.productPrice.text = data["currencySymbol"]!+min_price!+" - "+data["currencySymbol"]!+max_reg_price!
                    }
                    else
                    {
                        cell?.productPrice.text = data["currencySymbol"]!+min_price!
                    }
                    let offerPrice=NSMutableAttributedString(string: "");
                    offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                    cell?.regularPrice.attributedText=offerPrice
                }
                
                
            //print(wooSetting.productPlaceholder)
                //cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(url: URL(string: wooSetting.productPlaceholder)))
          
              
                
                /*
                 //original code
                
                if let userdefaults = UserDefaults.standard.value(forKey: "themeSettings") as? [String:String]
                {
                    if let placeholderImage = userdefaults["ced_theme_product_placeholder_image"]
                    {
                        cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(url: URL(string: placeholderImage)))
                    }
                    else
                    {
                        cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
                    }
                    
                }
                */
                
                cell?.outOfStockLabel.text = "OUT OF STOCK!"
                cell?.outOfStockLabel.font = mageWooCommon.setCustomFont(type: .medium, size: 12.0)
                
                
                if let stockStatus = data["stockLabel"]
                {
                    if stockStatus == "false"
                    {
                        cell?.outOfStockLabel.isHidden = false
                        cell?.outOfStockLabel.backgroundColor = wooSetting.themeColor
                        cell?.outOfStockLabel.backgroundColor?.withAlphaComponent(0.6)
                        cell?.outOfStockLabel.alpha = 0.7
                        cell?.outOfStockLabel.textColor = UIColor.white
                    }
                    else
                    {
                        cell?.outOfStockLabel.isHidden = true
                        cell?.outOfStockLabel.backgroundColor = UIColor.clear
                    }
                }
                
                cell?.qtyView.productQty.text = "1"
                cell?.qtyView.productQty.delegate = self
                cell?.qtyView.superView.layer.cornerRadius=15
                cell?.qtyView.incrementButton.clipsToBounds = true;
                cell?.qtyView.superView.backgroundColor = .clear
                cell?.qtyView.incrementButton.tag = indexPath.row
                cell?.qtyView.decrementButon.tag = indexPath.row
                
                cell?.qtyView.incrementButton.addTarget(self, action: #selector(incrementProductQty(_:)), for: .touchUpInside)
                cell?.qtyView.decrementButon.addTarget(self, action: #selector(decrementProductQty(_:)), for: .touchUpInside)
                cell?.addToCartButton.tag = indexPath.row
                cell?.addToCartButton.addTarget(self, action: #selector(addTocart(sender:)), for: .touchUpInside)
                cell?.addToCartButton.setThemeColor()
                cell?.addToCartButton.setTitleColor(wooSetting.textColor, for: .normal)
                cell?.addToCartButton.layer.cornerRadius = 5.0
                
                
                
                cell?.cellView.cardView();
            }
        }
        else
        {
            if let imageUrl = data["banner_url"] {
                if imageUrl != ""
                {
                    //cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(url: URL(string: wooSetting.productPlaceholder)))
                    cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(contentsOfFile: wooSetting.bannerPlaceholder))
                }
                else
                {
                    cell?.productImageView.image = UIImage(contentsOfFile: wooSetting.bannerPlaceholder)
                }
                
                
              /*  if let userdefaults = UserDefaults.standard.value(forKey: "themeSettings") as? [String:String]
                {
                    if let placeholderImage = userdefaults["ced_theme_product_placeholder_image"]
                    {
                        cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(url: URL(string: placeholderImage)))
                    }
                    else
                    {
                        cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
                    }
                    
                }*/
                
            }
        }
        return cell!
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(title == "BEST SELLING".localized)
        {
            if(UIDevice().model.lowercased() == "ipad".lowercased()){
                return CGSize(width: collectionView.frame.width/4-10, height: collectionView.frame.height-10)
            }
           return CGSize(width: UIScreen.main.bounds.width/2 - 15, height: productCollection.frame.height - 10)
        }
        else
        {
            if(UIDevice().model.lowercased() == "ipad".lowercased()){
                return CGSize(width: collectionView.frame.width-10, height: collectionView.frame.height-10)
            }
            return CGSize(width: UIScreen.main.bounds.width, height: productCollection.frame.height - 10)
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(title == "BEST SELLING".localized)
        {
            if let productId = productsData[indexPath.row]["productId"]{
                let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
                viewControl.productId = productId
                //parent.present(viewControl, animated: true, completion: nil)
                parent.navigationController?.pushViewController(viewControl, animated: true)
            }
        }
        else
        {
            let banner = productsData[indexPath.row]
            if(banner["link_to"] == "product"){
                let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
                viewControl.productId = banner["link_id"]!
                parent.navigationController?.pushViewController(viewControl, animated: true)
                
            }
            else if(banner["link_to"] == "category"){
                /*let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "categoryProducts") as! CategoryProductsView
                vc.categoryId=banner["link_id"]!
                parent.navigationController?.pushViewController(vc, animated: true)*/
                /*let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageSubCategories") as! cedMageSubCategories
                vc.categoryId=banner["link_id"]!
                
                parent.navigationController?.pushViewController(vc, animated: true)*/
                let page = 1;
                let categoryId = banner["link_id"]!
                User().subCategoryRequest(categoryId: categoryId, page: page, controller: parent) { (subcat) in
                    cedMageLoaders.removeLoadingIndicator(me: self.parent);
                    let categoryData = subcat["category"]!;
                    let productsData = subcat["product"]!;
                    let mainCategoryData = subcat["maincategory"]![0]
                    if categoryData.count==0 && productsData.count > 0{
                        let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "categoryProducts") as! CategoryProductsView
                        //vc.productsData=productsData
                        vc.categoryId=categoryId;
                        self.parent.navigationController?.pushViewController(vc, animated: true)
                    }
                    else
                    {
                        let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageSubCategories") as! cedMageSubCategories
                        let category = ["name":mainCategoryData["name"],"image":mainCategoryData["image"]];
                        if let categData = category as? [String:String]{
                            vc.categData = categData;
                            
                            vc.categoryId = categoryId;
                            self.parent.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                    }
                }
                
            }
            else if(banner["link_to"] == "website"){
                let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webController") as! mageHomeWebController
                vc.url=banner["link_id"]!
                parent.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension mageHomeProdutlist
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
       
        print("type = \(productsData[index])")
        //        print(selectedQty)
        if(productsData[index]["productType"]=="variable")
        {
            let data=productsData[index]
            let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
            viewControl.productId = data["productId"]!
            parent.navigationController?.pushViewController(viewControl, animated: true)
            return;
        }
        else
        {
            var params = Dictionary<String, String>()
            params["product_id"] = productsData[index]["productId"]!
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
            cedMageLoaders.addDefaultLoader(me: self.parent)
            mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/addtocart",method: "POST", params:params, controller: self.parent, completionHandler: {
                data,url,error in
                if let data = data {
                    cedMageLoaders.removeLoadingIndicator(me: self.parent)
                    if let json  = try? JSON(data:data)
                    {
                        print(json)
                        if(json["cart_id"]["success"].stringValue == "true")
                        {
                            self.parent.view.makeToast(json["cart_id"]["message"].stringValue, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
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
                            self.parent.updateBadge();
                        }
                        else
                        {
                            self.parent.view.makeToast(json["cart_id"]["message"].stringValue, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                        }
                    }
                }
            })
        }
    }
}
