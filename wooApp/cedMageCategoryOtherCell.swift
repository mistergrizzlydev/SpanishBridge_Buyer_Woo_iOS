//
//  cedMageCategoryOtherCell.swift
//  wooApp
//
//  Created by cedcoss on 22/01/18.
//  Copyright © 2018 MageNative. All rights reserved.
//

import UIKit

class cedMageCategoryOtherCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var productsData = [[String:String]]()
    var parent = UIViewController();
    var homeCategoryCheck = false;
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
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(homeCategoryCheck)
        {
            return productsData.count + 1;
        }
        return productsData.count + 1;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionCell", for: indexPath) as? cedMageHomeCollectionCell
        {
            if(indexPath.row == productsData.count)
            {
                cell.productImageView.clipsToBounds = true;
                cell.productImageView.layer.cornerRadius = cell.productImageView.frame.width/2;
                cell.productImageView.image = UIImage(named: "more_en")
                cell.productImageName.text = "";
                if(UserDefaults.standard.value(forKey: "store_id") != nil)
                {
                    let lang = UserDefaults.standard.value(forKey: "store_id") as! String
                    if(lang == "ar")
                    {
                        cell.productImageView.image = UIImage(named: "more_ar")
                    }
                }
            }
            else
            {
                cell.productImageName.text = productsData[indexPath.row]["category_name"]
                cell.productImageName.textColor = wooSetting.subTextColor
                /*if #available(iOS 12.0, *) {
                    if(traitCollection.userInterfaceStyle == .dark)
                    {
                        cell.productImageName.textColor = wooSetting.darkModeSubTextColor
                    }
                }*/
                cell.productImageName.font = mageWooCommon.setCustomFont(type: .regular, size: 12)
                
                if let imageUrl = productsData[indexPath.row]["category_image"]{
                    cell.productImageView.clipsToBounds = true;
                    cell.productImageView.layer.cornerRadius = cell.productImageView.frame.width/2;
                    
                     print(wooSetting.categoryPlaceholder)
                    if imageUrl != ""
                    {
                         cell.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(contentsOfFile: wooSetting.categoryPlaceholder))
                    }
                    else
                    {                    
                         cell.productImageView.image = UIImage(contentsOfFile:wooSetting.categoryPlaceholder)
                    }
                    
                    
                   
                    
                    /*
                     // original code
                     
                    if let userdefaults = UserDefaults.standard.value(forKey: "themeSettings") as? [String:String]
                    {
                        if let placeholderImage = userdefaults["ced_theme_category_placeholder_image"]
                        {
                            cell.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(url: URL(string: placeholderImage)))
                        }
                        else
                        {
                            cell.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "categoryplaceholder"))
                        }
                    }
                    
                   */
                }
            }
            
            cell.cardView()
            return cell
        }
        return UICollectionViewCell();
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(UIDevice().model.lowercased() == "ipad".lowercased()){
            return CGSize(width: collectionView.frame.width/4-10, height: collectionView.frame.height-10)
        }
        return CGSize(width: collectionView.frame.width/4 - 10, height: 110)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row == productsData.count)
        {
            let viewControl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mageWooMaincategory") as! mageWooMaincategory
            self.parent.navigationController?.pushViewController(viewControl, animated: true);
        }
        else{
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
                //vc.productsData=productsData
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
