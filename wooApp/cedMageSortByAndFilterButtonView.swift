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

class sortByAndFilterButtonView: UIView {

    @IBOutlet weak var sortButton: UIButton!;
    
    @IBOutlet weak var filterButton: UIButton!;
    
    @IBOutlet weak var changeViewButton: UIButton!;
    
    @IBOutlet weak var switchImage: UIImageView!;
    
    var view: UIView!
    
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
        sortButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        filterButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        if #available(iOS 12.0, *) {
            if(traitCollection.userInterfaceStyle == .dark)
            {
                sortButton.layer.borderColor = UIColor.white.cgColor
                filterButton.layer.borderColor = UIColor.white.cgColor
                switchImage.tintColor = UIColor.white;
            }
        }
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view);
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "sortByAndFilterButtonView", bundle: bundle)
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }


}
