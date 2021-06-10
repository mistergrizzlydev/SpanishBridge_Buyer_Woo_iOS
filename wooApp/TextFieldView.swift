//
//  TextFieldView.swift
//  wooApp
//
//  Created by Manohar Singh Rawat on 22/04/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import UIKit

class TextFieldView: UIView {

    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var contentTextField: UITextField!
    
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
           
           // Adding custom subview on top of our view (over any custom drawing > see note below)
           addSubview(view)
       }
       
       func loadViewFromNib() -> UIView
       {
           let bundle = Bundle(for: type(of: self))
           let nib = UINib(nibName: "TextFieldView", bundle: bundle)
           
           // Assumes UIView is top level and only object in CustomView.xib file
           let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
           return view
       }
    
}
