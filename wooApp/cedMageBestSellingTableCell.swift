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

class cedMageBestSellingTableCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    
    @IBOutlet var viewAllBtn: UIButton!
        {
        didSet
        {
            viewAllBtn.layer.cornerRadius = 5
        }
      }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productCollection: UICollectionView!
    var productsData = [[String:String]]()
    var parent = UIViewController()
    var title = String();
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func reloadData()
    {
        productCollection.delegate = self
        productCollection.dataSource = self
        productCollection.reloadData();
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productsCell", for: indexPath) as? cedMageHomeCollectionCell
        
        let product  = productsData[indexPath.row]
        if(title == "BEST SELLING".localized)
        {
           
            cell?.productNameLabel.text = product["productName"]
            cell?.productPriceLabel.text = product["productPrice"]
            cell?.productNameLabel.font = mageWooCommon.setCustomFont(type: .regular, size: 15)
            cell?.productNameLabel.textColor = wooSetting.subTextColor
            cell?.productPriceLabel.font = mageWooCommon.setCustomFont(type: .regular, size: 15)
            cell?.productPriceLabel.textColor = UIColor.red

            if let imageUrl = product["productImage"] {
                //print("my imageUrl = \(imageUrl)")
            if imageUrl != ""
            {
                cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(contentsOfFile:wooSetting.productPlaceholder))
            }
            else
            {
                cell?.productImageView.image = UIImage(contentsOfFile:wooSetting.productPlaceholder)
            }
            //print(wooSetting.productPlaceholder)
                //cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(url: URL(string: wooSetting.productPlaceholder)))
          
              
                
                /*
                 //original code
                
                if let userdefaults = UserDefaults.standard.value(forKey: "themeSettings") as? [String:String]
                {
                    if let placeholderImage = userdefaults["ced_theme_product_placeholder_image"]
                    {
                        cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(url: URL(string: placeholderImage)))
                    }
                    else
                    {
                        cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
                    }
                    
                }
                */
                cell?.regularPrice.isHidden = false
                if let productPrice = product["productPrice"]
                      {
                          cell?.productPriceLabel.text = productPrice;
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
                              cell?.productPriceLabel.text = product["currencySymbol"]!+min_price!+" - "+product["currencySymbol"]!+max_price!
                          }
                          else if(product["sale"] == "true" && min_reg_price == max_reg_price)
                          {
                             // cell?.saleTagLabel.isHidden = false;
                              cell?.productPriceLabel.text = product["currencySymbol"]!+min_price!+" - "+product["currencySymbol"]!+max_reg_price!
                          }
                          else
                          {
                              cell?.productPriceLabel.text = product["currencySymbol"]!+min_price!
                          }
                          let offerPrice=NSMutableAttributedString(string: "");
                          offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                          cell?.regularPrice.attributedText=offerPrice
                        cell?.regularPrice.isHidden = true;
                      }
                      
                      
                  //print(wooSetting.productPlaceholder)
                      //cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(url: URL(string: wooSetting.productPlaceholder)))
                
                    
                      
                      /*
                       //original code
                      
                      if let userdefaults = UserDefaults.standard.value(forKey: "themeSettings") as? [String:String]
                      {
                          if let placeholderImage = userdefaults["ced_theme_product_placeholder_image"]
                          {
                              cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(url: URL(string: placeholderImage)))
                          }
                          else
                          {
                              cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
                          }
                          
                      }
                      */
                    
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
                
                
                
                
                
                
                cell?.cellView.cardView();
            }
        }
        else
        {
            if let imageUrl = product["banner_url"] {
                if imageUrl != ""
                {
                    //cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(url: URL(string: wooSetting.productPlaceholder)))
                    cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(contentsOfFile: wooSetting.bannerPlaceholder))
                }
                else
                {
                    cell?.productImageView.image = UIImage(contentsOfFile: wooSetting.bannerPlaceholder)
                }
                
                
              /*  if let userdefaults = UserDefaults.standard.value(forKey: "themeSettings") as? [String:String]
                {
                    if let placeholderImage = userdefaults["ced_theme_product_placeholder_image"]
                    {
                        cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(url: URL(string: placeholderImage)))
                    }
                    else
                    {
                        cell?.productImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
                    }
                    
                }*/
                
            }
        }
        return cell!
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(title == "BEST SELLING".localized)
        {
            if(UIDevice().model.lowercased() == "ipad".lowercased()){
                return CGSize(width: collectionView.frame.width/4-10, height: collectionView.frame.height-10)
            }
            return CGSize(width: productCollection.frame.width/2, height: productCollection.frame.height/2)
        }
        else
        {
            if(UIDevice().model.lowercased() == "ipad".lowercased()){
                return CGSize(width: collectionView.frame.width-10, height: collectionView.frame.height-10)
            }
            return CGSize(width: UIScreen.main.bounds.width, height: productCollection.frame.height - 10)
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(title == "BEST SELLING".localized)
        {
            if let productId = productsData[indexPath.row]["productId"]{
                let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
                viewControl.productId = productId
                //parent.present(viewControl, animated: true, completion: nil)
                parent.navigationController?.pushViewController(viewControl, animated: true)
            }
        }
        else
        {
            let banner = productsData[indexPath.row]
            if(banner["link_to"] == "product"){
                let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
                viewControl.productId = banner["link_id"]!
                parent.navigationController?.pushViewController(viewControl, animated: true)
                
            }
            else if(banner["link_to"] == "category"){
                /*let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "categoryProducts") as! CategoryProductsView
                vc.categoryId=banner["link_id"]!
                parent.navigationController?.pushViewController(vc, animated: true)*/
                /*let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageSubCategories") as! cedMageSubCategories
                vc.categoryId=banner["link_id"]!
                
                parent.navigationController?.pushViewController(vc, animated: true)*/
                let page = 1;
                let categoryId = banner["link_id"]!
                User().subCategoryRequest(categoryId: categoryId, page: page, controller: parent) { (subcat) in
                    cedMageLoaders.removeLoadingIndicator(me: self.parent);
                    let categoryData = subcat["category"]!;
                    let productsData = subcat["product"]!;
                    let mainCategoryData = subcat["maincategory"]![0]
                    if categoryData.count==0 && productsData.count > 0{
                        let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "categoryProducts") as! CategoryProductsView
                        //vc.productsData=productsData
                        vc.categoryId=categoryId;
                        self.parent.navigationController?.pushViewController(vc, animated: true)
                    }
                    else
                    {
                        let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageSubCategories") as! cedMageSubCategories
                        let category = ["name":mainCategoryData["name"],"image":mainCategoryData["image"]];
                        if let categData = category as? [String:String]{
                            vc.categData = categData;
                            
                            vc.categoryId = categoryId;
                            self.parent.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                    }
                }
                
            }
            else if(banner["link_to"] == "website"){
                let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webController") as! mageHomeWebController
                vc.url=banner["link_id"]!
                parent.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
