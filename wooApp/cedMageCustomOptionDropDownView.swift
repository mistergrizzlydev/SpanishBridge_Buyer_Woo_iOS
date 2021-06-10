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

class CustomOptionDropDownView: UIView {

    // Our custom view from the XIB file
    var view: UIView!

    
    @IBOutlet weak var lineView: UIView!
    
    
    @IBOutlet weak var topLabel: UILabel!
    
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
        //let AppData=AppSourceDataViewController.AppData()
        //extra setup
        //topLabel.font = UIFont.systemFont(ofSize: 13)
        //dropDownButton.setTitleColor(UIColor.black, for: .normal)
        topLabel.textColor=UIColor.black
        dropDownButton.layer.borderWidth = 1;
        dropDownButton.layer.borderColor = UIColor.lightGray.cgColor;
        //extra setup
        img.tintColor=UIColor.black
        //lineView.backgroundColor=UIColor.black
        dropDownButton.setTitleColor(UIColor.black, for: .normal)
        //dropDownButton.layer.borderWidth = 2
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
        if #available(iOS 13.0, *) {
            dropDownButton.setTitleColor(UIColor.label, for: .normal)
            topLabel.textColor = UIColor.label;
            img.tintColor = UIColor.label;
        } else {
            dropDownButton.setTitleColor(UIColor.black, for: .normal)
            topLabel.textColor = UIColor.black;
            img.tintColor = UIColor.black;
        }
        
        dropDownButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        if #available(iOS 12.0, *) {
            if(traitCollection.userInterfaceStyle == .dark){
                
                dropDownButton.layer.borderColor = UIColor.white.cgColor
                //view.layer.borderColor = UIColor.white.cgColor;
               // view.layer.borderWidth = 1.0;
            }
        }
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomOptionDropDownView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
 
}
