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

class dropdownButtonLabelView: UIView {

    // Our custom view from the XIB file
    var view: UIView!
    
    
    @IBOutlet weak var lineView: UIView!
    
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var img: UIButton!
    
    //outlets
    @IBOutlet weak var dropDownButton: UIButton!
    
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
        labelName.textColor=UIColor.black
        
        dropDownButton.layer.borderColor = UIColor.lightGray.cgColor;
        //extra setup
        img.tintColor=UIColor.black
        lineView.backgroundColor=UIColor.black
        dropDownButton.setTitleColor(UIColor.black, for: .normal)
        dropDownButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        if let value = UserDefaults.standard.value(forKey: "wooAppLanguage") as? String
        {
            if value=="ar" || value=="ur"
            {
                dropDownButton?.contentHorizontalAlignment = .right
            }
            else
            {
                dropDownButton?.contentHorizontalAlignment = .left
            }
        }
        dropDownButton.cardView()
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "dropdownButtonLabelView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }



}
