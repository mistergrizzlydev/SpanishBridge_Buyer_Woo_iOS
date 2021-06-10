//
//  cedMageStoreCell.swift
//  wooApp
//
//  Created by cedcoss on 18/04/18.
//  Copyright © 2018 MageNative. All rights reserved.
//

import UIKit

class cedMageStoreCell: UITableViewCell {

    @IBOutlet weak var storeImageView: UIImageView!
    
    @IBOutlet weak var storeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
