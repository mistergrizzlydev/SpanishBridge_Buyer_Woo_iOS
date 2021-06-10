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

class mageWooHome: mageBaseViewController,UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate {
    
    
    @IBOutlet weak var chatButton: UIButton!
    
    
    @IBOutlet weak var mainTable: UITableView!
    var navigateCheck = false;
    var bestSellingProducts = [[String:String]]() //Best selling
    var featuredProducts = [[String:String]]()
    var newArrivalProducts = [[String:String]]()
    var homePageBanners    = [[String:String]]()
    var categoryProducts = [[String:String]]()
    var otherCategoryProducts = [[String:String]]()
    var bannerImageArray  = [String]()
    var moreClicked = false
    var featuredBanners = [[String:String]]()
    var newArrivalBanners = [[String:String]]();
    
    var categoryId = "";
    var productId = "";
    var webURL = "";
    var checkNotificationType=""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May    self.tracking(name: "home page")
        mainTable.delegate = self
        mainTable.dataSource = self
        chatButton.imageView?.contentMode = .scaleAspectFit
        chatButton.isHidden = true;
        chatButton.addTarget(self, action: #selector(chatClicked(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "loadHomePage"), object: nil);
        getData()
    }
    
    @objc func chatClicked(_ sender: UIButton){
        if let url = URL(string: "https://cedcommerce.com/magenativeapp.html?name=MageNativeWooCommerceApp") {
            UIApplication.shared.open(url)
        }
        /*
        
        if let url = URL(string: "https://cedcommerce.com/testtawkapp.html") {
            UIApplication.shared.open(url)
        }--*/
        
        //
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false;
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
        if checkNotificationType == "category"{
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
        }else if checkNotificationType == "website"{
            let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webController") as! mageHomeWebController
            vc.url=webURL
            vc.notificationCheck = true;
            self.navigationController?.pushViewController(vc, animated: true)
            checkNotificationType=""
            
        }
        self.updateBadge();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 4)
        {
            if(featuredBanners.count>0 || featuredProducts.count>0)
            {
                return 1
            }
            return 0
        }
        if(section == 7)
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
        if(indexPath.section == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as? cedMageHomeCategoryCell
            cell?.parent = self;
            cell?.productsData = categoryProducts;
            print("-----othehre")
            print(otherCategoryProducts)
            print(otherCategoryProducts.count);
            if(otherCategoryProducts.count == 0)
            {
                cell?.showMore = false
            }
            else
            {
                cell?.showMore = true;
            }
            cell?.reloadData();
            return cell!;
        }else if(indexPath.section == 1)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryOtherCell") as? cedMageCategoryOtherCell
            cell?.parent = self;
            cell?.productsData = otherCategoryProducts;
            cell?.reloadData();
            return cell!;
        }else if(indexPath.section == 2)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bannerCell") as? mageWooBannerCell
            cell?.dataSource = bannerImageArray
            cell?.bannerData=homePageBanners;
            cell?.imagePager.imageCounterDisabled = true
            cell?.imagePager.slideshowTimeInterval = 2
            cell?.parent=self;
            
            return cell!
        }else if(indexPath.section == 3)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topSellersCell") as? mageHomeProdutlist
            cell?.parent = self
            cell?.productsData = bestSellingProducts
            cell?.titleLabel.text="BEST SELLING".localized
            cell?.titleLabel.font = mageWooCommon.setCustomFont(type: .bold, size: 18)
            cell?.title = "BEST SELLING".localized;
            
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cedMageTitleCell") as? cedMageTitleCell{
                cell.titleLabel.text="FEATURED PRODUCTS".localized
                cell.titleLabel.font = mageWooCommon.setCustomFont(type: .bold, size: 18)
                return cell;
            }
        }
        else if(indexPath.section == 5)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "featuredProductsCell") as? mageHomeProdutlist
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
        }else if(indexPath.section == 6){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "popularProductCell") as? cedMagePopularProductCell
            cell?.parent = self
            cell?.title = "FEATURED PRODUCTS".localized
            cell?.productsData = featuredProducts;
            cell?.reloadData()
            return cell!
        }
        else if(indexPath.section == 7)
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cedMageTitleCell") as? cedMageTitleCell{
                cell.titleLabel.text="NEW ARRIVALS".localized
                cell.titleLabel.font = mageWooCommon.setCustomFont(type: .bold, size: 18)
                return cell;
            }
        }
        else if(indexPath.section == 8)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "featuredProductsCell") as? mageHomeProdutlist
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
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "popularProductCell") as? cedMagePopularProductCell
            cell?.title = "NEW ARRIVALS".localized
            cell?.parent = self
            cell?.productsData = newArrivalProducts;
            cell?.reloadData()
            
            return cell!
        }
        return UITableViewCell()
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
        if(indexPath.section == 0)
        {
            if(categoryProducts.count>0)
            {
                if(UIDevice().model.lowercased() == "ipad".lowercased()){
                   // return 250;
                    return 175;
                }
                return 140;
            }
        }
        else if(indexPath.section == 1)
        {
            if(moreClicked)
            {
                if(otherCategoryProducts.count>0)
                {
                    if(UIDevice().model.lowercased() == "ipad".lowercased()){
                       // return CGFloat(ceil(Double(otherCategoryProducts.count)/4.0) * 250);
                        return CGFloat(ceil(Double(otherCategoryProducts.count)/4.0) * 120);
                    }
                    return CGFloat(ceil(Double(otherCategoryProducts.count)/4.0) * 120);
                }
                return 0
            }
            return 0;
            
        }
        else if(indexPath.section == 2)
        {
            if(bannerImageArray.count>0)
            {
              //  return 215;
                return ((self.view.frame.width) * 3/7);
            }
        }
        else if(indexPath.section == 3)
        {
            if(bestSellingProducts.count>0)
            {
             //   return 255;
           //     return 305;
                return 315;
            }
            
        }
        else if(indexPath.section == 4)
        {
            return 50
        }
        else if(indexPath.section == 5)
        {
            if(featuredBanners.count>0)
            {
               // return 215;
                return ((self.view.frame.width) * 3/7);
            }
        }
        else if(indexPath.section == 6)
        {
            if(featuredProducts.count>0)
            {
               // return 215;
             //   return 265;
                return 275;
            }
        }
        else if(indexPath.section == 7)
        {
            return 50
        }
        else if(indexPath.section == 8)
        {
            if(newArrivalBanners.count>0)
            {
                //return 215;
                return ((self.view.frame.width) * 3/7);
            }
        }
        else if(indexPath.section == 9)
        {
            if(newArrivalProducts.count>0)
            {
              //  return 215;
            //    return 265;
                return 275;
            }
        }
        return 0;
        
    }
    
    @objc func getData(){
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
        
        if let user = User().getLoginUser() {
            params.updateValue(user["userId"]!, forKey: "user-id")
        }
        
        print("cedMageHomme")
        print(params)
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/get_homepage_details",method: "POST", params: params, controller: self, completionHandler: {
            
            data,url,error in
            
            DispatchQueue.main.async
                {
                    cedMageLoaders.removeLoadingIndicator(me: self)
                    if let data = data {
                        if let json = try? JSON(data:data){
                            print(json)
                            if json["status"].stringValue == "success" {
                                if json["data"]["best_selling_products"]["status"].stringValue == "enable" {
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
                                        self.bestSellingProducts.append(["productId":product["product_id"].stringValue,"productName":product["product_name"].stringValue,"currencySymbol":product["currency_symbol"].stringValue,"productType":product["product_type"].stringValue,"regularPrice":product["regular_price"].stringValue,"productPrice":productPrice,"wishlist":product["wishlist"].stringValue,"productImage":product["product_image"].stringValue,"salePrice":salePrice,"sale":sale,"product_price_min":product_price_min,"product_price_max":product_price_max,"product_price_min_reg":product_price_min_reg,"product_price_max_reg":product_price_max_reg, "stockLabel": product["is_in_stock"].stringValue])
                                        
                                        
                                    }
                                }
                                if(json["data"]["all_categories"]["status"].stringValue == "success")
                                {
                                    var i = 0;
                                    for category in json["data"]["all_categories"]["categories"].arrayValue{
                                        if(i<3)
                                        {
                                            self.categoryProducts.append(["category_id":category["category_id"].stringValue,"category_name":category["category_name"].stringValue,"category_image":category["category_image"].stringValue,"has_child":category["has_child"].stringValue])
                                        }
                                        else
                                        {
                                            self.otherCategoryProducts.append(["category_id":category["category_id"].stringValue,"category_name":category["category_name"].stringValue,"category_image":category["category_image"].stringValue,"has_child":category["has_child"].stringValue])
                                        }
                                        i += 1;
                                    }
                                }
                                if json["data"]["featured_products"]["status"].stringValue == "enable" {
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
                                        self.featuredProducts.append(["productId":product["product_id"].stringValue,"productName":product["product_name"].stringValue,"currencySymbol":product["currency_symbol"].stringValue,"productType":product["product_type"].stringValue,"regularPrice":product["regular_price"].stringValue,"productPrice":productPrice,"wishlist":product["wishlist"].stringValue,"productImage":product["product_image"].stringValue,"salePrice":salePrice,"sale":sale,"product_price_min":product_price_min,"product_price_max":product_price_max,"product_price_min_reg":product_price_min_reg,"product_price_max_reg":product_price_max_reg,"stockLabel": product["is_in_stock"].stringValue])
                                        
                                        
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
                                        self.newArrivalProducts.append(["productId":product["product_id"].stringValue,"productName":product["product_name"].stringValue,"currencySymbol":product["currency_symbol"].stringValue,"productType":product["product_type"].stringValue,"regularPrice":product["regular_price"].stringValue,"productPrice":productPrice,"wishlist":product["wishlist"].stringValue,"productImage":product["product_image"].stringValue,"salePrice":salePrice,"sale":sale,"product_price_min":product_price_min,"product_price_max":product_price_max,"product_price_min_reg":product_price_min_reg,"product_price_max_reg":product_price_max_reg,"stockLabel": product["is_in_stock"].stringValue])
                                        
                                        
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

