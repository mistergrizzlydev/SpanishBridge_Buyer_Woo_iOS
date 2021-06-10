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

class cedMageMydownloadcell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var clickToDownload: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        let imageView = UIImageView(image: UIImage(named: "download"))
       // imageView.center = clickToDownload.center
        imageView.frame = CGRect(x: UIScreen.main.bounds.width/2-25, y: clickToDownload.frame.origin.y, width: 30, height: 30)
        imageView.contentMode = .scaleAspectFit
        clickToDownload.addSubview(imageView)
        //clickToDownload.setThemeColor()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.size
    }
}
