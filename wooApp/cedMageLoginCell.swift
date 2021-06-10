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

class mageLoginCell: UITableViewCell {

    
    //@IBOutlet weak var signupView: UIView!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var forgotPassword: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginHeaderImageView: UIImageView!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var bottomLine: UILabel!
    
    @IBOutlet weak var orButton: UIButton!
    @IBOutlet weak var googleSignInButton: UIButton!
    @IBOutlet weak var fbSignInButton: UIButton!
    
    @IBOutlet weak var showPasswordButton: UIButton!
    
    @IBOutlet weak var leftLine: UILabel!
    
    @IBOutlet weak var rightLine: UILabel!
    
    @IBOutlet weak var appleSignInView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
