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
class mageRequets {
    
    //Mark: Send Request
    static func sendHttpRequest(endPoint:String,method:String = "POST",params:Dictionary<String,String> = [String:String](),controller: UIViewController, completionHandler:@escaping (Data?,String?,Error?) -> ()){
        let reqUrl =  wooSetting.baseUrl+endPoint
        
    
        print(reqUrl)
        var makeRequest = URLRequest(url: URL(string: reqUrl)!)
        var postData = ""
        makeRequest.httpMethod = method
        if(params.count>0){
            //makeRequest.httpMethod = method
            for (key,value) in params
            {
                postData+="&"+key+"="+value
            }
            postData+="&ced_mage_api=mobiconnect"
           makeRequest.httpBody = postData.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        }

        makeRequest.setValue(wooSetting.headerKey, forHTTPHeaderField: "uid")
        if(UserDefaults.standard.value(forKey: "store_id") != nil)
        {
            let lang = UserDefaults.standard.value(forKey: "store_id") as! String
            makeRequest.setValue(lang, forHTTPHeaderField: "langid")
            
        }
        
        print(postData)
        
        
        let task = URLSession.shared.dataTask(with: makeRequest, completionHandler: {data,response,error in
            // check for http errors
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200
            {
                print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
                DispatchQueue.main.async
                    {
                        cedMageLoaders.removeLoadingIndicator(me: controller)
                        print(reqUrl)
                        print(httpStatus.statusCode)
                        mageRequets.showError(controller:controller)
                }
                return;
            }
            guard error == nil && data != nil else
            {
                DispatchQueue.main.async
                    {
                        cedMageLoaders.removeLoadingIndicator(me: controller)
                        let AlertBckView = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        let OkAction = UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.destructive, handler: nil)
                        AlertBckView.addAction(OkAction)
                        
                        controller.present(AlertBckView, animated: true, completion: nil)
                }
                return ;
            }
            
            DispatchQueue.main.async
                {
                    print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
          _ =  completionHandler(data, endPoint, error)
            }
            
        })
        
        task.resume()
        
        
        
    }
    
    static func sendPaymentHttpRequest(endPoint:String,method:String = "POST",params:Dictionary<String,String> = [String:String](),controller: UIViewController, completionHandler:@escaping (Data?,String?,Error?) -> ()){
        let reqUrl =  endPoint
        
    
        print(reqUrl)
        var makeRequest = URLRequest(url: URL(string: reqUrl)!)
        var postData = ""
        makeRequest.httpMethod = method
        if(params.count>0){
            makeRequest.httpMethod = method
            for (key,value) in params
            {
                postData+="&"+key+"="+value
            }
            postData+="&ced_mage_api=mobiconnect"
           makeRequest.httpBody = postData.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        }

        makeRequest.setValue(wooSetting.headerKey, forHTTPHeaderField: "uid")
        if(UserDefaults.standard.value(forKey: "store_id") != nil)
        {
            let lang = UserDefaults.standard.value(forKey: "store_id") as! String
            makeRequest.setValue(lang, forHTTPHeaderField: "langid")
            
        }
        
        print(postData)
        
        
        let task = URLSession.shared.dataTask(with: makeRequest, completionHandler: {data,response,error in
            // check for http errors
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200
            {
                
                DispatchQueue.main.async
                    {
                        cedMageLoaders.removeLoadingIndicator(me: controller)
                        print(reqUrl)
                        
                        mageRequets.showError(controller:controller)
                }
                return;
            }
            guard error == nil && data != nil else
            {
                DispatchQueue.main.async
                    {
                        cedMageLoaders.removeLoadingIndicator(me: controller)
                        let AlertBckView = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        let OkAction = UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.destructive, handler: nil)
                        AlertBckView.addAction(OkAction)
                        
                        controller.present(AlertBckView, animated: true, completion: nil)
                }
                return ;
            }
            
            DispatchQueue.main.async
                {
                    print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
          _ =  completionHandler(data, endPoint, error)
            }
            
        })
        
        task.resume()
        
        
        
    }
    
    static func showError(controller:UIViewController){
        let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "errorview") as! ErrorPageView
        vc.modalPresentationStyle = .fullScreen;
        controller.present(vc, animated: true, completion: nil)
        return
    }
    //Mark: convert dictionary to JSon
   static func convtToJson(dict:Dictionary<String, Any>) -> NSString {
        do {
            let json = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            return NSString(data: json, encoding: String.Encoding.utf8.rawValue)!
        }catch {
            return ""
        }
    }
}
