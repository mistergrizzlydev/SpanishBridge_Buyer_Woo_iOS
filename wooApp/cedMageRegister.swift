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
import FBSDKCoreKit
import FBSDKLoginKit
//--edited10May import GoogleSignIn ,GIDSignInDelegate
class wooMageRegister: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var registerTableView: UITableView!
    
    var cartRegistrationCheck = false
    
    var showPassword = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        wooMageNavigation().makeNaVigationBar(me: self)
        //--edited10May     self.tracking(name: "signup page");
        registerTableView.delegate=self;
        registerTableView.dataSource=self
        

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section==0)
        {
            if let cell = registerTableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as? wooRegisterCell
            {
        
                return cell;
            }
        }
        if(indexPath.section==1)
        {
            if let cell = registerTableView.dequeueReusableCell(withIdentifier: "fieldCell", for: indexPath) as? wooRegisterCell
            {
                if let value = UserDefaults.standard.value(forKey: "wooAppLanguage") as? String
                {
                    if value=="ar" || value=="ur"
                    {
                        cell.firstNameField.textAlignment = .right
                        cell.lastNameField.textAlignment = .right
                        cell.emailField.textAlignment = .right
                        cell.passwordField.textAlignment = .right
                        
                        
                    }
                    else
                    {
                        cell.firstNameField.textAlignment = .left
                        cell.lastNameField.textAlignment = .left
                        cell.emailField.textAlignment = .left
                        cell.passwordField.textAlignment = .left
                    }
                }
                cell.firstNameField.tag=1;
                cell.lastNameField.tag=2;
                cell.emailField.tag=3;
                cell.passwordField.tag=4;
                cell.firstNameField.makeCircledField();
                cell.lastNameField.makeCircledField();
                cell.emailField.makeCircledField();
                cell.passwordField.makeCircledField();
                
                cell.showPasswordButton.setTitleColor(wooSetting.subTextColor, for: .normal);
                /*if #available(iOS 12.0, *) {
                    if(traitCollection.userInterfaceStyle == .dark)
                    {
                        cell.showPasswordButton.setTitleColor(wooSetting.darkModeSubTextColor, for: .normal);
                    }
                }*/
                cell.showPasswordButton.addTarget(self, action: #selector(showPasswordClicked(_:)), for: .touchUpInside)
                return cell;
            }
        }
        if(indexPath.section==2)
        {
            if let cell = registerTableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as? wooRegisterCell
            {
                cell.submitButton.addTarget(self, action: #selector(submitClicked(_:)), for: .touchUpInside)
                //cell.submitButton.setThemeColor();
                cell.submitButton.setTitleColor(wooSetting.textColor, for: .normal);
                
                //cell.submitButton.layer.cornerRadius=7;
                return cell;
            }
        }
        return UITableViewCell();
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section==0)
        {
            return 70;
        }
        else if(indexPath.section==1)
        {
            return 330;
        }
        return 180;
    }
    
    @objc func showPasswordClicked(_ sender: UIButton)
    {
        showPassword = !showPassword
        if let passwordField = self.view.viewWithTag(4) as? UITextField
        {
            if(showPassword)
            {
                passwordField.isSecureTextEntry = false;
                sender.setImage(UIImage(named: "checked"), for: .normal)
            }
            else
            {
                passwordField.isSecureTextEntry = true;
                sender.setImage(UIImage(named: "unchecked"), for: .normal)
            }
        }
        
    }
    
    @objc func submitClicked(_ sender: UIButton)
    {
        let emailField = self.view.viewWithTag(3) as! UITextField
        let firstNameField = self.view.viewWithTag(1) as! UITextField
        let lastnameField = self.view.viewWithTag(2) as! UITextField
        let passwordField = self.view.viewWithTag(4) as! UITextField
        emailField.resignFirstResponder();
        firstNameField.resignFirstResponder();
        lastnameField.resignFirstResponder();
        passwordField.resignFirstResponder();
        if let email = (self.view.viewWithTag(3) as? UITextField)?.text,let firstname = (self.view.viewWithTag(1) as? UITextField)?.text,let lastname = (self.view.viewWithTag(2) as? UITextField)?.text,let password = (self.view.viewWithTag(4) as? UITextField)?.text {
            if(email != "" && firstname != "" && lastname != "" && password != "")
            {
                if(!isValidEmail(testStr: email))
                {
                    self.view.makeToast("Email is not valid".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                    return
                }
                if(!isValidName(testStr: firstname) || !isValidName(testStr: lastname))
                {
                    self.view.makeToast("Name is not valid".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                    return
                }
                cedMageLoaders.addDefaultLoader(me: self)
              //  var params = ["email":email,"firstname":firstname,"lastname":lastname,"password":password,"user_mobile":"0000000000"];
                var params = ["email":email,"firstname":firstname,"lastname":lastname,"password":password];
                if let cartId = UserDefaults.standard.value(forKey: "cart_id")
                {
                    params["cart_id"] = cartId as? String
                }
                print("register params = \(params)")
                mageRequets.sendHttpRequest(endPoint: "mobiconnect/customer_account/register", params: params, controller: self, completionHandler: { data,url,error in
                    cedMageLoaders.removeLoadingIndicator(me: self)
                    //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
                    if let jsondata=try? JSON(data:data!)
                    {
                        print(jsondata)
                        if(jsondata["status"].stringValue == "success")
                        {
                            let message = jsondata["success_message"].stringValue;
                            UserDefaults.standard.set(["userEmail":email,"userId":jsondata["data"]["customer_id"].stringValue,"userHash":jsondata["data"]["hash_key"].stringValue], forKey: "mageWooUser")
                            UserDefaults.standard.set(true, forKey: "mageWooLogin")
                            self.view.makeToast(message, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                            NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"),object: nil);
                            mageWooCommon.delay(delay: 2.0, closure: {
                                if(self.cartRegistrationCheck)
                                {
                                    let vc=UIStoryboard(name: "mageWooCheckout", bundle: nil).instantiateViewController(withIdentifier: "cedMageNewAddressController") as? cedMageNewAddressController
                                    self.navigationController?.pushViewController(vc!, animated: true);
                                    //self.navigationController?.popViewController
                                }
                                else
                                {
                                    let vc=mageWooCommon().getHomepage()
                                    self.tabBarController?.selectedIndex = 0;
                                    self.navigationController?.setViewControllers([vc], animated: true)
                                    
                                    return
                                    
                                }
                            })
                            
                            return
                        }
                        else
                        {
                            let statusMessage = jsondata["message"].stringValue
                            self.showAlert(title: "Message", msg: statusMessage)
                        }
                    }
                    
                })
            }
            else
            {
                self.view.makeToast("Some fields are blank".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            }
            
        }

    }
    
  /*--edited10May  func googleSignInPressed(_ sender: UIButton)
    {
        let googlesignin = GIDSignIn.sharedInstance()
        googlesignin?.clientID = self.getInfoPlist(fileName: "GoogleService-Info", indexString: "CLIENT_ID") as? String
        
        googlesignin?.scopes.append("https://www.googleapis.com/auth/plus.login")
        googlesignin?.scopes.append("https://www.googleapis.com/auth/plus.me")
        //googlesignin?.uiDelegate = self
        googlesignin?.shouldFetchBasicProfile = true
        googlesignin?.delegate = self
        
        googlesignin?.signIn()

    }*/

    func facebookLogIn(_ sender: UIButton) {
        
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                print("RESULT")
                let fbloginresult : LoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil
                {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                    }
                }
            }
        }
    }
    
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let firstname = (result as AnyObject).value(forKey: "first_name") as! String
                    let lastname = (result as AnyObject).value(forKey: "last_name") as! String
                    var email=""
                    if let _ = (result as AnyObject).value(forKey: "email")
                    {
                        email = (result as AnyObject).value(forKey: "email") as! String
                    }
                    let fbuser = ["firstname":firstname,"lastname":lastname,"email":email]
                    print(fbuser)
                    self.doLOGIn(data: fbuser)
                }
            })
        }
    }

    func getInfoPlist(fileName:String?,indexString:NSString) ->AnyObject?{
        
        
        let path = Bundle.main.path(forResource: fileName, ofType: "plist")
        let storedvalues = NSDictionary(contentsOfFile: path!)
        let response: AnyObject? = storedvalues?.object(forKey: indexString) as AnyObject?
        return response
    }
    
    func loginButton(_ loginButton: FBLoginButton!, didCompleteWith result: LoginManagerLoginResult!, error: Error!) {
        
        if(result == nil){
            return
        }
        let accessToken = AccessToken.current
        if(accessToken != nil) //should be != nil
        {
            print(accessToken?.tokenString ?? "")
        }
        else
        {
            return
        }
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,first_name,last_name"], tokenString: accessToken!.tokenString, version: nil, httpMethod: HTTPMethod(rawValue: "GET"))
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil)
            {
                self.view.makeToast("Some Error Occured".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                
            }
            else
            {
                
                let firstname = (result as AnyObject).value(forKey: "first_name") as! String
                let lastname = (result as AnyObject).value(forKey: "last_name") as! String
                var email=""
                if let _ = (result as AnyObject).value(forKey: "email")
                {
                    email = (result as AnyObject).value(forKey: "email") as! String
                }
                
                let fbuser = ["firstname":firstname,"lastname":lastname,"email":email]
                print(fbuser)
                self.doLOGIn(data: fbuser)
                //etc...
            }
        })
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton!) {
        //UserDefaults.standard.removeObject(forKey: "userAccessToken")
    }
    /*--edited10May
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        viewController.modalPresentationStyle = .fullScreen;
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil)
        {
            // Perform any operations on signed in user here.
            let givenName = user.profile.givenName as String
            let familyName = user.profile.familyName as String
            let email = user.profile.email as String
            let user = ["firstname":givenName,"lastname":familyName,"email":email]
            print("--------Google------")
            print(email)
            self.doLOGIn(data: user)
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
        
        
    }
    */
    
    
    func doLOGIn(data:[String:String]){
        let email=data["email"]!
        let firstname=data["firstname"]!
        let lastname=data["lastname"]!
        var params = Dictionary<String,String>();
        params["email"]=email;
        params["firstname"]=firstname;
        params["lastname"]=lastname;
        if let cartId = UserDefaults.standard.value(forKey: "cart_id")
        {
            params["cart_id"] = cartId as? String
        }

        cedMageLoaders.addDefaultLoader(me: self)
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/customer_account/social_login", params: params, controller: self, completionHandler: { data,url,error in
            cedMageLoaders.removeLoadingIndicator(me: self)
            if let jsondata=try? JSON(data:data!)
            {
                print(jsondata)
                let status = jsondata["data"]["status"].stringValue
                if(status=="success")
                {
                    let message = jsondata["data"]["message"].stringValue;
                    UserDefaults.standard.set(["userEmail":email,"userId":jsondata["data"]["customer"]["customer_id"].stringValue,"userHash":jsondata["data"]["customer"]["hash"].stringValue], forKey: "mageWooUser")
                    UserDefaults.standard.set(true, forKey: "mageWooLogin")
                    if(jsondata["data"]["new_user"].stringValue == "false")
                    {
                        if(jsondata["data"]["customer"]["cart_count_status"].stringValue != "false")
                        {
                            if(jsondata["data"]["customer"]["cart_count"].exists())
                            {
                                var count = 0;
                                for(_,value) in jsondata["data"]["customer"]["cart_count"]
                                {
                                    count += value.intValue;
                                }
                                UserDefaults.standard.setValue(String(count), forKey: "CartQuantity")
                            }
                        }
                        
                    }
                    self.view.makeToast(message, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                    NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"),object: nil);
                    mageWooCommon.delay(delay: 2.0, closure: {
                        if(self.cartRegistrationCheck)
                        {
                            let vc=UIStoryboard(name: "mageWooCheckout", bundle: nil).instantiateViewController(withIdentifier: "addaddress") as? addAddressController
                            self.navigationController?.pushViewController(vc!, animated: true);
                        }
                        else
                        {
                            let vc=mageWooCommon().getHomepage()
                            self.tabBarController?.selectedIndex = 0;
                            self.navigationController?.setViewControllers([vc], animated: true)
                            
                            return
                            
                        }
                    })
                    return
                    
                }
                else
                {
                    let statusMessage = jsondata["data"]["message"].stringValue
                    self.showAlert(title: "Message".localized, msg: statusMessage)
                    
                }
                
            }
            
            /*if(jsondata["data"]["success_message"].stringValue == "Thank you for registering with Demo - Autoshare")
             {
             
             }*/
            //self.dismiss(animated: true, completion: nil);
        })
        
        //let loginManager = FBSDKLoginManager()
        //loginManager.logOut()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
