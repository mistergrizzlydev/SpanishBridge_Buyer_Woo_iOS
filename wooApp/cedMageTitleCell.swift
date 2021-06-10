//
//  cedMageTitleCell.swift
//  wooApp
//
//  Created by cedcoss on 05/04/18.
//  Copyright © 2018 MageNative. All rights reserved.
//

import UIKit

class cedMageTitleCell: UITableViewCell {

    @IBOutlet var viewAllBtn: UIButton!
        {
        didSet
        {
            viewAllBtn.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
