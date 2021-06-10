//
//  StripeViewController.swift
//  wooApp
//
//  Created by Manohar Singh Rawat on 13/04/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import UIKit
import Stripe

class StripeViewController: UIViewController, STPPaymentCardTextFieldDelegate {
    
    var orderId = "";
    var orderData = [String:String]();
    let paymentTextField = STPPaymentCardTextField()
    @IBOutlet weak var pay: UIButton!
    
    let backendBaseURL: String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.paymentTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.width - 30, height: 44)
        self.paymentTextField.delegate = self
        self.view.addSubview(self.paymentTextField)
        self.pay.addTarget(self, action: #selector(paymentButtonClicked(_:)), for: .touchUpInside);
        self.pay.isHidden = true;
        self.pay.setThemeColor()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
        navigationItem.hidesBackButton = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        if textField.isValid {
            pay.isHidden = false;
        }
        else
        {
            pay.isHidden = false;
        }
    }

    @objc func paymentButtonClicked(_ sender: UIButton)
    {
        let card = paymentTextField.cardParams
        let stpCard = STPCardParams()
        stpCard.number = card.number
        stpCard.cvc = card.cvc
        if let expmonth = card.expMonth as? UInt{
            stpCard.expMonth = expmonth
        }
        if let expyear = card.expYear as? UInt{
            stpCard.expYear = expyear
        }
        STPAPIClient.shared.createToken(withCard: stpCard, completion: {(token, error) -> Void in
        if let error = error {
            print("---error --")
            print(error)
            self.view.makeToast(error.localizedDescription, duration: 2.0, position: .center)
        }
        else if let token = token {
            print(token)
            self.chargeUsingToken(token: token)
        }})
    }
    
    func chargeUsingToken(token:STPToken) {
      //  let requestString = "https://yourwine.ie/wp-json/mobiconnect/checkout/callbackurl"
        let requestString = wooSetting.baseUrl+"mobiconnect/checkout/callbackurl"
        if let amount = Double(orderData["amount"]!) {
            //let amountInt = Int(amount)
            let params = ["stripeToken": token.tokenId, "amount": "\(amount)", "currency": "eur", "description": "iOS App Payment","order_id":orderId]
            print(params);
            cedMageLoaders.addDefaultLoader_withlockedbackground(me: self)
            //with response handler:
            mageRequets.sendPaymentHttpRequest(endPoint: requestString,method: "POST",params: params, controller: self, completionHandler: {
                data,url,error in
                //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
                if let data = data{
                    cedMageLoaders.removeLoadingIndicator(me: self)
                    let datastring = NSString(data: data, encoding: String.Encoding.utf8.rawValue);
                    print("datastring");
                    print(datastring as Any);
                    let json = try! JSON(data: data);
                    self.view.makeToast(json["message"].stringValue, duration: 2.0, position: .center);
                    mageWooCommon.delay(delay: 2.0, closure: {
                        print(json)
                        self.paymentCompleted(json: json);
                    })
                }
            })
            
        }
        
    }
    
    func paymentCompleted(json: JSON)
    {
        
        if(json["status"].stringValue.lowercased() == "success"){
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
            mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/empty_paypal_cart",method: "POST", params:params, controller: self, completionHandler: {
                data,url,error in
                if let data = data {
                    cedMageLoaders.removeLoadingIndicator(me: self);
                    let jsondata  = try! JSON(data:data)
                    print(jsondata)
                    if(jsondata["success"].stringValue == "true")
                    {
                        UserDefaults.standard.removeObject(forKey: "cart_id")
                        UserDefaults.standard.setValue("0", forKey: "CartQuantity")
                        //let msg = json["message"].stringValue;
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "orderCompletion") as? orderCompletion
                        self.navigationController?.setViewControllers([vc!], animated: true)
                        
                    }
                    else
                    {
                        self.view.makeToast("Some error occured".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                    }
                    
                }
            })
        }
        else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "orderFailed") as? orderFailed
            self.navigationController?.setViewControllers([vc!], animated: true)
        }
        
        /*cedMageLoaders.addDefaultLoader(me: self)
        var params = [String:String]()
        var status = "failure"
        if(json["status"].stringValue.lowercased() == "success")
        {
            status = "success";
        }
        let paymentId = json["transaction_id"].stringValue;
        params["order_id"] = orderId;
        params["transaction_id"] = paymentId;
        params["order_status"] = status
        if let user = User().getLoginUser() {
            params["customer_id"] = user["userId"]
        }
        else{
            if let cartId = UserDefaults.standard.value(forKey: "cart_id")
            {
                params["cart_id"] = cartId as? String
            }
        }
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/orderstatus",method: "POST", params: params, controller: self, completionHandler: {
            data,url,error in
            if let data = data {
                cedMageLoaders.removeLoadingIndicator(me: self);
                let json = try! JSON(data: data)
                print(json)
                if(json["data"]["status"].stringValue == "true")
                {
                    
                    self.view.makeToast("Payment completed successfully", duration: 2.0, position: .center)
                    mageWooCommon.delay(delay: 2.0, closure: {
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
                        mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/empty_paypal_cart",method: "POST", params:params, controller: self, completionHandler: {
                            data,url,error in
                            if let data = data {
                                cedMageLoaders.removeLoadingIndicator(me: self);
                                let jsondata  = try! JSON(data:data)
                                print(jsondata)
                                if(jsondata["success"].stringValue == "true")
                                {
                                    UserDefaults.standard.removeObject(forKey: "cart_id")
                                    UserDefaults.standard.setValue("0", forKey: "CartQuantity")
                                    //let msg = json["message"].stringValue;
                                    
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "orderCompletion") as? orderCompletion
                                    self.navigationController?.setViewControllers([vc!], animated: true)
                                    
                                }
                                else
                                {
                                    self.view.makeToast("Some error occured".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                                }
                                
                            }
                        })
                        
                    })
                    
                }
                else
                {
                    self.view.makeToast("Payment failed", duration: 2.0, position: .center)
                    mageWooCommon.delay(delay: 2.0, closure: {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "orderFailed") as? orderFailed
                        self.navigationController?.setViewControllers([vc!], animated: true)
                    })
                }
            }
        })*/
        
        
        
        /*let status = json["status"].stringValue;
        let paymentId = json["transaction_id"].stringValue;
        let params = ["status":status,"payment_id":paymentId, "orderId":orderId]
        mageRequets.sendHttpRequest(endPoint: "", method: "POST", params: params, controller: self) { (data, url, error) in
            if let data = data{
                let jsondata = JSON(data: data);
                if(jsondata["data"]["status"].stringValue == "true")
                {
                    if(status == "Success")
                    {
                        UserDefaults.standard.removeObject(forKey: "cart_id")
                        UserDefaults.standard.setValue("0", forKey: "CartQuantity")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "orderCompletion") as? orderCompletion
                        self.navigationController?.pushViewController(vc!, animated: true);
                    }
                    else
                    {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "orderFailed") as? orderFailed
                        self.navigationController?.pushViewController(vc!, animated: true);
                    }
                    
                }
            }
        }*/
    }
}

/*extension selectPaymentMethod: STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        <#code#>
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        self.navigationController?.popViewController(animated: true)
        // Show the error to your user, etc.
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        print(paymentResult)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        switch status {
        case .error:
            print("error")
            //self.showError(error)
        case .success:
            print("payment done")
            //self.showReceipt()
        case .userCancellation:
            return // Do nothing
        @unknown default:
            print("error not")
        }
    }
    

    
    
    
    
    
    /*func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        self.activityIndicator.animating = paymentContext.loading
        self.paymentButton.enabled = paymentContext.selectedPaymentOption != nil
        self.paymentLabel.text = paymentContext.selectedPaymentOption?.label
        self.paymentIcon.image = paymentContext.selectedPaymentOption?.image
    }*/
    
    
    func payButtonTapped() {
        self.paymentContext.requestPayment()
    }
    
    
    // If you prefer a modal presentation
    func choosePaymentButtonTapped() {
        self.paymentContext.presentPaymentOptionsViewController()
    }

   /* // If you prefer a navigation transition
    func choosePaymentButtonTapped() {
        self.paymentContext.pushPaymentOptionsViewController()
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}*/
