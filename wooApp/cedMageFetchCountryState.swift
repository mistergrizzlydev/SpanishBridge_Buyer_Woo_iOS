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

extension addAddressController
{
    
    func parseData(jsonData: JSON)
    {
        countriesData = jsonData["data"]["countries"].dictionary!
        let country = Array(countriesData.values)
        for index in country
        {
            countries.append(index.stringValue)
        }
        if(jsonData["data"]["user_data_status"].stringValue == "true")
        {
            if let billing = jsonData["data"]["user_data"]["billing"].dictionary
            {
                billingAddressData = billing
            }
            
            if let shipping = jsonData["data"]["user_data"]["shipping"].dictionary
            {
                shippingAddressData = shipping;
            }
            loadData();
        }
        
    }
    
    func getStates(countryName: String)
    {
        statesRelatedToCountry = [String]()
        billingStates = [String:String]()
        var params = Dictionary<String, String>()
        
        for(key,value) in countriesData
        {
            if(value.stringValue == countryName)
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
                            if(json["status"].stringValue == "true")
                            {
                                for(scode,sname) in json["states"]
                                {
                                    self.billingStates[scode] = sname.stringValue;
                                    self.statesRelatedToCountry.append(sname.stringValue)
                                    if(self.billingAddressData["state"] != "")
                                    {
                                        if(self.billingAddressData["state"]?.stringValue==scode)
                                        {
                                            self.stateDropDown.dropDownButton.setTitle(sname.stringValue, for: .normal)
                                            self.stateTextView.stateField.text = sname.stringValue;
                                            self.billingAddressData["state"] = "";
                                            
                                        }
                                        
                                    }
                                }
                                
                            }
                            if(self.statesRelatedToCountry.count == 0)
                            {
                                self.stateDropDown.isHidden = true;
                                self.stateTextView.isHidden = false;
                                self.stateTextView.stateField.text = self.billingAddressData["state"]?.stringValue
                            }
                            else
                            {
                                self.stateDropDown.isHidden = false;
                                self.stateTextView.isHidden = true;
                            }
                        }
                        
                    }
                    
                })
            }
        }
    }
    func getShippingStates(countryName: String)
    {
        shippingStatesRelatedToCountry = [String]()
        shippingStates = [String:String]()
        var params = Dictionary<String, String>()
        
        for(key,value) in countriesData
        {
            if(value.stringValue == countryName)
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
                            if(json["status"].stringValue == "true")
                            {
                                for(scode,sname) in json["states"]
                                {
                                    self.shippingStates[scode] = sname.stringValue;
                                    self.shippingStatesRelatedToCountry.append(sname.stringValue);
                                    if(self.shippingAddressData["state"] != "")
                                    {
                                        if(self.shippingAddressData["state"]?.stringValue==scode)
                                        {
                                            self.shippingAddressView.stateDropDown.dropDownButton.setTitle(sname.stringValue, for: .normal)
                                            self.shippingAddressView.stateView.stateField.text = sname.stringValue;
                                            
                                            self.shippingAddressData["state"] = "";
                                            
                                        }
                                        
                                    }
                                }
                            }
                            print(self.shippingCheck)
                            if(self.shippingStatesRelatedToCountry.count == 0)
                            {
                                self.shippingAddressView.stateDropDown.isHidden = true;
                                self.shippingAddressView.stateView.isHidden = false;
                                self.shippingAddressView.stateView.stateField.text = self.shippingAddressData["state"]?.stringValue;
                            }
                            else
                            {
                                print(self.shippingCheck)
                                
                                self.shippingAddressView.stateDropDown.isHidden = false;
                                self.shippingAddressView.stateView.isHidden = true;
                                if self.shippingCheck == false
                                {
                                    self.shippingAddressView.stateDropDown.isHidden = true;
                                }
                            }
                            
                            print("added --abcd1 ")
                            if self.shippingCheck == false
                            {
                                self.shippingAddressView.stateDropDown.isHidden = true;
                                self.shippingAddressView.stateView.isHidden = true;
                            }

                        }
                    }
                })
            }
        }
    }
}
