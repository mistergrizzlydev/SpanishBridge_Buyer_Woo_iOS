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
import SDWebImage
class CategoryProductsView: mageBaseViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var emptyImageView: UIImageView!
    var productsData=[[String:String]]()
    
    
    var sortViewHeight = 90;
    var sortStackViewHeight = 30;
    
    var filterData = [String: [String:String]]();
    
    var sortData = [String]();
    var loading = true;
    var page = 1;
    var sortByArray = [String:String]();
    
    var sortButtons = [UIButton]()
    
    @IBOutlet weak var sortFilterStackView: UIStackView!
    
    var floatingButton: UIButton!
    
    var notificationCheck = false;
    
    var sortBy = "";
    var categoryId="";
    var searchText = "";
    var currentView = "list"
    var currencySymbol = "";
    var sortFilterButtonView: sortByAndFilterButtonView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May    self.tracking(name: "category products");
        //floatingButton.isHidden=true;
        sortFilterButtonView = sortByAndFilterButtonView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-20, height: 40));
        sortFilterButtonView.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin]
        sortFilterStackView.addArrangedSubview(sortFilterButtonView);
        sortFilterButtonView.sortButton.addTarget(self, action: #selector(sortbyButtonPressed(_:)), for: .touchUpInside)
        sortFilterButtonView.filterButton.addTarget(self, action: #selector(filterClicked(_:)), for: .touchUpInside)
        sortFilterButtonView.sortButton.tag = 1000000;
        sortFilterButtonView.filterButton.tag = 1000001;
        collectionView.delegate=self
        collectionView.dataSource=self
        NotificationCenter.default.addObserver(self, selector: #selector(loadFilteredData(_:)), name: NSNotification.Name(rawValue: "loadFilteredProducts"), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(loadData(_:)), name: NSNotification.Name(rawValue: "loadProducts"), object: nil);
        if(productsData.count==0)
        {
            self.sortFilterButtonView.sortButton.isEnabled = false;
            NotificationCenter.default.post(name:  NSNotification.Name("loadProducts"), object: nil);
        }
        else
        {
            self.sortFilterButtonView.sortButton.isEnabled = true;
            collectionView.reloadData();
        }
        sortFilterButtonView.changeViewButton.addTarget(self, action: #selector(switchViews(_:)), for: .touchUpInside)
        sortFilterButtonView.switchImage.tag=258
        UIView.animate(withDuration: 4, delay: 1, options: [UIView.AnimationOptions.transitionFlipFromRight,  UIView.AnimationOptions.showHideTransitionViews], animations: {
            if(self.currentView == "grid"){
                self.sortFilterButtonView.switchImage.rotate360Degrees()
                self.sortFilterButtonView.switchImage.image = UIImage(named: "grid")
            }else{
                self.sortFilterButtonView.switchImage.rotate360Degrees()
                self.sortFilterButtonView.switchImage.image = UIImage(named: "list")
            }
        }, completion: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
        self.updateBadge();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    func sendRequestForData(urlToRequest: String, params: Dictionary<String,String>)
    {
        print(params)
        print(urlToRequest)
        if(page == 1)
        {
            self.productsData = [[String:String]]();
        }
        
        cedMageLoaders.addDefaultLoader(me: self);
        mageRequets.sendHttpRequest(endPoint: urlToRequest,method: "POST", params: params, controller: self, completionHandler: {
            data,url,error in
            DispatchQueue.main.async
                {
                    cedMageLoaders.removeLoadingIndicator(me: self)
                    
                    if let json = try? JSON(data: data!){
                        print(json);
                        self.parseData(json: json)
                    }
                    
            }
        })
    }
    
    func parseData(json: JSON)
    {
        let status=json["status"].stringValue
        print(json)
        if status=="true"{
            var productsData=[[String:String]]()
            currencySymbol = json["currency_symbol"].stringValue
            print(json["order-by"])
            for(key,value) in json["order-by"]
            {
                print(value)
                sortByArray[key] = value.stringValue;
            }
            
            for(key,value) in json["filters"]
            {
                var filt = [String:String]();
                for(key1,value1) in value
                {
                    filt[key1]=value1.stringValue;
                }
                filterData[key]=filt;
                
            }
            if(json["products"].exists())
            {
                
                if let products=json["products"].array{
                    
                    for node in products{
                        var salePrice = ""
                        var sale = ""
                        var productPrice = ""
                        var product_price_min = "";
                        var product_price_max = "";
                        var product_price_min_reg = "";
                        var product_price_max_reg = "";
                        if(node["sale"].exists())
                        {
                            sale = node["sale"].stringValue
                            product_price_min = node["product_price_min"].stringValue;
                            product_price_max = node["product_price_max"].stringValue;
                            product_price_min_reg = node["product_price_min_reg"].stringValue;
                            product_price_max_reg = node["product_price_max_reg"].stringValue;
                        }
                        else
                        {
                            productPrice = node["product_price"].stringValue
                        }
                        if(node["sale_price"].exists())
                        {
                            salePrice = node["sale_price"].stringValue;
                        }
                        productsData.append(["productId":node["product_id"].stringValue,"productName":node["product_name"].stringValue,"currencySymbol":node["currency_symbol"].stringValue,"productType":node["product_type"].stringValue,"regularPrice":node["regular_price"].stringValue,"productPrice":productPrice,"wishlist":node["wishlist"].stringValue,"productImage":node["product_image"].stringValue,"salePrice": salePrice,"sale":sale,"product_price_min":product_price_min,"product_price_max":product_price_max,"product_price_min_reg":product_price_min_reg,"product_price_max_reg":product_price_max_reg,"stockLabel":node["is_in_stock"].stringValue])
                        
                    }
                }
            }
            for index in productsData
            {
                self.productsData.append(index);
            }
            self.collectionView.isHidden = false;
            self.emptyImageView.isHidden = true;
            if(self.productsData.count == 0)
            {
                self.loading = false;
                if(page==1)
                {
                    self.sortFilterButtonView.sortButton.isEnabled = false;
                    self.collectionView.isHidden = true;
                    self.emptyImageView.isHidden = false;
                }
            }
            else
            {
                self.sortFilterButtonView.sortButton.isEnabled = true;
            }
        }
        else
        {
            self.loading = false;
            if(page==1)
            {
                
                self.sortFilterButtonView.sortButton.isEnabled = false;
                self.collectionView.isHidden = true;
                self.emptyImageView.isHidden = false;
                
                self.productsData=[[String:String]]()
            }
            
            
        }
        self.collectionView.reloadData()
    }
    
    @objc func wishButtonPressed(_ sender: UIButton){
        let tag=sender.tag
        let data=productsData[tag]
        let productId=data["productId"]!
        if User().getLoginUser() != nil {
            //let id=user["userId"]!
            
            User().wooAddToWishList(productId: productId, control: self, completion: {
                data in
                if let data = data {
                    if let json = try? JSON(data:data){
                        print(json)
                        if let jsonData=json["message"].string{
                            if jsonData=="Product removed from wishlist"{
                                sender.setImage(UIImage(named: "wishempty"), for: .normal)
                                self.productsData[tag]["wishlist"] = "no";
                                self.view.makeToast("Product removed from wishlist.".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                            }
                            else if jsonData=="Product added to wishlist"
                            {
                                sender.setImage(UIImage(named: "wishfilled"), for: .normal)
                                self.productsData[tag]["wishlist"] = "yes";
                                self.view.makeToast("Product added to wishlist.".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                            }
                            //NotificationCenter.default.post(name:  NSNotification.Name("loadProducts"), object: nil);
                        }
                    }
                }
            })
            
        }
        else{
            parent?.view.makeToast("Please Login First...!".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
        }
        
    }
    @objc func loadFilteredData(_ notification: NSNotification){
        page = 1;
        NotificationCenter.default.post(name:  NSNotification.Name("loadProducts"), object: nil);
    }
    @objc func loadData(_ notification: NSNotification){
        var params = Dictionary<String, String>();
        var url = String()
        if(sortBy != "")
        {
            params["order-by"]=sortBy;
        }
        params["current_page"] = "\(page)"
        if(UserDefaults.standard.value(forKey: "filters") != nil)
        {
            let filter = UserDefaults.standard.value(forKey: "filters") as? [String:String]
            for(key,value) in filter!
            {
                params[key]=value;
            }
        }
        
        if(categoryId != "")
        {
            params["category-id"]=categoryId;
            
            
            if let user = User().getLoginUser() {
                params.updateValue(user["userId"]!, forKey: "user-id")
            }
            url = "mobiconnect/get_all_cat_products";
        }
        else if(searchText != "")
        {
            params["search"] = searchText;
            url = "mobiconnect/getsearchedproducts";
        }
        sendRequestForData(urlToRequest: url, params: params)
    }
    
    /*func sortClicked(_ sender: UIButton)
     {
     let alphaView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
     self.view.addSubview(alphaView);
     alphaView.tag = 10;
     alphaView.backgroundColor=UIColor.darkGray
     alphaView.alpha=CGFloat(0.9);
     alphaView.addSubview(sortView);
     sortView.cardView();
     //sortView.backgroundColor=UIColor.white
     sortView.layer.cornerRadius=15.0;
     sortView.layer.masksToBounds=true;
     sortView.center=alphaView.center;
     for i in 0..<sortData.count
     {
     let sortButton = radioButtonView();
     sortView.sortByStackView.addArrangedSubview(sortButton)
     sortStackViewHeight += 30;
     sortViewHeight += 30;
     sortButton.radioButton.addTarget(self, action: #selector(sortByOptionChanged(_:)), for: .touchUpInside);
     sortButton.radioButton.setTitle(sortData[i], for: .normal)
     sortButtons.append(sortButton.radioButton);
     if(sortBy == sortData[i])
     {
     sortButton.radioButton.setImage(UIImage(named: "checked"), for: .normal);
     }
     }
     sortView.translatesAutoresizingMaskIntoConstraints=false;
     sortView.sortByStackHeight.constant = CGFloat(sortStackViewHeight);
     var testRect: CGRect = self.sortView.frame
     testRect.size.height = CGFloat(sortViewHeight);
     self.sortView.frame = testRect;
     sortView.center.x = alphaView.center.x;
     sortView.center.y = alphaView.center.y
     /*sortView.priceLowToHigh.addTarget(self, action: #selector(sortByOptionChanged(_:)), for: .touchUpInside)
     sortView.priceHighToLow.addTarget(self, action: #selector(sortByOptionChanged(_:)), for: .touchUpInside)
     sortView.orderByDate.addTarget(self, action: #selector(sortByOptionChanged(_:)), for: .touchUpInside)
     if(sortBy == "pricehigh")
     {
     sortView.priceHighToLow.setImage(UIImage(named: "checked"), for: .normal);
     }
     else if(sortBy == "pricelow")
     {
     sortView.priceLowToHigh.setImage(UIImage(named: "checked"), for: .normal);
     }
     else if(sortBy == "date")
     {
     sortView.orderByDate.setImage(UIImage(named: "checked"), for: .normal);
     }*/
     }
     
     func sortByOptionChanged(_ sender: UIButton)
     {
     let title = sender.currentTitle;
     for button in sortButtons
     {
     if(title == button.currentTitle)
     {
     sortBy = title!;
     sender.setImage(UIImage(named: "checked"), for: .normal);
     }
     else
     {
     button.setImage(UIImage(named: "unchecked"), for: .normal);
     }
     }
     /*if(title == "Price High To Low")
     {
     sortView.priceLowToHigh.setImage(UIImage(named: "unchecked"), for: .normal);
     sortView.priceHighToLow.setImage(UIImage(named: "checked"), for: .normal);
     sortView.orderByDate.setImage(UIImage(named: "unchecked"), for: .normal);
     sortBy = "pricehigh";
     }
     else if(title == "Price Low To High")
     {
     sortView.priceLowToHigh.setImage(UIImage(named: "checked"), for: .normal);
     sortView.priceHighToLow.setImage(UIImage(named: "unchecked"), for: .normal);
     sortView.orderByDate.setImage(UIImage(named: "unchecked"), for: .normal);
     sortBy = "pricelow"
     }
     else if(title == "Order By Date")
     {
     sortView.priceLowToHigh.setImage(UIImage(named: "unchecked"), for: .normal);
     sortView.priceHighToLow.setImage(UIImage(named: "unchecked"), for: .normal);
     sortView.orderByDate.setImage(UIImage(named: "checked"), for: .normal);
     sortBy = "date"
     }*/
     sortView.removeFromSuperview();
     let alphaView = self.view.viewWithTag(10)
     alphaView?.removeFromSuperview()
     NotificationCenter.default.post(name:  NSNotification.Name("loadProducts"), object: nil);
     }
     */
    @objc func filterClicked(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "productFiltersViewController") as? ProductFiltersViewController
        vc?.filterData = filterData;
        vc?.currencySymbol = currencySymbol
        self.navigationController?.pushViewController(vc!, animated: true);
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "categoryProducts", for: indexPath) as! mageHomeProductCell
        let data=productsData[indexPath.row]
        if let imageUrl=data["productImage"]
        {
            if(imageUrl != "")
            {
                cell.productImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(contentsOfFile: wooSetting.productPlaceholder))
            }
            else
            {
                cell.productImage.image = UIImage(contentsOfFile: wooSetting.productPlaceholder);
            }
            /*if let userdefaults = UserDefaults.standard.value(forKey: "themeSettings") as? [String:String]
             {
             if let placeholderImage = userdefaults["ced_theme_product_placeholder_image"]
             {
             cell.productImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(url: URL(string: placeholderImage)))
             }
             else
             {
             cell.productImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
             }
             
             }*/
        }
        
        //cell.productImage.sd_setImage(with: URL(string: imageUrl!), placeholderImage: UIImage(named: "placeholder"))
        cell.productName.font = mageWooCommon.setCustomFont(type: .regular, size: 12)
        cell.saleTagLabel.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        cell.productPrice.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        cell.regularPrice.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        cell.productName.text=data["productName"]
        if(data["sale"] == "true")
        {
            cell.saleTagLabel.isHidden = false;
        }
        else
        {
            cell.saleTagLabel.isHidden = true;
        }
        if let productPrice = data["productPrice"]
        {
            cell.productPrice.text = productPrice;
        }
        if(data["salePrice"] != "" && data["salePrice"] != nil)
        {
            cell.saleTagLabel.isHidden = false;
            if let regularPrice = data["regularPrice"]
            {
                let offerPrice=NSMutableAttributedString(string: regularPrice);
                offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                cell.regularPrice.attributedText=offerPrice
                //cell?.regularPrice.text = regularPrice;
            }
        }
        else
        {
            cell.saleTagLabel.isHidden = true;
            let offerPrice=NSMutableAttributedString(string: "");
            offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
            cell.regularPrice.attributedText=offerPrice
        }
        if(data["sale"] != "" && data["sale"] != nil)
        {
            let min_price = data["product_price_min"];
            let max_price = data["product_price_max"];
            let min_reg_price = data["product_price_min_reg"];
            let max_reg_price = data["product_price_max_reg"];
            if(min_price != max_price)
            {
                cell.saleTagLabel.isHidden = false;
                cell.productPrice.text = data["currencySymbol"]!+min_price!+" - "+data["currencySymbol"]!+max_price!
            }
            else if(data["sale"] == "true" && min_reg_price == max_reg_price)
            {
                cell.saleTagLabel.isHidden = false;
                cell.productPrice.text = data["currencySymbol"]!+min_price!+" - "+data["currencySymbol"]!+max_reg_price!
            }
            else
            {
                cell.productPrice.text = data["currencySymbol"]!+min_price!
            }
            let offerPrice=NSMutableAttributedString(string: "");
            offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
            cell.regularPrice.attributedText=offerPrice
        }
        if data["wishlist"]=="no"{
            cell.wishList.setImage(UIImage(named: "wishempty"), for: .normal)
        }
        else{
            cell.wishList.setImage(UIImage(named: "wishfilled"), for: .normal)
        }
        
        cell.wishList.tag=indexPath.row
        cell.wishList.addTarget(self, action: #selector(wishButtonPressed(_:)), for: .touchUpInside)
        cell.outOfStockLabel.text = "OUT OF STOCK!"
        cell.outOfStockLabel.font = mageWooCommon.setCustomFont(type: .medium, size: 12.0)
        
        if let stockStatus = data["stockLabel"]
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
        cell.viewForCard.cardView()
        return cell
    }
    
   
    
    @objc func switchViews(_ sender:UIButton){
        if let imageView = self.view.viewWithTag(258) as? UIImageView {
            if(self.currentView == "grid"){
                self.currentView = "list"
                imageView.image = UIImage(named:"list")
            }else{
                self.currentView = "grid"
                imageView.image = UIImage(named:"grid")
            }
            self.collectionView.reloadData()
        }
        
    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     return CGSize(width: self.view.frame.width/2-10, height: self.view.frame.height/2-50)
     }*/
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.currentView == "list" {
            let height = CGFloat(255)
            let width = UIWindow().frame.size.width/2 - 5
            return CGSize(width:width, height:height);
        }else{
            let height = CGFloat(255)
            let width = UIWindow().frame.size.width - 10
            return CGSize(width:width, height:height);
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data=productsData[indexPath.row]
        let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
        viewControl.productId = data["productId"]!
        self.navigationController?.pushViewController(viewControl, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maximumOffset - currentOffset) <= 40 {
            if loading{
                self.page += 1;
                NotificationCenter.default.post(name:  NSNotification.Name("loadProducts"), object: nil);
                collectionView.reloadData();
            }
            
        }
        
    }
    
    var scrollHidden = false
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scroll")
        if(scrollHidden == false)
        {
            self.tabBarController?.tabBar.isHidden = true;
            self.scrollHidden = true;
            self.tabBarController?.tabBar.fadeOut(completion: {
                (finished: Bool) -> Void in
                
            })
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("hello")
        if(scrollHidden)
        {
            self.tabBarController?.tabBar.alpha=0
            self.tabBarController?.tabBar.fadeIn(completion: {
                (finished: Bool) -> Void in
                self.tabBarController?.tabBar.isHidden = false;
                self.scrollHidden = false;
            })
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func renderFloatingButton(){
     floatingButton = UIButton();
     floatingButton.translatesAutoresizingMaskIntoConstraints = false;
     floatingButton.setThemeColor();
     self.view.addSubview(floatingButton);
     if(categoryId != "")
     {
     floatingButton.isHidden=false;
     }
     else
     {
     floatingButton.isHidden=true;
     }
     floatingButton.setImage(UIImage(named: "sort-icon"), for: UIControlState.normal);
     floatingButton.addTarget(self, action: #selector(sortClicked(_:)), for: UIControlEvents.touchUpInside);
     floatingButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
     self.view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: translateAccordingToDevice(50)));
     self.view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: translateAccordingToDevice(50)));
     self.view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -10));
     self.view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: NSLayoutAttribute.center, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.center, multiplier: 1, constant: -(translateAccordingToDevice(50)+10)));
     floatingButton.makeViewCircled(size: translateAccordingToDevice(50));
     /*if(isAddressPickMode){
     floatingButton.isHidden = true;
     }*/
     }*/
    func translateAccordingToDevice(_ value:CGFloat)->CGFloat{
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            // iPad
            return value*1.5;
        }
        return value;
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

