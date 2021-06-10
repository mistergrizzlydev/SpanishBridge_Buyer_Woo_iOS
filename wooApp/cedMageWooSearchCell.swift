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

class mageWooSearchCell: UITableViewCell, UISearchBarDelegate {

    var parent = UIViewController();
    
    @IBOutlet weak var productSearchBar: UISearchBar!
    override func awakeFromNib() {
        super.awakeFromNib()
        productSearchBar.delegate=self;
        // Initialization code
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var params = Dictionary<String,String>();
        params["search"] = searchBar.text;
        cedMageLoaders.addDefaultLoader(me: parent)
        var products = [[String:String]]();
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/getsearchedproducts",method: "POST", params: params, controller: parent, completionHandler: {
            data,url,error in
            
            DispatchQueue.main.async
                {
                    cedMageLoaders.removeLoadingIndicator(me: self.parent)
                    if let json = try? JSON(data: data!){
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
                        let vc=self.parent.storyboard?.instantiateViewController(withIdentifier: "categoryProducts") as? CategoryProductsView
                        vc?.productsData=products;
                        vc?.searchText = searchBar.text!;
                        self.parent.navigationController?.pushViewController(vc!, animated: true)
                    }
                    
            }
        })
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
