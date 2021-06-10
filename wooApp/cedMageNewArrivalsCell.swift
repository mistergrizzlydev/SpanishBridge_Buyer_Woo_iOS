//
//  cedMageNewArrivalsCell.swift
//  wooApp
//
//  Created by Manohar Singh Rawat on 05/04/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import UIKit

class cedMageNewArrivalsCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
   
    @IBOutlet var arrivalBtn3: UIButton!
    @IBOutlet var arrivalBtn2: UIButton!
    @IBOutlet var arrivalBtn1: UIButton!
    @IBOutlet var arrivalProduct3Price: UILabel!
    @IBOutlet var arrivalProduct3Name: UILabel!
    @IBOutlet var arrivalProduct3Img: UIImageView!
    @IBOutlet var arrivalProduct2Price: UILabel!
    @IBOutlet var arrivalProduct2Name: UILabel!
    @IBOutlet var arrivalProduct2Img: UIImageView!
    @IBOutlet var arrivalProduct1Price: UILabel!
    @IBOutlet var arrivalProduct1Name: UILabel!
    @IBOutlet var arrivalProduct1Img: UIImageView!
    
    
    @IBOutlet weak var arrivalProductOutOfStockLabel1: UILabel!
    @IBOutlet weak var arrivalProduct1RegularPrice: UILabel!
    
    @IBOutlet weak var arrivalProductOutOfStockLabel2: UILabel!
   @IBOutlet weak var arrivalProduct2RegularPrice: UILabel!
    
    @IBOutlet weak var arrivalProductOutOfStockLabel3: UILabel!
      @IBOutlet weak var arrivalProduct3RegularPrice: UILabel!
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    var parent = UIViewController()
    var productsData = [[String:String]]()
    var title = ""
    @IBOutlet weak var mainCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func reloadData()
    {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.reloadData();
        /*if(productsData.count>0)
        {
            let indexPath = IndexPath(row: 0, section: 0)
            
            mainCollectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: true)
        }*/
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section == 0)
        {
            return productsData.count
        }
        else
        {
            return 1;
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.section == 0)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCollectionCell", for: indexPath) as? cedMageHomeCollectionCell
            let product  = productsData[indexPath.row]
            cell?.productName.text = product["productName"]
           cell?.productPrice.text = product["productPrice"]
            cell?.productName.font = mageWooCommon.setCustomFont(type: .regular, size: 15)
            cell?.productPrice.font = mageWooCommon.setCustomFont(type: .regular, size: 15)
           
                  
            cell?.productName.textColor = wooSetting.subTextColor
            
            cell?.productPrice.textColor = UIColor.red
            if let imageUrl = product["productImage"] {
                if(imageUrl != "")
                {
                  
                    
                    cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(contentsOfFile: wooSetting.productPlaceholder))
                    
                }
                else
                {
                    cell?.productImageView.image = UIImage(contentsOfFile: wooSetting.productPlaceholder)
                }
                
            }
            
            cell?.outOfStockLabel.text = "OUT OF STOCK!"
            cell?.outOfStockLabel.font = mageWooCommon.setCustomFont(type: .medium, size: 12.0)
            
            if let stockStatus = product["stockLabel"]
            {
                if stockStatus == "false"
                {
                    cell?.outOfStockLabel.isHidden = false
                    cell?.outOfStockLabel.backgroundColor = wooSetting.themeColor
                    cell?.outOfStockLabel.backgroundColor?.withAlphaComponent(0.6)
                    cell?.outOfStockLabel.alpha = 0.7
                    cell?.outOfStockLabel.textColor = UIColor.white
                }
                else
                {
                    cell?.outOfStockLabel.isHidden = true
                    cell?.outOfStockLabel.backgroundColor = UIColor.clear
                   
                }
            }
            /* if(product["sale"] == "true")
             {
                 cell.saleTagLabel.isHidden = false;
             }
             else
             {
                 cell.saleTagLabel.isHidden = true;
             }*/
            cell?.regularPrice.isHidden = false
             if let productPrice = product["productPrice"]
             {
                 cell?.productPrice.text = productPrice;
             }
             if(product["salePrice"] != "" && product["salePrice"] != nil)
             {
                 //cell.saleTagLabel.isHidden = false;
                 if let regularPrice = product["regularPrice"]
                 {
                     let offerPrice=NSMutableAttributedString(string: regularPrice);
                     offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                     cell?.regularPrice.attributedText=offerPrice
                     //cell?.regularPrice.text = regularPrice;
                 }
             }
             else
             {
                // cell.saleTagLabel.isHidden = true;
                 let offerPrice=NSMutableAttributedString(string: "");
                 offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                 cell?.regularPrice.attributedText=offerPrice
             }
             if(product["sale"] != "" && product["sale"] != nil)
             {
                 let min_price = product["product_price_min"];
                 let max_price = product["product_price_max"];
                 let min_reg_price = product["product_price_min_reg"];
                 let max_reg_price = product["product_price_max_reg"];
                 if(min_price != max_price)
                 {
                    // cell.saleTagLabel.isHidden = false;
                     cell?.productPrice.text = product["currencySymbol"]!+min_price!+" - "+product["currencySymbol"]!+max_price!
                 }
                 else if(product["sale"] == "true" && min_reg_price == max_reg_price)
                 {
                    // cell?.saleTagLabel.isHidden = false;
                     cell?.productPrice.text = product["currencySymbol"]!+min_price!+" - "+product["currencySymbol"]!+max_reg_price!
                 }
                 else
                 {
                     cell?.productPrice.text = product["currencySymbol"]!+min_price!
                 }
                 let offerPrice=NSMutableAttributedString(string: "");
                 offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                 cell?.regularPrice.attributedText=offerPrice
                cell?.regularPrice.isHidden = true
             }

            
            cell?.cellView.cardView()
            return cell!
        }
        else if(indexPath.section == 1)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreProductCollectionCell", for: indexPath) as? cedMageHomeCollectionCell
            if(title == "FEATURED PRODUCTS".localized)
            {
                cell?.firstLabel.text = "MOST".localized
                cell?.secondLabel.text = "POPULAR".localized
            }
            else
            {
                cell?.firstLabel.text = "NEW".localized
                cell?.secondLabel.text = "ARRIVALS".localized
            }
            return cell!;
        }
        return UICollectionViewCell();
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /*if(UIDevice().model.lowercased() == "ipad".lowercased()){
            return CGSize(width: collectionView.frame.width/4-10, height: collectionView.frame.height-10)
        }*/
        return CGSize(width: mainCollectionView.frame.width, height: 100)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section == 0)
        {
            if let productId = productsData[indexPath.row]["productId"]{
                let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
                viewControl.productId = productId
                parent.navigationController?.pushViewController(viewControl, animated: true)
            }
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

