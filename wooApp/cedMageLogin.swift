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
import GoogleSignIn
import AuthenticationServices

class wooMageLogin: UIViewController, UITableViewDelegate, UITableViewDataSource, GIDSignInDelegate {

    var showPasswordCheck = false
    var cartRegistrationCheck = false
    @IBOutlet weak var loginTableView: UITableView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May   self.tracking(name: "login page");
        wooMageNavigation().makeNaVigationBar(me: self)
        loginTableView.delegate=self;
        loginTableView.dataSource=self;
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
            if let cell=loginTableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as? mageLoginCell
            {
                if let userdefaults = UserDefaults.standard.value(forKey: "themeSettings") as? [String:String]
                {
                    if let logoImage = userdefaults["ced_theme_loginpage_logo_image"]
                    {
                        cell.logoImageView.sd_setImage(with: URL(string: logoImage), placeholderImage: UIImage(named: "placeholder"))
                    }
                    if let logoHeader = userdefaults["ced_theme_loginpage_header_image"]
                    {
                        cell.loginHeaderImageView.sd_setImage(with: URL(string: logoHeader), placeholderImage: UIImage(named: "placeholder"))
                    }
                    
                }
                
                return cell
            }
        }
        else if(indexPath.section==1)
        {
            if let cell=loginTableView.dequeueReusableCell(withIdentifier: "fieldCell", for: indexPath) as? mageLoginCell
            {
                if let value = UserDefaults.standard.value(forKey: "wooAppLanguage") as? String
                {
                    if value=="ar" || value=="ur"
                    {
                        cell.emailField.textAlignment = .right
                        cell.passwordField.textAlignment = .right
                    }
                    else
                    {
                        cell.emailField.textAlignment = .left
                        cell.passwordField.textAlignment = .left
                    }
                }
                cell.emailField.tag = 1;
                cell.passwordField.tag = 2;
                cell.emailField.makeCircledField();
                cell.passwordField.makeCircledField();
                cell.showPasswordButton.addTarget(self, action: #selector(showPasswordClicked(_:)), for: .touchUpInside)
                cell.showPasswordButton.setTitleColor(wooSetting.subTextColor, for: .normal)
                /*if #available(iOS 12.0, *) {
                    if(traitCollection.userInterfaceStyle == .dark)
                    {
                        cell.showPasswordButton.setTitleColor(wooSetting.darkModeSubTextColor, for: .normal)
                    }
                }*/
                cell.loginButton.addTarget(self, action: #selector(loginClicked(_:)), for: .touchUpInside)
                return cell;
            }
        }
        else if(indexPath.section==2)
        {
            if let cell=loginTableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as? mageLoginCell
            {
                
                //cell.signupView.setThemeColor();
                cell.forgotPassword.addTarget(self, action: #selector(forgotPasswordClicked(_:)), for: .touchUpInside)
                cell.orButton.layer.cornerRadius=15;
                cell.orButton.layer.borderWidth=1;
                cell.orButton.layer.borderColor=wooSetting.subTextColor?.cgColor
                cell.leftLine.backgroundColor = wooSetting.subTextColor;
                cell.rightLine.backgroundColor = wooSetting.subTextColor;
                cell.bottomLine.backgroundColor = wooSetting.subTextColor;
                cell.forgotPassword.setTitleColor(wooSetting.subTextColor, for: .normal)
                cell.signupButton.setTitleColor(wooSetting.subTextColor, for: .normal);
                cell.fbSignInButton.addTarget(self, action: #selector(facebookLogIn(_:)), for: .touchUpInside)
                cell.googleSignInButton.addTarget(self, action: #selector(googleSignInPressed(_:)), for: .touchUpInside)
                cell.forgotPassword.layer.cornerRadius=7;
                
                if #available(iOS 12.0, *) {
                    let isDarkTheme = view.traitCollection.userInterfaceStyle == .dark
                    if #available(iOS 13.0, *) {
                        let style: ASAuthorizationAppleIDButton.Style = isDarkTheme ? .white : .black
                        let authorizationButton = ASAuthorizationAppleIDButton(type: .default, style: style)
                        cell.appleSignInView.addSubview(authorizationButton)
                        authorizationButton.translatesAutoresizingMaskIntoConstraints = false;
                        authorizationButton.center = cell.appleSignInView.center
                        let heightConstraint = authorizationButton.heightAnchor.constraint(equalToConstant: 40)
                        authorizationButton.addConstraint(heightConstraint)
                        
                        //                        let widthConstraint = authorizationButton.widthAnchor.constraint(equalToConstant: 250)
                        //                        authorizationButton.addConstraint(widthConstraint)
                        cell.appleSignInView.addConstraint(NSLayoutConstraint(item: authorizationButton, attribute: .trailing, relatedBy: .equal, toItem: cell.appleSignInView, attribute: .trailing, multiplier: 1, constant: -10))
                        cell.appleSignInView.addConstraint(NSLayoutConstraint(item: authorizationButton, attribute: .leading, relatedBy: .equal, toItem: cell.appleSignInView, attribute: .leading, multiplier: 1, constant: 10))
                        cell.appleSignInView.layer.cornerRadius = 7;
                        
                        authorizationButton.addTarget(self, action: #selector(handleLogInWithAppleIDButtonPress), for: .touchUpInside)
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    // Create and Setup Apple ID Authorization Button
                    
                } else {
                    // Fallback on earlier versions
                }
                
                return cell;
            }
        }
        return UITableViewCell();
    }
    

    @objc func showPasswordClicked(_ sender: UIButton)
    {
        showPasswordCheck = !showPasswordCheck
        if let passwordField = self.view.viewWithTag(2) as? UITextField
        {
            if(showPasswordCheck)
            {
                passwordField.isSecureTextEntry = false
                sender.setImage(UIImage(named: "checked"), for: .normal)
            }
            else
            {
                passwordField.isSecureTextEntry = true
                sender.setImage(UIImage(named: "unchecked"), for: .normal)
            }
        }
        
    }
    
    @objc func loginClicked(_ sender:UIButton)
    {
        let emailField = self.view.viewWithTag(1) as! UITextField
        let passwordField = self.view.viewWithTag(2) as! UITextField
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        if let email=(self.view.viewWithTag(1) as? UITextField)?.text, let password=(self.view.viewWithTag(2) as? UITextField)?.text
        {
            if(email == "" || password == "")
            {
                self.view.makeToast("Some fields are blank".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                return;
            }
            if(!isValidEmail(testStr: email))
            {
                self.view.makeToast("Email is invalid".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                return;
            }
            cedMageLoaders.addDefaultLoader(me: self)
            User().wooLogin(email: email, password: password, control: self){
                success in
                cedMageLoaders.removeLoadingIndicator(me: self)
                print(success)
                if success{
                    self.view.makeToast("Login Successful".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                    NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"),object: nil);
                    mageWooCommon.delay(delay: 2.0, closure: {
                        let vc=mageWooCommon().getHomepage()
                        self.tabBarController?.selectedIndex = 0;
                        self.navigationController?.setViewControllers([vc], animated: true)
                        
                        return
                    })
                }else{
                    
                    let alert=UIAlertController(title: "Error".localized, message: "Wrong Email Or Password.".localized, preferredStyle: .alert)
                    let action=UIAlertAction(title: "Ok".localized, style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }

        }
    }
    
    @objc func forgotPasswordClicked(_ sender:UIButton)
    {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "forgot") as? mageWooForgotPassword
        {
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
    func signupClicked(_ sender:UIButton)
    {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section==0)
        {
            return 250
        }
        else if(indexPath.section==1)
        {
            return 220
        }
        //return 320
        return 380
    }
    
    func getInfoPlist(fileName:String?,indexString:NSString) ->AnyObject?{
        
        
        let path = Bundle.main.path(forResource: fileName, ofType: "plist")
        let storedvalues = NSDictionary(contentsOfFile: path!)
        let response: AnyObject? = storedvalues?.object(forKey: indexString) as AnyObject?
        return response
    }
    
    @objc func googleSignInPressed(_ sender: UIButton)
    {
        let googlesignin = GIDSignIn.sharedInstance()
        googlesignin?.presentingViewController = self;
        googlesignin?.clientID = self.getInfoPlist(fileName: "GoogleService-Info", indexString: "CLIENT_ID") as? String

        googlesignin?.scopes.append("https://www.googleapis.com/auth/plus.login")
        googlesignin?.scopes.append("https://www.googleapis.com/auth/plus.me")
        //googlesignin?.uiDelegate = self
        googlesignin?.shouldFetchBasicProfile = true
        googlesignin?.delegate = self

        googlesignin?.signIn()

    }
    
    
    @objc func facebookLogIn(_ sender: UIButton) {
        
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
                    print(result)
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
                print(result)
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
    //--edited10May
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
                    NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"),object: nil);
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
                    //NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"),object: nil);
                    mageWooCommon.delay(delay: 2.0, closure: {
                        if(self.cartRegistrationCheck)
                        {
                            let vc=UIStoryboard(name: "mageWooCheckout", bundle: nil).instantiateViewController(withIdentifier: "cedMageNewAddressController") as? cedMageNewAddressController
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

//MARK:- Apple Sign Methods
extension wooMageLogin : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding
{
    @objc func handleLogInWithAppleIDButtonPress() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
                
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    private func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        if #available(iOS 13.0, *) {
            let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
            // Create an authorization controller with the given requests.
            let authorizationController = ASAuthorizationController(authorizationRequests: requests)
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
        
        
    }
       
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
           //Handle error here
           print("error = \(error.localizedDescription)")
       }
       
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Create an account in your system.
            print("User Id - \(appleIDCredential.user)")
            print("User Name - \(appleIDCredential.fullName?.description ?? "N/A")")
            print("User Email - \(appleIDCredential.email ?? "N/A")")
            print("Real User Status - \(appleIDCredential.realUserStatus.rawValue)")
            
            if let identityTokenData = appleIDCredential.identityToken,
                let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                print("Identity Token \(identityTokenString)")
            }
            
            self.signInWithAppleRequest(params: ["apple_id":appleIDCredential.user,"firstname":appleIDCredential.fullName?.givenName ?? "","lastname":appleIDCredential.fullName?.familyName ?? "","email":appleIDCredential.email ?? ""])
            
            //Show Home View Controller
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
                let alertController = UIAlertController(title: "Keychain Credential Received",
                                                        message: message,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    func signInWithAppleRequest(params: [String:String])
    {
        cedMageLoaders.addDefaultLoader(me: self)
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/customer_account/appleaccountlogin", params: params, controller: self, completionHandler: { data,url,error in
            cedMageLoaders.removeLoadingIndicator(me: self)
           // print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
            guard let jsondata = try? JSON(data:data!) else {return}
            print(jsondata)
          
            let status = jsondata["data"]["status"].stringValue
            if(status=="success")
            {
                let message = jsondata["data"]["message"].stringValue;
                let customer = jsondata["data"]["customer"];
                let email = customer["customer_email"].stringValue
            UserDefaults.standard.set(["userEmail":email,"userId":jsondata["data"]["customer"]["customer_id"].stringValue,"userHash":jsondata["data"]["customer"]["hash"].stringValue], forKey: "mageWooUser")
                NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"),object: nil);
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
                //NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"),object: nil);
                mageWooCommon.delay(delay: 2.0, closure: {
                    if(self.cartRegistrationCheck)
                    {
                        self.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
                        let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainhomevc") as! mageWooHome
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
            
            /*if(jsondata["data"]["success_message"].stringValue == "Thank you for registering with Demo - Autoshare")
             {
             
             }*/
            //self.dismiss(animated: true, completion: nil);
        })
    }
}



