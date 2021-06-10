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

class productSearch: mageBaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var mainTable: UITableView!
    
    var products = [[String:String]]();
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May    self.tracking(name: "product search")
        searchBar.becomeFirstResponder()
        searchBar.cardView()
        //searchBar.barTintColor=UIColor(hexString: "#FFFFFF")
        
        
        //let view: UIView = searchBar.subviews[0] as UIView
        //let subViewsArray = view.subviews
        
        /*for subView: UIView in subViewsArray {
            if subView.isKind(of: UIButton.self){
                subView.tintColor = UIColor.white
            }
        }*/
        
        searchBar.delegate=self
        mainTable.isHidden=true
        mainTable.dataSource=self
        mainTable.delegate=self
        // Do any additional setup after loading the view.
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text==""{
            
            self.view.makeToast("Enter some text to search products.".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            
            return
        }
        var params = Dictionary<String,String>();
        params["search"] = searchBar.text;
        /*cedMageLoaders.addDefaultLoader(me: self)
        products = [[String:String]]();
        mageRequets.sendHttpRequest(endPoint: "getsearchedproducts",method: "POST", params: params, controller: self, completionHandler: {
            data,url,error in
            DispatchQueue.main.async
            {
                cedMageLoaders.removeLoadingIndicator(me: self)
                if let data = data{
                    let json = JSON(data: data);
                    if(json["status"].stringValue == "true")
                    {
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
                            self.products.append(productsData)
                            
                        }
                        let vc=self.storyboard?.instantiateViewController(withIdentifier: "categoryProducts") as? CategoryProductsView
                        //vc?.productsData=self.products;
                        vc?.searchText = searchBar.text!
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }
                    else
                    {
                        self.products = [[String:String]]();
                        self.mainTable.reloadData();
                        self.mainTable.isHidden=false;
                    }
                    
                }
            }
        })*/
        /*let vc=self.storyboard?.instantiateViewController(withIdentifier: "categoryProducts") as? CategoryProductsView
        //vc?.productsData=self.products;
        vc?.searchText = searchBar.text!
        self.navigationController?.pushViewController(vc!, animated: true)*/
        let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageSubCategories") as! cedMageSubCategories
        vc.searchText = searchBar.text!;
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func getSearchedProduct(searchText: String)
    {
        var params = Dictionary<String,String>();
        params["search"] = searchText;
        cedMageLoaders.addDefaultLoader(me: self)
        products = [[String:String]]();
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/autosuggestions",method: "POST", params: params, controller: self, completionHandler: {
            data,url,error in
            DispatchQueue.main.async
            {
                
                cedMageLoaders.removeLoadingIndicator(me: self)
                if let json = try? JSON(data: data!){
                    print(json)
                    if(json["status"].stringValue=="200ok")
                    {
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
                            self.products.append(productsData)
                            
                        }
                        
                    }
                    self.mainTable.reloadData();
                    self.mainTable.isHidden=false;
                }
                
            }
        })
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(products.count>0)
        {
            return products.count;
        }
        else
        {
            return 1;
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell", for: indexPath)
        if(products.count==0)
        {
            cell.textLabel?.text = "No Result found".localized
            return cell;
        }
        else{
            cell.textLabel?.text = products[indexPath.row]["productName"];
            return cell;
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productId = products[indexPath.row]["productId"];
        let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
        viewControl.productId = productId!
        self.navigationController?.pushViewController(viewControl, animated: true)

    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        
        searchBar.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(getHint), object: nil)
        self.perform(#selector(getHint), with: nil, afterDelay: 2)
    }
    @objc func getHint() {
        if((searchBar.text?.count)! >= 3)
        {
            let searchText=searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            getSearchedProduct(searchText: searchText!);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
