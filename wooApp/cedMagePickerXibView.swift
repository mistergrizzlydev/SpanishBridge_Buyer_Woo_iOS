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
class PickerXibView: UIView {

    @IBOutlet weak var mainPickerView: UIPickerView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    var view: UIView!;
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
        doneButton.setThemeColor();
        doneButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .bold, size: 17);
        doneButton.setTitleColor(wooSetting.textColor, for: .normal);
        cancelButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .bold, size: 17)
        cancelButton.setTitleColor(wooSetting.textColor, for: .normal);
        
        doneButton.layer.cornerRadius=7;
        cancelButton.setThemeColor();
        
        
        cancelButton.layer.cornerRadius=7;
        view.backgroundColor=UIColor.lightGray
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view);
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PickerXibView", bundle: bundle)
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
