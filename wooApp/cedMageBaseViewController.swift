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

class mageBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        wooMageNavigation().makeNaVigationBar(me: self)
        
        
        if let navBar = self.navigationController?.navigationBar
        {
            navBar.contentMode = .scaleAspectFit
            let navBtn  = UIButton()
            navBtn.imageView?.contentMode = .scaleAspectFit
            navBtn.setImage(UIImage(named: "wooLogo"), for: .normal)
            if let userdefaults = UserDefaults.standard.value(forKey: "themeSettings") as? [String:String]
            {
                if let logoImage = userdefaults["ced_theme_header_logo_image"]
                {
                    navBtn.sd_setImage(with: URL(string: logoImage), for: .normal);
                }
                
            }
            navBtn.frame = CGRect(x: 0.0, y: 0.0, width: ((self.navigationController?.navigationBar.frame.size.width)!)/2, height: ((self.navigationController?.navigationBar.frame.size.height)!)-10)
            navBtn.center = CGPoint(x: navBar.center.x, y: 20)
            
            navBar.addSubview(navBtn)
            navBtn.superview?.bringSubviewToFront(navBtn)
            navBtn.addTarget(self, action: #selector(homeClicked(_:)), for: .touchUpInside)
        }
        
        self.tabBarController?.tabBar.isHidden = true;
        // Do any additional setup after loading the view.
    }
    
    /*override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            if(previousTraitCollection?.hasDifferentColorAppearance(comparedTo: traitCollection) ?? false){
                guard UIApplication.shared.applicationState == .inactive else{
                    return;
                }
                (UIApplication.shared.delegate as! AppDelegate).changeLanguage()
            }
        }
        
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func homeClicked(_ sender: UIButton)
    {
        print("homeClicked")
        let vc=mageWooCommon().getHomepage()
        self.tabBarController?.selectedIndex = 0;
        // self.setViewControllers([vc], animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
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
