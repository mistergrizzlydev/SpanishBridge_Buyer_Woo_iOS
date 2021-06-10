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

class addressFieldsView: UIView {

    @IBOutlet weak var stateView: StateTextFieldView!
    
    // Our custom view from the XIB file
    var view: UIView!
    
    @IBOutlet weak var firstNameField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lastNameField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var addressLine2: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var addressLine1Field: SkyFloatingLabelTextField!
    
    @IBOutlet weak var countryDropDown: CustomOptionDropDownView!
    
    
    @IBOutlet weak var stateDropDown: CustomOptionDropDownView!
    
    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    @IBOutlet weak var companyField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneField: SkyFloatingLabelTextField!
    @IBOutlet weak var zipField: SkyFloatingLabelTextField!
    @IBOutlet weak var cityField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var countryDropDownHeight: NSLayoutConstraint!
    
    @IBOutlet weak var stateDropDownHeight: NSLayoutConstraint!
    
    override init(frame: CGRect)
    {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup()
    {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        //extra setup
        // self.makeCard(self, cornerRadius: 2, color: UIColor.black, shadowOpacity: 0.4);
        //extra setup
        firstNameField.decorateField();
        firstNameField.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        lastNameField.decorateField();
        lastNameField.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        emailField.decorateField();
        emailField.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        addressLine1Field.decorateField();
        addressLine1Field.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        addressLine2.decorateField();
        addressLine2.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        cityField.decorateField();
        cityField.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        zipField.decorateField();
        zipField.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        companyField.decorateField();
        companyField.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        phoneField.decorateField();
        phoneField.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view);
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "addressFieldsView", bundle: bundle)
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

}
