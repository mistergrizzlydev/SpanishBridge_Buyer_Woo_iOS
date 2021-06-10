
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

class ErrorPageView: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tryAgainButton: UIButton!
    var isWishList=false
    var isOrder=false
    override func viewDidLoad() {
        super.viewDidLoad()

        if isWishList || isOrder{
            tryAgainButton.isHidden=true
            tryAgainButton.isEnabled=false
            
            
            let navigationTitle = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
            navigationTitle.addTarget(self, action: #selector(navigateHomeView(_:)), for: .touchUpInside)
            navigationTitle.setBackgroundImage(UIImage(named: "header"), for: .normal)
            navigationTitle.contentMode = .scaleAspectFit
            self.navigationItem.titleView = navigationTitle
            
            if isWishList{
                imageView.image=UIImage(named: "Empty-wishlist")
                
            }
            if isOrder{
                imageView.image=UIImage(named: "No-order")
            }
            
        }
        
        
        //--edited10May  self.tracking(name: "ErrorPageView")

        
        
        // Do any additional setup after loading the view.
    }

    @objc func navigateHomeView(_ sender: UIButton){
        
        let vc=mageWooCommon().getHomepage()
        self.navigationController?.navigationBar.isHidden=false
        self.tabBarController?.selectedIndex = 0;
        self.navigationController?.setViewControllers([vc], animated: true)
        
        return
    }
    
    
    
    @IBAction func tryAgainPressed(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name("loadHomePage"),object: nil);
        NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"),object: nil);
        self.dismiss(animated: true, completion: nil)
        
        
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
