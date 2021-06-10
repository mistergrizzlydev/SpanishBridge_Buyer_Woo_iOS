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



class wooMageNavigation: UINavigationController,UINavigationControllerDelegate {
    
    var categoryId = "";
    var productId = "";
    var webURL = "";
    var checkNotificationType=""
    var currentViewController:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //self.navigationBar.tintColor=UIColor.black
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationBar.barTintColor=wooSetting.bartintColor;
        // Do any additional setup after loading the view.
        self.navigationBar.tintColor=wooSetting.tintColor;
        let viewControl = mageWooCommon().getHomepage()
        let vc = [viewControl]
        self.setViewControllers(vc, animated: false)
        
    }
    
    func makeCart(){
        
    }
    
    
    func makeNaVigationBar(me:UIViewController?){
        let toglebut = UIButton()
        me?.navigationController?.navigationBar.barTintColor=wooSetting.bartintColor;
        // Do any additional setup after loading the view.
        me?.navigationController?.navigationBar.tintColor=wooSetting.tintColor;
        toglebut.frame.size = CGSize(width:15, height:15)
        toglebut.setImage(UIImage(named: "hamp"), for: .normal)
        toglebut.imageView?.contentMode = .scaleAspectFit;
        toglebut.addTarget(self, action: #selector(wooMageNavigation.toggleDrawer), for: UIControl.Event.touchUpInside)
        let togglebutton = UIBarButtonItem(customView: toglebut)
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        backButton.addTarget(self, action: #selector(wooMageNavigation.backfunc(sender:)), for: .touchUpInside)
        backButton.setImage(UIImage(named:"backArrow"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit;
        currentViewController = me
        let backBarButton = UIBarButtonItem(customView: backButton)
        
        //Make search item
        let searchButton=UIButton(type: .custom)
        searchButton.frame=CGRect(x: 0, y: 0, width: 15, height: 15)
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit;
        searchButton.addTarget(self, action: #selector(searchNavigate), for: .touchUpInside)
        let searchButtonNav =  UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(searchNavigate))
        
        //Make cart item
        let cartbutton = UIButton()
        cartbutton.frame=CGRect(x: 0, y: 0, width: 15, height: 15)
        cartbutton.setImage(UIImage(named: "shopping_cart"), for: .normal)
        cartbutton.imageView?.contentMode = .scaleAspectFit;
        cartbutton.addTarget(self, action: #selector(viewCart(sender:)), for: .touchUpInside)
        let cart = UIBarButtonItem(customView: cartbutton)
        //cartbutton.addTarget(self, action: #selector(wooMageNavigation.viewCart(sender:)), for: UIControl.Event.touchUpInside)
        /*let cart = UIBarButtonItem(image: UIImage(named: "shopping_cart"),
        style: .plain,
        target: self,
        action: #selector(cartClicked(_:)))*///UIBarButtonItem(customView: cartbutton)
        cart.tag = 786;
        //cart.target = self;
        //cart.action = #selector(cartClicked(_:))
        let navigationTitle = UIButton(frame: CGRect(x: 0, y: 0, width: 110, height: 70))
        //let navigationTitle = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        navigationTitle.setImage(UIImage(named: "wooLogo"), for: .normal)
        if let userdefaults = UserDefaults.standard.value(forKey: "themeSettings") as? [String:String]
        {
            if let logoImage = userdefaults["ced_theme_header_logo_image"]
            {
                navigationTitle.sd_setImage(with: URL(string: logoImage), for: .normal);
            }
            
        }
        //navigationTitle.imageView?.contentMode = .scaleAspectFit
        navigationTitle.addTarget(self, action: #selector(homeClicked(sender:)), for: .touchUpInside);
        //me?.navigationItem.titleView = navigationTitle
        if let me = me as? mageWooHome{
            me.navigationItem.leftBarButtonItems = [togglebutton]
            me.navigationItem.rightBarButtonItems = [cart,searchButtonNav]
        } else if let me = me as? mageWooAppSiteTheme{
            me.navigationItem.leftBarButtonItems = [togglebutton]
            me.navigationItem.rightBarButtonItems = [cart,searchButtonNav]
        }else if let me = me as? wooMageLogin{
            me.navigationItem.leftBarButtonItems = []
            me.navigationItem.rightBarButtonItems = []
        }else if let me = me as? wooMageRegister{
            me.navigationItem.leftBarButtonItems = [backBarButton]
            me.navigationItem.rightBarButtonItems = []
        }else if let me = me as? mageWooForgotPassword{
            me.navigationItem.leftBarButtonItems = [backBarButton]
            me.navigationItem.rightBarButtonItems = []
        }else if let me = me as? mageWooWishList{
            me.navigationItem.leftBarButtonItems = [togglebutton]
            me.navigationItem.rightBarButtonItems = [cart,searchButtonNav]
        }else if let me = me as? mageWooEditProfile{
            me.navigationItem.leftBarButtonItems = [togglebutton]
            me.navigationItem.rightBarButtonItems = [cart,searchButtonNav]
        }else if let me = me as? mageWooMaincategory{
            me.navigationItem.leftBarButtonItems = [backBarButton,togglebutton]
            me.navigationItem.rightBarButtonItems = [cart,searchButtonNav]
        }else if let me = me as? orderCompletion{
            me.navigationItem.leftBarButtonItems = [togglebutton]
            me.navigationItem.rightBarButtonItems = [cart,searchButtonNav]
        }else if let me = me as? orderFailed{
            me.navigationItem.leftBarButtonItems = [togglebutton]
            me.navigationItem.rightBarButtonItems = [cart,searchButtonNav]
        }else if let me = me as? checkoutWebView{
            me.navigationItem.leftBarButtonItems = []
            me.navigationItem.rightBarButtonItems = [cart,searchButtonNav]
        }else if let me = me as? CategoryProductsView{
            if(me.notificationCheck == true)
            {
                me.navigationItem.leftBarButtonItems = []
            }
            else
            {
                me.navigationItem.leftBarButtonItems = [backBarButton,togglebutton]
            }
            me.navigationItem.rightBarButtonItems = [cart,searchButtonNav]
        }else if let me = me as? mageWooNotifications{
            me.navigationItem.leftBarButtonItems = [togglebutton]
            me.navigationItem.rightBarButtonItems = [cart,searchButtonNav]
        }else if let me = me as? mageWooProductView{
            if(me.notificationCheck == true)
            {
                me.navigationItem.leftBarButtonItems = []
            }
            else
            {
                me.navigationItem.leftBarButtonItems = [backBarButton,togglebutton]
            }
            me.navigationItem.rightBarButtonItems = [cart,searchButtonNav]
        }else if let me = me as? mageHomeWebController{
            if(me.notificationCheck == true)
            {
                me.navigationItem.leftBarButtonItems = []
            }
            else
            {
                me.navigationItem.leftBarButtonItems = [backBarButton,togglebutton]
            }
            me.navigationItem.rightBarButtonItems = [cart,searchButtonNav]
        }else{
            me?.navigationItem.leftBarButtonItems = [backBarButton,togglebutton]
            me?.navigationItem.rightBarButtonItems = [cart,searchButtonNav]
        }
    }
    
    
    
    @objc func searchNavigate()
    {
        let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchproduct") as! productSearch
        self.pushViewController(vc, animated: true)
    }
    
    @objc func viewCart(sender:UIButton){
        
        if let cartViewControl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cartlist") as? CartProductListView {
            self.pushViewController(cartViewControl, animated: true)
        }
        
    }
    
    @objc func homeClicked(sender: UIButton)
    {
        let vc=mageWooCommon().getHomepage()
        self.tabBarController?.selectedIndex = 0;
        self.setViewControllers([vc], animated: true)
    }
    
    @objc func backfunc(sender:UIButton){
        //let mainview = self.sideDrawerViewController?.mainViewController  as? wooMageNavigation
        let mainview = self;
        let result =  mainview.popViewController(animated: true)
        print(result ?? "text")
    }
    
    @objc func toggleDrawer() {
        if let sideDrawerViewController = self.sideDrawerViewController {
            sideDrawerViewController.toggleDrawer()
        }
    }
}

