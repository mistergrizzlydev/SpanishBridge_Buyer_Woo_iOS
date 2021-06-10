//
//  StateTextFieldView.swift
//  wooApp
//
//  Created by cedcoss on 28/02/18.
//  Copyright © 2018 MageNative. All rights reserved.
//

import UIKit

class StateTextFieldView: UIView {

    var view: UIView!
    
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var stateField: UITextField!
    
    
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
        headingLabel.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        stateField.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view);
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "StateTextFieldView", bundle: bundle)
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

}
