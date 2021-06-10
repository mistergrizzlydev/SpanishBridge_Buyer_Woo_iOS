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

class ProductQtyView: UIView {

    // Our custom view from the XIB file
    var view: UIView!
    
    //outlets
    
    @IBOutlet weak var superView: UIView!
    @IBOutlet weak var decrementButon: UIButton!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var productQty: UITextField!
    
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
        
        //productQty.font = UIFont(fontName: "", fontSize: CGFloat(17.0));
        
        productQty.text = "1";
        superView.layer.borderWidth=0.5
        superView.layer.cornerRadius=13
        superView.layer.borderColor=UIColor.black.cgColor
        superView.backgroundColor = .clear
        if #available(iOS 12.0, *) {
            if(traitCollection.userInterfaceStyle == .dark){
                superView.layer.borderColor=UIColor.white.cgColor
                superView.layer.borderWidth=1.0
            }
        }
        //incrementButton.addTarget(self, action: #selector(ProductQtyView.incrementProductQty(_:)), for: UIControlEvents.touchUpInside);
        //decrementButon.addTarget(self, action: #selector(ProductQtyView.decrementProductQty(_:)), for: UIControlEvents.touchUpInside);
        
        //self.makeCard(self, cornerRadius: 2, color: UIColor.black, shadowOpacity: 0.0);
        //extra setup
        
        
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ProductQtyView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    

}
