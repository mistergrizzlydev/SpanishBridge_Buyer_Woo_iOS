//
//  ButtonXibView.swift
//  wooApp
//
//  Created by Manohar Singh Rawat on 22/04/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import UIKit

class ButtonXibView: UIView {

    var view: UIView!;
    
    @IBOutlet weak var contentButton: UIButton!
    
    @IBOutlet weak var headingLabel: UILabel!
    
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
        contentButton.layer.borderWidth = 1.0;
        contentButton.layer.borderColor = UIColor.gray.cgColor
        if #available(iOS 13.0, *) {
            contentButton.setTitleColor(UIColor.label, for: .normal)
        } else {
            contentButton.setTitleColor(UIColor.black, for: .normal)
        }
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ButtonXibView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
   

}
