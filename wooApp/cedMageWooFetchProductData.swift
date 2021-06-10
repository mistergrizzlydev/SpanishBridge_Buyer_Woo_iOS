//
//  mageWooFetchProductData.swift
//  wooApp
//
//  Created by CEDCOSS Technologies Private Limited on 11/07/17.
//  Copyright © 2017 MageNative. All rights reserved.
//

import Foundation
extension mageWooProductView {
    
    func fetchProductData(json:JSON) {
        print("fetch")
        print(json)
        if json["status"].stringValue == "200Ok" {
            wishlistCheck = json["product_data"]["wishlist"].stringValue
            productData["enable-qrcode"] = json["product_data"]["enable-qrcode"].stringValue;
            productData["productName"] = json["product_data"]["name"].stringValue
            productData["sku"] = json["product_data"]["sku"].stringValue;
            productData["productId"] = json["product_data"]["id"].stringValue
            productData["productImage"] = json["product_data"]["product_image"].stringValue
            productData["productType"] = json["product_data"]["product-type"].stringValue
            productData["short_description"] = json["product_data"]["short_description"].stringValue;
            if(json["product_data"]["product-gallery-status"].stringValue == "true")
            {
                for gallery in json["product_data"]["product-gallery"].arrayValue
                {
                    galleryImages.append(gallery.stringValue)
                }
            }
            descriptionHeight = heightForView(text: productData["short_description"]!, font: UIFont(name: "Roboto-Regular", size: 15)!, width: self.view.frame.width-10)
            productData["productDesc"] = json["product_data"]["description"].stringValue
            longDescriptionHeight = heightForView(text: productData["productDesc"]!, font: UIFont(name: "Roboto-Regular", size: 15)!, width: self.view.frame.width-10)
            print("--longdesc--\(longDescriptionHeight)")
            productData["currencySymbol"] = json["product_data"]["currency_symbol"].stringValue
            productData["regularPrice"] = json["product_data"]["display_regular_price"].stringValue
            productData["salePrice"] = ""
            if(json["product_data"]["display_sale_price"].exists())
            {
                productData["salePrice"] = json["product_data"]["display_sale_price"].stringValue
            }
            productData["handler"]=json["product_data"]["handler"].stringValue;
            productData["productPrice"] = json["product_data"]["display_price"].stringValue
            enableReview = json["product_data"]["enable-review"].stringValue
            for index in json["product_data"]["related_ids"].arrayValue
            {
                print(index["product_id"])
                var product_price_min = "";
                var product_price_max = "";
                var product_price_min_reg = "";
                var product_price_max_reg = "";
                var salePrice = "";
                var sale = ""
                var productPrice = ""
                if(index["sale"].exists())
                {
                    sale = index["sale"].stringValue
                    product_price_min = index["product_price_min"].stringValue;
                    product_price_max = index["product_price_max"].stringValue;
                    product_price_min_reg = index["product_price_min_reg"].stringValue;
                    product_price_max_reg = index["product_price_max_reg"].stringValue;
                }
                else
                {
                    productPrice = index["product_price"].stringValue
                }
                if(index["sale_price"].exists())
                {
                    salePrice = index["sale_price"].stringValue
                }
                relatedData.append(["product_id": index["product_id"].stringValue, "product_name": index["product_name"].stringValue, "product_image": index["product_image"].stringValue, "product_price": index["product_price"].stringValue, "sale_price":salePrice, "regular_price":productPrice,"sale":sale,"product_price_min":product_price_min,"product_price_max":product_price_max,"product_price_min_reg":product_price_min_reg,"product_price_max_reg":product_price_max_reg,"stockLabel": index["is_in_stock"].stringValue]);
                
            }
            if(json["product_data"]["additional"].exists())
            {
                for(_,value) in json["product_data"]["additional"]
                {
                    additionalInfo[value["label"].stringValue] = value["data"].stringValue;
                }
            }
            
            if(json["product_data"]["stock_status"].stringValue == "instock")
            {
                checkStock=true;
            }
            if(json["product_data"]["product-type"].stringValue == "variable")
            {
                saleCheck = json["product_data"]["sale"].stringValue;
                productData["product_price_min"] = json["product_data"]["product_price_min"].stringValue;
                productData["product_price_max"] = json["product_data"]["product_price_max"].stringValue;
                productData["product_price_min_reg"] = json["product_data"]["product_price_min_reg"].stringValue;
                productData["product_price_max_reg"] = json["product_data"]["product_price_max_reg"].stringValue;
                
                for variation in json["product_data"]["variation_data"].arrayValue
                {
                    
                    if(variation["display_sale_price"].exists())
                    {
                        var varData = [String:JSON]()
                        varData["attributes"] = variation["attributes"];
                        varData["is_in_stock"] = variation["is_in_stock"];
                        varData["variation_id"] = variation["variation_id"]
                        varData["regular_price"] = variation["display_regular_price"]
                        varData["sale_price"] = variation["display_sale_price"]
                        varData["display_price"] =  variation["display_price"]
                        varData["image"] = variation["image"]["src"]
                        variationData.append(varData)
                    }
                    else
                    {
                        var varData = [String:JSON]()
                        varData["attributes"] = variation["attributes"];
                        varData["is_in_stock"] = variation["is_in_stock"];
                        varData["variation_id"] = variation["variation_id"]
                        varData["regular_price"] = variation["display_regular_price"]
                        varData["sale_price"] = "";
                        varData["display_price"] =  variation["display_price"]
                        varData["image"] = variation["image"]["src"]
                        variationData.append(varData)
                    }
                    
                }
                print(variationData)
                isVariable=true;
                if(json["product_data"]["variation_data"].count != 0)
                {
                    for(key,value) in json["product_data"]["variation_attr"]
                    {
                        
                        productOptionsData[key] = value;
                    }
                }
                
            }
            productTable.reloadData()
        }
    }
    
    
    
}
public extension CGFloat {
    /**
     Converts pixels to points based on the screen scale. For example, if you
     call CGFloat(1).pixelsToPoints() on an @2x device, this method will return
     0.5.
     
     - parameter pixels: to be converted into points
     
     - returns: a points representation of the pixels
     */
    func pixelsToPoints() -> CGFloat {
        return self / UIScreen.main.scale
    }
    
    /**
     Returns the number of points needed to make a 1 pixel line, based on the
     scale of the device's screen.
     
     - returns: the number of points needed to make a 1 pixel line
     */
    static func onePixelInPoints() -> CGFloat {
        return CGFloat(1).pixelsToPoints()
    }
}
