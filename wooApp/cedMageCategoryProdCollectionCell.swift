//
//  cedMageCategoryProdCollectionCell.swift
//  wooApp
//
//  Created by cedcoss on 25/01/18.
//  Copyright © 2018 MageNative. All rights reserved.
//

import UIKit

class cedMageCategoryProdCollectionCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var regularPrice: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var saleTagLabel: UILabel!
    
    @IBOutlet weak var wishlist: UIButton!
    
    @IBOutlet weak var cellCardView: UIView!
    
    @IBOutlet weak var outOfStockLabel: UILabel!
    
    @IBOutlet weak var qtyView: ProductQtyView!
    
    @IBOutlet weak var addToCartButton: UIButton!
    
}
