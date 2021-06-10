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

class mageAddReviewCell: UITableViewCell {

    @IBOutlet weak var writeAReviewButton: UIButton!
    
    @IBOutlet weak var name: SkyFloatingLabelTextField!
    
    @IBOutlet weak var email: SkyFloatingLabelTextField!
    
    @IBOutlet weak var review: SkyFloatingLabelTextField!
    
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var ratingStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
