//
//  cedMageHomeCategoryCell.swift
//  wooApp
//
//  Created by cedcoss on 10/01/18.
//  Copyright © 2018 MageNative. All rights reserved.
//

import UIKit

class cedMageHomeCategoryCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var showMore = true;
    var productsData = [[String:String]]()
    var parent = UIViewController();
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
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print(showMore)
        if(showMore)
        {
            return 2;
        }
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section == 0)
        {
            return productsData.count;
        }
        else
        {
            return 1;
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.section == 0)
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionCell", for: indexPath) as? cedMageHomeCollectionCell
            cell?.productImageName.text = productsData[indexPath.row]["category_name"]
            cell?.productImageName.textColor = wooSetting.subTextColor
            /*if #available(iOS 12.0, *) {
                if(traitCollection.userInterfaceStyle == .dark)
                {
                    cell?.productImageName.textColor = wooSetting.darkModeSubTextColor
                }
            }*/
            cell?.productImageName.font = mageWooCommon.setCustomFont(type: .regular, size: 12)
            if let imageUrl = productsData[indexPath.row]["category_image"]{
                cell?.productImageView.clipsToBounds = true;
                cell?.productImageView.layer.cornerRadius = (cell?.productImageView.frame.width)!/2;
                
                if imageUrl != ""
                {
                     cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(contentsOfFile:wooSetting.categoryPlaceholder))
                }
                else
                {
                    
                     cell?.productImageView.image = UIImage(contentsOfFile:wooSetting.categoryPlaceholder)
                }
                print(wooSetting.categoryPlaceholder)
                
              // cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(url: URL(string: wooSetting.categoryPlaceholder)))
                
                
                
                
                /*
                // original code
                
                if let userdefaults = UserDefaults.standard.value(forKey: "themeSettings") as? [String:String]
                {
                    if let placeholderImage = userdefaults["ced_theme_category_placeholder_image"]
                    {
                        cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(url: URL(string: placeholderImage)))
                    }
                    else
                    {
                        cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "categoryplaceholder"))
                    }
                    
                }
                */
                //cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "categoryplaceholder"))
            }
            cell?.cardView()
            return cell!
        }
        else if(indexPath.section == 1)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreCollectionCell", for: indexPath) as? cedMageHomeCollectionCell
            cell?.moreLabel.text = "MORE".localized
            cell?.moreLabel.font = mageWooCommon.setCustomFont(type: .regular, size: 12)
            cell?.moreLabel.textColor = wooSetting.subTextColor
            
            cell?.moreCircleImageView.clipsToBounds = true;
            cell?.moreCircleImageView.layer.cornerRadius = (cell?.moreCircleImageView.frame.width)!/2;
            cell?.moreCircleImageView.layer.borderWidth = 1;
            cell?.moreImageView.image = UIImage(named: "category--dropdown")
            return cell!;
        }
        return UICollectionViewCell();
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(UIDevice().model.lowercased() == "ipad".lowercased()){
            return CGSize(width: collectionView.frame.width/4-10, height: collectionView.frame.height-10)
        }
        return CGSize(width: UIScreen.main.bounds.width/4 - 5, height: 100)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section == 1)
        {
            
            if let home = parent as? mageWooHome
            {
                if(home.moreClicked)
                {
                    home.moreClicked = false;
                }
                else
                {
                    home.moreClicked = true;
                }
                let sectionToReload = 1
                let indexSet: IndexSet = [sectionToReload]
                home.mainTable.reloadSections(indexSet, with: .automatic);
            }
            if let home = parent as? cedMageSubCategories
            {
                if(home.moreClicked)
                {
                    home.moreClicked = false;
                }
                else
                {
                    home.moreClicked = true;
                }
                let sectionToReload = 1
                let indexSet: IndexSet = [sectionToReload]
                home.mainTableView.reloadSections(indexSet, with: .automatic);
            }
        }
        else
        {
            
            let data=productsData[indexPath.row]
            let categoryId=data["category_id"]
            let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageSubCategories") as! cedMageSubCategories
            let category = ["name":self.productsData[indexPath.row]["category_name"],"image":self.productsData[indexPath.row]["category_image"]];
            if let categData = category as? [String:String]{
                vc.categData = categData;
                
                vc.categoryId = categoryId!;
                
                self.parent.navigationController?.pushViewController(vc, animated: true)
            }
            /*if(data["has_child"] == "true")
            {
                let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageSubCategories") as! cedMageSubCategories
                let category = ["name":self.productsData[indexPath.row]["category_name"],"image":self.productsData[indexPath.row]["category_image"]];
                if let categData = category as? [String:String]{
                    vc.categData = categData;
                    
                    vc.categoryId = categoryId!;
                    
                    self.parent.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else
            {
                let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "categoryProducts") as! CategoryProductsView
                vc.categoryId=categoryId!
                self.parent.navigationController?.pushViewController(vc, animated: true)
            }*/
            /*cedMageLoaders.addDefaultLoader(me: parent)
            let page = 1;
            User().subCategoryRequest(categoryId: categoryId!, page: page, controller: parent) { (subcat) in
                cedMageLoaders.removeLoadingIndicator(me: self.parent);
                let categoryData = subcat["category"]!;
                let productsData = subcat["product"]!;
                if categoryData.count==0 && productsData.count > 0{
                    let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "categoryProducts") as! CategoryProductsView
                    //vc.productsData=productsData
                    vc.categoryId=self.productsData[indexPath.row]["category_id"]!
                    self.parent.navigationController?.pushViewController(vc, animated: true)
                }
                else if(categoryData.count==0 && productsData.count == 0){
                    self.parent.view.makeToast("No products available", duration: 2.0, position: .bottom);
                }
                else
                {
                    let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageSubCategories") as! cedMageSubCategories
                    let category = ["name":self.productsData[indexPath.row]["category_name"],"image":self.productsData[indexPath.row]["category_image"]];
                    if let categData = category as? [String:String]{
                        vc.categData = categData;
                        
                        vc.categoryId = self.productsData[indexPath.row]["category_id"]!;
                        
                        self.parent.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    
                    
                }
            }*/
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
