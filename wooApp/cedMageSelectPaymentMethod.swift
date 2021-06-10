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
import Stripe

class selectPaymentMethod: mageBaseViewController {
    
    
    // MyAPIClient implements STPCustomerEphemeralKeyProvider (see above)
   // let customerContext = STPCustomerContext(keyProvider: StripeAPIClient())
    
    //var paymentContext: STPPaymentContext
    
    @IBOutlet weak var mainWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var mainHeight: NSLayoutConstraint!
    
    @IBOutlet weak var taxLabel: UILabel!
    
    @IBOutlet weak var shippingCostLabel: UILabel!
    
    @IBOutlet weak var grandTotalLabel: UILabel!
    
    @IBOutlet weak var subtotalLabel: UILabel!
    
    @IBOutlet weak var selectLabel: UILabel!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var stackWidth: NSLayoutConstraint!
    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var proceedButton: UIButton!
    
    var paymentMethods = [String:String]()
    
    var shippingMethod = String();
    
    var buttonsGroup = [UIButton]();
    
    var selectedPaymentMethod = "";
    
    var tax = "0";
    var subtotal = "0";
    var shippingCost = "0";
    var grandTotal = "0";
    
    var totalAmount = "0";
    var currency = "";
    var orderId = ""
    /*var environment:String = PayPalEnvironmentNoNetwork {
     willSet(newEnvironment) {
     if (newEnvironment != environment) {
     PayPalMobile.preconnect(withEnvironment: newEnvironment)
     }
     }
     }
     
     var resultText = "" // empty
     var payPalConfig = PayPalConfiguration() // default
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May   self.tracking(name: "select payment method");
        //self.paymentContext = STPPaymentContext(customerContext: customerContext)
        //self.paymentContext.delegate = self
        //self.paymentContext.hostViewController = self
        if(tax == "")
        {
            tax = "0"
        }
        makePaymentButtons();
        proceedButton.setThemeColor();
        proceedButton.setTitleColor(wooSetting.textColor, for: .normal)
        
        mainWidth.constant = self.view.frame.width;
        mainHeight.constant = self.view.frame.height;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateBadge();
        self.tabBarController?.tabBar.isHidden = true;
        //PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    
    
    func makePaymentButtons()
    {
        taxLabel.text = currency+tax;
        taxLabel.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        subtotalLabel.text = currency+subtotal;
        subtotalLabel.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        grandTotalLabel.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        shippingCostLabel.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        
        if(shippingCost != "Free!")
        {
            grandTotalLabel.text = currency + grandTotal
            shippingCostLabel.text = currency+shippingCost
        }
        else
        {
            grandTotalLabel.text = currency + grandTotal
            shippingCostLabel.text = shippingCost
        }
        var i = 1;
        for(_, value) in paymentMethods
        {
            let paymentMethodView = radioButtonView();
            mainStackView.addArrangedSubview(paymentMethodView)
            buttonsGroup.append(paymentMethodView.radioButton)
            paymentMethodView.radioButton.setTitle(value, for: .normal)
            
            paymentMethodView.radioButton.addTarget(self, action: #selector(paymentMethodClicked(_:)), for: .touchUpInside);
            paymentMethodView.radioButton.setImage(UIImage(named: "unchecked"), for: .normal);
            buttonsGroup.append(paymentMethodView.radioButton)
            if(i == 1)
            {
                paymentMethodView.radioButton.setImage(UIImage(named: "checked"), for: .normal);
                selectedPaymentMethod=value
            }
            stackHeight.constant += 45;
            mainHeight.constant += 50;
            i += 1;
        }
    }
    
    @objc func paymentMethodClicked(_ sender:UIButton)
    {
        let title = sender.currentTitle;
        for index in 0..<(buttonsGroup.count)
        {
            if(buttonsGroup[index].currentTitle == title)
            {
                sender.setImage(UIImage(named: "checked"), for: .normal);
                selectedPaymentMethod=title!;
            }
            else
            {
                buttonsGroup[index].setImage(UIImage(named: "unchecked"), for: .normal);
            }
        }
    }
    
    
    
    // PayPalPaymentDelegate
    
    /*func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
     print("PayPal Payment Cancelled")
     resultText = ""
     //successView.isHidden = true
     paymentViewController.dismiss(animated: true, completion: nil)
     }
     
     func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
     print("PayPal Payment Success !")
     paymentViewController.dismiss(animated: true, completion: { () -> Void in
     // send completed confirmaion to your server
     print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
     print(completedPayment.confirmation)
     print(completedPayment.invoiceNumber)
     print(completedPayment.description)
     self.resultText = completedPayment.description
     //self.showSuccess()
     })
     }*/
    
    @IBAction func proceedClicked(_ sender: UIButton) {
        if(selectedPaymentMethod == "")
        {
            self.view.makeToast("Select payment method".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            return;
        }
            /*else if(selectedPaymentMethod == "PayPal")
             {
             let total = NSDecimalNumber(string: totalAmount)
             let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Magenative Woocommerce Sale", intent: .sale)
             if (payment.processable) {
             let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
             present(paymentViewController!, animated: true, completion: nil)
             }
             else {
             // This particular payment will always be processable. If, for
             // example, the amount was negative or the shortDescription was
             // empty, this payment wouldn't be processable, and you'd want
             // to handle that here.
             print("Payment not processalbe: \(payment)")
             }
             }*/
        else
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
            params["shipping_method"]=shippingMethod;
            for(key,value) in paymentMethods
            {
                if(value==selectedPaymentMethod)
                {
                    params["payment_method"]=key;
                }
            }
            cedMageLoaders.addDefaultLoader(me: self);
            mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/processcheckout",method: "POST", params:params, controller: self, completionHandler: {
                data,url,error in
                if let data = data {
                    cedMageLoaders.removeLoadingIndicator(me: self);
                    if let json  = try? JSON(data:data)
                    {
                        print(json)
                        if(json["success"].stringValue == "true")
                        {
                            if(params["payment_method"] == "stripe"){
                                
                                let orderData = ["amount":self.grandTotal.replacingOccurrences(of: ",", with: ""),"currency":self.currency]
                                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "StripeViewController") as? StripeViewController
                                {
                                    self.orderId = json["order_id"].stringValue
                                    vc.orderData = orderData;
                                    vc.orderId = self.orderId;
                                    
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                return;
                            }
                            else{
                                let url=URL(string: json["payment_response"]["redirect"].stringValue)
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "checkoutWebView") as? checkoutWebView
                                vc?.url = url;
                                self.navigationController?.pushViewController(vc!, animated: true);
                                
                            }
                            
                            /*if(self.selectedPaymentMethod == "Stripe".localized)
                            {
                                //self.orderId = "456"//json["order_id"].stringValue;
                                let orderData = ["amount":self.grandTotal.replacingOccurrences(of: ",", with: ""),"currency":self.currency]
                                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "StripeViewController") as? StripeViewController
                                {
                                    vc.orderData = orderData;
                                    vc.orderId = "456";
                                    
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                return;
                            }
                            let msg = json["message"].stringValue;
                            let url=URL(string: json["payment_response"]["redirect"].stringValue)
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "checkoutWebView") as? checkoutWebView
                            vc?.url = url;
                            self.navigationController?.pushViewController(vc!, animated: true);*/
                            /*if(params["payment_method"] == "bacs" || params["payment_method"] == "cod" || params["payment_method"] == "cheque")
                             {
                             self.view.makeToast(msg, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                             mageWooCommon.delay(delay: 2.0, closure: {
                             let vc = self.storyboard?.instantiateViewController(withIdentifier: "orderCompletion") as? orderCompletion
                             self.navigationController?.pushViewController(vc!, animated: true);
                             
                             })
                             }
                             else
                             {
                             let url=URL(string: json["payment_response"]["redirect"].stringValue)
                             let vc = self.storyboard?.instantiateViewController(withIdentifier: "checkoutWebView") as? checkoutWebView
                             vc?.url = url;
                             self.navigationController?.pushViewController(vc!, animated: true);
                             }*/
                        }
                        else
                        {
                            self.view.makeToast("Some error occured".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                        }
                    }
                    
                    
                }
            })
        }
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

