//
//  cedMageRecentlyViewCell.swift
//  wooApp
//
//  Created by cedcoss on 22/01/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import UIKit

class cedMageRecentlyViewCell: UITableViewCell , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout
{
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var titleLabel: UILabel!
    var recentlyViewArray = [[String:String]]()
    var parent = UIViewController()
    //var categoriesArray = [[String:String]]()
    //var recent = [[String:String]]()
    override func awakeFromNib()
    {
        super.awakeFromNib()
       
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func reload()
    {
        collectionView.delegate = self
        collectionView.dataSource = self
      //  recentlyViewArray = UserDefaults.standard.object(forKey: "recentlyViewData") as? [[String:String]] ?? [[:]]
        
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return recentlyViewArray.count - 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width/2 - 20, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentlyColCell", for: indexPath) as! cedMageRecentlyViewCollectionCell
        let proData = recentlyViewArray[indexPath.row + 1]
        cell.prodName.text = proData["productName"]
        cell.prodPrice.text = proData["productPrice"]
        cell.prodName.font = mageWooCommon.setCustomFont(type: .regular, size: 15)
        cell.prodName.textColor = wooSetting.subTextColor
        cell.prodPrice.font = mageWooCommon.setCustomFont(type: .regular, size: 15)
        cell.prodPrice.textColor = UIColor.red
        if let imageUrl = proData["productImage"] {
            if(imageUrl != "")
            {
                
                
                cell.prodImg.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(contentsOfFile: wooSetting.productPlaceholder))
                
            }
            else
            {
                cell.prodImg.image = UIImage(contentsOfFile: wooSetting.productPlaceholder)
            }
        }
        //let product = recentlyViewArray[indexPath.row]["name"]
       // cell.prodName.text = product
//        let product = recent[indexPath.row]
//        cell.prodName.text = product["category_name"]
//        cell.prodPrice.text = product["category_name"]
        cell.cellView.cardView()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if let productId = recentlyViewArray[indexPath.row + 1]["productId"]
        {
            let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
            viewControl.productId = productId
            //parent.present(viewControl, animated: true, completion: nil)
            parent.navigationController?.pushViewController(viewControl, animated: true)
        }
    }
}
