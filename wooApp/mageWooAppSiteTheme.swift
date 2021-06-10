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

class mageWooAppSiteTheme: mageBaseViewController,UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate
{
    
    @IBOutlet weak var mainTable: UITableView!
    var navigateCheck = false;
    var isResponse = false
    var bestSellingProducts = [[String:String]]() //Best selling
    var viewAllbestSellingProducts = [[String:String]]()
    var featuredProducts = [[String:String]]()
    var viewAllfeaturedProducts = [[String:String]]()
    var newArrivalProducts = [[String:String]]()
    var homePageBanners    = [[String:String]]()
    var categoryProducts = [[String:String]]()
    var otherCategoryProducts = [[String:String]]()
    var recentlyViewArray = [[String:String]]()
    var bannerImageArray  = [String]()
    var moreClicked = false
    var featuredBanners = [[String:String]]()
    var newArrivalBanners = [[String:String]]();
    var arrivalProductId1 = ""
    var arrivalProductId2 = ""
    var arrivalProductId3 = ""
    var categoryId = "";
    var productId = "";
    var webURL = "";
    var checkNotificationType=""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //--edited10May    self.tracking(name: "home page")
        mainTable.delegate = self
        mainTable.dataSource = self
        print(UserDefaults.standard.object(forKey: "produnctId") as? String)
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "loadHomePage"), object: nil);
        getData()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        if isResponse
        {
        mainTable.reloadData()
         recentlyViewArray = UserDefaults.standard.object(forKey: "recentlyViewData") as? [[String:String]] ?? [[:]]
        }
        self.tabBarController?.tabBar.isHidden = false;
         print(UserDefaults.standard.object(forKey: "productsId"))
        //SettingUp navigation bar
        if UserDefaults.standard.value(forKey: "NotificationData") != nil
        {
            let data=UserDefaults.standard.value(forKey: "NotificationData") as! [String:String]
            UserDefaults.standard.removeObject(forKey: "NotificationData")
            print(data)
            for (key,value) in data{
                checkNotificationType=key
                if key=="category"{
                    categoryId=value
                }
                else if key=="product"{
                    productId=value
                }
                else if key=="website"{
                    let temp=URL(string: value)
                    webURL=(temp?.absoluteString)!
                }
            }
        }
        UserDefaults.standard.removeObject(forKey: "NotificationData")
        if checkNotificationType == "category"
        {
            print("NOTIFICATIONCOLLECTION")
            let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "categoryProducts") as! CategoryProductsView
            vc.categoryId=self.categoryId
            vc.notificationCheck = true;
            self.navigationController?.pushViewController(vc, animated: true)
            self.checkNotificationType=""
        }
        else if checkNotificationType == "product"
        {
            
            let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
            viewControl.productId = self.productId
            viewControl.notificationCheck = true;
            self.navigationController?.pushViewController(viewControl, animated: true)
            
            self.checkNotificationType=""
        }
        else if checkNotificationType == "website"
        {
            let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webController") as! mageHomeWebController
            vc.url=webURL
            vc.notificationCheck = true;
            self.navigationController?.pushViewController(vc, animated: true)
            checkNotificationType=""
            
        }
        self.updateBadge();
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 11
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(section == 5)
        {
            if(featuredBanners.count>0 || featuredProducts.count>0)
            {
                return 1
            }
            return 0
        }
        if(section == 8)
        {
            if(newArrivalBanners.count>0 || newArrivalProducts.count>0)
            {
                return 1;
            }
            return 0;
        }
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 2)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as? HomeCategoryCell
            cell?.parent = self;
            cell?.productsData = categoryProducts;
            print("-----othehre")
            print(otherCategoryProducts)
            print(otherCategoryProducts.count);
            
//            if(otherCategoryProducts.count == 0)
//            {
//                cell?.showMore = false
//            }
//            else
//            {
//                cell?.showMore = true;
//            }
            cell?.reloadData();
            return cell!;
        }
        else if(indexPath.section == 1)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryOtherCell") as? cedMageCategoryOtherCell
            cell?.parent = self;
            cell?.productsData = otherCategoryProducts;
            cell?.reloadData();
            return cell!;
        }
        else if(indexPath.section == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bannerCell") as? mageWooBannerCell
            cell?.dataSource = bannerImageArray
            cell?.bannerData=homePageBanners;
            cell?.imagePager.imageCounterDisabled = true
            cell?.imagePager.slideshowTimeInterval = 2
            cell?.parent=self;
            
            return cell!
        }
        else if(indexPath.section == 3)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topSellersCell") as? cedMageBestSellingTableCell
            cell?.parent = self
            cell?.productsData = bestSellingProducts
            cell?.titleLabel.text="ITEMS ON SALE".localized
            cell?.titleLabel.font = mageWooCommon.setCustomFont(type: .bold, size: 15)
            cell?.titleLabel.textColor = wooSetting.textColor
            cell?.title = "BEST SELLING".localized;
            cell?.viewAllBtn.addTarget(self, action: #selector(viewAllItemsOnSale), for: .touchUpInside)
            cell?.reloadData();
            if(bestSellingProducts.count>0)
            {
                let indexPath = IndexPath(row: 0, section: 0)
                
                cell?.productCollection.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: true)
            }
            
            return cell!
        }
            else if(indexPath.section == 4)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "recentlyCell") as? cedMageRecentlyViewCell
                cell?.titleLabel.text = "RECENTLY VIEWED"
                    
                cell?.recentlyViewArray = recentlyViewArray
                cell?.titleLabel.font = mageWooCommon.setCustomFont(type: .bold, size: 15)
                cell?.titleLabel.textColor = wooSetting.textColor
//                cell?.recentlyView = recentViewdata!
//                cell?.categoriesArray = categoryProducts
                
                cell?.reload()
                
                return cell!
            }
        else if(indexPath.section == 5)
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cedMageTitleCell") as? cedMageTitleCell{
                cell.titleLabel.text="FEATURED PRODUCTS".localized
                cell.viewAllBtn.tag = indexPath.section
                cell.viewAllBtn.addTarget(self, action: #selector(viewAllFeaturedandArrivalBtn), for: .touchUpInside)
                cell.contentView.backgroundColor = UIColor(hexString: "#FF9500")
                cell.titleLabel.font = mageWooCommon.setCustomFont(type: .bold, size: 15)
                cell.titleLabel.textColor = wooSetting.textColor
                return cell;
            }
        }
        else if(indexPath.section == 6)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "featuredProductsCell") as? cedMageBestSellingTableCell
            cell?.parent = self
            cell?.productsData = featuredBanners
            //cell?.titleLabel.text="FEATURED PRODUCTS".localized
            cell?.title = "FEATURED PRODUCTS".localized
            cell?.reloadData();
            /*if(featuredBanners.count>0)
             {
             let indexPath = IndexPath(row: 0, section: 0)
             
             cell?.productCollection.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: true)
             }*/
            return cell!
        }else if(indexPath.section == 7)
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "popularProductCell") as? cedMageNewArrivalsCell
            cell?.parent = self
            cell?.title = "FEATURED PRODUCTS".localized
            cell?.productsData = featuredProducts;
            cell?.reloadData()
            return cell!
        }
        else if(indexPath.section == 8)
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cedMageTitleCell") as? cedMageTitleCell{
                cell.titleLabel.text="NEW ARRIVALS".localized
                cell.viewAllBtn.tag = indexPath.section
                cell.viewAllBtn.addTarget(self, action: #selector(viewAllFeaturedandArrivalBtn), for: .touchUpInside)
                cell.contentView.backgroundColor = UIColor(hexString: "#28CA9A")
                cell.titleLabel.font = mageWooCommon.setCustomFont(type: .bold, size: 15)
                cell.titleLabel.textColor = wooSetting.textColor
                return cell;
            }
        }
        else if(indexPath.section == 9)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "featuredProductsCell") as? cedMageBestSellingTableCell
            cell?.parent = self
            cell?.productsData = newArrivalBanners
            cell?.title = "NEW ARRIVALS".localized
            cell?.reloadData();
            if(newArrivalBanners.count>0)
            {
                let indexPath = IndexPath(row: 0, section: 0)
                
                cell?.productCollection.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: true)
            }
            return cell!
        }
        else
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Arrivalcell") as? cedMageNewArrivalsCell
            cell?.arrivalBtn1.addTarget(self, action: #selector(arrivalfirstProductAction), for: .touchUpInside)
            cell?.arrivalBtn2.addTarget(self, action: #selector(arrivalsecondProductAction), for: .touchUpInside)
            cell?.arrivalBtn3.addTarget(self, action: #selector(arrivalthirdProductAction), for: .touchUpInside)
            
            /*
             arrivalProductOutOfStockLabel1: UILabel!
             @IBOutlet weak var arrivalProduct1RegularPrice
             */
            if newArrivalProducts.count>0
            {
            let product  = newArrivalProducts[0]
            cell?.arrivalProduct1Name.text = product["productName"]
            cell?.arrivalProduct1Price.text = product["productPrice"]
                cell?.arrivalProduct1Name.textColor = wooSetting.subTextColor
                cell?.arrivalProduct1Price.textColor = UIColor.red
            arrivalProductId1 = product["productId"] ?? ""
            cell?.arrivalProduct1Price.font = mageWooCommon.setCustomFont(type: .regular, size: 15)
            cell?.arrivalProduct1Name.font = mageWooCommon.setCustomFont(type: .regular, size: 15)
            if let imageUrl = product["productImage"] {
            if(imageUrl != "")
            {


                cell?.arrivalProduct1Img.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(contentsOfFile: wooSetting.productPlaceholder))

            }
            else
            {
                cell?.arrivalProduct1Img.image = UIImage(contentsOfFile: wooSetting.productPlaceholder)
            }
            }
                
                cell?.arrivalProductOutOfStockLabel1.text = "OUT OF STOCK!"
                cell?.arrivalProductOutOfStockLabel1.font = mageWooCommon.setCustomFont(type: .medium, size: 12.0)
                
                if let stockStatus = product["stockLabel"]
                {
                    if stockStatus == "false"
                    {
                        cell?.arrivalProductOutOfStockLabel1.isHidden = false
                        cell?.arrivalProductOutOfStockLabel1.backgroundColor = wooSetting.themeColor
                        cell?.arrivalProductOutOfStockLabel1.backgroundColor?.withAlphaComponent(0.6)
                        cell?.arrivalProductOutOfStockLabel1.alpha = 0.7
                        cell?.arrivalProductOutOfStockLabel1.textColor = UIColor.white
                    }
                    else
                    {
                        cell?.arrivalProductOutOfStockLabel1.isHidden = true
                        cell?.arrivalProductOutOfStockLabel1.backgroundColor = UIColor.clear
                       
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
                cell?.arrivalProduct1RegularPrice.isHidden = false
                 if let productPrice = product["productPrice"]
                 {
                     cell?.arrivalProduct1Price.text = productPrice;
                 }
                 if(product["salePrice"] != "" && product["salePrice"] != nil)
                 {
                     //cell.saleTagLabel.isHidden = false;
                     if let regularPrice = product["regularPrice"]
                     {
                         let offerPrice=NSMutableAttributedString(string: regularPrice);
                         offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                         cell?.arrivalProduct1RegularPrice.attributedText=offerPrice
                         //cell?.regularPrice.text = regularPrice;
                     }
                 }
                 else
                 {
                    // cell.saleTagLabel.isHidden = true;
                     let offerPrice=NSMutableAttributedString(string: "");
                     offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                     cell?.arrivalProduct1RegularPrice.attributedText=offerPrice
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
                         cell?.arrivalProduct1Price.text = product["currencySymbol"]!+min_price!+" - "+product["currencySymbol"]!+max_price!
                     }
                     else if(product["sale"] == "true" && min_reg_price == max_reg_price)
                     {
                        // cell?.saleTagLabel.isHidden = false;
                         cell?.arrivalProduct1Price.text = product["currencySymbol"]!+min_price!+" - "+product["currencySymbol"]!+max_reg_price!
                     }
                     else
                     {
                         cell?.arrivalProduct1Price.text = product["currencySymbol"]!+min_price!
                     }
                     let offerPrice=NSMutableAttributedString(string: "");
                     offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                     cell?.arrivalProduct1RegularPrice.attributedText=offerPrice
                    cell?.arrivalProduct1RegularPrice.isHidden = true
                 }

                
                
                
                
                
                //2nd product
                
                let product1  = newArrivalProducts[1]
                cell?.arrivalProduct2Name.text = product1["productName"]
                cell?.arrivalProduct2Price.text = product1["productPrice"]
                arrivalProductId2 = product1["productId"] ?? ""
                cell?.arrivalProduct2Name.textColor = wooSetting.subTextColor
                cell?.arrivalProduct2Price.textColor = UIColor.red;
                cell?.arrivalProduct2Price.font = mageWooCommon.setCustomFont(type: .regular, size: 15)
                cell?.arrivalProduct2Name.font = mageWooCommon.setCustomFont(type: .regular, size: 15)
                if let imageUrl = product1["productImage"] {
                if(imageUrl != "")
                {


                    cell?.arrivalProduct2Img.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(contentsOfFile: wooSetting.productPlaceholder))

                }
                else
                {
                    cell?.arrivalProduct2Img.image = UIImage(contentsOfFile: wooSetting.productPlaceholder)
                }
                }
                
                cell?.arrivalProductOutOfStockLabel2.text = "OUT OF STOCK!"
                cell?.arrivalProductOutOfStockLabel2.font = mageWooCommon.setCustomFont(type: .medium, size: 12.0)
                
                if let stockStatus = product["stockLabel"]
                {
                    if stockStatus == "false"
                    {
                        cell?.arrivalProductOutOfStockLabel2.isHidden = false
                        cell?.arrivalProductOutOfStockLabel2.backgroundColor = wooSetting.themeColor
                        cell?.arrivalProductOutOfStockLabel2.backgroundColor?.withAlphaComponent(0.6)
                        cell?.arrivalProductOutOfStockLabel2.alpha = 0.7
                        cell?.arrivalProductOutOfStockLabel2.textColor = UIColor.white
                    }
                    else
                    {
                        cell?.arrivalProductOutOfStockLabel2.isHidden = true
                        cell?.arrivalProductOutOfStockLabel2.backgroundColor = UIColor.clear
                       
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
                cell?.arrivalProduct2RegularPrice.isHidden = false
                 if let productPrice = product1["productPrice"]
                 {
                     cell?.arrivalProduct2Price.text = productPrice;
                 }
                 if(product1["salePrice"] != "" && product1["salePrice"] != nil)
                 {
                     //cell.saleTagLabel.isHidden = false;
                     if let regularPrice = product1["regularPrice"]
                     {
                         let offerPrice=NSMutableAttributedString(string: regularPrice);
                         offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                         cell?.arrivalProduct2RegularPrice.attributedText=offerPrice
                         //cell?.regularPrice.text = regularPrice;
                     }
                 }
                 else
                 {
                    // cell.saleTagLabel.isHidden = true;
                     let offerPrice=NSMutableAttributedString(string: "");
                     offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                     cell?.arrivalProduct2RegularPrice.attributedText=offerPrice
                 }
                 if(product1["sale"] != "" && product1["sale"] != nil)
                 {
                     let min_price = product["product_price_min"];
                     let max_price = product["product_price_max"];
                     let min_reg_price = product["product_price_min_reg"];
                     let max_reg_price = product["product_price_max_reg"];
                     if(min_price != max_price)
                     {
                        // cell.saleTagLabel.isHidden = false;
                        cell?.arrivalProduct2Price.text = product1["currencySymbol"]!+min_price!+" - "+product1["currencySymbol"]!+max_price!
                     }
                     else if(product1["sale"] == "true" && min_reg_price == max_reg_price)
                     {
                        // cell?.saleTagLabel.isHidden = false;
                         cell?.arrivalProduct2Price.text = product1["currencySymbol"]!+min_price!+" - "+product1["currencySymbol"]!+max_reg_price!
                     }
                     else
                     {
                         cell?.arrivalProduct2Price.text = product1["currencySymbol"]!+min_price!
                     }
                     let offerPrice=NSMutableAttributedString(string: "");
                     offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                     cell?.arrivalProduct2RegularPrice.attributedText=offerPrice
                    cell?.arrivalProduct2RegularPrice.isHidden = true
                 }
                
                
                
                
                
                
                
                //3rd product
                let product2  = newArrivalProducts[2]
                cell?.arrivalProduct3Name.text = product2["productName"]
                cell?.arrivalProduct3Price.text = product2["productPrice"]
                cell?.arrivalProduct3Name.textColor = wooSetting.subTextColor
                cell?.arrivalProduct3Price.textColor = UIColor.red
                arrivalProductId3 = product2["productId"] ?? ""
                cell?.arrivalProduct3Price.font = mageWooCommon.setCustomFont(type: .regular, size: 15)
                cell?.arrivalProduct3Name.font = mageWooCommon.setCustomFont(type: .regular, size: 15)
                if let imageUrl = product2["productImage"] {
                if(imageUrl != "")
                {


                    cell?.arrivalProduct3Img.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(contentsOfFile: wooSetting.productPlaceholder))

                }
                else
                {
                    cell?.arrivalProduct3Img.image = UIImage(contentsOfFile: wooSetting.productPlaceholder)
                }
                }
                
                
                cell?.arrivalProductOutOfStockLabel3.text = "OUT OF STOCK!"
                cell?.arrivalProductOutOfStockLabel3.font = mageWooCommon.setCustomFont(type: .medium, size: 12.0)
                
                if let stockStatus = product["stockLabel"]
                {
                    if stockStatus == "false"
                    {
                        cell?.arrivalProductOutOfStockLabel3.isHidden = false
                        cell?.arrivalProductOutOfStockLabel3.backgroundColor = wooSetting.themeColor
                        cell?.arrivalProductOutOfStockLabel3.backgroundColor?.withAlphaComponent(0.6)
                        cell?.arrivalProductOutOfStockLabel3.alpha = 0.7
                        cell?.arrivalProductOutOfStockLabel3.textColor = UIColor.white
                    }
                    else
                    {
                        cell?.arrivalProductOutOfStockLabel3.isHidden = true
                        cell?.arrivalProductOutOfStockLabel3.backgroundColor = UIColor.clear
                       
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
                cell?.arrivalProduct3RegularPrice.isHidden = false
                 if let productPrice = product2["productPrice"]
                 {
                     cell?.arrivalProduct3Price.text = productPrice;
                 }
                 if(product2["salePrice"] != "" && product2["salePrice"] != nil)
                 {
                     //cell.saleTagLabel.isHidden = false;
                     if let regularPrice = product2["regularPrice"]
                     {
                         let offerPrice=NSMutableAttributedString(string: regularPrice);
                         offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                         cell?.arrivalProduct3RegularPrice.attributedText=offerPrice
                         //cell?.regularPrice.text = regularPrice;
                     }
                 }
                 else
                 {
                    // cell.saleTagLabel.isHidden = true;
                     let offerPrice=NSMutableAttributedString(string: "");
                     offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                     cell?.arrivalProduct3RegularPrice.attributedText=offerPrice
                 }
                 if(product2["sale"] != "" && product2["sale"] != nil)
                 {
                     let min_price = product["product_price_min"];
                     let max_price = product["product_price_max"];
                     let min_reg_price = product["product_price_min_reg"];
                     let max_reg_price = product["product_price_max_reg"];
                     if(min_price != max_price)
                     {
                        // cell.saleTagLabel.isHidden = false;
                         cell?.arrivalProduct3Price.text = product2["currencySymbol"]!+min_price!+" - "+product2["currencySymbol"]!+max_price!
                     }
                     else if(product2["sale"] == "true" && min_reg_price == max_reg_price)
                     {
                        // cell?.saleTagLabel.isHidden = false;
                         cell?.arrivalProduct3Price.text = product2["currencySymbol"]!+min_price!+" - "+product2["currencySymbol"]!+max_reg_price!
                     }
                     else
                     {
                         cell?.arrivalProduct3Price.text = product2["currencySymbol"]!+min_price!
                     }
                     let offerPrice=NSMutableAttributedString(string: "");
                     offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                     cell?.arrivalProduct3RegularPrice.attributedText=offerPrice
                    cell?.arrivalProduct3RegularPrice.isHidden = true
                 }
                
                
            }
           // cell?.title = "NEW ARRIVALS".localized
            //cell?.parent = self
            //cell?.productsData = newArrivalProducts;
            //cell?.reloadData()
            
            return cell!
        }
        return UITableViewCell()
    }
    
    
    @objc func arrivalfirstProductAction(_sender : UIButton)
    {
            let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
            viewControl.productId = arrivalProductId1
            self.navigationController?.pushViewController(viewControl, animated: true)
       
    }
    @objc func arrivalsecondProductAction(_sender : UIButton)
    {
      
            let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
            viewControl.productId = arrivalProductId2
            self.navigationController?.pushViewController(viewControl, animated: true)
      
    }
    @objc func arrivalthirdProductAction(_sender : UIButton)
    {
      
            let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
            viewControl.productId = arrivalProductId3
            self.navigationController?.pushViewController(viewControl, animated: true)
       
    }
    @objc func viewAllItemsOnSale(_sender : UIButton)
    {
        let viewControl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageVIewAllProduct") as! cedMageVIewAllProduct
        viewControl.allProducts = viewAllbestSellingProducts
        self.navigationController?.pushViewController(viewControl, animated: true)
    }
    @objc func viewAllFeaturedandArrivalBtn(_sender : UIButton)
    {
        let viewControl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageVIewAllProduct") as! cedMageVIewAllProduct
        if _sender.tag == 4
        {
            viewControl.allProducts = viewAllfeaturedProducts
        }
        else
        {
          viewControl.allProducts = newArrivalProducts
        }
        
        self.navigationController?.pushViewController(viewControl, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var params = Dictionary<String,String>();
        params["search"] = searchBar.text;
        cedMageLoaders.addDefaultLoader(me: self)
        var products = [[String:String]]();
        print("test")
        print(params)
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/getsearchedproducts",method: "POST", params: params, controller: self, completionHandler: {
            data,url,error in
            
            DispatchQueue.main.async
                {
                    cedMageLoaders.removeLoadingIndicator(me: self)
                    
                    if let json = try? JSON(data: data!){
                        print(json)
                        let prod = json["products"];
                        for index in 0..<prod.count
                        {
                            var productsData = [String:String]();
                            productsData["productName"]=prod[index]["product_name"].stringValue;
                            productsData["productImage"]=prod[index]["product_image"].stringValue;
                            productsData["productId"]=prod[index]["product_id"].stringValue;
                            productsData["currencySymbol"]=prod[index]["currency_symbol"].stringValue;
                            productsData["regularPrice"]=prod[index]["regular_price"].stringValue;
                            productsData["productPrice"]=prod[index]["product_price"].stringValue;
                            productsData["wishlist"]=prod[index]["wishlist"].stringValue;
                            productsData["averageRating"]=prod[index]["average_rating"].stringValue;
                            productsData["productGallery"]=prod[index]["product-gallery"].stringValue;
                            products.append(productsData)
                            
                        }
                        let vc=self.storyboard?.instantiateViewController(withIdentifier: "categoryProducts") as? CategoryProductsView
                        //vc?.productsData=products;
                        vc?.searchText = searchBar.text!
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }
                    
            }
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 2)
        {
            if(categoryProducts.count>0)
            {
                if(UIDevice().model.lowercased() == "ipad".lowercased()){
                    return 250;
                }
                return 400;
            }
        }
        else if(indexPath.section == 1)
        {
            if(moreClicked)
            {
                if(otherCategoryProducts.count>0)
                {
                    if(UIDevice().model.lowercased() == "ipad".lowercased()){
                        return CGFloat(ceil(Double(otherCategoryProducts.count)/4.0) * 250);
                    }
                    return CGFloat(ceil(Double(otherCategoryProducts.count)/4.0) * 120);
                }
                return 0
            }
            return 0;
            
        }
        else if(indexPath.section == 0)
        {
            if(bannerImageArray.count>0)
            {
                return self.view.frame.width * 3/7;
            }
        }
        else if(indexPath.section == 3)
        {
            if(bestSellingProducts.count>0)
            {
                return 450;
            }
            
        }
            else if(indexPath.section == 4)
            {
                if(recentlyViewArray.count>1)
                {
                    return 215;
                }
                
                
            }
        else if(indexPath.section == 5)
        {
            return 50
        }
        else if(indexPath.section == 6)
        {
            if(featuredBanners.count>0)
            {
                return self.view.frame.width * 3/7;
            }
        }
        else if(indexPath.section == 7)
        {
            if(featuredProducts.count>0)
            {
                return CGFloat(featuredProducts.count*110);
            }
        }
        else if(indexPath.section == 8)
        {
            return 50
        }
        else if(indexPath.section == 9)
        {
            if(newArrivalBanners.count>0)
            {
                return self.view.frame.width * 3/7;
            }
        }
        else if(indexPath.section == 10)
        {
            if(newArrivalProducts.count>0)
            {
                if(UIDevice.current.userInterfaceIdiom == .pad){
                    return 400
                }
                return 300;
            }
        }
        return 0;
        
    }
    
    @objc func getData()
    {
        bestSellingProducts = [[String:String]]() //Best selling
        featuredProducts = [[String:String]]()
        newArrivalProducts = [[String:String]]()
        homePageBanners    = [[String:String]]()
        categoryProducts = [[String:String]]()
        bannerImageArray  = [String]()
        otherCategoryProducts = [[String:String]]()
        newArrivalBanners = [[String:String]]()
        featuredBanners = [[String:String]]()
        self.updateBadge()
        cedMageLoaders.addDefaultLoader(me: self)
        
        var params=[String:String]()
        
        if let user = User().getLoginUser()
        {
            params.updateValue(user["userId"]!, forKey: "user-id")
        }
        
        print("cedMageHomme")
        print(params)
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/get_homepage_details",method: "POST", params: params, controller: self, completionHandler: {
            
            data,url,error in
            
            DispatchQueue.main.async
                {
                    cedMageLoaders.removeLoadingIndicator(me: self)
                    self.isResponse = true
                    self.recentlyViewArray = UserDefaults.standard.object(forKey: "recentlyViewData") as? [[String:String]] ?? [[:]]
                    if let data = data {
                        if let json = try? JSON(data:data){
                            print(json)
                            if json["status"].stringValue == "success" {
                                if json["data"]["best_selling_products"]["status"].stringValue == "enable" {
                                    var i = 0
                                    for product in json["data"]["best_selling_products"]["products"].arrayValue {
                                       
                                        var product_price_min = "";
                                        var product_price_max = "";
                                        var product_price_min_reg = "";
                                        var product_price_max_reg = "";
                                        //if(product["product_price_min"])
                                        var salePrice = "";
                                        var sale = ""
                                        var productPrice = ""
                                        if(product["sale"].exists())
                                        {
                                            sale = product["sale"].stringValue
                                            product_price_min = product["product_price_min"].stringValue;
                                            product_price_max = product["product_price_max"].stringValue;
                                            product_price_min_reg = product["product_price_min_reg"].stringValue;
                                            product_price_max_reg = product["product_price_max_reg"].stringValue;
                                        }
                                        else
                                        {
                                            productPrice = product["product_price"].stringValue
                                        }
                                        if(product["sale_price"].exists())
                                        {
                                            salePrice = product["sale_price"].stringValue;
                                        }
                                      /*  if ((product["product_image"].stringValue != "") && product["product_image"].stringValue != nil)
                                        {
                                            print("in image chk")
                                            print(product["product_image"].stringValue)
                                            if let imageUrl = product["product_image"].string
                                            {
                                                print("in image chk12344")
                                                let img = product["product_image"].stringValue
                                                let name = product["product_name"].stringValue
                                                let url = URL(string:img)
                                                if let data = try? Data(contentsOf: url!)
                                                {
                                                    print("url converted to image ")
                                                    let image: UIImage = UIImage(data: data)!
                                                    self.saveImageDocumentDirectory(image: image, imageName: name)
                                                    
                                                }
                                            }
                                            
                                        }*/
                                          if i<4
                                        {
                                            self.bestSellingProducts.append(["productId":product["product_id"].stringValue,"productName":product["product_name"].stringValue,"currencySymbol":product["currency_symbol"].stringValue,"productType":product["product_type"].stringValue,"regularPrice":product["regular_price"].stringValue,"productPrice":productPrice,"wishlist":product["wishlist"].stringValue,"productImage":product["product_image"].stringValue,"salePrice":salePrice,"sale":sale,"product_price_min":product_price_min,"product_price_max":product_price_max,"product_price_min_reg":product_price_min_reg,"product_price_max_reg":product_price_max_reg,"stockLabel" : product["is_in_stock"].stringValue])
                                        
                                        }
                                        self.viewAllbestSellingProducts.append(["productId":product["product_id"].stringValue,"productName":product["product_name"].stringValue,"currencySymbol":product["currency_symbol"].stringValue,"productType":product["product_type"].stringValue,"regularPrice":product["regular_price"].stringValue,"productPrice":productPrice,"wishlist":product["wishlist"].stringValue,"productImage":product["product_image"].stringValue,"salePrice":salePrice,"sale":sale,"product_price_min":product_price_min,"product_price_max":product_price_max,"product_price_min_reg":product_price_min_reg,"product_price_max_reg":product_price_max_reg,"stockLabel" : product["is_in_stock"].stringValue])
                                        
                                        i = i + 1
                                    }
                                }
                                if(json["data"]["all_categories"]["status"].stringValue == "success")
                                {
                                    //var i = 0;
                                    for category in json["data"]["all_categories"]["categories"].arrayValue{
//                                        if(i<3)
//                                        {
                                            self.categoryProducts.append(["category_id":category["category_id"].stringValue,"category_name":category["category_name"].stringValue,"category_image":category["category_image"].stringValue,"has_child":category["has_child"].stringValue])
                                       // }
//                                        else
//                                        {
//                                            self.otherCategoryProducts.append(["category_id":category["category_id"].stringValue,"category_name":category["category_name"].stringValue,"category_image":category["category_image"].stringValue,"has_child":category["has_child"].stringValue])
                                       // }
                                       // i += 1;
                                    }
                                }
                                if json["data"]["featured_products"]["status"].stringValue == "enable" {
                                    var i = 0
                                    for product in json["data"]["featured_products"]["products"].arrayValue {
                                        
                                        var product_price_min = "";
                                        var product_price_max = "";
                                        var product_price_min_reg = "";
                                        var product_price_max_reg = "";
                                        //if(product["product_price_min"])
                                        var salePrice = "";
                                        var sale = ""
                                        var productPrice = ""
                                        if(product["sale"].exists())
                                        {
                                            sale = product["sale"].stringValue
                                            product_price_min = product["product_price_min"].stringValue;
                                            product_price_max = product["product_price_max"].stringValue;
                                            product_price_min_reg = product["product_price_min_reg"].stringValue;
                                            product_price_max_reg = product["product_price_max_reg"].stringValue;
                                        }
                                        else{
                                            productPrice = product["product_price"].stringValue
                                        }
                                        if(product["sale_price"].exists())
                                        {
                                            salePrice = product["sale_price"].stringValue;
                                        }
                                       if i<4
                                            
                                        { self.featuredProducts.append(["productId":product["product_id"].stringValue,"productName":product["product_name"].stringValue,"currencySymbol":product["currency_symbol"].stringValue,"productType":product["product_type"].stringValue,"regularPrice":product["regular_price"].stringValue,"productPrice":productPrice,"wishlist":product["wishlist"].stringValue,"productImage":product["product_image"].stringValue,"salePrice":salePrice,"sale":sale,"product_price_min":product_price_min,"product_price_max":product_price_max,"product_price_min_reg":product_price_min_reg,"product_price_max_reg":product_price_max_reg,"stockLabel" : product["is_in_stock"].stringValue])
                                        }
                                        self.viewAllfeaturedProducts.append(["productId":product["product_id"].stringValue,"productName":product["product_name"].stringValue,"currencySymbol":product["currency_symbol"].stringValue,"productType":product["product_type"].stringValue,"regularPrice":product["regular_price"].stringValue,"productPrice":productPrice,"wishlist":product["wishlist"].stringValue,"productImage":product["product_image"].stringValue,"salePrice":salePrice,"sale":sale,"product_price_min":product_price_min,"product_price_max":product_price_max,"product_price_min_reg":product_price_min_reg,"product_price_max_reg":product_price_max_reg,"stockLabel" : product["is_in_stock"].stringValue])
                                        i = i+1
                                        
                                    }
                                }
                                
                                if json["data"]["new_arrival_products"]["status"].stringValue == "enable" {
                                    for product in json["data"]["new_arrival_products"]["products"].arrayValue {
                                        
                                        var product_price_min = "";
                                        var product_price_max = "";
                                        var product_price_min_reg = "";
                                        var product_price_max_reg = "";
                                        //if(product["product_price_min"])
                                        var salePrice = "";
                                        var sale = ""
                                        var productPrice = ""
                                        if(product["sale"].exists())
                                        {
                                            sale = product["sale"].stringValue
                                            product_price_min = product["product_price_min"].stringValue;
                                            product_price_max = product["product_price_max"].stringValue;
                                            product_price_min_reg = product["product_price_min_reg"].stringValue;
                                            product_price_max_reg = product["product_price_max_reg"].stringValue;
                                        }
                                        else
                                        {
                                            productPrice = product["product_price"].stringValue
                                        }
                                        if(product["sale_price"].exists())
                                        {
                                            salePrice = product["sale_price"].stringValue;
                                        }
                                        self.newArrivalProducts.append(["productId":product["product_id"].stringValue,"productName":product["product_name"].stringValue,"currencySymbol":product["currency_symbol"].stringValue,"productType":product["product_type"].stringValue,"regularPrice":product["regular_price"].stringValue,"productPrice":productPrice,"wishlist":product["wishlist"].stringValue,"productImage":product["product_image"].stringValue,"salePrice":salePrice,"sale":sale,"product_price_min":product_price_min,"product_price_max":product_price_max,"product_price_min_reg":product_price_min_reg,"product_price_max_reg":product_price_max_reg,"stockLabel" : product["is_in_stock"].stringValue])
                                        
                                        
                                    }
                                }
                                
                                if json["data"]["home_page_banners"]["status"].stringValue == "enabled" {
                                    for banner in json["data"]["home_page_banners"]["banner"].arrayValue {
                                        if(banner["status"] == "on")
                                        {
                                            if(banner["link_display"] == "home")
                                            {
                                                self.homePageBanners.append(["title":banner["title"].stringValue,"link_id":banner["link_idd"].stringValue,"banner_url":banner["banner_url"].stringValue,"link_to":banner["link_to"].stringValue])
                                            }
                                            else if(banner["link_display"] == "feature")
                                            {
                                                self.featuredBanners.append(["title":banner["title"].stringValue,"link_id":banner["link_idd"].stringValue,"banner_url":banner["banner_url"].stringValue,"link_to":banner["link_to"].stringValue])
                                            }
                                            else if(banner["link_display"] == "new")
                                            {
                                                self.newArrivalBanners.append(["title":banner["title"].stringValue,"link_id":banner["link_idd"].stringValue,"banner_url":banner["banner_url"].stringValue,"link_to":banner["link_to"].stringValue])
                                            }
                                        }
                                        
                                        
                                    }
                                    self.bannerImageArray = [String]()
                                    for image in self.homePageBanners{
                                        self.bannerImageArray.append(image["banner_url"]!)
                                    }
                                    
                                }
                                
                              
                                self.mainTable.reloadData()
                                
                            }
                        }
                        
                    }
            }
        })
    }
  
  
    /*
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.tabBarController?.tabBar.fadeOut(completion: {
            (finished: Bool) -> Void in
            self.tabBarController?.tabBar.isHidden = true;
            
        })
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.tabBarController?.tabBar.alpha=0
        
        self.tabBarController?.tabBar.fadeIn(completion: {
            (finished: Bool) -> Void in
            self.tabBarController?.tabBar.isHidden = false;
            
        })
    }*/
}

