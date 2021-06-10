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

import Foundation

class User: NSObject {
    
    func getLoginUser()->[String:String]?{
        let defaults = UserDefaults.standard
        let user = defaults.value(forKey: "mageWooUser") as? [String:String]
        return user
    }
    
    //Mark: Login Function
    func wooLogin(email:String = "", password:String = "", control: UIViewController, login:@escaping(Bool)->())->(){
        var params = Dictionary<String,String>();
        params["email"]=email;
        params["password"]=password;
        if let cartId = UserDefaults.standard.value(forKey: "cart_id")
        {
            params["cart_id"] = cartId as? String
        }
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/customer_account/login", params: params, controller: control, completionHandler: {data,url,error in
            print(url ?? "Requesturl")
           if let json = try? JSON(data:data!)
           {
            print(json)
            if json["data"]["message"].stringValue == "success" {
                let cust_email = json["data"]["customer"]["customer_email"].stringValue
                let cust_id = json["data"]["customer"]["customer_id"].stringValue
                let cust_hash = json["data"]["customer"]["hash"].stringValue
                
                UserDefaults.standard.set(["userEmail":cust_email,"userId":cust_id,"userHash":cust_hash], forKey: "mageWooUser")
                UserDefaults.standard.set(true, forKey: "mageWooLogin")
                UserDefaults.standard.removeObject(forKey: "cart_id");
                if(json["data"]["customer"]["cart_count_status"].stringValue == "true")
                {
                    var count = 0;
                    for(_,value) in json["data"]["customer"]["cart_count"]
                    {
                        count += value.intValue;
                    }
                    UserDefaults.standard.setValue(String(count), forKey: "CartQuantity")
                }
                login(true)
                
            }else{
                login(false)
            }
            }
            
        })
    }
    
    //Mark: ADD TO Wishlist
    
    func wooAddToWishList(productId:String,userId:String = "", control: UIViewController, completion:@escaping(Data?)->()){
        if let userId = getLoginUser()?["userId"] {
            mageRequets.sendHttpRequest(endPoint: "mobiconnect/set_user_wishlist", params: ["product-id":productId,"user-id":userId], controller: control, completionHandler: {data,url,error in
           completion(data)
            })
        }
    }
    
    func getCartCount(){
        let reqUrl =  wooSetting.baseUrl+"mobiconnect/customer_account/getcartcount"
        print(reqUrl)
        var makeRequest = URLRequest(url: URL(string: reqUrl)!)
        var params=[String:String]()
        if let cust_id = User().getLoginUser()?["userId"]
        {
            params["customer_id"] = cust_id;
        }
        else
        {
            params["cart_id"] = UserDefaults.standard.value(forKey: "cart_id") as? String;
        }
        if(params == [:])
        {
            params["cart_id"] = "0";
            UserDefaults.standard.setValue("0", forKey: "CartQuantity")
        }
        makeRequest.setValue(wooSetting.headerKey, forHTTPHeaderField: "uid")
        makeRequest.httpMethod = "POST"
        var postData = ""
        if(params.count>0){
            
            for (key,value) in params
            {
                postData+="&"+key+"="+value
            }
            makeRequest.httpBody = postData.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            if(UserDefaults.standard.value(forKey: "store_id") != nil)
            {
                let lang = UserDefaults.standard.value(forKey: "store_id") as! String
                makeRequest.setValue(lang, forHTTPHeaderField: "langid")
            }
            
        }
        print(postData)
        makeRequest.setValue("mobiconnnect", forHTTPHeaderField: "ced_mage_api")
        let task = URLSession.shared.dataTask(with: makeRequest, completionHandler: {data,response,error in
            // check for http errors
            DispatchQueue.main.async
            {
                if let data = data{
                    if let json = try? JSON(data:data)
                    {
                        print(json)
                        var count = 0;
                        if(json["status"].stringValue == "true")
                        {
                            
                            for(_,value) in json["data"]["items_count"]
                            {
                                count += value.intValue;
                            }
                            
                        }
                        UserDefaults.standard.setValue(String(count), forKey: "CartQuantity")
                        if(UserDefaults.standard.value(forKey: "store_id") == nil)
                        {
                            let lang = json["data"]["lang"][0]["id"].stringValue
                            if lang == "en" || lang == "en-US" || lang == "en_US"
                            {
                                UserDefaults.standard.setValue("en", forKey: "wooAppLanguage")
                            }
                            else
                            {
                                UserDefaults.standard.setValue(json["data"]["lang"][0]["id"].stringValue, forKey: "wooAppLanguage")
                            }
                            UserDefaults.standard.set(json["data"]["lang"][0]["id"].stringValue, forKey: "store_id")
                            //UserDefaults.standard.setValue("ar", forKey: "wooAppLanguage")
                            //UserDefaults.standard.setValue(json["data"]["lang"][0]["id"].stringValue, forKey: "wooAppLanguage")
                            
                            (UIApplication.shared.delegate as! AppDelegate).changeLanguage()
                        }
                    }
                    
                    
                }
                
            }
            
        })
        
        task.resume()
    }
    
    func getStores(controller: UIViewController, completion:@escaping([[String:String]])->())
    {
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/all_languages", method: "GET",  controller: controller, completionHandler: {
            data,url,error in
            var langData = [[String:String]]();
            if let json = try? JSON(data:data!)
            {
                print(json);
                
                for index in json.arrayValue
                {
                    langData.append(["id":index["id"].stringValue,"name":index["name"].stringValue]);
                }
                
            }
            completion(langData);
            
        })
    }
    
    func categoryRequest(controller: UIViewController, completion:@escaping([[String:String]])->())
    {
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/category/get_main_categories", method: "GET",  controller: controller, completionHandler: {
            data,url,error in
            var categoriesData = [[String: String]]()
            if let json = try? JSON(data:data!)
            {
                print(json)
                
                if json["status"].stringValue == "success"{
                    for categories in json["data"]["categories"].arrayValue {
                        categoriesData.append(["categoryId":categories["category_id"].stringValue,"category_name":categories["category_name"].stringValue,"category_image":categories["category_image"].stringValue,"has_child":categories["has_child"].stringValue])
                    }
                }
            }
            completion(categoriesData);
        })
    }
    
    func getcategoryRequest(controller: UIViewController, completion:@escaping([String:JSON])->())
    {
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/category/get_sub_category", method: "GET",  controller: controller, completionHandler: {
            data,url,error in
            var mainData = [[String: JSON]]()
            var catData = [String: JSON]()
            if let json = try? JSON(data:data!)
            {
                print(json)
                
                print("----")
                if json["status"].stringValue == "true"{
                    
                    for (key,value) in json["category_info"]["product_cat"]
                    {
                        print("CATEGORIES : ")
                        print(key)
                        print(value)
                        mainData.append([key:value])
                        catData[key] = value
                    }
                    
                    print("catData = \(catData)")
                    print("mainData = \(mainData)")
                    print("keys value ===")
                    print(catData.keys)
                    
                    
                    
                  /*  for categories in json["data"]["categories"].arrayValue {
                        categoriesData.append(["categoryId":categories["category_id"].stringValue,"category_name":categories["category_name"].stringValue,"category_image":categories["category_image"].stringValue,"has_child":categories["has_child"].stringValue])
                    } */
                }
            }
            completion(catData);
        })
    }
    
    
    
    
    
    func clearCartWishlist(controller: UIViewController, completion:@escaping(Bool)->())
    {
        let reqUrl = "mobiconnect/clear_cart_wishlist";
        var params=[String:String]()
        if let cust_id = User().getLoginUser()?["userId"]
        {
            params["user-id"] = cust_id;
        }
        else
        {
            if(UserDefaults.standard.value(forKey: "cart_id") != nil)
            {
                params["cart_id"] = UserDefaults.standard.value(forKey: "cart_id") as? String;
            }
            
        }
        if(params == [:])
        {
            params["cart_id"] = "0";
            UserDefaults.standard.setValue("0", forKey: "CartQuantity")
        }
        mageRequets.sendHttpRequest(endPoint: reqUrl, params: params, controller: controller, completionHandler: {
            data,url,error in
            if let data = data
            {
                if let json = try? JSON(data:data)
                {
                    if(json["cart_id"]["success"].stringValue == "true")
                    {
                        completion(true);
                    }
                    else
                    {
                        completion(false);
                    }
                }
                else{
                    completion(false);
                }
                
            }
            
        })
        
    }
    
    func subCategoryRequest(categoryId: String, page: Int, controller: UIViewController, completion:@escaping([String:[[String:String]]])->())
    {
        var params=["category-id":categoryId, "current_page":"\(page)"]
        
        if let user = User().getLoginUser() {
            params.updateValue(user["userId"]!, forKey: "user-id")
        }
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/get_all_cat_products", params: params, controller: controller, completionHandler: {
            data,url,error in
            var productsData=[[String:String]]()
            var categoryData=[[String:String]]()
            var mainCategoryData = [String:String]()
            if let data = data{
                if let json = try? JSON(data: data)
                {
                    print(json)
                    let success=json["message"].stringValue
                    if success=="success"{
                        if let subcategories=json["subcategories"].array{
                            for node in subcategories{
                                let cateName=node["name"].stringValue
                                let cateId=node["term_id"].stringValue
                                let imageName=node["sub_image"].stringValue
                                
                                let hasChild=node["has_child"].stringValue;
                                
                                let temp=["categoryName":cateName,"categoryId":cateId,"imageName":imageName,"has_child":hasChild]
                                categoryData.append(temp)
                            }
                        }
                        if let products=json["products"].array{
                            for node in products{
                                var salePrice = ""
                                var sale = ""
                                var productPrice = ""
                                var product_price_min = "";
                                var product_price_max = "";
                                var product_price_min_reg = "";
                                var product_price_max_reg = "";
                                if(node["sale"].exists())
                                {
                                    sale = node["sale"].stringValue
                                    
                                    print("--sale---\(node["sale"].stringValue)")
                                    print(node["product_id"].stringValue)
                                    product_price_min = node["product_price_min"].stringValue;
                                    product_price_max = node["product_price_max"].stringValue;
                                    product_price_min_reg = node["product_price_min_reg"].stringValue;
                                    product_price_max_reg = node["product_price_max_reg"].stringValue;
                                }
                                else
                                {
                                    productPrice = node["product_price"].stringValue
                                }
                                if(node["sale_price"].exists())
                                {
                                    salePrice = node["sale_price"].stringValue;
                                }
                                productsData.append(["productId":node["product_id"].stringValue,"productName":node["product_name"].stringValue,"currencySymbol":node["currency_symbol"].stringValue,"productType":node["product_type"].stringValue,"regularPrice":node["regular_price"].stringValue,"productPrice":productPrice,"wishlist":node["wishlist"].stringValue,"productImage":node["product_image"].stringValue,"salePrice": salePrice,"sale":sale,"product_price_min":product_price_min,"product_price_max":product_price_max,"product_price_min_reg":product_price_min_reg,"product_price_max_reg":product_price_max_reg, "product_type":node["product_type"].stringValue])
                                
                            }
                        }
                        mainCategoryData["name"] = json["cat_name"].stringValue;
                        mainCategoryData["image"] = json["category_image"].stringValue;
                    }
                }
                
            }
            completion(["product":productsData, "category":categoryData,"maincategory":[mainCategoryData]])
        })
    }
    
}
