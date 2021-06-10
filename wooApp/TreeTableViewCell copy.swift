//
//  TreeTableViewCell.swift
//  RATreeViewExamples
//
//  Created by Rafal Augustyniak on 22/11/15.
//  Copyright © 2015 com.Augustyniak. All rights reserved.
//

import UIKit
import SDWebImage
class TreeTableViewCell : UITableViewCell {

    
    
    @IBOutlet weak var rightImage: UIImageView!
    
    
    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet private weak var customTitleLabel: UILabel!

    @IBOutlet weak var img: UIImageView!
    

    override func awakeFromNib() {
        selectedBackgroundView? = UIView()
        selectedBackgroundView?.backgroundColor = .clear
    }

    var additionButtonActionBlock : ((TreeTableViewCell) -> Void)?;
    func setup(withTitle title: String, detailsText: String, level : Int, additionalButtonHidden: Bool, img: String) {
        customTitleLabel.text = title
        detailsLabel.text = ""
        if level == 0
        {
            self.customTitleLabel.textColor = UIColor(hexString: wooSetting.themeColor)
        }
        else
        {
            self.customTitleLabel.textColor = UIColor.black
        }
        
       
       // self.img.image = UIImage(named: "categoryplaceholder")
      //  self.img.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "bullet"))
        self.img.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "categoryplaceholder"))
        let left = 11.0 + 20.0 * CGFloat(level)
        self.customTitleLabel.frame.origin.x = left+30
        self.img.frame.origin.x = left
        self.detailsLabel.frame.origin.x = left+30
        
    }

    func additionButtonTapped(_ sender : AnyObject) -> Void {
        /*if let action = additionButtonActionBlock {
            action(self)
        }*/
    }

}
