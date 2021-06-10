//
//  cedMagePaymentMethodsCell.swift
//  wooApp
//
//  Created by cedcoss on 02/12/17.
//  Copyright © 2017 MageNative. All rights reserved.
//

import UIKit

class cedMagePaymentMethodsCell: UITableViewCell {

    @IBOutlet weak var shippingMethodLabel: UILabel!
    @IBOutlet weak var paymentMethodsStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var paymentMethodsStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
