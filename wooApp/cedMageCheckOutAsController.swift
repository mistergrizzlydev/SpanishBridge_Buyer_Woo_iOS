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

class checkOutAsController: mageBaseViewController {

    @IBOutlet weak var signUpView: UIView!
    
    @IBOutlet weak var SignUpButton: UIButton!
        
    @IBOutlet weak var guestUserButton: UIButton!
    
    @IBOutlet weak var existingUserButton: UIButton!
    
    @IBOutlet weak var noAccountLabel: UILabel!
    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var emaiPassViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var proceedButton: UIButton!
    
    @IBOutlet weak var superViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var superViewWidth: NSLayoutConstraint!
    
    var registeredUserCheck = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May   self.tracking(name: "Checkout as");
        superViewWidth.constant = self.view.frame.width;
        superViewHeight.constant = self.view.frame.height;
        passwordField.isHidden=true;
        passwordField.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        emaiPassViewHeight.constant=55;
        emailField.decorateField();
        emailField.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        passwordField.decorateField();
        guestUserButton.addTarget(self, action: #selector(guestUserButtonClicked(_:)), for: .touchUpInside)
        guestUserButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .bold, size: 17)
        existingUserButton.addTarget(self, action: #selector(existingUserButtonClicked(_:)), for: .touchUpInside)
        proceedButton.backgroundColor=wooSetting.themeColor
        
        proceedButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .bold, size: 17)
        proceedButton.addTarget(self, action: #selector(proceedButtonClicked(_:)), for: .touchUpInside)
        signUpView.setThemeColor()
        signUpView.layer.cornerRadius = 7
        SignUpButton.backgroundColor = wooSetting.themeColor
        
        SignUpButton.setTitleColor(wooSetting.textColor, for: .normal)
        noAccountLabel.textColor = wooSetting.textColor
        proceedButton.setTitleColor(wooSetting.textColor, for: .normal)
        SignUpButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        SignUpButton.addTarget(self, action: #selector(SignUpButtonClicked(_:)), for: .touchUpInside)
        SignUpButton.layer.cornerRadius=7;
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.updateBadge();
        //self.tabBarController?.tabBar.isHidden = false;
    }
    
    
    
    @objc func guestUserButtonClicked(_ sender: UIButton)
    {
        existingUserButton.setImage(UIImage(named: "unchecked"), for: .normal)
        guestUserButton.setImage(UIImage(named: "checked"), for: .normal)
        registeredUserCheck=false;
        emaiPassViewHeight.constant = 55;
        passwordField.isHidden=true;
    }
    
    @objc func existingUserButtonClicked(_ sender: UIButton)
    {
        existingUserButton.setImage(UIImage(named: "checked"), for: .normal)
        guestUserButton.setImage(UIImage(named: "unchecked"), for: .normal)
        registeredUserCheck=true;
        emaiPassViewHeight.constant = 110;
        passwordField.isHidden=false;
    }
    
    @objc func proceedButtonClicked(_ sender: UIButton)
    {
        if(registeredUserCheck==true)
        {
            let email = emailField.text!;
            let password = passwordField.text!;
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
                       let vc=UIStoryboard(name: "mageWooCheckout", bundle: nil).instantiateViewController(withIdentifier: "cedMageNewAddressController") as? cedMageNewAddressController
                        self.navigationController?.pushViewController(vc!, animated: true);
                        return
                    })
                }else{
                    
                    let alert=UIAlertController(title: "Error".localized, message: "Wrong Email Or Password.".localized, preferredStyle: .alert)
                    let action=UIAlertAction(title: "Ok".localized, style: .default, handler: nil)
                    alert.addAction(action)
                    alert.modalPresentationStyle = .fullScreen;
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
        }
        else
        {
            if(emailField.text == "")
            {
                self.view.makeToast("Email field is blank".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                return;
            }
            let vc=UIStoryboard(name: "mageWooCheckout", bundle: nil).instantiateViewController(withIdentifier: "cedMageNewAddressController") as? cedMageNewAddressController
            self.navigationController?.pushViewController(vc!, animated: true);
        }
    }
    
    @objc func SignUpButtonClicked(_ sender:UIButton)
    {
        let vc = UIStoryboard(name: "mageWooLogin", bundle: nil).instantiateViewController(withIdentifier: "registerController") as! wooMageRegister
        vc.cartRegistrationCheck=true;
        navigationController?.pushViewController(vc, animated: true)
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
