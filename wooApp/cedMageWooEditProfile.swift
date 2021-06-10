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

class mageWooEditProfile: mageBaseViewController {

    @IBOutlet weak var firstName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var showPasswordLabel: UILabel!
    @IBOutlet weak var lastName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var email: SkyFloatingLabelTextField!
    
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var passwordCheckbox: UIButton!
    
    @IBOutlet weak var oldPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var newPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var confirmPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    var passwordCheck = false;
    
    var userName = String();
    
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mainViewWidth: NSLayoutConstraint!
    
    var showPasswordCheck = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May   self.tracking(name: "edit profile");
        mainViewHeight.constant = self.view.frame.height;
        mainViewWidth.constant = self.view.frame.width;
        viewHeight.constant -= 190;
        firstName.decorateField();
        firstName.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        lastName.decorateField();
        lastName.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        email.decorateField();
        email.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        oldPassword.decorateField();
        oldPassword.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        newPassword.decorateField();
        newPassword.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        confirmPassword.decorateField();
        confirmPassword.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        oldPassword.isHidden=true;
        newPassword.isHidden=true;
        confirmPassword.isHidden=true;
        showPasswordLabel.isHidden=true;
        showPasswordButton.isHidden=true;
        showPasswordButton.setImage(UIImage(named: "unchecked"), for: .normal);
        passwordCheckbox.setImage(UIImage(named: "unchecked"), for: .normal);
        passwordCheckbox.addTarget(self, action: #selector(passwordClicked(_:)), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonClicked(_:)), for: .touchUpInside)
        saveButton.setThemeColor();
        saveButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        saveButton.setTitleColor(wooSetting.textColor, for: .normal)
        /*if #available(iOS 12.0, *) {
            if(traitCollection.userInterfaceStyle == .dark)
            {
                saveButton.setTitleColor(wooSetting.darkModeTextColor, for: .normal)
            }
        }*/
        showPasswordButton.addTarget(self, action: #selector(showPasswordClicked(_:)), for: .touchUpInside)
        showPasswordButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        var userId = ""
        if let user = User().getLoginUser() {
            userId = user["userId"]!
        }
        cedMageLoaders.addDefaultLoader(me: self)
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/customer_account/fetch_userprofile", params: ["user-id":userId], controller: self, completionHandler: {
            data,url,error in
            if let data = data {
                cedMageLoaders.removeLoadingIndicator(me: self)
                if let jsondata = try? JSON(data:data){
                    print(jsondata)
                    self.email.text = jsondata["data"]["customer"]["email"].stringValue;
                    self.firstName.text = jsondata["data"]["customer"]["first_name"].stringValue;
                    self.lastName.text = jsondata["data"]["customer"]["last_name"].stringValue;
                    self.userName=jsondata["data"]["customer"]["user_name"].stringValue;
                    self.viewHeight.constant = 130;
                }
                
            }
        })
        // Do any additional setup after loading the view.
    }

    
    
    @objc func showPasswordClicked(_ sender: UIButton)
    {
        showPasswordCheck = !showPasswordCheck;
        if(showPasswordCheck)
        {
            oldPassword.isSecureTextEntry = false;
            newPassword.isSecureTextEntry = false;
            confirmPassword.isSecureTextEntry = false;
            sender.setImage(UIImage(named: "checked"), for: .normal);
        }
        else
        {
            oldPassword.isSecureTextEntry = true;
            newPassword.isSecureTextEntry = true;
            confirmPassword.isSecureTextEntry = true;
            sender.setImage(UIImage(named: "unchecked"), for: .normal);
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
        self.updateBadge();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    @objc func passwordClicked(_ sender: UIButton)
    {
        if(passwordCheck==false)
        {
            passwordCheck=true;
            sender.setImage(UIImage(named: "checked"), for: .normal);
            viewHeight.constant += 190;
            oldPassword.isHidden=false;
            newPassword.isHidden=false;
            confirmPassword.isHidden=false;
            showPasswordLabel.isHidden=false;
            showPasswordButton.isHidden=false;
        }
        else if(passwordCheck==true)
        {
            passwordCheck=false;
            sender.setImage(UIImage(named: "unchecked"), for: .normal);
            viewHeight.constant -= 190;
            oldPassword.isHidden=true;
            newPassword.isHidden=true;
            confirmPassword.isHidden=true;
            showPasswordLabel.isHidden=true;
            showPasswordButton.isHidden=true;
        }
    }
    
    @objc func saveButtonClicked(_ sender: UIButton)
    {
        print(passwordCheck)
        email.resignFirstResponder();
        firstName.resignFirstResponder();
        lastName.resignFirstResponder();
        oldPassword.resignFirstResponder();
        newPassword.resignFirstResponder();
        confirmPassword.resignFirstResponder();
        let emailText = email.text;
        let firstNameText = firstName.text;
        let lastNameText = lastName.text;
        let oldPasswordText = oldPassword.text;
        let newPasswordText = newPassword.text;
        let confirmPasswordText = confirmPassword.text;
        var params = Dictionary<String, String>()
        if let user = User().getLoginUser() {
            params["user-id"] = user["userId"]
        }
        if(firstNameText == "" || lastNameText == "" || emailText == "")
        {
            self.view.makeToast("All Fields are Required.".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            return
        }
        if(!isValidName(testStr: firstNameText!))
        {
            self.view.makeToast("First Name Is Required.".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            return
        }
        if(!isValidName(testStr: lastNameText!))
        {
            self.view.makeToast("Last Name Is Required.".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            return
        }
        if(!isValidEmail(testStr: emailText!))
        {
            self.view.makeToast("Email is Required.".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            return
        }
        params["firstname"]=firstNameText!;
        params["lastname"]=lastNameText!;
        params["email"]=emailText!;
        if(passwordCheck==true)
        {
            if(oldPasswordText == "" || newPasswordText == "" || confirmPasswordText == "")
            {
                self.view.makeToast("All Fields are Required.".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                return
            }
            if(newPasswordText != confirmPasswordText)
            {
                self.view.makeToast("Please enter same password for confirm password".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                return
            }
            params["user_name"]=userName;
            params["oldpassword"]=oldPasswordText!;
            params["new_password"]=newPasswordText!
            params["confirm_password"]=confirmPasswordText!;
        }
        cedMageLoaders.addDefaultLoader(me: self)
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/customer_account/updateProfile", params: params,controller: self, completionHandler: {data,url,error in
            if let data = data {
                cedMageLoaders.removeLoadingIndicator(me: self)
                if let jsondata = try? JSON(data:data){
                    let status = jsondata["data"]["customer"]["status"].stringValue;
                    let msg = jsondata["data"]["customer"]["message"].stringValue;
                    if(status=="success")
                    {
                        self.view.makeToast(msg, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                        mageWooCommon.delay(delay: 2.0, closure: {
                            let vc=mageWooCommon().getHomepage()
                            self.tabBarController?.selectedIndex = 0;
                            self.navigationController?.setViewControllers([vc], animated: true)
                            
                            return
                        })
                    }
                    else
                    {
                        self.view.makeToast(msg, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                    }
                }
                
                
            }
        })
        
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
