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
class subCategoryCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var superView: UIView!
    
    
    @IBOutlet weak var img: UIImageView!
    
    var parent:UIViewController?=nil
    
    var table=UITableView()
    @IBOutlet weak var categoryName: UILabel!
    
    
    var productData=[[String:String]]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fetch(){
        collectionView.delegate=self
        collectionView.dataSource=self
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        print("COLLECTION$$$$$$$")
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "subCateProductCell", for: indexPath) as! mageHomeProductCell
        let data=productData[indexPath.row]
        let imageUrl=data["productImage"]
        
        cell.productImage.sd_setImage(with: URL(string: imageUrl!), placeholderImage: UIImage(named: "placeholder"))
        cell.viewForCard.cardView()
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
        if(data["product_type"] == "variable")
        {
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
            let offerPrice=NSMutableAttributedString(string: "");
            offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
            cell.regularPrice.attributedText=offerPrice
        }
        
        if(data["sale"] != nil && data["sale"] != "")
        {
            let min_price = data["product_price_min"];
            let max_price = data["product_price_max"];
            let min_reg_price = data["product_price_min_reg"];
            let max_reg_price = data["product_price_max_reg"];
            if(min_price != max_price)
            {
                cell.productPrice.text = data["currencySymbol"]!+min_price!+" - "+data["currencySymbol"]!+max_price!
            }
            else if(data["sale"] == "true" && min_reg_price == max_reg_price)
            {
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
        cell.productName.text=data["productName"]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (parent?.view.frame.width)!/2-10, height: (parent?.view.frame.height)!/2-50)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data=productData[indexPath.row]
        let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
        viewControl.productId = data["productId"]!
        parent?.navigationController?.pushViewController(viewControl, animated: true)
    }
    
    @objc func wishButtonPressed(_ sender: UIButton){
        let tag=sender.tag
        let data=productData[tag]
        let productId=data["productId"]!
        if User().getLoginUser() != nil {
            //let id=user["userId"]!
            
            User().wooAddToWishList(productId: productId, control: parent!, completion: {
                data in
                if let data = data {
                    if let json = try? JSON(data:data)
                    {
                        print(json)
                        if let jsonData=json["message"].string{
                            if jsonData=="Product removed from wishlist"{
                                sender.setImage(UIImage(named: "wishempty"), for: .normal)
                                self.parent?.view.makeToast("Product removed from wishlist.".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                            }
                            else if jsonData=="Product added to wishlist"
                            {
                                sender.setImage(UIImage(named: "wishfilled"), for: .normal)
                                self.parent?.view.makeToast("Product added to wishlist.".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                            }
                            //self.collectionView.reloadData()
                            //self.table.reloadData()
                            NotificationCenter.default.post(name: NSNotification.Name("loadCategoryView"),object: nil);
                        }
                    }
                    
                    
                    
                }
            })
            
        }
        else{
            parent?.view.makeToast("Please Login First...!".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
