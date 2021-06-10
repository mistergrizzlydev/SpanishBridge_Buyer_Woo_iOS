//
//  cedMageCategoryProductCell.swift
//  wooApp
//
//  Created by cedcoss on 25/01/18.
//  Copyright © 2018 MageNative. All rights reserved.
//

import UIKit

class cedMageCategoryProductCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {

    var parent = cedMageSubCategories();
    var productData = [[String:String]]()
    @IBOutlet weak var mainCollectionView: UICollectionView!
    var currentView = "list"
    
    var selectedQty = "1"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func reloadData()
    {
        mainCollectionView.delegate = self;
        mainCollectionView.dataSource = self;
        mainCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productData.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cedMageCategoryProdCollectionCell", for: indexPath) as? cedMageCategoryProdCollectionCell
        {
            UIView.animate(withDuration: 0.5, delay: 0.5 * Double(indexPath.row), usingSpringWithDamping: 5, initialSpringVelocity: 2, options: indexPath.row % 2 == 0 ? .transitionFlipFromLeft : .transitionFlipFromRight, animations: {

                if indexPath.row % 2 == 0 {
                    UIViewController.viewSlideInFromLeft(toRight: cell)
                }
                else {
                    UIViewController.viewSlideInFromRight(toLeft: cell)
                }

            }, completion: { (done) in
                //cell.isAnimated = true
            })
            
            let data=productData[indexPath.row]
            let imageUrl=data["productImage"]?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            cell.productImageView.sd_setImage(with: URL(string: imageUrl!), placeholderImage: UIImage(contentsOfFile: wooSetting.productPlaceholder))
            cell.cellCardView.cardView()
            cell.saleTagLabel.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
            cell.productPrice.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
            cell.regularPrice.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
            cell.productNameLabel.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
            if(data["sale"] == "true")
            {
                cell.saleTagLabel.isHidden = false;
            }
            else
            {
                cell.saleTagLabel.isHidden = true;
            }
            if let productPrice = data["productPrice"]
            {
                cell.productPrice.text = productPrice;
            }
            if(data["salePrice"] != "" && data["salePrice"] != nil)
            {
                if let regularPrice = data["regularPrice"]
                {
                    let offerPrice=NSMutableAttributedString(string: regularPrice);
                    offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                    cell.regularPrice.attributedText=offerPrice
                    //cell?.regularPrice.text = regularPrice;
                }
            }
            else
            {
                let offerPrice=NSMutableAttributedString(string: "");
                offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                cell.regularPrice.attributedText=offerPrice
            }
            
            if(data["sale"] != nil && data["sale"] != "")
            {
                let min_price = data["product_price_min"];
                let max_price = data["product_price_max"];
                let min_reg_price = data["product_price_min_reg"];
                let max_reg_price = data["product_price_max_reg"];
                if(min_price != max_price)
                {
                    cell.saleTagLabel.isHidden = false;
                    cell.productPrice.text = data["currencySymbol"]!+min_price!+" - "+data["currencySymbol"]!+max_price!
                }
                else if(data["sale"] == "true" && min_reg_price == max_reg_price)
                {
                    cell.saleTagLabel.isHidden = false;
                    cell.productPrice.text = data["currencySymbol"]!+min_price!+" - "+data["currencySymbol"]!+max_reg_price!
                }
                else
                {
                    cell.productPrice.text = data["currencySymbol"]!+min_price!
                }
                let offerPrice=NSMutableAttributedString(string: "");
                offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                cell.regularPrice.attributedText=offerPrice
            }
            if data["wishlist"]=="no"{
                cell.wishlist.setImage(UIImage(named: "wishempty"), for: .normal)
            }
            else{
                cell.wishlist.setImage(UIImage(named: "wishfilled"), for: .normal)
            }
            
            cell.wishlist.tag=indexPath.row
            cell.wishlist.addTarget(self, action: #selector(wishButtonPressed(_:)), for: .touchUpInside)
            cell.productNameLabel.text=data["productName"]
            
            cell.outOfStockLabel.text = "OUT OF STOCK!"
            cell.outOfStockLabel.font = mageWooCommon.setCustomFont(type: .medium, size: 12.0)
          
            if let stockStatus = data["stockLabel"]
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
            
            
            
            return cell;
        }
        return UICollectionViewCell();
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data=productData[indexPath.row]
        let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
        viewControl.productId = data["productId"]!
        parent.navigationController?.pushViewController(viewControl, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(currentView == "list")
        {
            if(UIDevice.current.model.lowercased() == "ipad")
            {
                 return collectionView.calculateCellSize(numberOfColumns: 4, of: 75)
            }
            return collectionView.calculateCellSize(numberOfColumns: 2, of: 75)
        //     return collectionView.calculateCellSize(numberOfColumns: 2, of: 125)
        }
        else
        {
            return collectionView.calculateCellSize(numberOfColumns: 1, of: 75)
          //  return collectionView.calculateCellSize(numberOfColumns: 1, of: 125)
        }
       
    }
    
    @objc func wishButtonPressed(_ sender: UIButton){
        let tag=sender.tag
        let data=productData[tag]
        let productId=data["productId"]!
        if User().getLoginUser() != nil {
            //let id=user["userId"]!
            
            User().wooAddToWishList(productId: productId, control: parent, completion: {
                data in
                if let data = data {
                    if let json = try? JSON(data:data){
                        print(json)
                        if let jsonData=json["message"].string{
                            if jsonData=="Product removed from wishlist"{
                                self.productData[tag]["wishlist"] = "no";
                                if let vc = self.parent as? cedMageSubCategories{
                                    vc.productsData[tag]["wishlist"] = "no";
                                }
                                sender.setImage(UIImage(named: "wishempty"), for: .normal)
                                self.parent.view.makeToast("Product removed from wishlist.".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                            }
                            else if jsonData=="Product added to wishlist"
                            {
                                self.productData[tag]["wishlist"] = "yes";
                                if let vc = self.parent as? cedMageSubCategories{
                                    vc.productsData[tag]["wishlist"] = "yes";
                                }
                                sender.setImage(UIImage(named: "wishfilled"), for: .normal)
                                self.parent.view.makeToast("Product added to wishlist.".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                            }
                        }
                    }
                }
            })
            
        }
        else{
            parent.view.makeToast("Please Login First...!".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension cedMageCategoryProductCell
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
        print("type = \(productData[index]["productType"])")
        //        print(selectedQty)
        if(productData[index]["productType"]=="variable")
        {
            let data=productData[index]
            let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
            viewControl.productId = data["productId"]!
            parent.navigationController?.pushViewController(viewControl, animated: true)
            return;
        }
        else
        {
            var params = Dictionary<String, String>()
            params["product_id"] = productData[index]["productId"]!
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
            
            mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/addtocart",method: "POST", params:params, controller: self.parent, completionHandler: {
                data,url,error in
                if let data = data {
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
