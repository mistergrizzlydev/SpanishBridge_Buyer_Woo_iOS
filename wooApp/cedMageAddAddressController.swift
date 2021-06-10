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

class addAddressController: mageBaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var countriesData = [String:JSON]();
    
    //var statesData = [String:[String:String]]();
    
    var statesRelatedToCountry = [String]();
    
    var shippingStatesRelatedToCountry = [String]();
    
    var countries = [String]();
    
    var billingStates = [String:String]()
    
    var shippingStates = [String:String]()
    
    var paymentMethods = [String]()
    @IBOutlet weak var firstNameField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lastNameField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var addressLine1: SkyFloatingLabelTextField!
    
    @IBOutlet weak var addressLine2: SkyFloatingLabelTextField!
    
    @IBOutlet weak var cityField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var zipField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var phoneField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var stateDropDown: CustomOptionDropDownView!
    
    
    @IBOutlet weak var stateTextView: StateTextFieldView!
    
    @IBOutlet weak var countryDropDown: CustomOptionDropDownView!
    
    @IBOutlet weak var companyField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var superViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var superViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var stateDropDownTopSpace: NSLayoutConstraint!
    
    @IBOutlet weak var fieldsViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var stateDropDownHeight: NSLayoutConstraint!
    
    @IBOutlet weak var countryDropDownHeight: NSLayoutConstraint!
    
    
    var countryXibView = PickerXibView();
    
    
    var stateXibView = PickerXibView()
    
    
    var shippingCountryXibView = PickerXibView();
    
    var shippingStateXibView = PickerXibView();
    
    
    
    @IBOutlet weak var proceedButton: UIButton!
    
    @IBOutlet weak var shipAddressStackView: UIStackView!
    
    @IBOutlet weak var shippingButton: UIButton!
    
    @IBOutlet weak var shipAddressStackViewHeight: NSLayoutConstraint!
    
    var shippingCheck = false;
    var guestEmail = "";
    
    var billingAddressData = [String:JSON]();
    var shippingAddressData = [String:JSON]();
    
    let shippingAddressView = addressFieldsView();
    
    var selectedCountry = "";
    var selectedState = "";
    var selectedShippingCountry = "";
    var selectedShippingState = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May  self.tracking(name: "add address")
        
        if let value = UserDefaults.standard.value(forKey: "wooAppLanguage") as? String
        {
            if value=="ar" || value=="ur"
            {
                stateTextView.stateField.textAlignment = .right
               shippingAddressView.stateView.stateField.textAlignment = .right
            }
            else
            {
                stateTextView.stateField.textAlignment = .left
                shippingAddressView.stateView.stateField.textAlignment = .left
            }
        }
        superViewHeight.constant = 730;
        superViewWidth.constant = self.view.frame.width;
        countryXibView.frame=CGRect(x: 0, y: Int(self.view.frame.height/2+100), width: Int(self.view.frame.width), height: Int(self.view.frame.height/2-100))
        countryXibView.mainPickerView.backgroundColor=UIColor.lightGray
        countryXibView.mainPickerView.dataSource=self
        countryXibView.mainPickerView.delegate=self
        self.view.addSubview(countryXibView)
        countryXibView.doneButton.tag=1000;
        countryXibView.doneButton.addTarget(self, action: #selector(doneButtonClicked(_:)), for: .touchUpInside);
        countryXibView.cancelButton.addTarget(self, action: #selector(cancelButtonClicked(_:)), for: .touchUpInside);
        countryXibView.isHidden=true
        
        stateXibView.frame=CGRect(x: 0, y: Int(self.view.frame.height/2+100), width: Int(self.view.frame.width), height: Int(self.view.frame.height/2-100))
        stateXibView.mainPickerView.backgroundColor=UIColor.lightGray
        stateXibView.mainPickerView.dataSource=self
        stateXibView.mainPickerView.delegate=self
        self.view.addSubview(stateXibView)
        stateXibView.doneButton.tag=1001;
        
        stateXibView.doneButton.addTarget(self, action: #selector(doneButtonClicked(_:)), for: .touchUpInside);
        stateXibView.cancelButton.addTarget(self, action: #selector(cancelButtonClicked(_:)), for: .touchUpInside);
        stateXibView.isHidden=true
        stateDropDown.topLabel.text="State *".localized
        stateTextView.headingLabel.text = "State *".localized
        stateDropDown.dropDownButton.setTitle("--Select--", for: .normal)
        stateDropDown.dropDownButton.addTarget(self, action: #selector(stateButtonPressed(_:)), for: .touchUpInside)
        stateDropDown.isHidden = true;
        self.countryDropDown.dropDownButton.setTitle("--Select--", for: .normal)
        self.countryDropDown.topLabel.text="Country *".localized
        self.countryDropDown.dropDownButton.addTarget(self, action: #selector(self.countryButtonPressed(_:)), for: .touchUpInside)
        self.countryDropDown.backgroundColor=UIColor.clear
        self.getAddress();
        
        proceedButton.addTarget(self, action: #selector(self.saveAddress), for: .touchUpInside)
        firstNameField.decorateField();
        firstNameField.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        lastNameField.decorateField();
        lastNameField.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        emailField.decorateField();
        emailField.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        addressLine1.decorateField();
        addressLine1.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        addressLine2.decorateField();
        addressLine2.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        cityField.decorateField();
        cityField.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        zipField.decorateField();
        zipField.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        companyField.decorateField();
        zipField.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        phoneField.decorateField();
        phoneField.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        shippingButton.addTarget(self, action: #selector(shippingButtonClicked(_:)), for: .touchUpInside)
        shippingButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        shipAddressStackView.addArrangedSubview(shippingAddressView)
        shippingAddressView.countryDropDown.view.layer.borderWidth = 0.0;
        shippingAddressView.stateDropDown.view.layer.borderWidth = 0.0;
        countryDropDown.view.layer.borderWidth = 0.0;
        stateDropDown.view.layer.borderWidth = 0.0;
        shippingCountryXibView.frame=CGRect(x: 0, y: Int(self.view.frame.height/2+100), width: Int(self.view.frame.width), height: Int(self.view.frame.height/2-100))
        shippingCountryXibView.mainPickerView.backgroundColor=UIColor.lightGray
        shippingCountryXibView.mainPickerView.dataSource=self
        shippingCountryXibView.mainPickerView.delegate=self
        self.view.addSubview(shippingCountryXibView)
        shippingCountryXibView.doneButton.tag=1002;
        shippingCountryXibView.doneButton.addTarget(self, action: #selector(doneButtonClicked(_:)), for: .touchUpInside);
        shippingCountryXibView.cancelButton.addTarget(self, action: #selector(cancelButtonClicked(_:)), for: .touchUpInside);
        shippingCountryXibView.isHidden=true
        
        shippingStateXibView.frame=CGRect(x: 0, y: Int(self.view.frame.height/2+100), width: Int(self.view.frame.width), height: Int(self.view.frame.height/2-100))
        shippingStateXibView.mainPickerView.backgroundColor=UIColor.lightGray
        shippingStateXibView.mainPickerView.dataSource=self
        shippingStateXibView.mainPickerView.delegate=self
        self.view.addSubview(shippingStateXibView)
        shippingStateXibView.doneButton.tag=1003;
        shippingStateXibView.doneButton.addTarget(self, action: #selector(doneButtonClicked(_:)), for: .touchUpInside);
        shippingStateXibView.cancelButton.addTarget(self, action: #selector(cancelButtonClicked(_:)), for: .touchUpInside);
        shippingStateXibView.isHidden=true;
        shippingAddressView.countryDropDown.dropDownButton.setTitle("--Select--", for: .normal)
        shippingAddressView.countryDropDown.topLabel.text="Country *".localized
        shippingAddressView.countryDropDown.dropDownButton.addTarget(self, action: #selector(self.shippingCountryButtonPressed(_:)), for: .touchUpInside)
        shippingAddressView.countryDropDown.backgroundColor=UIColor.clear
        
        shippingAddressView.stateDropDown.dropDownButton.setTitle("--Select--", for: .normal)
        shippingAddressView.stateDropDown.topLabel.text="State *".localized
        shippingAddressView.stateView.headingLabel.text="State *".localized
        //shippingAddressView.stateView.isHidden = true;
        shippingAddressView.stateDropDown.isHidden = true;
        shippingAddressView.stateDropDown.dropDownButton.addTarget(self, action: #selector(self.shippingStateButtonPressed(_:)), for: .touchUpInside)
        shippingAddressView.stateDropDown.backgroundColor=UIColor.clear
        shippingButtonsHide();
        if(guestEmail != "")
        {
            emailField.text=guestEmail;
            shippingAddressView.emailField.text=guestEmail;
        }
        else
        {
            if UserDefaults.standard.bool(forKey: "mageWooLogin") {
                if let user = User().getLoginUser() {
                    shippingAddressView.emailField.text=user["userEmail"]!;
                    emailField.text = user["userEmail"]!
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateBadge();
        self.proceedButton.setThemeColor();
        proceedButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        proceedButton.setTitleColor(wooSetting.textColor, for: .normal);
        /*if #available(iOS 12.0, *) {
            if(traitCollection.userInterfaceStyle == .dark)
            {
                proceedButton.setTitleColor(wooSetting.darkModeTextColor, for: .normal);
            }
        }*/
        proceedButton.layer.cornerRadius=7;
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
    }
    
    func shippingButtonsHide()
    {
        shippingAddressView.firstNameField.isHidden=true;
        shippingAddressView.lastNameField.isHidden=true;
        shippingAddressView.addressLine1Field.isHidden=true;
        shippingAddressView.addressLine2.isHidden=true;
        shippingAddressView.countryDropDown.isHidden=true;
        shippingAddressView.cityField.isHidden=true;
        shippingAddressView.stateDropDown.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        shippingAddressView.stateDropDown.isHidden=true;
        shippingAddressView.zipField.isHidden=true;
        shippingAddressView.phoneField.isHidden=true;
        shippingAddressView.companyField.isHidden=true;
        shippingAddressView.stateView.isHidden=true;
        shippingAddressView.stateView.stateField.isHidden=true;
        shippingAddressView.stateView.headingLabel.isHidden=true;
        shipAddressStackViewHeight.constant=0;
        
    }
    
    @objc func shippingButtonClicked(_ sender:UIButton)
    {
        if(shippingCheck==true)
        {
            shippingButtonsHide()
            superViewHeight.constant -= 505;
            shippingCheck=false;
            shippingButton.setImage(UIImage(named: "unchecked"), for: .normal)
        }
        else if(shippingCheck==false)
        {
            shippingButton.setImage(UIImage(named: "checked"), for: .normal)
            shippingAddressView.firstNameField.isHidden=false;
            shippingAddressView.lastNameField.isHidden=false;
            shippingAddressView.addressLine1Field.isHidden=false;
            shippingAddressView.addressLine2.isHidden=false;
            shippingAddressView.countryDropDown.isHidden=false;
            shippingAddressView.cityField.isHidden=false;
            shippingAddressView.stateDropDown.isHidden=false;
            shippingAddressView.zipField.isHidden=false;
            shippingAddressView.phoneField.isHidden=false;
            shippingAddressView.companyField.isHidden=false;
            shippingAddressView.stateView.isHidden=false;
            shippingAddressView.stateView.stateField.isHidden=false;
            shippingAddressView.stateView.headingLabel.isHidden=false;
            shipAddressStackViewHeight.constant=505;
            superViewHeight.constant += 505;
            shippingCheck=true;
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView==countryXibView.mainPickerView{
            return countries.count
        }
        else if pickerView==shippingCountryXibView.mainPickerView{
            return countries.count
        }
        else if pickerView==shippingStateXibView.mainPickerView{
            return shippingStatesRelatedToCountry.count;
        }
        else
        {
            return statesRelatedToCountry.count;
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView==countryXibView.mainPickerView{
            return countries[row]
        }
        else if pickerView==shippingCountryXibView.mainPickerView{
            return countries[row]
        }
        else if pickerView==shippingStateXibView.mainPickerView{
            return shippingStatesRelatedToCountry[row]
        }
            
        else
        {
            return statesRelatedToCountry[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView==countryXibView.mainPickerView{
            selectedCountry=countries[row];
        }
        else if pickerView==shippingCountryXibView.mainPickerView{
            selectedShippingCountry=countries[row];
        }
        else if pickerView==shippingStateXibView.mainPickerView{
            selectedShippingState=shippingStatesRelatedToCountry[row];
        }
        else
        {
            selectedState=statesRelatedToCountry[row];
        }
    }
    
    @objc func doneButtonClicked(_ sender: UIButton)
    {
        if(sender.tag==1000)
        {
            if(countries.count > 0){
                if(selectedCountry == ""){
                    selectedCountry = countries[0]
                }
            }
            countryXibView.isHidden=true
            stateDropDown.topLabel.text="State *".localized
            stateDropDown.dropDownButton.setTitle("--Select--", for: .normal)
            countryDropDown.dropDownButton.setTitle(selectedCountry, for: .normal)
            self.getStates(countryName: selectedCountry)
        }
        else if(sender.tag==1001)
        {
            if(statesRelatedToCountry.count > 0)
            {
                if(selectedState == ""){
                    selectedState = statesRelatedToCountry[0];
                }
            }
            stateXibView.isHidden=true
            stateDropDown.dropDownButton.setTitle(selectedState, for: .normal)
        }
        else if(sender.tag==1002)
        {
            if(countries.count > 0)
            {
                if(selectedShippingCountry == "")
                {
                    selectedShippingCountry = countries[0]
                }
            }
            shippingCountryXibView.isHidden=true
            shippingAddressView.stateDropDown.dropDownButton.setTitle("--Select--", for: .normal)
            shippingAddressView.stateDropDown.topLabel.text="State *".localized
            shippingAddressView.countryDropDown.dropDownButton.setTitle(selectedShippingCountry, for: .normal)
            self.getShippingStates(countryName: selectedShippingCountry)
        }
        else if(sender.tag==1003)
        {
            if(shippingStatesRelatedToCountry.count > 0){
                if(selectedShippingState == ""){
                    selectedShippingState = shippingStatesRelatedToCountry[0]
                }
                
            }
            shippingStateXibView.isHidden=true
            shippingAddressView.stateDropDown.dropDownButton.setTitle(selectedShippingState, for: .normal)
        }
    }
    
    @objc func cancelButtonClicked(_ sender: UIButton)
    {
        countryXibView.isHidden=true;
        shippingStateXibView.isHidden=true;
        shippingCountryXibView.isHidden=true;
        stateXibView.isHidden=true;
    }
    
    func loadData()
    {
        print(shippingAddressData)
        shippingAddressView.firstNameField.text=shippingAddressData["first_name"]?.stringValue
        shippingAddressView.lastNameField.text=shippingAddressData["last_name"]?.stringValue
        shippingAddressView.addressLine1Field.text=shippingAddressData["address_1"]?.stringValue;
        shippingAddressView.addressLine2.text=shippingAddressData["address_2"]?.stringValue;
        var scheck = 0
        if(shippingAddressData["country"] != "")
        {
            for(key,value) in countriesData
            {
                if(key==shippingAddressData["country"]?.stringValue)
                {
                    shippingAddressView.countryDropDown.dropDownButton.setTitle(value.stringValue, for: .normal)
                    getShippingStates(countryName: value.stringValue);
                    scheck += 1;
                    
                }
                if(scheck != 0)
                {
                    break;
                }
            }
            
        }
        
        shippingAddressView.cityField.text=shippingAddressData["city"]?.stringValue
        
        shippingAddressView.zipField.text=shippingAddressData["postcode"]?.stringValue;
        shippingAddressView.companyField.text=shippingAddressData["company"]?.stringValue;
        
        shippingAddressView.emailField.text=billingAddressData["email"]?.stringValue;

        
        firstNameField.text=billingAddressData["first_name"]?.stringValue;
        lastNameField.text=billingAddressData["last_name"]?.stringValue;
        addressLine1.text=billingAddressData["address_1"]?.stringValue;
        addressLine2.text=billingAddressData["address_2"]?.stringValue;
        var bcheck=0;
        if(billingAddressData["country"]?.stringValue != "")
        {
            for(key,value) in countriesData
            {
                if(key==billingAddressData["country"]?.stringValue)
                {
                    countryDropDown.dropDownButton.setTitle(value.stringValue, for: .normal);
                    getStates(countryName: value.stringValue);
                    bcheck += 1;
                }
                if(bcheck != 0)
                {
                    break;
                }
            }
            
        }
        
        cityField.text=billingAddressData["city"]?.stringValue;
        zipField.text=billingAddressData["postcode"]?.stringValue;
        phoneField.text=billingAddressData["phone"]?.stringValue;
        companyField.text=billingAddressData["company"]?.stringValue;
        emailField.text=billingAddressData["email"]?.stringValue;
    }
    
    func hideKeyboard()
    {
        emailField.resignFirstResponder();
        cityField.resignFirstResponder();
        zipField.resignFirstResponder();
        companyField.resignFirstResponder();
        addressLine1.resignFirstResponder();
        addressLine2.resignFirstResponder();
        firstNameField.resignFirstResponder();
        lastNameField.resignFirstResponder();
        phoneField.resignFirstResponder();
        shippingAddressView.emailField.resignFirstResponder();
        shippingAddressView.cityField.resignFirstResponder();
        shippingAddressView.zipField.resignFirstResponder();
        shippingAddressView.companyField.resignFirstResponder();
        shippingAddressView.addressLine1Field.resignFirstResponder();
        shippingAddressView.addressLine2.resignFirstResponder();
        shippingAddressView.firstNameField.resignFirstResponder();
        shippingAddressView.lastNameField.resignFirstResponder();
        shippingAddressView.phoneField.resignFirstResponder();
    }
    
    @objc func countryButtonPressed(_ sender: UIButton)
    {
        hideKeyboard()
        countryXibView.mainPickerView.reloadAllComponents()
        countryXibView.isHidden=false
    }
    
    @objc func stateButtonPressed(_ sender: UIButton)
    {
        hideKeyboard()
        stateXibView.mainPickerView.reloadAllComponents();
        if(statesRelatedToCountry.count>0)
        {
            stateXibView.isHidden=false;
        }
        
    }
    
    @objc func shippingCountryButtonPressed(_ sender: UIButton)
    {
        hideKeyboard()
        shippingCountryXibView.mainPickerView.reloadAllComponents();
        shippingCountryXibView.isHidden=false;
    }
    
    @objc func shippingStateButtonPressed(_ sender: UIButton)
    {
        hideKeyboard()
        shippingStateXibView.mainPickerView.reloadAllComponents();
        if(shippingStatesRelatedToCountry.count>0)
        {
            shippingStateXibView.isHidden=false;
        }
    }
    
    func getAddress()
    {
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
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/getsavedaddress",method: "POST", params: params, controller: self, completionHandler: {
            data,url,error in
            
            if let data = data {
                cedMageLoaders.removeLoadingIndicator(me: self)
                if let json  = try? JSON(data:data){
                    print(json)
                    self.parseData(jsonData: json)
                }
                
                
            }
            
            
        })
    }
    
    @objc func saveAddress()
    {
        hideKeyboard()
        shippingCountryXibView.isHidden = true;
        shippingStateXibView.isHidden = true;
        countryXibView.isHidden = true;
        stateXibView.isHidden = true;
        let email = emailField.text;
        let firstName = firstNameField.text;
        let lastName = lastNameField.text;
        let phone = phoneField.text;
        let company = companyField.text;
        let address1 = addressLine1.text;
        let address2 = addressLine2.text;
        let zip = zipField.text;
        let city = cityField.text;
        let state = stateDropDown.dropDownButton.title(for: .normal);
        let country = countryDropDown.dropDownButton.title(for: .normal);
        var params = Dictionary<String,String>();
        if(email=="" || firstName=="" || lastName=="" || phone=="" || address1=="" || zip=="" || city=="" || country=="--Select--")
        {
            self.view.makeToast("All fields are required".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            return;
        }
        
        if(!isValidName(Name: firstName!))
        {
            self.view.makeToast("Enter letters only in firstname".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            return;
        }
        if(!isValidName(Name: lastName!))
        {
            self.view.makeToast("Enter letters only in lastname".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            return;
        }
        if(!isValidName(Name: city!))
        {
            self.view.makeToast("Enter letters only in city".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            return;
        }
        if(!isValidNumber(Number: phone!))
        {
            self.view.makeToast("Enter digits only in phone".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            return;
        }
        
        if let user = User().getLoginUser() {
            params["customer_id"] = user["userId"]
        }
        else{
            if let cartId = UserDefaults.standard.value(forKey: "cart_id")
            {
                params["cart_id"] = cartId as? String
            }
        }
        params["billing_first_name"]=firstName
        params["billing_last_name"]=lastName
        if(company != "")
        {
            params["billing_company"]=company
        }
        for(key,value) in countriesData
        {
            if(value.stringValue==country)
            {
                params["billing_country"]=key
                
            }
        }
        if(self.stateDropDown.isHidden == false)
        {
            if(state=="--Select--")
            {
                self.view.makeToast("All fields are required".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                return;
            }
            for(key1,value1) in billingStates
            {
                if(value1==state)
                {
                    params["billing_state"]=key1;
                    break;
                }
            }
        }
        else
        {
            let state = self.stateTextView.stateField.text;
            if(state == "")
            {
                self.view.makeToast("All fields are required".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                return;
            }
            params["billing_state"]=state;
        }
        params["billing_address_1"]=address1
        if(address2 != "")
        {
            params["billing_address_2"]=address2
        }
        params["billing_city"]=city
        params["billing_postcode"]=zip
        params["billing_phone"]=phone
        params["billing_email"]=email
        params["ship_to_same"]="true";
        if(shippingCheck)
        {
            params["ship_to_same"]="false";
            let ship_lastName = shippingAddressView.lastNameField.text;
            let ship_firstName = shippingAddressView.firstNameField.text;
            let ship_email = shippingAddressView.emailField.text;
            let ship_phone = shippingAddressView.phoneField.text;
            let ship_zip = shippingAddressView.zipField.text;
            let ship_company = shippingAddressView.companyField.text;
            let ship_state = shippingAddressView.stateDropDown.dropDownButton.currentTitle;
            let ship_country = shippingAddressView.countryDropDown.dropDownButton.currentTitle;
            let ship_address1 = shippingAddressView.addressLine1Field.text;
            let ship_address2 = shippingAddressView.addressLine2.text;
            let ship_city = shippingAddressView.cityField.text;
            
            if(ship_email=="" || ship_firstName=="" || ship_lastName=="" || ship_phone=="" || ship_address1=="" || ship_zip=="" || ship_city==""  || ship_country=="--Select--")
            {
                self.view.makeToast("All fields are required".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                return;
            }
            if(!isValidName(Name: ship_firstName!))
            {
                self.view.makeToast("Enter letters only in ship_firstName".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                return;
            }
            if(!isValidName(Name: ship_lastName!))
            {
                self.view.makeToast("Enter letters only in ship_lastName".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                return;
            }
            if(!isValidName(Name: ship_city!))
            {
                self.view.makeToast("Enter letters only in ship_city".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                return;
            }
            if(!isValidNumber(Number: ship_phone!))
            {
                self.view.makeToast("Enter digits only in ship_phone".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                return;
            }
            if(!isValidNumber(Number: ship_zip!))
            {
                self.view.makeToast("Enter digits only in ship_zip".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                return;
            }
            
            params["shipping_first_name"]=ship_firstName
            params["shipping_last_name"]=ship_lastName
            if(ship_company != "")
            {
                params["shipping_company"]=ship_company
            }
            
            params["shipping_address_1"]=ship_address1
            if(ship_address2 != "")
            {
                params["shipping_address_2"]=ship_address2
            }
            params["shipping_city"]=ship_city
            params["shipping_postcode"]=ship_zip
            params["shipping_phone"]=ship_phone
            params["shipping_email"]=ship_email
            params["shipping_same"]="false";
            
            for(key,value) in countriesData
            {
                if(value.stringValue==ship_country)
                {
                    params["shipping_country"]=key
                    
                }
            }
            if(self.shippingAddressView.stateDropDown.isHidden == false)
            {
                if(ship_state=="--Select--")
                {
                    self.view.makeToast("All fields are required".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                    return;
                }
                for(key1,value1) in shippingStates
                {
                    if(value1==ship_state)
                    {
                        params["shipping_state"]=key1;
                        break;
                    }
                }
            }
            else
            {
                let state = self.shippingAddressView.stateView.stateField.text
                if(state == "")
                {
                    self.view.makeToast("All fields are required".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                    return;
                }
                params["shipping_state"]=state;
            }
            
        }
        cedMageLoaders.addDefaultLoader(me: self)
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/saveuseraddress",method: "POST", params:params, controller: self, completionHandler: {
            data,url,error in
            if let data = data {
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
                                self.view.makeToast("Shipping methods not available", duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                            }
                            
                        })
                    }
                }
                
                
                
            }
        })
        
    }
    func isValidName(Name:String) -> Bool {
        let nameRegEx = "[A-Za-z ]*$"
        let Test = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        //print(Test.evaluate(with: Name))
        return Test.evaluate(with: Name)
    }
    func isValidNumber(Number:String) -> Bool {
        let number = "^([0-9]+)?(\\.([0-9]{1,2})?)?$"
        let Test = NSPredicate(format:"SELF MATCHES %@", number)
        //print(Test.evaluate(with: Name))
        return Test.evaluate(with: Number)
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

