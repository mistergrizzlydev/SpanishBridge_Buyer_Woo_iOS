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

class cedMageTrial: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func appSubscriptionCheck(){
        
        let previousDate = PlistManager.sharedInstance.getValueForKey(key: "currentDate") as! String;
        
        let date = NSDate();
        let calendar = Calendar.current;
        let day = String(calendar.component(Calendar.Component.day, from: date as Date));
        let month = String(calendar.component(Calendar.Component.month, from: date as Date));
        let year = String(calendar.component(Calendar.Component.year, from: date as Date));
        let currentDate = day+"-"+month+"-"+year;
        print(currentDate);
        
        
        let isActive = PlistManager.sharedInstance.getValueForKey(key: "isActive") as! String;
        if(isActive == "0"){
            print("subscription over :: please upgrade to paid service");
        }
        else{
            print("previousDate");
            print(previousDate);
            print("currentDate");
            print(currentDate);
            
            if(previousDate != currentDate){
                let urlToRequest = "https://magenative.cedcommerce.com/refund/download/validitycheck/";
                let appId = PlistManager.sharedInstance.getValueForKey(key: "appId");
                let postString = "app_id="+(appId! as! String);
                
                print(urlToRequest);
                print(postString);
                
                var request = URLRequest(url: URL(string: "\(urlToRequest)")!);
                request.httpMethod = "POST";
                request.httpBody = postString.data(using: String.Encoding.utf8);
                
                let task = URLSession.shared.dataTask(with: request){
                    
                    // check for fundamental networking error
                    data, response, error in
                    guard error == nil && data != nil else{
                        
                        DispatchQueue.main.async{
                            print(error?.localizedDescription as Any);
                        }
                        return;
                    }
                    
                    // check for http errors
                    if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200{
                        
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        
                        DispatchQueue.main.async{
                        }
                        return;
                    }
                    
                    // code to fetch values from response :: start
                    
                    let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue);
                    print("datastring");
                    print(datastring as Any);
                    
                    if let jsonResponse = try? JSON(data: data!){
                        if(jsonResponse != nil){
                            DispatchQueue.main.async{
                                print(jsonResponse);
                                if(jsonResponse["data"]["success"].stringValue == "true"){
                                    PlistManager.sharedInstance.saveValue(value: currentDate as AnyObject, forKey: "currentDate");
                                    PlistManager.sharedInstance.saveValue(value: "1" as AnyObject, forKey: "isActive");
                                }
                                else{
                                    PlistManager.sharedInstance.saveValue(value: "0" as AnyObject, forKey: "isActive");
                                }
                            }
                        }
                    }
                    
                }
                task.resume();
            }
            else{
                print("todays validation check is done");
            }
        }
        
    }
    
    
    
}

