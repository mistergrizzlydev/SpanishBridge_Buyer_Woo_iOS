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

class menuSlider: UIViewController {

    var pageMenu : CAPSPageMenu?
    var categoryLayout = [[String:String]]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let controllerArray : [UIViewController] = []
        /*if let controller1 : cedMageHomeDefault = UIStoryboard(name: "homeLayouts", bundle: nil).instantiateViewController(withIdentifier: "homaDefault") as? cedMageHomeDefault {
            controller1.title = "Deals".localized
            controllerArray.append(controller1)
        }
        if let controller2 : cedMageHomeDefault2 = UIStoryboard(name: "homeLayouts", bundle: nil).instantiateViewController(withIdentifier: "categoryController") as? cedMageHomeDefault2 {
            controller2.title = "Category".localized
            controllerArray.append(controller2)
        }
        if let controller3 : cedMageDealsViewController = UIStoryboard(name: "homeLayouts", bundle: nil).instantiateViewController(withIdentifier: "dealsController") as? cedMageDealsViewController {
            controller3.title = "Home".localized
            controllerArray.append(controller3)
        }
        let appLanguage = UserDefaults.standard.string(forKey: "currentCedAppLanguage")
        if appLanguage == "ar" {
            controllerArray.reverse()
        }*/
        
        let menuWidth = self.view.bounds.width/3 - 20
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(mageWooCommon.UIColorFromRGB(colorCode: "#57910A")),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor.white),
            .bottomMenuHairlineColor(UIColor.white),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 12.0)!),
            .menuHeight(50.0),
            .menuItemWidth(menuWidth),
            .centerMenuItems(true),
            .addBottomMenuShadow(true),
            .menuShadowColor(UIColor.white),
            .menuShadowRadius(4)
        ]
        // Initialize scroll menu
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: rect, pageMenuOptions: parameters)
        
        self.addChild(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        pageMenu!.didMove(toParent: self)
    }
    
    func didTapGoToLeft() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex > 0 {
            pageMenu!.moveToPage(currentIndex - 1)
        }
    }
    
    func didTapGoToRight() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex < pageMenu!.controllerArray.count {
            pageMenu!.moveToPage(currentIndex + 1)
        }
    }
    
    
    // MARK: - Container View Controller
    //	override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
    //		return true
    //	}
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
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
