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

class mageWooForgotPassword: UIViewController {

    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var mainViewWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May    self.tracking(name: "forgot password");
        mainViewWidth.constant=self.view.frame.width;
        resetButton.addTarget(self, action: #selector(forgotPasswordClicked(_:)), for: .touchUpInside)
        emailField.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        resetButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        emailField.decorateField();
        resetButton.setThemeColor();
        resetButton.setTitleColor(wooSetting.textColor, for: .normal)
        /*if #available(iOS 12.0, *) {
            if(traitCollection.userInterfaceStyle == .dark)
            {
                resetButton.setTitleColor(wooSetting.darkModeTextColor, for: .normal)
            }
        }*/        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    @objc func forgotPasswordClicked(_ sender: UIButton)
    {
        emailField.resignFirstResponder();
        let email = emailField.text!;
        if(email == "")
        {
            self.view.makeToast("Email is required".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            return;
        }
        if(!isValidEmail(testStr: email))
        {
            self.view.makeToast("Email is invalid".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            return;
        }
        cedMageLoaders.addDefaultLoader(me: self);
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/customer_account/forgotPassword",method: "POST", params:["email":email], controller: self, completionHandler: {
            data,url,error in
            if let data = data {
                cedMageLoaders.removeLoadingIndicator(me: self);
                if let json  = try? JSON(data:data){
                    print(json)
                    let status = json["data"]["customer"]["status"].stringValue;
                    if(status=="success")
                    {
                        let message = json["data"]["customer"]["message"].stringValue
                        self.view.makeToast(message, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                        mageWooCommon.delay(delay: 2.0, closure: {
                            self.navigationController?.popToRootViewController(animated: true);
                        })
                        
                    }
                    else
                    {
                        let message = json["data"]["customer"]["message"].stringValue
                        self.view.makeToast(message, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
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
