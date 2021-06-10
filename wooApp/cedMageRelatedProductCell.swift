//
//  relatedProductCell.swift
//  wooApp
//
//  Created by cedcoss on 9/25/17.
//  Copyright © 2017 MageNative. All rights reserved.
//

import UIKit

class relatedProductCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var headingCell: UILabel!
    var data = true
    var sbounds = CGRect()
    var parent = UIViewController()
    var relatedData = [[String: String]]();
    var currencySymbol = String();
    @IBOutlet weak var relatedCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    func fetch()
    {
        relatedCollectionView.dataSource=self;
        relatedCollectionView.delegate=self;
        relatedCollectionView.reloadData();
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("--relate--")
        print(relatedData.count)
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return relatedData.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = relatedCollectionView.dequeueReusableCell(withReuseIdentifier: "relProdCell", for: indexPath) as? relatedProdCollectionCell
        {
            if(relatedData[indexPath.row]["product_image"] != "" && relatedData[indexPath.row]["product_image"] != nil)
            {
                cell.relatedImageView.sd_setImage(with: URL(string: relatedData[indexPath.row]["product_image"]!), placeholderImage: UIImage(named: "placeholder")!);
            }
            else
            {
                cell.relatedImageView.image = UIImage(named: "placeholder");
            }
            cell.relatedName.text = relatedData[indexPath.row]["product_name"];
            cell.relatedName.font = mageWooCommon.setCustomFont(type: .regular, size: 12)
            if let productPrice = relatedData[indexPath.row]["product_price"]
            {
                cell.relatedproductPrice.text = productPrice
            }
            cell.relatedproductPrice.font = mageWooCommon.setCustomFont(type: .regular, size: 12)
            if(relatedData[indexPath.row]["sale_price"] != nil && relatedData[indexPath.row]["sale_price"] != "")
            {
                if(relatedData[indexPath.row]["product_price"] != relatedData[indexPath.row]["regular_price"])
                {
                    if let regularPrice = relatedData[indexPath.row]["regular_price"]
                    {
                        let offerPrice=NSMutableAttributedString(string: regularPrice);
                        offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                        cell.relatedRegularPrice.attributedText=offerPrice
                    }
                    
                }
            }
            else
            {
                let offerPrice=NSMutableAttributedString(string: "");
                offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                cell.relatedRegularPrice.attributedText=offerPrice
            }
            cell.relatedRegularPrice.font = mageWooCommon.setCustomFont(type: .regular, size: 12)
            if(relatedData[indexPath.row]["sale"] != "")
            {
                let min_price = relatedData[indexPath.row]["product_price_min"];
                let max_price = relatedData[indexPath.row]["product_price_max"];
                let min_reg_price = relatedData[indexPath.row]["product_price_min_reg"];
                let max_reg_price = relatedData[indexPath.row]["product_price_max_reg"];
                if(min_price != max_price)
                {
                    cell.relatedproductPrice.text = currencySymbol+min_price!+" - "+currencySymbol+max_price!
                }
                else if(relatedData[indexPath.row]["sale"] == "true" && min_reg_price == max_reg_price)
                {
                    cell.relatedproductPrice.text = currencySymbol+min_price!+" - "+currencySymbol+max_reg_price!
                }
                else
                {
                    cell.relatedproductPrice.text = currencySymbol+min_price!
                }
                let offerPrice=NSMutableAttributedString(string: "");
                offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                cell.relatedRegularPrice.attributedText=offerPrice
            }
            
            cell.outOfStockLabel.text = "OUT OF STOCK!"
            cell.outOfStockLabel.font = mageWooCommon.setCustomFont(type: .medium, size: 12.0)
            //cell.outOfStockLabel.isHidden = true
            if let stockStatus = relatedData[indexPath.row]["stockLabel"]
            {
                if stockStatus == "false"
                {
                    
                    cell.outOfStockLabel.isHidden = false
                    cell.outOfStockLabel.backgroundColor = wooSetting.themeColor
                    cell.outOfStockLabel.backgroundColor?.withAlphaComponent(0.6)
                    cell.outOfStockLabel.alpha = 0.7
                    cell.outOfStockLabel.textColor = UIColor.white
                }
                else
                {
                    cell.outOfStockLabel.isHidden = true
                    cell.outOfStockLabel.backgroundColor = UIColor.clear
                   
                }
            }
            
            
            cell.cardView()
            return cell;
        }
        return UICollectionViewCell();
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data=relatedData[indexPath.row]
        let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
        viewControl.productId = data["product_id"]!
        parent.navigationController?.pushViewController(viewControl, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: relatedCollectionView.frame.width/2.5 - 5, height: relatedCollectionView.frame.height - 10)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
