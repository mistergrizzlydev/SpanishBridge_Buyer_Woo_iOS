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

class mageHomeProductCell: UICollectionViewCell {
    
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var regularPrice: UILabel!
    
    @IBOutlet weak var viewForCard: UIView!
    
    @IBOutlet weak var saleTagLabel: UILabel!
    @IBOutlet weak var wishList: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var outOfStockLabel: UILabel!
    
    
}
