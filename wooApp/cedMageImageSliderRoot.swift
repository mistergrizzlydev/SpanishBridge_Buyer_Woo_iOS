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

class imageSliderRoot: UIViewController,UIPageViewControllerDelegate , UIPageViewControllerDataSource {
    
    var pageViewController : UIPageViewController!
    var pageData = NSArray()
    var titleView: UIView!
    var counter = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let instance = mageWooCommon.singletonInstance
        //create viewcontroller
        pageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pageControl") as! UIPageViewController
        pageViewController.dataSource = self
        let startingViewController = self.viewControllerAtIndex(index: 0)
        counter = instance.getInfo()
        print(instance.getInfo())
        let viewcontrolls = [startingViewController!]
        pageViewController.setViewControllers(viewcontrolls, direction:UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
        let pageViewRect = self.view.bounds
        let toplayoutguide = self.navigationController!.view.frame.origin.y;
        
        
        pageViewController.view.frame = CGRect(x: pageViewRect.origin.x, y: pageViewRect.origin.y + toplayoutguide, width: pageViewRect.size.width, height: pageViewRect.size.height)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        pageViewController.view.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.lightGray
        self.view.insertSubview(blurEffectView, belowSubview: pageViewController.view)
        // setupPageControl()
    }
    
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        //let page = UIPageControl()
        appearance.pageIndicatorTintColor = UIColor.black
        appearance.currentPageIndicatorTintColor = UIColor.red
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            // println(index)
            if (pageData.count == 0) ||
                (counter >= pageData.count) || (counter < 0){
                counter = 0
                
            }
            print(counter)
            counter += 1
            if(counter >= pageData.count){
                counter = 0
            }
            let startingViewController = self.viewControllerAtIndex(index: counter)
            let viewcontrolls = [startingViewController!]
            pageViewController.setViewControllers(viewcontrolls, direction:UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
            self.addChild(pageViewController)
            self.view.addSubview(pageViewController.view)
            
        }
    }
    
    
    
   func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController: viewController as! cedMageSingleProductImage)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        index -= 1
        counter = index
        return viewControllerAtIndex(index: index)
    }
    
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController: viewController as! cedMageSingleProductImage)
        //println(index)
        if (index == NSNotFound) {
            return nil
        }
        index += 1;
        if (index == self.pageData.count ) {
            return nil;
        }
        counter = index
        return viewControllerAtIndex(index: index)
    }
    
    func viewControllerAtIndex(index: Int) -> cedMageSingleProductImage? {
        
        // println(index)
        if (pageData.count == 0) ||
            (index >= pageData.count) {
            return nil
        }
        
        let storyBoard = UIStoryboard(name: "Main",
                                      bundle: nil)
        let dataViewController = storyBoard.instantiateViewController(withIdentifier: "singleImages") as! cedMageSingleProductImage
        
        dataViewController.imageArray = pageData as! [String]
        dataViewController.dataObject = pageData[index] as! String
        return dataViewController
    }
    
    func indexOfViewController(viewController:cedMageSingleProductImage ) -> Int {
        // println(pageData)
        return pageData.index(of: viewController.dataObject)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
    
}
