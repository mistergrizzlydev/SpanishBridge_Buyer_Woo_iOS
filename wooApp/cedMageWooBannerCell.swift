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

class mageWooBannerCell: UITableViewCell,KIImagePagerDelegate,KIImagePagerDataSource {

    @IBOutlet weak var imagePager: KIImagePager!
    var dataSource = [String]()
    var bannerData=[[String:String]]()
    @IBOutlet weak var productSearchBar: UISearchBar!
    var parent = UIViewController();
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imagePager.delegate = self
        imagePager.indicatorDisabled = false
        imagePager.dataSource = self
    }
    
    
    
    public func array(withImages pager: KIImagePager!) -> [Any]! {
        if dataSource.count == 0 {
          //  return ["bannerplaceholder" as AnyObject]
            return [wooSetting.bannerPlaceholder as AnyObject]
        }
        return dataSource as [AnyObject]?
    }
    
    func contentMode(forPlaceHolder pager: KIImagePager!) -> UIView.ContentMode {
        return UIView.ContentMode.scaleToFill
    }
    
    func contentMode(forImage image: UInt, in pager: KIImagePager!) -> UIView.ContentMode {
        return UIView.ContentMode.scaleToFill
    }
    
    func placeHolderImage(for pager: KIImagePager!) -> UIImage! {
       // return UIImage(named: "bannerplaceholder")
        return UIImage(contentsOfFile: wooSetting.bannerPlaceholder)
        
    }
    func imagePager(_ imagePager: KIImagePager!, didSelectImageAt index: UInt) {
        if index >= 0{
            let banner = bannerData[Int(index)]
            if(banner["link_to"] == "product"){
                let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
                viewControl.productId = banner["link_id"]!
                parent.navigationController?.pushViewController(viewControl, animated: true)
                
            }
            else if(banner["link_to"] == "category"){
                /*let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "categoryProducts") as! CategoryProductsView
                vc.categoryId=banner["link_id"]!
                parent.navigationController?.pushViewController(vc, animated: true)*/
                let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageSubCategories") as! cedMageSubCategories
                vc.categoryId = banner["link_id"]!;
                parent.navigationController?.pushViewController(vc, animated: true)
                
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
