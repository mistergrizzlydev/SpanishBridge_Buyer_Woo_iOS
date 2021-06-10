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

//pod 'Google/Analytics'
//pod 'GoogleSignIn'
import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import UserNotifications
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var gcmMessageIDKey = "gcm.Message_ID"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //trialCheck();
        //User().getLocale();
        User().getCartCount();
        //UIApplication.shared.statusBarStyle = .lightContent;
        IQKeyboardManager.shared.enable = true;
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if Messaging.messaging().fcmToken != nil {
            Messaging.messaging().subscribe(toTopic: "SpanishBridgeNotification");
        }
        
    /*--editedMay10
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
            return true;
        }
        gai.tracker(withTrackingId: wooSetting.trackingId)
        // Optional: automatically report uncaught exceptions.
        gai.trackUncaughtExceptions = true
        
        // Optional: set Logger to VERBOSE for debug information.
        // Remove before app release.
        gai.logger.logLevel = .verbose;
    */
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
        
        //PayPalMobile .initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "YOUR_CLIENT_ID_FOR_PRODUCTION", PayPalEnvironmentSandbox: "AUJ6K560HKjpq835-NDAr36Z6aTUWHhRn83DpSBuPrpky0SacJ9FvXiJaIXkz7SiMhP04F1OTuyB03lO"])
        return true
    }
    
    func changeLanguage()
    {
        
        if let appLanguage = UserDefaults.standard.object(forKey: "wooAppLanguage") as? String{
            if appLanguage == "ar" || appLanguage == "ur" {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
               
                Bundle.setLanguage("ar")
                
            }
            else
            {
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                Bundle.setLanguage(appLanguage)
            }
        }
        let story = UIStoryboard(name: "Main", bundle: nil)
        let viewControl = story.instantiateViewController(withIdentifier: "mainView") as? cedMageSideDrawer
        self.window?.rootViewController = viewControl
        self.window?.makeKeyAndVisible()
    }
    
    func trialCheck()
    {
        let trialController = cedMageTrial()
        trialController.appSubscriptionCheck();
        if let isActive = PlistManager.sharedInstance.getValueForKey(key: "isActive") as? String
        {
            if(isActive == "0"){
                print("subscription over :: please upgrade to paid service");
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "trial") as? cedMageNotAvailable
                {
                    mageRequets.showError(controller:vc);
                    self.window?.rootViewController=vc
                    self.window?.makeKeyAndVisible()
                    
                    return;
                }
                
                
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let sourceApplication: String? = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
        if(url.scheme!.contains("fb")){
            return ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: sourceApplication,
                annotation: nil)
        }
        else{
           return GIDSignIn.sharedInstance().handle(url)
        }
//        //--added10May
//        return false
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        //added
        Messaging.messaging().apnsToken = deviceToken
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        let udid=UIDevice.current.identifierForVendor!.uuidString
        print("UDID")
        print(udid)
        print("token")
        print(deviceTokenString)
        /*let alert=UIAlertController(title: "Token", message: deviceTokenString, preferredStyle: .alert)
        let action=UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            
        })
        let action_cancel=UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
            return
        })
        alert.addAction(action)
        alert.addAction(action_cancel)
        alert.modalPresentationStyle = .fullScreen;
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)*/
        if(deviceTokenString != "")
        {
            var params = Dictionary<String, String>();
            params["token-id"]=deviceTokenString
            params["type"]="2"
            let reqUrl =  wooSetting.baseUrl+"mobiconnect/customer_account/savetokenid"
            print(reqUrl)
            var makeRequest = URLRequest(url: URL(string: reqUrl)!)
            var postData = ""
            if(params.count>0){
                makeRequest.httpMethod = "POST"
                for (key,value) in params
                {
                    postData+="&"+key+"="+value
                }
            }
            
            print(postData)
            makeRequest.httpBody = postData.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            if(UserDefaults.standard.value(forKey: "store_id") != nil)
            {
                let lang = UserDefaults.standard.value(forKey: "store_id") as! String
                makeRequest.setValue(lang, forHTTPHeaderField: "langid")
            }
            
            makeRequest.setValue(wooSetting.headerKey, forHTTPHeaderField: "uid")
            let task = URLSession.shared.dataTask(with: makeRequest, completionHandler: {data,response,error in
                DispatchQueue.main.async
                {
                    if let data = data {
                        if let json = try? JSON(data:data){
                            print(json);
                        }
                        
                    }
                }
                
            })
            
            task.resume()
        }
    }
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        
        Messaging.messaging().subscribe(toTopic: "SpanishBridgeNotification");
        
        self.receivedNotification(userInfoData: userInfo)
        
        
        let state = UIApplication.shared.applicationState
        let test=userInfo["aps"] as! Dictionary<String,Any>
        let main=test["alert"] as! Dictionary<String,Any>
        //let data=userInfo["data"] as! Dictionary<String,Any>
        if state == .active {
            
            
            let alert=UIAlertController(title: main["title"] as? String, message: main["body"] as? String, preferredStyle: .alert)
            let action=UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.onGetNotification(main: main)
                
            })
            let action_cancel=UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
                return
            })
            alert.addAction(action)
            alert.addAction(action_cancel)
            alert.modalPresentationStyle = .fullScreen;
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
        else if state == .background{
            onGetNotification(main: main)
        }
        else if state == .inactive{
            onGetNotification(main: main)
        }
        else{
            onGetNotification(main: main)
        }

    }
    func onGetNotification(main:Dictionary<String,Any>){
        
        let notType=main["link_type"] as! String
        let notification_id=main["notification_id"] as! String
        if UserDefaults.standard.value(forKey: "NotificationIDS") != nil
        {
            let temp=UserDefaults.standard.value(forKey: "NotificationIDS") as! String
            let data=","+notification_id
            UserDefaults.standard.set(temp+data, forKey: "NotificationIDS")
        }
        else
        {
            UserDefaults.standard.set(notification_id, forKey: "NotificationIDS")
        }
        if(notType == "category"){
            let data=main["link_id"] as! String
            
            
            UserDefaults.standard.set(["category":data], forKey: "NotificationData")
            let drawer=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainView") as! cedMageSideDrawer
            
            self.window?.rootViewController=drawer
            self.window?.makeKeyAndVisible()
            
        }else if (notType == "product"){
            let data=main["link_id"] as! String
            
            UserDefaults.standard.set(["product":data], forKey: "NotificationData")
            
            let drawer=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainView") as! cedMageSideDrawer
            
            self.window?.rootViewController=drawer
            
            self.window?.makeKeyAndVisible()
            
        }else if (notType == "website"){
            let data=main["link_id"] as! String
            
            UserDefaults.standard.set(["website":data], forKey: "NotificationData")
            
            let drawer=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainView") as! cedMageSideDrawer
            
            self.window?.rootViewController=drawer
            self.window?.makeKeyAndVisible()
            
            
            
        }
        return
    }
    
    //--added new 10 june
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("willPresent")
        print(userInfo)
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // Change this to your preferred presentation option
        completionHandler([[.alert, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("didReceive")
        print(userInfo)
        Messaging.messaging().appDidReceiveMessage(userInfo)
        self.receivedNotification(userInfoData: userInfo)
        completionHandler()
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print("errrrr")
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func receivedNotification(userInfoData: [AnyHashable : Any]){
        print("receive notify")
        print(userInfoData)
        if let messageID = userInfoData[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        let state = UIApplication.shared.applicationState
        let test=userInfoData["aps"] as! Dictionary<String,Any>
        let mainContent=test["alert"] as! Dictionary<String,Any>
        do{
            if let bodys = userInfoData["gcm.notification.datas"] as? String{
                let main = convertToDictionary(text: bodys)
                if state == .active {
                    let alert=UIAlertController(title: mainContent["title"] as? String, message: mainContent["body"] as? String, preferredStyle: .alert)
                    let action=UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        self.onGetNotification(main: main!)
                        
                    })
                    let action_cancel=UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
                        return
                    })
                    alert.addAction(action)
                    alert.addAction(action_cancel)
                    alert.modalPresentationStyle = .fullScreen;
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    return
                }
                else if state == .background{
                    self.onGetNotification(main: main!)
                }
                else if state == .inactive{
                    self.onGetNotification(main: main!)
                }
                else{
                    self.onGetNotification(main: main!)
                }
            }
        }

       
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        Messaging.messaging().subscribe(toTopic: "SpanishBridgeNotification");
          let dataDict:[String: String] = ["token": fcmToken!]
          NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        if(fcmToken != "")
        {
            var params = Dictionary<String, String>();
            params["token-id"]=fcmToken
            params["type"]="2"
            let reqUrl =  wooSetting.baseUrl+"mobiconnect/customer_account/savetokenid"
            print(reqUrl)
            var makeRequest = URLRequest(url: URL(string: reqUrl)!)
            var postData = ""
            if(params.count>0){
                makeRequest.httpMethod = "POST"
                for (key,value) in params
                {
                    postData+="&"+key+"="+value
                }
            }
            
            print(postData)
            makeRequest.httpBody = postData.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            if(UserDefaults.standard.value(forKey: "store_id") != nil)
            {
                let lang = UserDefaults.standard.value(forKey: "store_id") as! String
                makeRequest.setValue(lang, forHTTPHeaderField: "langid")
            }
            
            makeRequest.setValue(wooSetting.headerKey, forHTTPHeaderField: "uid")
            let task = URLSession.shared.dataTask(with: makeRequest, completionHandler: {data,response,error in
                DispatchQueue.main.async
                {
                    if let data = data {
                        if let json = try? JSON(data:data){
                            print(json);
                        }
                        
                    }
                }
                
            })
            
            task.resume()
        }
    }
}



/*-- edited10May
extension UIViewController{
    
    /**
     Function to send name/url of current page opened in webview to google analytics.
     - parameter name: name/url of current webpage. Type-String
     */
    func tracking(name: String)
    {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: name)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
}
*/
