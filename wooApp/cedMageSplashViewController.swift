//
//  cedMageSplashViewController.swift
//  wooApp
//
//  Created by Manohar Singh Rawat on 08/05/19.
//  Copyright © 2019 MageNative. All rights reserved.
//

import UIKit
import Stripe

class cedMageSplashViewController: UIViewController {

    var path = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        path = createDirectory()
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData()
    {
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/get_theme_setting", method: "GET", params: [:], controller: self) { (data, url, error) in
            if let data = data{
                if let json = try? JSON(data: data){
                    print(json);
                    if(json["status"].stringValue == "success")
                    {
                        var settingsArray = [String:String]()
                        for(key,value) in json["data"]{
                            settingsArray[key] = value.stringValue;
                            if(key == "ced_theme_color_field")
                            {
                                if(value.stringValue != "")
                                {
                                    wooSetting.themeColor = {
                                        if #available(iOS 13.0, *) {
                                        
                                          return UIColor { (UITraitCollection) -> UIColor in
                                            if UITraitCollection.userInterfaceStyle == .dark { return UIColor(hexString: json["data"]["ced_theme_color_field_dark"].stringValue)! }
                                            else { return UIColor(hexString: value.stringValue)! }
                                          }
                                        } else {
                                            return mageWooCommon.UIColorFromRGB(colorCode: value.stringValue)
                                        }
                                    }()
                                }
                                
                            }
                            else if(key == "ced_theme_text_color_field")
                            {
                                if(value.stringValue != "")
                                {
                                    wooSetting.textColor = {
                                        if #available(iOS 13.0, *) {
            
                                          return UIColor { (UITraitCollection) -> UIColor in
                                            if UITraitCollection.userInterfaceStyle == .dark { return UIColor(hexString: json["data"]["ced_theme_text_color_field_dark"].stringValue)! }
                                            else { return UIColor(hexString: value.stringValue)! }
                                          }
                                        } else {
                                            return mageWooCommon.UIColorFromRGB(colorCode: value.stringValue)
                                        }
                                    }()
                                }
                                
                            }
                            else if(key == "ced_theme_navigation_bar_color_field"){
                                if(value.stringValue != ""){
                                    wooSetting.bartintColor = {
                                        if #available(iOS 13.0, *) {
                                          return UIColor { (UITraitCollection) -> UIColor in
                                            if UITraitCollection.userInterfaceStyle == .dark {
                                                return UIColor(hexString: json["data"]["ced_theme_navigation_bar_color_field_dark"].stringValue)! }
                                            else {
                                                return UIColor(hexString: value.stringValue)! }
                                          }
                                        } else {
                                            return mageWooCommon.UIColorFromRGB(colorCode: value.stringValue)
                                        }
                                    }()
                                }
                                
                            }
                            else if(key == "ced_theme_navigation_tint_color_field"){
                                if(value.stringValue != ""){
                                    wooSetting.tintColor = {
                                        if #available(iOS 13.0, *) {
                                          return UIColor { (UITraitCollection) -> UIColor in
                                            if UITraitCollection.userInterfaceStyle == .dark {
                                                return UIColor(hexString: json["data"]["ced_theme_navigation_tint_color_field_dark"].stringValue)! }
                                            else {
                                                return UIColor(hexString: value.stringValue)! }
                                          }
                                        } else {
                                            return mageWooCommon.UIColorFromRGB(colorCode: value.stringValue)
                                        }
                                    }()
                                }
                                
                            }
                            else if(key == "ced_theme_secoundary_tint_color_field")
                            {
                                if(value.stringValue != "")
                                {
                                    
                                    wooSetting.subTextColor = {
                                        if #available(iOS 13.0, *) {
                                        
                                          return UIColor { (UITraitCollection) -> UIColor in
                                            if UITraitCollection.userInterfaceStyle == .dark { return UIColor(hexString: json["data"]["ced_theme_secoundary_tint_color_field_dark"].stringValue)! }
                                            else { return UIColor(hexString: value.stringValue)! }
                                          }
                                        } else {
                                            return mageWooCommon.UIColorFromRGB(colorCode: value.stringValue)
                                        }
                                    }()
                                }
                            }
                            else if(key == "ced_theme_category_placeholder_image")
                            {
                                print("CatplaceholderImage")
                                if(value.stringValue != "")
                                {
                                    let img = value.stringValue
                                    let name = "CategoryplaceholderImage"
                                    let url = URL(string:img)
                                    if let data = try? Data(contentsOf: url!)
                                    {
                                        //print("url converted to image ")
                                        let image: UIImage = UIImage(data: data)!
                                        let catImagePAth = self.saveImageDocumentDirectory(image: image, imageName: name)
                                        wooSetting.categoryPlaceholder = catImagePAth!
                                    }
                                }
                            }
                            else if(key == "ced_theme_product_placeholder_image")
                            {
                                print("ProdplaceholderImage")
                                if(value.stringValue != "")
                                {
                                    let img = value.stringValue
                                    let name = "ProductplaceholderImage"
                                    let url = URL(string:img)
                                    if let data = try? Data(contentsOf: url!)
                                    {
                                        let image: UIImage = UIImage(data: data)!
                                        let prodImagePAth = self.saveImageDocumentDirectory(image: image, imageName: name)
                                        wooSetting.productPlaceholder = prodImagePAth!
                                        
                                    }
                                }
                            }
                            else if(key == "ced_theme_banner_placeholder_image")
                            {
                                print("BannerplaceholderImage")
                                if(value.stringValue != "")
                                {
                                    let img = value.stringValue
                                    let name = "BannerplaceholderImage"
                                    let url = URL(string:img)
                                    if let data = try? Data(contentsOf: url!)
                                    {
                                        //print("url converted to image ")
                                        let image: UIImage = UIImage(data: data)!
                                        let bannerImagePAth = self.saveImageDocumentDirectory(image: image, imageName: name)
                                        //print("bannerImagePAth = \(bannerImagePAth)")
                                        wooSetting.bannerPlaceholder = bannerImagePAth!
                                    }
                                }
                            }
                            
                        }
                        if(json["stripe_setting"].exists()){
                            let stripeSetting = json["stripe_setting"];
                            if(stripeSetting["enabled"].stringValue == "yes"){
                                if(stripeSetting["testmode"].stringValue == "no"){
                                    Stripe.setDefaultPublishableKey(stripeSetting["publishable_key"].stringValue)
                                }
                                else{
                                    Stripe.setDefaultPublishableKey(stripeSetting["test_publishable_key"].stringValue)
                                }
                            }
                        }
                       //  Stripe.setDefaultPublishableKey("pk_test_xJWWQaGnINuH6qQdhNnovRS000nrF5yxSu")
                            
                        //Stripe.setDefaultPublishableKey("pk_test_xJWWQaGnINuH6qQdhNnovRS000nrF5yxSu")
                        
                        UserDefaults.standard.set(settingsArray, forKey: "themeSettings")
                        (UIApplication.shared.delegate as! AppDelegate).changeLanguage()
                    }
                }                
            }
        }
    }

    // Creation Of a Directory
    func createDirectory()-> String {
        let fileManager = FileManager.default
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("placeholderImages")
        
        if !fileManager.fileExists(atPath: paths){
            //print("--creation starts--")
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
            
        }else{
            //print("--creation fails--")
            print("Already dictionary created.")
            
        }
        //print("--- created ---")
        return paths
    }
    
    // save the image and imageName in directory
    
    func saveImageDocumentDirectory(image: UIImage, imageName: String) -> String?
    {
        //print("in saveImageDocumentDirectory")
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("placeholderImages")
        if !fileManager.fileExists(atPath: path)
        {
            try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        let url = NSURL(string: path)
        //print("\(imageName).jpg")
        let newImage = "\(imageName).jpg"
        let imagePath = url!.appendingPathComponent(newImage)
        let urlString: String = imagePath!.absoluteString
        let imageData = image.jpegData(compressionQuality: 0.5)
        do {
            let items = try fileManager.contentsOfDirectory(atPath: path)
            if items.isEmpty == true
            {
                fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
                return urlString
            }
            else
            {
                print("original contents : ")
                print(try fileManager.contentsOfDirectory(atPath: path))
                if items.contains(newImage)
                {
                    let index = items.firstIndex(of: newImage)
                    //print(items[index!])
                    let originalPath = url!.appendingPathComponent(items[index!])
                    let urlStr2 = originalPath?.absoluteString
                    try fileManager.removeItem(atPath: urlStr2 as! String)
                  
                }
                
               fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
               return urlString
                
              
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
        
        return ""
    }
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
