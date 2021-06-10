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

class CartProductListView: mageBaseViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var emptyImage: UIImageView!
    
    @IBOutlet weak var continueShoppingButton: UIButton!
    @IBOutlet weak var emptyView: UIView!
    
    
    @IBOutlet weak var table_View: UITableView!
    
    var cartController:UIViewController?=nil
    var currency = ""
    var isOrder=false
    var counter=0
    var quantityAll=0
    var grandtotal="0.00"
    var cartDetails=[[String:String]]()
    var cartProductData = [[String:String]]()
    var couponApplied = false;
    var couponAmount = "0.00";
    var appliedCoupon = "";
    var arrayqtyText=[UITextField]()
    var subtotalvalue = "0.00"
    
    var cartKeyArray = ""
    var taxLabel = "";
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //--edited10May     self.tracking(name: "cart listing");
        table_View.dataSource=self
        table_View.delegate=self
        
        
        self.emptyImage.isHidden=true
        
        self.continueShoppingButton.isHidden=true
        self.emptyView.isHidden=true
        
        getCartData()
       
        
        // Do any additional setup after loading the view.
    }

    func wishclicked(wishlistChecked: Bool) {
        print(wishlistChecked)
    }
    
    
    func getCartData(){
        quantityAll=0;
        grandtotal="0.00";
        cartProductData = [[String:String]]();
        var parameters = [String:String]();
        if let cust_id = User().getLoginUser()?["userId"]
        {
            parameters["customer_id"] = cust_id;
        }
        else
        {
            parameters["cart_id"] = UserDefaults.standard.value(forKey: "cart_id") as? String;
        }
        print(parameters);
        if parameters == [:]
        {
            self.table_View.isHidden=true
            self.emptyImage.isHidden=false
            self.continueShoppingButton.isHidden=false
            self.emptyView.isHidden=false
            return;
        }
        cedMageLoaders.addDefaultLoader(me: self)
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/viewcart", method: "POST",params: parameters, controller: self, completionHandler: {
            data,url,error in
            if let data = data {
                cedMageLoaders.removeLoadingIndicator(me: self)
                if let json = try? JSON(data:data)
                {
                    print(json)
                    //print(json["data"]["products"].stringValue)
                    if(json["status"].stringValue == "false")
                    {
                        self.table_View.isHidden=true
                        self.emptyImage.isHidden=false
                        self.continueShoppingButton.isHidden=false
                        self.emptyView.isHidden=false
                        self.cartProductData=[[String:String]]();
                        self.grandtotal = "0.00";
                        self.currency = ""
                        UserDefaults.standard.setValue("0", forKey: "CartQuantity");
                        self.updateBadge();
                    }
                    else if(json["data"]["items_count"].count == 0)
                    {
                        self.table_View.isHidden=true
                        self.emptyImage.isHidden=false
                        self.continueShoppingButton.isHidden=false
                        self.emptyView.isHidden=false
                        self.cartProductData=[[String:String]]();
                        self.grandtotal = "0.00";
                        self.currency = ""
                        UserDefaults.standard.setValue("0", forKey: "CartQuantity");
                        self.updateBadge();
                    }
                    else
                    {
                        self.table_View.isHidden=false
                        self.emptyImage.isHidden=false
                        self.continueShoppingButton.isHidden=true
                        self.emptyView.isHidden=false
                        self.grandtotal = json["data"]["cart_total"].stringValue;
                        self.subtotalvalue = json["data"]["cart_subtotal"].stringValue;
                        self.taxLabel = json["data"]["tax_label"].stringValue
                        self.currency = json["data"]["currency_symbol"].stringValue
                        self.couponAmount = json["data"]["discount_amount"].stringValue
                        self.cartProductData=[[String:String]]();
                        for(_,value) in json["data"]["items_count"]
                        {
                            self.quantityAll += value.intValue;
                        }
                        UserDefaults.standard.setValue(String(self.quantityAll), forKey: "CartQuantity")
                        self.updateBadge();
                        for index in 0..<(json["data"]["products"].count)
                        {
                            var productData = [String:String]();
                            
                            for(key,value) in json["data"]["products"][index]
                            {
                                productData[key]=value.stringValue
                                
                            }
                            
                            self.cartProductData.append(productData);
                            
                        }
                        if(json["data"]["applied_coupons"].exists())
                        {
                            
                            self.appliedCoupon = json["data"]["applied_coupons"][0].stringValue;
                            
                            self.couponApplied=true;
                        }
                        
                        self.table_View.reloadData()
                    }
                }
                
                
                
            }
        })
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateBadge();
        self.continueShoppingButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        self.continueShoppingButton.backgroundColor=wooSetting.themeColor
        /*if #available(iOS 12.0, *) {
            if(traitCollection.userInterfaceStyle == .dark)
            {
                self.continueShoppingButton.backgroundColor=UIColor(hexString: wooSetting.darkModeThemeColor)
            }
        }*/
        self.continueShoppingButton.setTitleColor(wooSetting.textColor, for: .normal);
        /*if #available(iOS 12.0, *) {
            if(traitCollection.userInterfaceStyle == .dark)
            {
                self.continueShoppingButton.setTitleColor(wooSetting.darkModeTextColor, for: .normal);
            }
        }*/
        self.tabBarController?.tabBar.isHidden = true;
        let barbuttons=self.navigationItem.rightBarButtonItems
        for items in barbuttons!
        {
            if items.tag==786
            {
                
                items.isEnabled=false
            }
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
        let barbuttons=self.navigationItem.rightBarButtonItems
        for items in barbuttons!
        {
            if items.tag==786
            {
                items.isEnabled=true
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==1{
            return cartProductData.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.section==0{
           
            let cell=table_View.dequeueReusableCell(withIdentifier: "cartDetailCell") as! cartViewCell
            if isOrder==true
            {
                cell.topCell.text="Your Order".localized+"\n"+String(quantityAll)+" items".localized
            }
            else
            {
                cell.topCell.text="Shopping Cart".localized+"\n"+String(quantityAll)+" items".localized
            }
            cell.topCell.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
            cell.totalItemsCell.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
            cell.totalItemsCell.text=currency+" "+String(grandtotal)
            
            if isOrder==true
            {
                cell.deleteCartButton.isHidden=true
            }
            else
            {
                cell.deleteCartButton.isHidden=false
                cell.deleteCartButton.addTarget(self, action: #selector(deleteCart), for: .touchUpInside)
            }
            cell.deleteCartButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
            return cell
        }
        else if indexPath.section==1
        {
        
            //let cart=UserDefaults.standard.value(forKey: "Cart") as! [[String:String]]
            let cell=table_View.dequeueReusableCell(withIdentifier: "productCell") as! cartViewCell
            /*if let userdefaults = UserDefaults.standard.value(forKey: "themeSettings") as? [String:String]
            {
                if let placeholderImage = userdefaults["ced_theme_product_placeholder_image"]
                {
                    cell.productImage?.sd_setImage(with: URL(string: (cartProductData[indexPath.row]["product_image"])!), placeholderImage: UIImage(url: URL(string: placeholderImage)))
                    
                }
                else
                {
                    cell.productImage?.sd_setImage(with: URL(string: (cartProductData[indexPath.row]["product_image"])!), placeholderImage: UIImage(named: "placeholder"))
                }
                
            }*/
            cell.productImage?.sd_setImage(with: URL(string: (cartProductData[indexPath.row]["product_image"])!), placeholderImage: UIImage(contentsOfFile: wooSetting.productPlaceholder))
            
            cell.productName.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
            cell.productName.text=cartProductData[indexPath.row]["product_name"]! 
            //name = cell.productName.text!
            cell.productPrice.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
            cell.productSubtotal.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
            if let prodPrice = cartProductData[indexPath.row]["product_price"]
            {
                cell.productPrice.text=currency+prodPrice;
                if let subtotal = cartProductData[indexPath.row]["product_subtotal"]
                {
                    cell.productSubtotal.text = "Total: ".localized+currency+subtotal;
                }
                //cell.productSubtotal.text = "Total: "+currency+" "+String(Double(prodPrice)! * Double(cartProductData[indexPath.row]["quantity"]!)!)
            }
            
            
            /*if cart[indexPath.row]["comparePrice"] != ""{
                let offerPrice=NSMutableAttributedString(string: currency+cart[indexPath.row]["comparePrice"]!)
                offerPrice.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, offerPrice.length))
                cell.compareAtLabel.attributedText=offerPrice
            }*/
            
            cell.productPrice.textColor=wooSetting.themeColor
            /*if #available(iOS 12.0, *) {
                if(traitCollection.userInterfaceStyle == .dark){
                    cell.productPrice.textColor=UIColor(hexString: wooSetting.darkModeThemeColor)
                }
            }*/
            if isOrder==true
            {
                cell.updateProductButton.isHidden=true
                cell.deleteProductButton.isHidden=true
                cell.qtyView.productQty.isEnabled=false
                cell.qtyView.decrementButon.isHidden=true
                cell.qtyView.incrementButton.isHidden=true
            }
            else
            {
                cell.qtyView.productQty.isEnabled=true
                cell.qtyView.decrementButon.tag=indexPath.row
                cell.qtyView.decrementButon.addTarget(self, action: #selector(decrementProductQty(_:)), for: .touchUpInside)
                
                arrayqtyText.append(cell.qtyView.productQty)
                
                cell.qtyView.productQty.text=cartProductData[indexPath.row]["quantity"]!
                cell.qtyView.incrementButton.tag=indexPath.row
                cell.qtyView.incrementButton.addTarget(self, action: #selector(incrementProductQty(_:)), for: .touchUpInside)
                //emptyCartButton.isHidden=false
                
                cell.updateProductButton.tag=indexPath.row
                cell.updateProductButton.addTarget(self, action: #selector(updateProduct(_:)), for: .touchUpInside)
                
                
                cell.deleteProductButton.tag=indexPath.row
                cell.deleteProductButton.addTarget(self, action: #selector(deleteProduct(_:)), for: .touchUpInside)
                cell.cellView.cardView();
            }
            return cell
            
        }
        else if indexPath.section==2
        {
            let cell=table_View.dequeueReusableCell(withIdentifier: "couponCell") as! cartViewCell
            cell.applyCoupon.backgroundColor=wooSetting.themeColor
            /*if #available(iOS 12.0, *) {
                if(traitCollection.userInterfaceStyle == .dark)
                {
                    cell.applyCoupon.backgroundColor=mageWooCommon.UIColorFromRGB(colorCode: wooSetting.darkModeThemeColor)
                }
            }*/
            
            cell.applyCoupon.titleLabel?.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
            cell.applyCoupon.setTitleColor(wooSetting.textColor, for: .normal)
            cell.applyCoupon.layer.cornerRadius=7.0;
            cell.applyCoupon.addTarget(self, action: #selector(couponApplied(_:)), for: .touchUpInside)
            //cell.couponTextField.decorateField()
            cell.couponTextField.layer.borderWidth = 1.0;
            cell.couponTextField.layer.borderColor = wooSetting.themeColor?.cgColor
            
            cell.couponTextField.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
            cell.couponTextField.layer.cornerRadius = 5.0;
            if(couponApplied==true)
            {
                cell.couponTextField.isEnabled=false;
                cell.couponTextField.text=appliedCoupon;
                cell.applyCoupon.setTitle("Remove Coupon".localized, for: .normal);
            }
            else
            {
                cell.couponTextField.isEnabled=true;
                cell.couponTextField.text="";
                cell.applyCoupon.setTitle("Apply Coupon".localized, for: .normal);
            }
            cell.couponTextField.tag = 1000;
            
            return cell;
        }
        else if indexPath.section==3{
            
            let cell=table_View.dequeueReusableCell(withIdentifier: "amountDetails") as! cartViewCell
            cell.cartTotal.text=currency+" "+String(subtotalvalue)+" "+taxLabel
            cell.cartDiscount.text=currency+" "+String(couponAmount)
            cell.subtotal.text=currency+" "+String(subtotalvalue)
            cell.delivery.text="Free".localized
            cell.grandTotal.text=currency+" "+String(grandtotal)
            cell.grandTotal.textColor=wooSetting.themeColor
            
            cell.cellView.layer.borderWidth = 1
            cell.cellView.layer.borderColor = UIColor.darkGray.cgColor
            cell.cartTotal.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
            cell.cartDiscount.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
            cell.subtotal.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
            cell.delivery.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
            cell.grandTotal.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
            return cell
            
        }
        else 
        {
            let cell=table_View.dequeueReusableCell(withIdentifier: "proceedButtonCell") as! cartViewCell
            
            cell.proceedButton.addTarget(self, action: #selector(placeOrderButtonPressed(_:)), for: .touchUpInside)
            cell.proceedButton.setThemeColor()
            
            cell.proceedButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
            cell.proceedButton.setTitleColor(wooSetting.textColor, for: .normal)
            
            return cell
            
        }
    }
    
    
    @objc func couponApplied(_ sender: UIButton)
    {
        
        if let couponField = self.view.viewWithTag(1000) as? UITextField
        {
            let couponText = couponField.text;
            if(couponText != "")
            {
                var parameters = [String:String]();
                if let cust_id = User().getLoginUser()?["userId"]
                {
                    parameters["customer_id"] = cust_id;
                }
                else
                {
                    parameters["cart_id"] = UserDefaults.standard.value(forKey: "cart_id") as? String;
                }
                parameters["coupon_code"] = couponText;
                cedMageLoaders.addDefaultLoader(me: self)
                if(sender.currentTitle == "Apply Coupon".localized)
                {
                    mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/applycoupon", method: "POST",params: parameters, controller: self, completionHandler: {
                        data,url,error in
                        if let data = data {
                            cedMageLoaders.removeLoadingIndicator(me: self)
                            if let json = try? JSON(data:data){
                                print(json)
                                let success = json["cart_id"]["success"].stringValue
                                if(success == "true")
                                {
                                    self.view.makeToast(json["cart_id"]["message"].stringValue, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                                    mageWooCommon.delay(delay: 2.0, closure: {
                                        self.couponApplied=true;
                                        self.getCartData()
                                    })
                                    
                                }
                                else{
                                    self.view.makeToast(json["message"].stringValue, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                                }
                            }
                            
                            
                        }
                    })
                    
                }
                else if(sender.currentTitle == "Remove Coupon".localized)
                {
                    parameters["coupon_code"] = couponText;
                    mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/removecoupon", method: "POST",params: parameters, controller: self, completionHandler: {
                        data,url,error in
                        if let data = data {
                            if let json = try? JSON(data:data){
                                print(json)
                                cedMageLoaders.removeLoadingIndicator(me: self)
                                self.view.makeToast(json["cart_id"]["message"].stringValue, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                                self.couponApplied=false;
                                self.appliedCoupon="";
                                mageWooCommon.delay(delay: 2.0, closure: {
                                    self.getCartData()
                                })
                            }
                            
                        }
                    })

                }
                
            }
            else{
                self.view.makeToast("Enter coupon code".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            }
        }
    }
    
    @objc func placeOrderButtonPressed(_ sender: UIButton) {
        if let _ = User().getLoginUser()
        {
            
            let vc=UIStoryboard(name: "mageWooCheckout", bundle: nil).instantiateViewController(withIdentifier: "cedMageNewAddressController") as? cedMageNewAddressController
            self.navigationController?.pushViewController(vc!, animated: true);
        }
        else
        {
            let vc=UIStoryboard(name: "mageWooCheckout", bundle: nil).instantiateViewController(withIdentifier: "checkas") as! checkOutAsController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section==0{
            return 110
        }else if indexPath.section==1{
            return 170
        }else if indexPath.section==2{
            return 50
        }else if indexPath.section==3{
            return 80
        }else{
            return 60
        }
    }
    
    @objc func updateProduct(_ sender: UIButton){
        let qty=arrayqtyText[sender.tag]
        qty.resignFirstResponder()
        let qtyCharactersCheck=qty.text?.count
        
        if qtyCharactersCheck! > 3{
            let checkqty=Int(cartProductData[sender.tag]["quantity"]!)
            
            if checkqty! > 999{
                qty.text=cartProductData[sender.tag]["quantity"]!
                //updateBadge()
            }
            else
            {
                qty.text=cartProductData[sender.tag]["quantity"]!
                //updateBadge()
                self.showAlert(title: "Wrong Input.".localized, msg: "Please enter quantity of maximum 3 digits.".localized)
                
                return
            }
            
        }
        
        let qtycheck=Int(qty.text!)
        if qtycheck==nil{
            qty.text=cartProductData[sender.tag]["quantity"]
            
            self.showAlert(title: "Wrong Input.".localized, msg: "Please enter positive integer number for quantity.".localized)
            
            return
        }
        let qtyFloatCheck=qty.text?.contains(".")
        if qty.text==""
        {
            qty.text=cartProductData[sender.tag]["quantity"]!
            self.showAlert(title: "Wrong Input.".localized, msg: "Please enter 1 or more quantity for product to add to cart.".localized)
            
            return
            
        }else if qtyFloatCheck!{
            
            qty.text=cartProductData[sender.tag]["quantity"]!
            self.showAlert(title: "Wrong Input.".localized, msg: "Please enter 1 or more quantity with whole number.".localized)
            
            return
        }
        else if qtycheck! < 1{
            
            qty.text=cartProductData[sender.tag]["quantity"]
            self.showAlert(title: "Wrong Input.".localized, msg: "Please add atleast 1 as quantity.".localized)
            
            return
        }
        var parameters = [String:String]();
        if let userId = User().getLoginUser()?["userId"] {
            parameters["customer_id"] = userId;
        }
        else
        {
            parameters["cart_id"] = UserDefaults.standard.value(forKey: "cart_id") as? String;
        }
        parameters["product_id"] = cartProductData[sender.tag]["product_id"]!;
        if(cartProductData[sender.tag]["variation_id"] != nil)
        {
            parameters["variation_id"] = cartProductData[sender.tag]["variation_id"]!;
        }
        parameters["qty"] = qty.text;
        cedMageLoaders.addDefaultLoader(me: self)
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/updatecart", method: "POST",params: parameters, controller: self, completionHandler: {
            data,url,error in
            if let data = data {
                if let json = try? JSON(data:data){
                    print(json)
                    cedMageLoaders.removeLoadingIndicator(me: self)
                    self.view.makeToast("Quantity Updated.".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                    mageWooCommon.delay(delay: 2.0, closure: {
                        self.getCartData()
                        
                    })
                }
                
                
                
            }
        })
    }
    @objc func deleteProduct(_ sender: UIButton){
        //let qty=arrayqtyText[sender.tag]
        
        let confirmationAlert=UIAlertController(title: "", message: "Are you sure to remove the product from cart..?".localized, preferredStyle: .alert)
        let yesAction=UIAlertAction(title: "Yes".localized, style: .default,handler: {
            alert -> Void in
            if self.cartProductData.count==0
            {
                let alert=UIAlertController(title: "Empty".localized, message: "Your cart is empty please add some items to it.".localized, preferredStyle: .alert)
                let action=UIAlertAction(title: "OK", style: .default,handler: {
                    alert -> Void in
                    //self.updateBadge()
                    
                    self.table_View.isHidden=true
                    self.emptyImage.isHidden=false
                    
                    self.continueShoppingButton.isHidden=false
                    self.emptyView.isHidden=false
                    return
                    
                })
                alert.addAction(action)
                alert.modalPresentationStyle = .fullScreen
                self.present(alert, animated: true, completion: nil)
                return
            }
            else
            {
                var parameters = [String:String]();
                if let userId = User().getLoginUser()?["userId"]
                {
                    parameters["customer_id"] = userId;
                }
                else
                {
                    parameters["cart_id"] = UserDefaults.standard.value(forKey: "cart_id") as? String;
                }
                parameters["product_id"] = self.cartProductData[sender.tag]["product_id"];
                if(self.cartProductData[sender.tag]["variation_id"] != nil)
                {
                    parameters["variation_id"] = self.cartProductData[sender.tag]["variation_id"];
                }
                cedMageLoaders.addDefaultLoader(me: self)
                mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/removecart", method: "POST",params: parameters, controller: self, completionHandler: {
                    data,url,error in
                    if let data = data {
                        if let json = try? JSON(data:data)
                        {
                            print(json)
                            cedMageLoaders.removeLoadingIndicator(me: self)
                            self.view.makeToast("Item is removed from cart.".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                            mageWooCommon.delay(delay: 2.0, closure: {
                                self.getCartData()
                            })
                        }
                        
                    }
                })
            }
            return
        })
        let cancel=UIAlertAction(title: "Cancel".localized, style: .destructive, handler: nil)
        confirmationAlert.addAction(yesAction)
        confirmationAlert.addAction(cancel)
        
        confirmationAlert.modalPresentationStyle = .fullScreen;
        self.present(confirmationAlert, animated: true, completion: nil)
        return
    }
    
    @objc func deleteCart(){
        let alert=UIAlertController(title: "Confirmation..!".localized, message: "Are You sure you want to empty the cart.".localized, preferredStyle: .alert)
        let actionOk=UIAlertAction(title: "Yes".localized, style: .default,handler: {
            alert -> Void in
            var parameters = [String:String]();
            if let userId = User().getLoginUser()?["userId"]
            {
                parameters["customer_id"] = userId;
            }
            else
            {
                parameters["cart_id"] = UserDefaults.standard.value(forKey: "cart_id") as? String;
            }
            mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/deletecart", method: "POST",params: parameters, controller: self, completionHandler: {
                data,url,error in
                if let data = data {
                    if let json = try? JSON(data:data)
                    {
                        print(json)
                        cedMageLoaders.removeLoadingIndicator(me: self)
                        if(json["cart_id"]["success"].stringValue == "true")
                        {
                            UserDefaults.standard.removeObject(forKey: "CartQuantity")
                            self.updateBadge()
                            self.view.makeToast("Item is removed from cart.".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                            mageWooCommon.delay(delay: 2.0, closure: {
                                self.getCartData()
                            })
                            
                        }
                    }
                    
                }
            })
        })
        let actionNo=UIAlertAction(title: "No".localized, style: .destructive, handler: nil)
        alert.addAction(actionOk)
        alert.addAction(actionNo)
        alert.modalPresentationStyle = .fullScreen;
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    @IBAction func continueShoppingPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true);
        
    }
    
    @objc func incrementProductQty(_ sender:UIButton){
        
        let qtyView=arrayqtyText[sender.tag]
        
        
        if(qtyView.text == ""){
            qtyView.text = String("1");
            return;
        }
        if(qtyView.text != ""){
            var currentQty = Int(qtyView.text!)!;
            currentQty = currentQty+1;
            if let checkqty=Int(cartProductData[sender.tag]["max_quantity"]!){
                if(currentQty > checkqty){
                    self.view.makeToast("Product quantity cannot be more than stock", duration: 2.0, position: .center)
                    return;
                }
            }
            
            qtyView.text = String(currentQty);
        }
        
        //var cart=UserDefaults.standard.value(forKey: "Cart") as! [[String:String]]
        let qty=Int(qtyView.text!)
        if qtyView.text==""
        {
            UserDefaults.standard.set("Error".localized, forKey: "qtyerror".localized)
            
        }else if qty! < 1{
            UserDefaults.standard.set("Error".localized, forKey: "qtyerror".localized)
        }
        /*else
        {
            for key in 0..<cart.count
            {
                if cart[key]["variantId"]==cart[sender.tag]["variantId"]
                {
                    cart[key].updateValue(qtyView.text!, forKey: "quantity")
                    UserDefaults.standard.set(cart, forKey: "Cart")
                    //updateBadge()
                }
            }
        }*/
    }
    
    @objc func decrementProductQty(_ sender:UIButton){
        let qtyView=arrayqtyText[sender.tag]
        if(qtyView.text != "" && qtyView.text != "1"){
            var currentQty = Int(qtyView.text!)!;
            currentQty = currentQty-1;
            qtyView.text = String(currentQty);
        }
        
        
            //var cart=UserDefaults.standard.value(forKey: "Cart") as! [[String:String]]
            let qty=Int(qtyView.text!)
            if qtyView.text==""
            {
                UserDefaults.standard.set("Error".localized, forKey: "qtyerror".localized)
                
            }else if qty! < 1{
                UserDefaults.standard.set("Error".localized, forKey: "qtyerror".localized)
            }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1)
        {
            let data=cartProductData[indexPath.row]
            let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
            viewControl.productId = data["product_id"]!
            self.navigationController?.pushViewController(viewControl, animated: true)
        }
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
