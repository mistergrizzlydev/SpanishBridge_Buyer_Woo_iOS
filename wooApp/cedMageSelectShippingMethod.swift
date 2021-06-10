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

class selectShippingMethod: mageBaseViewController {
    
    @IBOutlet weak var selectShippingLabel: UILabel!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var superViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var superViewWidth: NSLayoutConstraint!
    
    var shippingMethods = [[String:String]]()
    var taxes = "0"
    var buttonsGroup = [UIButton]();
    var cart_subtotal = "";
    var selectedMethod = "";
    var tax_label = ""
    var totalAmount = "0"
    var paymentMethods = [String: String]();
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var subtotal: UILabel!
    var currency = ""
    
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var proceedButton: UIButton!
    
    @IBOutlet weak var chargesView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May   self.tracking(name: "select shipping method");
        getShippingMethods();
        superViewHeight.constant = self.view.frame.height;
        superViewWidth.constant = self.view.frame.width;
        proceedButton.addTarget(self, action: #selector(proceedButtonClicked(_:)), for: .touchUpInside)
        stackViewHeight.constant = 0;
        chargesView.layer.borderWidth = 1;
        chargesView.layer.borderColor = UIColor.black.cgColor;
        if #available(iOS 12.0, *) {
            if(traitCollection.userInterfaceStyle == .dark)
            {
                chargesView.layer.borderColor = UIColor.white.cgColor;
            }
        }
        proceedButton.setThemeColor();
        proceedButton.setTitleColor(wooSetting.textColor, for: .normal)
        /*if #available(iOS 12.0, *) {
            if(traitCollection.userInterfaceStyle == .dark)
            {
                proceedButton.setTitleColor(wooSetting.darkModeTextColor, for: .normal);
            }
        }*/
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateBadge();
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    
    
    func getShippingMethods()
    {
        var params = Dictionary<String,String>();
        if let user = User().getLoginUser() {
            params["customer_id"] = user["userId"]
        }
        else{
            if let cartId = UserDefaults.standard.value(forKey: "cart_id")
            {
                params["cart_id"] = cartId as? String
            }
        }
        cedMageLoaders.addDefaultLoader(me: self);
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/checkoutdetailpage",method: "POST", params:params, controller: self, completionHandler: {
            data,url,error in
            if let data = data {
                cedMageLoaders.removeLoadingIndicator(me: self);
                if let json  = try? JSON(data:data)
                {
                    print(json)
                    if(json["success"].stringValue == "true")
                    {
                        self.tax_label = json["data"]["tax_label"].stringValue
                        self.cart_subtotal = json["data"]["cart_subtotal"].stringValue
                        self.taxes = json["data"]["taxes_total"].stringValue
                        self.currency = json["data"]["currency_symbol"].stringValue
                        self.totalAmount = json["data"]["cart_total"].stringValue
                        for(_,value) in json["data"]["rates"]
                        {
                            var ship = [String:String]()
                            ship["id"]=value["id"].stringValue
                            ship["label"]=value["label"].stringValue
                            ship["cost"]=value["cost"].stringValue
                            ship["final_cost"]=value["final_cost"].stringValue;
                            self.shippingMethods.append(ship);
                        }
                        self.makeShippingButtons();
                    }
                }
                
            }
        })
    }
    
    func makeShippingButtons()
    {
        subtotal.text = currency+cart_subtotal
        subtotal.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        tax.text = currency+self.taxes;
        tax.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        if(taxes == "")
        {
            tax.text = currency+"0";
            
        }
        total.text = currency+self.totalAmount;
        total.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        for index in 0..<shippingMethods.count
        {
            let shippingView = radioButtonView();
            let curr = currency + shippingMethods[index]["final_cost"]!
            let title = shippingMethods[index]["label"]! + " - " + curr + "\(tax_label)"
            print(title)
            shippingView.radioButton.setImage(UIImage(named: "unchecked"), for: .normal)
            shippingView.radioButton.setTitle(title , for: .normal);
            if(index == 0)
            {
                selectedMethod=shippingMethods[index]["label"]!;
                shippingView.radioButton.setImage(UIImage(named: "checked"), for: .normal)
                //total.text = currency + String(Double(totalAmount)! + Double(shippingMethods[index]["cost"]!)!)
                //subtotal.text = currency + String(Double(cart_subtotal)! + Double(shippingMethods[index]["cost"]!)!)
                
            }
            shippingView.radioButton.addTarget(self, action: #selector(shippingMethodClicked(_:)), for: .touchUpInside)
            
            shippingView.radioButton.tag=index;
            buttonsGroup.append(shippingView.radioButton);
            stackViewHeight.constant += 45
            superViewHeight.constant += 45;
            mainStackView.addArrangedSubview(shippingView);
            
            
        }
    }
    
    @objc func shippingMethodClicked(_ sender: UIButton)
    {
        //let buttonTitle = sender.currentTitle
        let senderTag = sender.tag
        for index in 0..<buttonsGroup.count
        {
            if(index == senderTag)
            {
                buttonsGroup[index].setImage(UIImage(named: "checked"), for: .normal);
                selectedMethod=shippingMethods[index]["label"]!;
                //subtotal.text = currency + String(Double(cart_subtotal)! + Double(shippingMethods[index]["cost"]!)!)
                //total.text = currency + String(Double(totalAmount)! + Double(shippingMethods[index]["cost"]!)!)
                
                
                
            }
            else
            {
                buttonsGroup[index].setImage(UIImage(named: "unchecked"), for: .normal);
            }
        }
    }
    
    @objc func proceedButtonClicked(_ sender:UIButton)
    {
        if(selectedMethod=="")
        {
            self.view.makeToast("Select shipping method".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            return;
        }
        var params = Dictionary<String,String>();
        if let user = User().getLoginUser() {
            params["customer_id"] = user["userId"]
        }
        else{
            if let cartId = UserDefaults.standard.value(forKey: "cart_id")
            {
                params["cart_id"] = cartId as? String
            }
        }
        var shipping_id = "";
        for index in 0..<shippingMethods.count
        {
            if(shippingMethods[index]["label"]==selectedMethod)
            {
                shipping_id=shippingMethods[index]["id"]!;
            }
        }
        params["shipping_id"]=shipping_id;
        cedMageLoaders.addDefaultLoader(me: self);
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/changeshipping",method: "POST", params:params, controller: self, completionHandler: {
            data,url,error in
            if let data = data {
                cedMageLoaders.removeLoadingIndicator(me: self);
                if let json  = try? JSON(data:data)
                {
                    print(json)
                    if(json["success"].stringValue == "true")
                    {
                        for(key,value) in json["data"]["gateways"]
                        {
                            self.paymentMethods[key]=value["title"].stringValue;
                        }
                        if(self.paymentMethods.count == 0)
                        {
                            self.view.makeToast("Payment Methods Not Available".localized, duration: 2.0, position: .center);
                            return;
                        }
                        let total = json["data"]["cart_total"].stringValue;
                        self.view.makeToast("Shipping Method Changed Successfully".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                        mageWooCommon.delay(delay: 2.0, closure: {
                            let vc=self.storyboard?.instantiateViewController(withIdentifier: "selectpayment") as? selectPaymentMethod
                            vc?.paymentMethods=self.paymentMethods;
                            vc?.shippingMethod=shipping_id;
                            vc?.totalAmount=total;
                            
                            vc?.tax = json["data"]["taxes_total"].stringValue;
                            vc?.subtotal = json["data"]["cart_subtotal"].stringValue;
                            vc?.grandTotal = json["data"]["cart_total"].stringValue;
                            vc?.currency = self.currency;
                            vc?.shippingCost = json["data"]["shipping_total"].stringValue;
                            self.navigationController?.pushViewController(vc!, animated: true);
                            
                        })
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

