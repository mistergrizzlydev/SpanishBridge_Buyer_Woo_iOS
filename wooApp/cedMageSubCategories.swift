//
//  cedMageSubCategories.swift
//  wooApp
//
//  Created by cedcoss on 11/01/18.
//  Copyright © 2018 MageNative. All rights reserved.
//

import UIKit

class cedMageSubCategories: mageBaseViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    var categoryId=""
    var categData = [String:String]()
    var categoryData=[[String:String]]()
    var productsData=[[String:String]]()
    var mainCategoriesData = [[String:String]]()
    var otherCategoryProducts = [[String:String]]()
    var dataSource = expandingCells()
    var previouslySelectedHeaderIndex: Int?
    var selectedHeaderIndex: Int?
    var selectedItemIndex: Int?
    var showCheck = [Bool]();
    var moreClicked = false;
    var loading = true;
    var page = 1;
    var sortBy = ""
    var categoryid="";
    var searchText = "";
    var sortByArray = [String:String]();
    var filterData = [String: [String:String]]()
    var currencysymbol = "";
    var customFilters = [String: [String:Any]]()
    var customsData = [[String:Any]]()
    var customFilterDataArray = [String: [String:Any]]()
    var customs = [[String:Any]]()
    var layoutHeight: CGFloat = 0.0
    
    @IBOutlet weak var sortFilterViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sortFilterView: sortByAndFilterButtonView!
    var productCollectionView : UICollectionView!
    var currentView = "list"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May  self.tracking(name: "sub categories");
        print("cedMageSubCategories_page")
        mainTableView.delegate = self;
        mainTableView.dataSource = self;
        UserDefaults.standard.removeObject(forKey: "filters");
        self.reloadData()
        /*if(categoryData.count == 0)
        {
            
        }
        else
        {
            mainTableView.reloadData();
        }*/
        if(searchText != "")
        {
            sortFilterViewHeight.constant = 0;
            sortFilterView.isHidden = true;
        }
        sortFilterView.cardView()
        sortFilterView.filterButton.addTarget(self, action: #selector(filterClicked(_:)), for: .touchUpInside)
        sortFilterView.sortButton.addTarget(self,action: #selector(sortbyButtonPressed(_:)), for: .touchUpInside)
        sortFilterView.changeViewButton.addTarget(self, action: #selector(switchViews(_:)), for: .touchUpInside)
        sortFilterView.switchImage.tag=258
        UIView.animate(withDuration: 4, delay: 1, options: [UIView.AnimationOptions.transitionFlipFromRight,  UIView.AnimationOptions.showHideTransitionViews], animations: {
            if(self.currentView == "grid"){
                self.sortFilterView.switchImage.rotate360Degrees()
                self.sortFilterView.switchImage.image = UIImage(named: "grid")
            }else{
                self.sortFilterView.switchImage.rotate360Degrees()
                self.sortFilterView.switchImage.image = UIImage(named: "list")
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
    }
    
    func loadData(){
        
        cedMageLoaders.addDefaultLoader(me: self)
        User().subCategoryRequest(categoryId: categoryId, page: page, controller: self) { (subcat) in
            cedMageLoaders.removeLoadingIndicator(me: self)
            if(subcat["product"]?.count == 0)
            {
                self.loading = false
                
            }
            for index in subcat["product"]!{
                self.productsData.append(index);
            }
            if(self.page == 1)
            {
                self.categoryData=subcat["category"]!;
                self.categData=subcat["maincategory"]![0];
                self.mainTableView.reloadData()
            }
            self.mainTableView.reloadSections(NSIndexSet(index: 2) as IndexSet, with: .none)
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if(section == 1){
         return categoryData.count
         }else{
         return 1
         }*/
        if(section == 0)
        {
            if(categoryData.count == 0)
            {
                return 0
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        
        if(indexPath.section == 0)
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryNames", for: indexPath) as? SubCategoryNamesCell
            {
                cell.categoryData = categoryData
                cell.parent = self
                cell.collectionLoad()
                return cell
            }
        }
        else if(indexPath.section == 1)
        {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "categoryProductCell", for: indexPath) as? cedMageCategoryProductCell
            {
                cell.productData = productsData;
                cell.parent = self;
                cell.reloadData();
                cell.currentView = currentView;
                if(productsData.count > 0){
                    var itemInRow = 2
                    if(UIDevice.current.userInterfaceIdiom == .pad){
                        itemInRow = 4
                    }
                    var count = productsData.count
                    if (productsData.count%(itemInRow) != 0) {
                        count += 1
                    }
                    print("a\(count)  \(itemInRow) \(count/itemInRow)")
                    layoutHeight = (cell.mainCollectionView.calculateCellSize(numberOfColumns: itemInRow).height) * CGFloat(count/(itemInRow))
                    mainTableView.beginUpdates()
                    mainTableView.endUpdates()
                }
                self.productCollectionView = cell.mainCollectionView
                return cell;
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            if (categoryData.count > 0)
            {
              //  return CGFloat(ceil(Double(categoryData.count)/3.0) * 60)
                return CGFloat(ceil(Double(categoryData.count)/3.0) * 90)
            }
        }
        if(indexPath.section == 1)
        {
            if(productsData.count>0)
            {
                //return CGFloat(ceil(Double(productsData.count)/2.0) * 410);
                return layoutHeight
                
            }
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0)
        {
            let data=categoryData[indexPath.row]
            let categoryId=data["categoryId"]
            let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageSubCategories") as! cedMageSubCategories
            let category = ["name":self.categoryData[indexPath.row]["categoryName"],"image":self.categoryData[indexPath.row]["imageName"]];
            vc.categData = category as! [String : String];
            
            vc.categoryId = categoryId!;
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maximumOffset - currentOffset) <= 40 {
            if loading{
                self.page += 1;
                self.reloadData();
            }
            
        }
        
    }
    func translateAccordingToDevice(_ value:CGFloat)->CGFloat{
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            // iPad
            return value*1.5;
        }
        return value;
    }
    
    @objc func filterClicked(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "productFiltersViewController") as? ProductFiltersViewController
        vc?.filterData = filterData;
        vc?.currencySymbol = currencysymbol
        vc?.vc = self;
        self.navigationController?.pushViewController(vc!, animated: true);
    }
    
    
    
    
    @objc func loadFilteredData(){
        page = 1;
        loading = true;
        self.reloadData();
        //NotificationCenter.default.post(name:  NSNotification.Name("loadSubcategoryProducts"), object: nil);
    }
    @objc func reloadData(){
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
        //if(categoryid != "")
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
        print("productView json : ")
        print(json)
        if status=="true"{
            var productsData=[[String:String]]()
            currencysymbol = json["currency_symbol"].stringValue
            print(json["order-by"])
            for(key,value) in json["order-by"]
            {
                print(value)
                sortByArray[key] = value.stringValue;
            }
            
            // --------- PRICE FILTER DATA
            for(key,value) in json["filters"]
            {
                var filt = [String:String]();
                for(key1,value1) in value
                {
                    filt[key1]=value1.stringValue;
                }
                filterData[key]=filt;
                
            }
            if(page == 1)
            {
                categoryData = [[String:String]]()
                if let subcategories=json["subcategories"].array{
                    for node in subcategories{
                        let cateName=node["name"].stringValue
                        let cateId=node["term_id"].stringValue
                        let imageName=node["sub_image"].stringValue
                        let hasChild=node["has_child"].stringValue;
                        let temp=["categoryName":cateName,"categoryId":cateId,"imageName":imageName,"has_child":hasChild]
                        categoryData.append(temp)
                    }
                }
            }
            
            // ------- PRODUCTS
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
            else{
                self.loading = false;
            }
            for index in productsData
            {
                self.productsData.append(index);
            }
            if(self.productsData.count == 0)
            {
                self.loading = false;
                if(page==1)
                {
                    self.sortFilterView.sortButton.isEnabled = false
                    self.sortFilterView.filterButton.isEnabled = false;
                    self.productCollectionView.isHidden = true
                }
            }
            else
            {
                self.sortFilterView.sortButton.isEnabled = true
                self.sortFilterView.filterButton.isEnabled = true;
                if(page != 1)
                {
                    self.mainTableView.beginUpdates()
                    self.mainTableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .none)
                    self.mainTableView.endUpdates()
                    return;
                }
                
                //self.sortFilterButtonView.sortButton.isEnabled = true;
            }
        }
        else
        {
            self.loading = false;
            if(page==1)
            {
                self.sortFilterView.sortButton.isEnabled = false
                self.productCollectionView.isHidden = true
                self.productsData=[[String:String]]()
            }
        }
        print("-------------")
        print(productsData)
        self.mainTableView.reloadData()
        if(page == 1)
        {
            if(categoryData.count > 0)
            {
                let topIndex = IndexPath(row: 0, section: 0)
                mainTableView.scrollToRow(at: topIndex, at: .top, animated: true)
            }
            else
            {
                if(productsData.count > 0)
                {
                    let topIndex = IndexPath(row: 0, section: 1)
                    mainTableView.scrollToRow(at: topIndex, at: .top, animated: true)
                    
                    
                }
            }
        }
    }
    
}
extension cedMageSubCategories{
    @objc func switchViews(_ sender:UIButton){
        if let imageView = self.view.viewWithTag(258) as? UIImageView {
            if(self.currentView == "grid"){
                self.currentView = "list"
                imageView.image = UIImage(named:"list")
            }else{
                self.currentView = "grid"
                imageView.image = UIImage(named:"grid")
            }
            self.mainTableView.reloadData()
        }
        
    }
    
    @objc func sortbyButtonPressed(_ sender:UIButton){
        print("sortbyButtonPressed");
        print(sortByArray)
        let alertController=UIAlertController(title: "", message: "Select Option.".localized, preferredStyle: .alert)
        let sortKeys = Array(self.sortByArray.values)
        for item in sortKeys{
            let action = UIAlertAction(title: item, style: .default, handler: {  Void in
                for(key,value) in self.sortByArray
                {
                    if(value == item)
                    {
                        self.sortBy = key;
                        break;
                    }
                    
                }
                self.loadFilteredData();
            })
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title:"Cancel".localized, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        if UIDevice.current.model.lowercased() == "ipad".lowercased(){
            alertController.popoverPresentationController?.sourceView = sender
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
