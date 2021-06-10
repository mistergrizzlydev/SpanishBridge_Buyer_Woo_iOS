//
//  cedMageNewAddressController.swift
//  wooApp
//
//  Created by Manohar Singh Rawat on 22/04/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class cedMageNewAddressController: mageBaseViewController {
    
    @IBOutlet weak var mainStackWidth: NSLayoutConstraint!
    @IBOutlet weak var mainStackHeight: NSLayoutConstraint!
    @IBOutlet weak var mainStack: UIStackView!
    var countriesDict = Dictionary<String,JSON>()
    var billingFields = [AddressFields]()
    var shippingFields = [AddressFields]()
    var additionalFields = [AddressFields]()
    var savedBillingState = true;
    var savedShippingState = true;
    var billingStates = BehaviorSubject(value: Dictionary<String,String>())
    var shippingStates = BehaviorSubject(value: Dictionary<String,String>())
    let disposeBag = DisposeBag()
    let dropDown = DropDown()
    var shippingLabel: UILabel!
    var shippingButton: UIButton!
    var billingTextView: TextFieldView?
    var billingButtonView: ButtonXibView?
    var shippingTextView: TextFieldView?
    var shippingButtonView: ButtonXibView?
    var initialLoadShippingFields = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainStackHeight.constant = 0;
        mainStackWidth.constant = self.view.frame.width;
        loadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateBadge()
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
//parse address
extension cedMageNewAddressController{
    func loadData(){
        
        for i in self.mainStack.arrangedSubviews{
            i.removeFromSuperview()
        }
        mainStackHeight.constant = 0;
        
        var params = Dictionary<String, String>()
        if let user = User().getLoginUser() {
            params["customer_id"] = user["userId"]
        }
        else{
            if let cartId = UserDefaults.standard.value(forKey: "cart_id")
            {
                params["cart_id"] = cartId as? String
            }
        }
        cedMageLoaders.addDefaultLoader(me: self)
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/getsavedaddress", method: "POST", params: params, controller: self) {[weak self] (data, url, error) in
            cedMageLoaders.removeLoadingIndicator(me: self!)
            guard let data = data else{return;}
            if let json = try? JSON(data: data){
                print(json)
                self?.setupHeader(text: "Address")
                //--added
                var avoidRepeatStateField = true
                //
                self?.countriesDict = json["data"]["countries"].dictionaryValue
                for index in json["data"]["billing_fields"].arrayValue{
                    //--added 3Jun
                    if (index["type"].stringValue == "state" && index["index"].stringValue == "billing_state"){
                        avoidRepeatStateField = false
                    }
                    //
                    self?.billingFields.append((self?.makeField(params: AddressFields(value: index["value"].stringValue, placeholder: index["placeholder"].stringValue, type: index["type"].stringValue, label: index["label"].stringValue, required: index["required"].boolValue, index: index["index"].stringValue, options: index["options"].dictionary, field: nil)))!)

                 if(index["index"].stringValue == "billing_state"){
                        print("avoidRepeatStateField = \(avoidRepeatStateField)")
                        if avoidRepeatStateField == true{
                            self?.billingFields.append((self?.makeField(params: AddressFields(value: index["value"].stringValue, placeholder: index["placeholder"].stringValue, type: "text", label: index["label"].stringValue, required: index["required"].boolValue, index: index["index"].stringValue, options: index["options"].dictionary, field: nil)))!)
                        }

                    }

                    
                    /*--edited
                     if(index["index"].stringValue == "billing_state"){
                         self?.billingFields.append((self?.makeField(params: AddressFields(value: index["value"].stringValue, placeholder: index["placeholder"].stringValue, type: "text", label: index["label"].stringValue, required: index["required"].boolValue, index: index["index"].stringValue, options: index["options"].dictionary, field: nil)))!)
                     }
                    */
                    
                }
                self?.setupShippingButton()
                self?.setupHeader(text: "Shipping Address")
                /*--added
                var avoidRepeatshippingStateField = true
                //--*/
                for index in json["data"]["shipping_fields"].arrayValue{
                    /*--added 3Jun
                    if (index["type"].stringValue == "state" && index["index"].stringValue == "shipping_state"){
                        avoidRepeatshippingStateField = false
                    }
                    //--*/
                    self?.shippingFields.append((self?.makeField(params: AddressFields(value: index["value"].stringValue, placeholder: index["placeholder"].stringValue, type: index["type"].stringValue, label: index["label"].stringValue, required: index["required"].boolValue, index: index["index"].stringValue, options: index["options"].dictionary, field: nil)))!)
                /*    if(index["index"].stringValue == "shipping_state"){
                        if avoidRepeatshippingStateField == true{
                            self?.shippingFields.append((self?.makeField(params: AddressFields(value: index["value"].stringValue, placeholder: index["placeholder"].stringValue, type: "text", label: index["label"].stringValue, required: index["required"].boolValue, index: index["index"].stringValue, options: index["options"].dictionary, field: nil)))!)
                        }

                    }

                    /--edited 3Jun*/
                     if(index["index"].stringValue == "shipping_state"){
                         self?.shippingFields.append((self?.makeField(params: AddressFields(value: index["value"].stringValue, placeholder: index["placeholder"].stringValue, type: "text", label: index["label"].stringValue, required: index["required"].boolValue, index: index["index"].stringValue, options: index["options"].dictionary, field: nil)))!)
                     }
//                     */
                }
                
               
                for index in json["data"]["additional_fields"].arrayValue{
                    self?.additionalFields.append((self?.makeField(params: AddressFields(value: index["value"].stringValue, placeholder: index["placeholder"].stringValue, type: index["type"].stringValue, label: index["label"].stringValue, required: index["required"].boolValue, index: index["index"].stringValue, options: index["options"].dictionary, field: nil)))!)
                }
                self?.hideShippingFields()
                self?.makeProceedButton()
                
            }
            
        }
    }
    func getStates(countryName: String, billinStateCheck: Bool = true)
    {
        if(billinStateCheck){
            billingStates.onNext([String:String]())
        }
        else{
            shippingStates.onNext([String:String]())
        }
        var params = Dictionary<String, String>()
        
        for(key,_) in countriesDict
        {
            if(key == countryName)
            {
                params["country"] = key;
                //cedMageLoaders.addDefaultLoader(me: self)
                mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/fetchstates",method: "POST", params: params, controller: self, completionHandler: {
                    data,url,error in
                    if let data = data {
                        if let json  = try? JSON(data:data)
                        {
                            print(json)
                            //cedMageLoaders.removeLoadingIndicator(me: self)
                            var billingStatesListing = [String:String]()
                            var shippingStatesListing = [String:String]()
                            do{
                                try? billingStatesListing = self.billingStates.value()
                                try? shippingStatesListing = self.shippingStates.value()
                            }
                            
                            
                            if(json["status"].stringValue == "true")
                            {
                                for(scode,sname) in json["states"]
                                {
                                    if(billinStateCheck){
                                        
                                        billingStatesListing[scode] = sname.stringValue;
                                    }
                                    else{
                                        shippingStatesListing[scode] = sname.stringValue;
                                    }
                                    
                                    //self.statesRelatedToCountry.append(sname.stringValue)
                                }
                                do{
                                    print(shippingStatesListing)
                                    try? self.billingStates.onNext(billingStatesListing)
                                    try? self.shippingStates.onNext(shippingStatesListing)
                                    
                                    
                                    if(!billinStateCheck){
                                        if(shippingStatesListing.count>0){
                                            self.shippingButtonView?.isHidden = false;
                                            self.shippingTextView?.isHidden = true;
                                            
                                            //--added 3Jun
                                            if !(self.initialLoadShippingFields){
                                                self.shippingButtonView?.isHidden = true;
                                                self.shippingTextView?.isHidden = true;
                                            }
                                        }
                                    }
                                    else{
                                        if(billingStatesListing.count > 0){
                                            self.billingButtonView?.isHidden = false;
                                            self.billingTextView?.isHidden = true;
                                            /*self.billingTextView?.contentTextField.isHidden = true;
                                            self.billingTextView?.headingLabel.isHidden = true;*/
                                        }
                                    }
                                    
                                    
                                    
                                    
                                }
                                
                                
                                
                            }
                            else{
                                if(billinStateCheck){
                                    self.billingButtonView?.isHidden = true;
                                    self.billingTextView?.isHidden = false;
                                }
                                else{
                                    self.shippingButtonView?.isHidden = true;
                                    self.shippingTextView?.isHidden = false;
                                }
                            }
                            
                        }
                        
                    }
                    
                })
            }
        }
    }
}
//make layouts
extension cedMageNewAddressController{
    func setupHeader(text: String)
    {
        let label = UILabel()
        label.textAlignment = .center
        label.text = text
        if(label.text == "Shipping Address"){
            shippingLabel = label;
        }
        label.font = mageWooCommon.setCustomFont(type: .medium, size: 16.0)
        mainStack.addArrangedSubview(label)
        let labelHeightConstriaint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40)
        label.addConstraint(labelHeightConstriaint)
        mainStackHeight.constant += 40
        
    }
    
    func makeField(params: AddressFields)-> AddressFields{
        var addressFields = params
        switch addressFields.type {
        case "text":
           
            addressFields.field=makeTextFieldView(params: params)
            return addressFields
        case "textarea":
            
            addressFields.field=makeTextViewxib(params: params)
            return addressFields
        case "select","country","state":
           
            addressFields.field=makeButtonxib(params: params)
            return addressFields
        case "tel":
           
            addressFields.field=makeTextFieldView(params: params)
            return addressFields
        case "email":
           
            addressFields.field=makeTextFieldView(params: params)
            return addressFields
        default:
           
            addressFields.field=makeCheckboxxib(params: params)
            return addressFields
        }
    }
    
    func makeTextFieldView(params: AddressFields)->TextFieldView{
        let textFieldView = TextFieldView()
        mainStack.addArrangedSubview(textFieldView)
        textFieldView.headingLabel.text = params.label;
        textFieldView.contentTextField.text = params.value
        textFieldView.headingLabel.font = mageWooCommon.setCustomFont(type: .medium, size: 15.0)
        if(params.label != params.placeholder){
            textFieldView.contentTextField.placeholder = params.placeholder
        }
        if(params.index == "billing_state"){
            self.billingTextView = textFieldView
            self.billingTextView?.isHidden = true;
        }
        if(params.index == "shipping_state"){
            self.shippingTextView = textFieldView
            self.shippingTextView?.isHidden = true;
        }
        let labelHeightConstriaint = NSLayoutConstraint(item: textFieldView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 100)
        textFieldView.addConstraint(labelHeightConstriaint)
        mainStackHeight.constant += 100
        return textFieldView
    }
    
    func makeTextViewxib(params: AddressFields)->TextViewXib{
        let textFieldView = TextViewXib()
        mainStack.addArrangedSubview(textFieldView)
        textFieldView.headingLabel.text = params.label;
        textFieldView.headingLabel.font = mageWooCommon.setCustomFont(type: .medium, size: 15.0)
        //textFieldView.text = "Placeholder"
        if(params.value != ""){
            textFieldView.contentTextView.text = params.value
        }
        else{
            textFieldView.contentTextView.placeholder = params.placeholder
        }
        
        let labelHeightConstriaint = NSLayoutConstraint(item: textFieldView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 180)
        textFieldView.addConstraint(labelHeightConstriaint)
        mainStackHeight.constant += 180
        return textFieldView
    }
    
    func makeCheckboxxib(params: AddressFields)->CheckboxView{
        let textFieldView = CheckboxView()
        mainStack.addArrangedSubview(textFieldView)
        textFieldView.contentButton.setTitle(params.label, for: .normal)
        textFieldView.contentButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .medium, size: 15.0)
        textFieldView.contentButton.addTarget(self, action: #selector(checkboxClicked(_:)), for: .touchUpInside)
        let labelHeightConstriaint = NSLayoutConstraint(item: textFieldView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 90)
        textFieldView.addConstraint(labelHeightConstriaint)
        mainStackHeight.constant += 90
        return textFieldView
    }
    
    @objc func checkboxClicked(_ sender: UIButton){
        if(sender.currentImage == UIImage(named: "unchecked")){
            sender.setImage(UIImage(named: "checked"), for: .normal)
        }
        else{
            sender.setImage(UIImage(named: "unchecked"), for: .normal)
        }
    }
    
    func makeButtonxib(params: AddressFields)->ButtonXibView{
        let textFieldView = ButtonXibView()
        mainStack.addArrangedSubview(textFieldView)
        textFieldView.headingLabel.text = params.label
        textFieldView.headingLabel.font = mageWooCommon.setCustomFont(type: .medium, size: 15.0)
        textFieldView.contentButton.addTarget(self, action: #selector(dropDownButtonClicked(_:)), for: .touchUpInside)
        if(params.index == "billing_state"){
            print("stte abc ")
            self.billingButtonView = textFieldView
            self.billingStates.asObservable()
                .subscribe( onNext: { value in
                    if(self.savedBillingState){
                        if(params.value != ""){
                            do{
                                
                                let filtervalue = try? self.billingStates.value().filter({$0.key == params.value})
                                if(filtervalue?.count ?? 0 > 0){
                                    textFieldView.contentButton.setTitle(Array((filtervalue?.values)!)[0], for: .normal)
                                    //self.billingTextView?.isHidden = true;
                                    //textFieldView.isHidden = false;
                                }
                            }
                            
                            
                        }
                        
                    }
                    else{
                        textFieldView.contentButton.setTitle("Select", for: .normal)
                    }
                    
                    
                }).disposed(by: disposeBag)
        }
        else if(params.index == "shipping_state"){
            self.shippingButtonView = textFieldView
            self.shippingStates.asObservable()
                .subscribe( onNext: { value in
                    if(self.savedShippingState){
                        if(params.value != ""){
                            do{
                                let filtervalue = try? self.shippingStates.value().filter({$0.key == params.value})
                                if(filtervalue?.count ?? 0 > 0){
                                    textFieldView.contentButton.setTitle(Array((filtervalue?.values)!)[0], for: .normal)
                                }
                            }
                            
                            
                        }
                    }
                    else{
                        textFieldView.contentButton.setTitle("Select", for: .normal)
                    }
                }).disposed(by: disposeBag)
        }
        else if(params.index == "billing_country"){
            
            
            if(params.value != ""){
                textFieldView.contentButton.setTitle(countriesDict[params.value!]?.stringValue, for: .normal)
                self.getStates(countryName: params.value ?? "")
            }
        }
        else if(params.index == "shipping_country"){
            if(params.value != ""){
                textFieldView.contentButton.setTitle(countriesDict[params.value!]?.stringValue, for: .normal)
                self.getStates(countryName: params.value ?? "", billinStateCheck: false)
            }
        }
        let labelHeightConstriaint = NSLayoutConstraint(item: textFieldView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 100)
        textFieldView.addConstraint(labelHeightConstriaint)
        mainStackHeight.constant += 100
        return textFieldView
    }
    
    
    
    func setupShippingButton(){
        shippingButton = UIButton()
        mainStack.addArrangedSubview(shippingButton);
        shippingButton.contentHorizontalAlignment = .left
        shippingButton.setTitle("Different Shipping Address", for: .normal)
        shippingButton.setImage(UIImage(named: "unchecked"), for: .normal)
        shippingButton.imageView?.contentMode = .scaleAspectFit
        shippingButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        if #available(iOS 13.0, *) {
            shippingButton.setTitleColor(UIColor.label, for: .normal)
            shippingButton.tintColor = UIColor.label
        } else {
            shippingButton.setTitleColor(UIColor.black, for: .normal)
            shippingButton.tintColor = UIColor.black
        }
        
        shippingButton.addTarget(self, action: #selector(toggleShippingFields(_:)), for: .touchUpInside)
        let labelHeightConstriaint = NSLayoutConstraint(item: shippingButton!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
        shippingButton.addConstraint(labelHeightConstriaint)
        mainStackHeight.constant += 30
    }
    
    @objc func dropDownButtonClicked(_ sender: UIButton){
        
        for index in billingFields{
            if let field = index.field as? ButtonXibView{
                if(field.contentButton == sender){
                    switch index.index {
                    case "billing_country":
                        do{
                            var billing = Dictionary<String,String>()
                            _ = Array(countriesDict.keys).map() {
                                billing.updateValue(countriesDict[$0]!.stringValue, forKey: $0)
                            }
                            showOptions(sender: sender, options: billing, key: "billing")
                        }
                    case "billing_state":
                        do{
                            let billing = try? billingStates.value()
                            showOptions(sender: sender, options: billing)
                        }
                    default:
                        var billing = Dictionary<String,String>()
                        _ = Array(index.options!.keys).map() {
                            billing.updateValue(index.options![$0]!.stringValue, forKey: $0)
                        showOptions(sender: sender, options: billing)
                        }
                    
                    }
                }
            }
            
        }
        for index in shippingFields{
            if let field = index.field as? ButtonXibView{
                if(field.contentButton == sender){
                    switch index.index {
                    case "shipping_country":
                        do{
                            var billing = Dictionary<String,String>()
                            _ = Array(countriesDict.keys).map() {
                                billing.updateValue(countriesDict[$0]!.stringValue, forKey: $0)
                            }
                            showOptions(sender: sender, options: billing, key: "shipping")
                        }
                    case "shipping_state":
                    do{
                        let billing = try? shippingStates.value()
                        showOptions(sender: sender, options: billing)
                    }
                    default:
                        var billing = Dictionary<String,String>()
                        _ = Array(index.options!.keys).map() {
                            billing.updateValue(index.options![$0]!.stringValue, forKey: $0)}
                        showOptions(sender: sender, options: billing)
                        
                    
                    }
                }
            }
        }
        for index in additionalFields{
            if let field = index.field as? ButtonXibView{
                if(field.contentButton == sender){
                    var billing = Dictionary<String,String>()
                    _ = Array(index.options!.keys).map() {
                        billing.updateValue(index.options![$0]!.stringValue, forKey: $0)}
                    showOptions(sender: sender, options: billing)
                    
                }
            }
        }
        
        
    }
    
    func showOptions(sender: UIButton, options: Dictionary<String,String>?,key: String = ""){
        var tempDataSource = Array(options!.values);
        print(tempDataSource);
        tempDataSource = tempDataSource.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        dropDown.dataSource = tempDataSource;
        
        dropDown.selectionAction = {(index, item) in
            sender.setTitle(item, for: UIControl.State());
            if(key=="billing"){
                let arr = options!.filter({$0.value == item})
                self.savedBillingState = false;
                self.getStates(countryName: Array(arr.keys)[0])
            }
            else if(key=="shipping"){
                let arr = options!.filter({$0.value == item})
                self.savedShippingState = true;
                self.getStates(countryName: Array(arr.keys)[0],billinStateCheck: false)
            }
        }
        
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y:sender.bounds.height)
        if dropDown.isHidden {
            let _ = dropDown.show();
        } else {
            dropDown.hide();
        }
    }
    
}

//save/hide shipping fields
extension cedMageNewAddressController{
    
    @objc func toggleShippingFields(_ sender: UIButton){
        if(sender.currentImage == UIImage(named: "unchecked")){
            sender.setImage(UIImage(named: "checked"), for: .normal)
            initialLoadShippingFields = true
            showShippingFields()
        }
        else{
            sender.setImage(UIImage(named: "unchecked"), for: .normal)
            hideShippingFields()
            initialLoadShippingFields = false
        }
    }
    
    func hideShippingFields(){
        shippingLabel.isHidden = true;
        mainStackHeight.constant -= 40
        for index in shippingFields{
            if let field = index.field as? TextFieldView{
                field.isHidden = true;
                mainStackHeight.constant -= 100
            }
            if let field = index.field as? TextViewXib{
                field.isHidden = true;
                mainStackHeight.constant -= 100
            }
            if let field = index.field as? ButtonXibView{
                field.isHidden = true;
                mainStackHeight.constant -= 100
            }
        }
    }
    
    func showShippingFields(){
       shippingLabel.isHidden = false;
       mainStackHeight.constant += 40
       for index in shippingFields{
           if let field = index.field as? TextFieldView{
               field.isHidden = false;
               mainStackHeight.constant += 100
           }
           if let field = index.field as? TextViewXib{
               field.isHidden = false;
               mainStackHeight.constant += 100
           }
           if let field = index.field as? ButtonXibView{
               field.isHidden = false;
               mainStackHeight.constant += 100
           }
       }
    }
}

//Post params
extension cedMageNewAddressController{
    
    func makeProceedButton(){
        let button = UIButton()
        mainStack.addArrangedSubview(button)
        button.setThemeColor()
        button.setTitleColor(wooSetting.textColor, for: .normal)
        button.setTitle("Proceed", for: .normal)
        button.addTarget(self, action: #selector(saveAddress(_:)), for: .touchUpInside)
      
        let buttonConstraint = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50)
        button.addConstraint(buttonConstraint)
        mainStackHeight.constant += 50
    }
    
    @objc func saveAddress(_ sender: UIButton){
        var params = Dictionary<String,String>()
        if let user = User().getLoginUser() {
            params["customer_id"] = user["userId"]
        }
        else{
            if let cartId = UserDefaults.standard.value(forKey: "cart_id")
            {
                params["cart_id"] = cartId as? String
            }
        }
        for index in billingFields{
            if let field = index.field as? TextFieldView{
                if(index.required){
                    if(field.contentTextField.text == ""){
                        if(index.index != "billing_state"){
                            print(index.index)
                            self.view.makeToast("\(index.label) cannot be blank", duration: 2.0, position: .center)
                            return;
                        }
                        
                    }
                }
                if(field.contentTextField.text?.count ?? 0 > 35){
                    self.view.makeToast("\(index.label) cannot be more than 35 characters", duration: 2.0, position: .center)
                    return;
                }
                if(index.index == "billing_postcode"){
                    if(field.contentTextField.text?.count ?? 0 < 5){
                        self.view.makeToast("\(index.label) should be more than 5 characters", duration: 2.0, position: .center)
                        return;
                    }
                }
                if(index.index.contains("email")){
                    if(!field.contentTextField.text!.contains("@")){
                        self.view.makeToast("\(index.label) is not valid", duration: 2.0, position: .center)
                        return;
                    }
                }
                if(index.index != "billing_state"){
                    params[index.index] = field.contentTextField.text;
                }
                
            }
            if let field = index.field as? TextViewXib{
                if(index.required){
                    if(field.contentTextView.text == ""){
                        
                        self.view.makeToast("\(index.label) cannot be blank", duration: 2.0, position: .center)
                        return;
                    }
                }
                if(field.contentTextView.text?.count ?? 0 > 35){
                    self.view.makeToast("\(index.label) cannot be more than 35 characters", duration: 2.0, position: .center)
                    return;
                }
                params[index.index] = field.contentTextView.text;
            }
            if let field = index.field as? ButtonXibView{
                if(index.required){
                    if(index.index == "billing_state"){
                        let billingStatesValue = try! billingStates.value().count
                        if(billingStatesValue > 0){
                            if(field.contentButton.currentTitle == "Select"){
                                self.view.makeToast("Please Select \(index.label)", duration: 2.0, position: .center)
                                return;
                            }
                        }
                        else{
                            if(billingTextView?.contentTextField.text == ""){
                                self.view.makeToast("Please Select \(index.label)", duration: 2.0, position: .center)
                                return;
                            }
                        }
                    }
                    else{
                        if(field.contentButton.currentTitle == "Select"){
                            self.view.makeToast("Please Select \(index.label)", duration: 2.0, position: .center)
                            return;
                        }
                    }
                    
                }
                switch index.index {
                case "billing_country":
                    let arr = countriesDict.filter({$0.value.stringValue == field.contentButton.currentTitle!})
                    params[index.index] = Array(arr.keys)[0]
                case "billing_state":
                    if(!field.isHidden){
                        do{
                            let arr = try? billingStates.value().filter({$0.value == field.contentButton.currentTitle!})
                            params[index.index] = Array(arr!.keys)[0]
                        }
                    }
                    else{
                        params[index.index] = billingTextView?.contentTextField.text!;
                    }
                    
                    
                default:
                    let arr = index.options?.filter({$0.value.stringValue == field.contentButton.currentTitle!})
                    params[index.index] = Array(arr!.keys)[0]
                }
                
            }
            if let field = index.field as? CheckboxView{
                if(index.required){
                    if(field.contentButton.currentImage == UIImage(named: "unchecked")){
                        self.view.makeToast("\(index.label)", duration: 2.0, position: .center)
                        return;
                    }
                }
                var check = false
                if(field.contentButton.currentImage == UIImage(named: "checked")){
                    check = true;
                }
                params[index.index] = "\(check)"
                
            }
        }
        if(shippingButton.currentImage == UIImage(named: "checked")){
            params["ship_to_same"] = "false";
            for index in shippingFields{
                if let field = index.field as? TextFieldView{
                    if(index.required){
                        if(field.contentTextField.text == ""){
                            if(index.index != "shipping_state"){
                                self.view.makeToast("\(index.label) cannot be blank", duration: 2.0, position: .center)
                                return;
                            }
                            
                        }
                    }
                    if(field.contentTextField.text?.count ?? 0 > 35){
                        self.view.makeToast("\(index.label) cannot be more than 35 characters", duration: 2.0, position: .center)
                        return;
                    }
                    if(index.index == "shipping_postcode"){
                        if(field.contentTextField.text?.count ?? 0 < 5){
                            self.view.makeToast("\(index.label) should be more than 5 characters", duration: 2.0, position: .center)
                            return;
                        }
                    }
                    if(index.index.contains("email")){
                        if(!field.contentTextField.text!.contains("@")){
                            self.view.makeToast("\(index.label) is not valid", duration: 2.0, position: .center)
                            return;
                        }
                    }
                    if(index.index != "shipping_state"){
                        params[index.index] = field.contentTextField.text;
                    }
                    
                }
                if let field = index.field as? TextViewXib{
                    if(index.required){
                        if(field.contentTextView.text == ""){
                            self.view.makeToast("\(index.label) cannot be blank", duration: 2.0, position: .center)
                            return;
                        }
                    }
                    if(field.contentTextView.text?.count ?? 0 > 35){
                        self.view.makeToast("\(index.label) cannot be more than 35 characters", duration: 2.0, position: .center)
                        return;
                    }
                    params[index.index] = field.contentTextView.text;
                }
                if let field = index.field as? ButtonXibView{
                    if(index.required){
                        /*if(field.contentButton.currentTitle == "Select"){
                            self.view.makeToast("Please Select \(index.label)", duration: 2.0, position: .center)
                            return;
                        }*/
                        if(index.index == "shipping_state"){
                            let billingStatesValue = try! shippingStates.value().count
                            if(billingStatesValue > 0){
                                if(field.contentButton.currentTitle == "Select"){
                                    self.view.makeToast("Please Select \(index.label)", duration: 2.0, position: .center)
                                    return;
                                }
                            }
                            else{
                                if(shippingTextView?.contentTextField.text == ""){
                                    self.view.makeToast("Please Select \(index.label)", duration: 2.0, position: .center)
                                    return;
                                }
                            }
                        }
                        else{
                            if(field.contentButton.currentTitle == "Select"){
                                self.view.makeToast("Please Select \(index.label)", duration: 2.0, position: .center)
                                return;
                            }
                        }
                    }
                    switch index.index {
                    case "shipping_country":
                        let arr = countriesDict.filter({$0.value.stringValue == field.contentButton.currentTitle!})
                        params[index.index] = Array(arr.keys)[0]
                    case "shipping_state":
                        /*do{
                            let arr = try? billingStates.value().filter({$0.value == field.contentButton.currentTitle!})
                            params[index.index] = Array(arr!.keys)[0]
                        }*/
                        if(!field.isHidden){
                            do{
                                let arr = try? billingStates.value().filter({$0.value == field.contentButton.currentTitle!})
                                params[index.index] = Array(arr!.keys)[0]
                            }
                        }
                        else{
                            params[index.index] = shippingTextView?.contentTextField.text!;
                        }
                        
                    default:
                        let arr = index.options?.filter({$0.value.stringValue == field.contentButton.currentTitle!})
                        params[index.index] = Array(arr!.keys)[0]
                    }
                    
                }
                if let field = index.field as? CheckboxView{
                    if(index.required){
                        if(field.contentButton.currentImage == UIImage(named: "unchecked")){
                            self.view.makeToast("\(index.label)", duration: 2.0, position: .center)
                            return;
                        }
                    }
                    var check = false
                    if(field.contentButton.currentImage == UIImage(named: "checked")){
                        check = true;
                    }
                    params[index.index] = "\(check)"
                    
                }
            }
        }
        else{
            params["ship_to_same"] = "true"
        }
        
        for index in additionalFields{
            if let field = index.field as? TextFieldView{
                if(index.required){
                    if(field.contentTextField.text == ""){
                        self.view.makeToast("\(index.label) cannot be blank", duration: 2.0, position: .center)
                        return;
                    }
                }
                if(field.contentTextField.text?.count ?? 0 > 35){
                    self.view.makeToast("\(index.label) cannot be more than 35 characters", duration: 2.0, position: .center)
                    return;
                }
                params[index.index] = field.contentTextField.text;
            }
            if let field = index.field as? TextViewXib{
                if(index.required){
                    if(field.contentTextView.text == ""){
                        self.view.makeToast("\(index.label) cannot be blank", duration: 2.0, position: .center)
                        return;
                    }
                }
                if(field.contentTextView.text?.count ?? 0 > 35){
                    self.view.makeToast("\(index.label) cannot be more than 35 characters", duration: 2.0, position: .center)
                    return;
                }
                params[index.index] = field.contentTextView.text;
            }
            if let field = index.field as? ButtonXibView{
                if(index.required){
                    if(field.contentButton.currentTitle == "Select"){
                        self.view.makeToast("Please Select \(index.label)", duration: 2.0, position: .center)
                        return;
                    }
                }
                let arr = index.options?.filter({$0.value.stringValue == field.contentButton.currentTitle!})
                params[index.index] = Array(arr!.keys)[0]
                
            }
            if let field = index.field as? CheckboxView{
                if(index.required){
                    if(field.contentButton.currentImage == UIImage(named: "unchecked")){
                        self.view.makeToast("\(index.label)", duration: 2.0, position: .center)
                        return;
                    }
                }
                var check = false
                if(field.contentButton.currentImage == UIImage(named: "checked")){
                    check = true;
                }
                params[index.index] = "\(check)"
                
            }
        }
        print(params)
        cedMageLoaders.addDefaultLoader(me: self)
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/saveuseraddress",method: "POST", params:params, controller: self, completionHandler: {
            data,url,error in
            if let data = data {
                print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
                cedMageLoaders.removeLoadingIndicator(me: self)
                if let json  = try? JSON(data:data)
                {
                    print(json)
                    if(json["success"].stringValue=="true")
                    {
                        self.view.makeToast("Address Added Successfully".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                        mageWooCommon.delay(delay: 2.0, closure: {
                            if(json["data"]["allow_checkout"].stringValue == "true" && json["data"]["rates_status"].stringValue == "true")
                            {
                                let vc=self.storyboard?.instantiateViewController(withIdentifier: "selectshipping") as? selectShippingMethod
                                self.navigationController?.pushViewController(vc!, animated: true);
                            }
                            else if(json["data"]["allow_checkout"].stringValue == "true" && json["data"]["rates_status"].stringValue == "false")
                            {
                                let vc=self.storyboard?.instantiateViewController(withIdentifier: "selectpayment") as? selectPaymentMethod
                                var paymentMethods = [String: String]();
                                for(key,value) in json["data"]["gateways"]
                                {
                                    paymentMethods[key]=value["title"].stringValue;
                                }
                                vc?.paymentMethods=paymentMethods;
                                vc?.shippingMethod="";
                                
                                vc?.tax = json["data"]["taxes_total"].stringValue;
                                vc?.subtotal = json["data"]["cart_subtotal"].stringValue;
                                vc?.grandTotal = json["data"]["cart_total"].stringValue;
                                vc?.currency = json["data"]["currency_symbol"].stringValue;
                                vc?.shippingCost = json["data"]["shipping_total"].stringValue;
                                self.navigationController?.pushViewController(vc!, animated: true);
                            }
                            else
                            {
                                self.view.makeToast("Shipping methods not available", duration: 15.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                            }
                            
                        })
                    }
                    else{
                        self.view.makeToast(json["message"].stringValue, duration: 15.0, position: .center)
                    }
                }
                
                
                
            }
        })
        
    }
    
    
    
}
extension cedMageNewAddressController{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
