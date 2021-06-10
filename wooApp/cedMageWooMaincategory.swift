/**
 * CedCommerce
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the End User License Agreement (EULA)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://cedcommerce.com/license-agreement.txt
 *
 * @category  Ced
 * @package   MageNative
 * @author    CedCommerce Core Team <connect@cedcommerce.com >
 * @copyright Copyright CEDCOMMERCE (http://cedcommerce.com/)
 * @license      http://cedcommerce.com/license-agreement.txt
 */

import UIKit

class mageWooMaincategory: mageBaseViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var mainTableView: UITableView!
    //@IBOutlet weak var mainCollection: UICollectionView!
    var categoriesData = [[String:String]]()
    //@IBOutlet weak var noDataImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May    self.tracking(name: "main category page");
        mainTableView.delegate = self;
        mainTableView.dataSource = self;
        self.getmaincategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
        self.updateBadge();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesData.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? cedMageCategoryCell
            {
                if let imageUrl = categoriesData[indexPath.row]["category_image"]
                {
                    
                    cell.categoryImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(contentsOfFile: wooSetting.categoryPlaceholder))
                    /*if let userdefaults = UserDefaults.standard.value(forKey: "themeSettings") as? [String:String]
                    {
                        if let placeholderImage = userdefaults["ced_theme_category_placeholder_image"]
                        {
                            cell.categoryImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(url: URL(string: placeholderImage)))
                        }
                        else
                        {
                            cell.categoryImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "categoryplaceholder"))
                        }
                        
                    }*/
                    
                    
                }
                
                cell.categoryImageView.clipsToBounds = true;
                cell.categoryImageView.layer.cornerRadius = cell.categoryImageView.frame.width/2;
                cell.categoryName.text = categoriesData[indexPath.row]["category_name"]
                cell.categoryName.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
                cell.categoryName.textColor = wooSetting.subTextColor
                
                return cell;
            }
        }
        return UITableViewCell();
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func getmaincategories(){
        cedMageLoaders.addDefaultLoader(me: self)
        User().categoryRequest(controller: self) { (categoryData) in
            cedMageLoaders.removeLoadingIndicator(me: self);
            self.categoriesData = categoryData;
            self.mainTableView.reloadData()
            //self.noDataImageView.isHidden=true;
            if(self.categoriesData.count == 0)
            {
                //self.noDataImageView.isHidden=false;
                self.mainTableView.isHidden=true;
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0)
        {
            let data=categoriesData[indexPath.row]
            let categoryId=data["categoryId"]
            let page = 1;
            User().subCategoryRequest(categoryId: categoryId!, page: page, controller: self) { (subcat) in
                cedMageLoaders.removeLoadingIndicator(me: self);
                
                let categoryData = subcat["category"]!;
                let productsData = subcat["product"]!;
                if(categoryData.count==0 && productsData.count == 0){
                    self.view.makeToast("No products available", duration: 2.0, position: .bottom);
                }
                let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageSubCategories") as! cedMageSubCategories
                let category = ["name":self.categoriesData[indexPath.row]["category_name"],"image":self.categoriesData[indexPath.row]["category_image"]];
                if let categData = category as? [String:String]{
                    vc.categData = categData;
                    
                    vc.categoryId = self.categoriesData[indexPath.row]["categoryId"]!;
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                /*if categoryData.count==0 && productsData.count > 0{
                    let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "categoryProducts") as! CategoryProductsView
                    //vc.productsData=productsData
                    vc.categoryId=self.categoriesData[indexPath.row]["categoryId"]!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if(categoryData.count==0 && productsData.count == 0){
                    self.view.makeToast("No products available", duration: 2.0, position: .bottom);
                }
                else
                {
                    let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageSubCategories") as! cedMageSubCategories
                    let category = ["name":self.categoriesData[indexPath.row]["category_name"],"image":self.categoriesData[indexPath.row]["category_image"]];
                    if let categData = category as? [String:String]{
                        vc.categData = categData;
                        
                        vc.categoryId = self.categoriesData[indexPath.row]["categoryId"]!;
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }*/
            }
        }
    }
}
extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}
