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

class cartViewCell: UITableViewCell {

    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var compareAtLabel: UILabel!
    
    @IBOutlet weak var topCell: UILabel!
    
    @IBOutlet weak var deleteCartButton: UIButton!
    
    @IBOutlet weak var totalItemsCell: UILabel!
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var qtyView: ProductQtyView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var productSubtotal: UILabel!
    
    @IBOutlet weak var updateProductButton: UIButton!
    
    @IBOutlet weak var deleteProductButton: UIButton!
    
    @IBOutlet weak var ChangeSetting: UIButton!
    
    @IBOutlet weak var Add: UIButton!
    
    @IBOutlet weak var couponTextField: UITextField!
    
    @IBOutlet weak var applyCoupon: UIButton!
    
    
    @IBOutlet weak var cartTotal: UILabel!
    
    @IBOutlet weak var cartDiscount: UILabel!
    
    
    @IBOutlet weak var subtotal: UILabel!
    
    
    @IBOutlet weak var delivery: UILabel!
    
    
    @IBOutlet weak var grandTotal: UILabel!
    
    
    
    
    @IBOutlet weak var proceedButton: UIButton!
    
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
