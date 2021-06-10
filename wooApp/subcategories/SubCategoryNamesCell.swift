//
//  SubCategoryNamesCell.swift
//  wooApp
//
//  Created by cedcoss on 30/05/19.
//  Copyright © 2019 MageNative. All rights reserved.
//

import UIKit

class SubCategoryNamesCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    
    @IBOutlet weak var subCategoryNameCollection: UICollectionView!
    
    var categoryData = [[String:String]]()
    var parent = UIViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionLoad()
        // Initialization code
    }

    func collectionLoad()
    {
        subCategoryNameCollection.delegate = self
        subCategoryNameCollection.dataSource = self
        subCategoryNameCollection.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = subCategoryNameCollection.dequeueReusableCell(withReuseIdentifier: "subCategoryNameCollectionCell", for: indexPath) as! subCategoryNameCollectionCell
        let subcateg = categoryData[indexPath.row]
        cell.subcategory.text = subcateg["categoryName"]?.replacingOccurrences(of: "&amp;", with: "&")
        cell.subcategory.font = mageWooCommon.setCustomFont(type: .regular, size: 17)
        cell.subcategory.textColor = wooSetting.textColor
        cell.subcategory.backgroundColor = wooSetting.themeColor
        /*if #available(iOS 12.0, *) {
            if(traitCollection.userInterfaceStyle == .dark)
            {
                cell.backgroundColor = wooSetting.themeColor
                cell.subcategory.textColor = wooSetting.darkModeSubTextColor
            }
        } else {
            // Fallback on earlier versions
        }*/
        //cell.subcategory.textColor = wooSetting.subTextColor
        cell.subcategory.layer.cornerRadius = 5.0
        cell.subcategory.clipsToBounds = true;
        //cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //cell.layer.borderWidth = 1.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screen = UIScreen.main.bounds;
       // return CGSize(width: screen.width/3 - 10, height: 50)
        return CGSize(width: screen.width/3 - 10, height: 80)
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("checked child")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageSubCategories") as! cedMageSubCategories
        let category = ["name":self.categoryData[indexPath.row]["categoryName"],"image":self.categoryData[indexPath.row]["imageName"]]
        vc.categData = category as! [String:String]
        vc.categoryId = categoryData[indexPath.row]["categoryId"]!
        self.parent.navigationController?.pushViewController(vc, animated: true)
        /*print("in didSelect subCategory collection")
        let data = categoryData[indexPath.row]
        print("selected item = \(data)")
        let categoryId = data["categoryId"]
        print("category Id = \(categoryId)")
        if (data["has_child"] == "true")
        {
            
            print("redirected to cedMageSubCategories")
        }
        else{
            print("else checked child")
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "categoryProducts") as! CategoryProductsView
            vc.categoryId = categoryId!
            self.parent.navigationController?.pushViewController(vc, animated: true)
            print("redirected to CategoryProductsView")
        }*/
    }
}
