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

class orderCompletion: mageBaseViewController {

    
    @IBOutlet weak var continueShopping: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May  self.tracking(name: "order completed")
        UserDefaults.standard.removeObject(forKey: "cart_id");
        UserDefaults.standard.removeObject(forKey: "CartQuantity");
        continueShopping.setThemeColor();
        continueShopping.setTitleColor(wooSetting.textColor, for: .normal)
        /*if #available(iOS 12.0, *) {
            if(traitCollection.userInterfaceStyle == .dark)
            {
                continueShopping.setTitleColor(wooSetting.darkModeTextColor, for: .normal);
            }
        }*/
        continueShopping.addTarget(self, action: #selector(continueShoppingClicked(_:)), for: .touchUpInside)
        continueShopping.titleLabel?.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        self.updateBadge();
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
    }
    
    @objc func continueShoppingClicked(_ sender: UIButton)
    {
        self.tabBarController?.selectedIndex = 0
       /*--edited  let vc=mageWooCommon().getHomepage()
        
        self.navigationController?.setViewControllers([vc], animated: true)*/
        (UIApplication.shared.delegate as! AppDelegate).changeLanguage()
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
