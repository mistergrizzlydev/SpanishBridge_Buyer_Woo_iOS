//
//  mageProductViewCell.swift
//  wooApp
//
//  Created by cedcoss on 8/17/17.
//  Copyright © 2017 MageNative. All rights reserved.
//

import UIKit
import ImageSlideshow
import WebKit

class mageProductViewCell: UITableViewCell {

    var dataLoaded = false;
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var outOfStockLabel: UILabel!
    @IBOutlet weak var soldOutImage: UIImageView!
    @IBOutlet weak var skuLabel: UILabel!
    
    @IBOutlet weak var productImage: ImageSlideshow!
    @IBOutlet weak var wishListButton: UIButton!
    
    @IBOutlet weak var saleLabel: UILabel!
    @IBOutlet weak var productfName: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var compare: UILabel!
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var optionStackView: UIStackView!
    
    @IBOutlet weak var qtyStackView: UIStackView!
    
    @IBOutlet weak var descriptionText: WKWebView!
    //@IBOutlet weak var descriptionText: UILabel!
    
    @IBOutlet weak var optionStackViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var optionStackViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var qtyStackViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var qtyStackViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var reviewButton: UIButton!
    
    
    @IBOutlet weak var longDescriptionButton: UIButton!
    
    @IBOutlet weak var longDescriptionWebView: WKWebView!
    //@IBOutlet weak var longDescriptionLabel: UILabel!
    
    @IBOutlet weak var longDescriptionImageView: UIImageView!
    
    
    @IBOutlet weak var additionInfoStackView: UIStackView!
    
    @IBOutlet weak var additionInfoStackHeight: NSLayoutConstraint!
    
    @IBOutlet weak var additionInfoButton: UIButton!
    
    
    @IBOutlet weak var additionInfoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
