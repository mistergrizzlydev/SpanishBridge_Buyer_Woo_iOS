//
//  cedMageCategoryCell.swift
//  wooApp
//
//  Created by cedcoss on 11/01/18.
//  Copyright © 2018 MageNative. All rights reserved.
//

import UIKit

class cedMageCategoryCell: UITableViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var categoryName: UILabel!
    
    @IBOutlet weak var categoryView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
