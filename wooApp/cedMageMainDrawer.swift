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

class wooMageMainDrawer: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var blurView: UIImageView!
    
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    
    var categoriesData = [[String:String]]()
    
    @IBOutlet weak var mainTable: UITableView!
    var maxCategoryNumber = 0
    let defaults = UserDefaults.standard
    var Stores = [[String:String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May   self.tracking(name: "drawer");
        mainTable.delegate=self;
        mainTable.dataSource=self;
        if #available(iOS 13.0, *) {
            mainTable.backgroundColor = UIColor.systemBackground
        } else {
            mainTable.backgroundColor = UIColor.white;
        }
        if #available(iOS 11.0, *) {
            mainTable.contentInsetAdjustmentBehavior = .never
        }
        NotificationCenter.default.addObserver(self, selector: #selector(wooMageMainDrawer.loadFromNotif(_:)), name: NSNotification.Name(rawValue: "loadDrawerAgain"), object: nil);
        NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"),object: nil);
    }

    
    
    override func viewWillAppear(_ animated: Bool)
    {
        if let value=UserDefaults.standard.string(forKey: "wooAppLanguage")
        {
            print("drawer--")
            print(value)
            if value == "ar" || value == "ur"
            {
                self.sideDrawerViewController?.drawerDirection = .Right
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                Bundle.setLanguage("ar")
                
                
            }
            else
            {
                self.sideDrawerViewController?.drawerDirection = .Left
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                
                
            }
        }
        else
        {
            self.sideDrawerViewController?.drawerDirection = .Left
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            //Bundle.setLanguage("en")
        }
        //Bundle.setLanguage("en");
    }
    
    @objc func loadFromNotif(_ notification: NSNotification)
    {
        categoriesData = [[String:String]]()
        cedMageLoaders.addDefaultLoader(me: self)
        User().categoryRequest(controller: self) { (categoryData) in
            cedMageLoaders.removeLoadingIndicator(me: self);
            self.categoriesData = categoryData;
            self.mainTable.reloadData();
        }
        
    }
    
    
    func loadBlur(){
        
        if !UIAccessibility.isReduceTransparencyEnabled {
            
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.mainTable.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            let effect = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.light))
            effect.frame = blurView.frame
            effect.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            blurView.addSubview(effect)
            blurView.setThemeColor()
            
        }
        
    }
    func imageWithView(view:UIView)->UIImage{
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section==0)
        {
            return 1;
        }
        else if(section == 1){
            return 1;
        }
        else if(section==2)
        {
            if(categoriesData.count>0)
            {
                if(categoriesData.count>5)
                {
                    maxCategoryNumber = 5;
                    return 6;
                }
                maxCategoryNumber = categoriesData.count;
                return categoriesData.count + 1;
            }
            else
            {
                maxCategoryNumber = 0
                return 0;
            }
        }
        else if(section==3)
        {
            return 1
        }
        else if(section==4)
        {
            if(UserDefaults.standard.bool(forKey: "mageWooLogin"))
            {
                return 1;
            }
        }
        return 0;
    }
    
    @objc func changeThemeClicked(_ sender: UIButton){
        print("--changeThemeClicked function called --")
        self.sideDrawerViewController?.toggleDrawer()
        let alertController = UIAlertController(title: nil, message: "Select Theme", preferredStyle: .actionSheet)

        let defaultAction = UIAlertAction(title: "Default", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            UserDefaults.standard.set("default", forKey: "selectedTheme")
            (UIApplication.shared.delegate as! AppDelegate).changeLanguage()
        })

        let customAction = UIAlertAction(title: "Custom", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            UserDefaults.standard.set("custom", forKey: "selectedTheme")
            (UIApplication.shared.delegate as! AppDelegate).changeLanguage()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
        })
        alertController.addAction(defaultAction)
        alertController.addAction(customAction)
        alertController.addAction(cancelAction)
        if let popoverController = alertController.popoverPresentationController {
          popoverController.sourceView = self.view
          popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
          popoverController.permittedArrowDirections = []
        }

        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section==0)
        {
            if let cell = mainTable.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? userCell
            {
                cell.emailButton.addTarget(self, action: #selector(profileClicked(_:)), for: .touchUpInside)
                cell.setThemeColor()
                if #available(iOS 13.0, *) {
                    cell.emailButton.setTitleColor(UIColor.systemBackground, for: .normal)
                } else {
                    cell.emailButton.setTitleColor(UIColor.white, for: .normal)
                }
                cell.userName.text="Guest".localized;
                cell.userName.textColor = .white
                cell.emailButton.setTitle("LOGIN/SIGNUP".localized, for: .normal)
                if let user = User().getLoginUser()
                {
                    cell.userName.text="User".localized;
                    cell.emailButton.setTitle(user["userEmail"], for: .normal);
                    return cell;
                }
                
                
                return cell;
            }
            
        }
        else if(indexPath.section==1)
        {
            if let cell = mainTable.dequeueReusableCell(withIdentifier: "themeCell", for: indexPath) as? logoutCell
            {
                cell.logoutButton.setTitle("Change Theme".localized, for: .normal)
                cell.logoutButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .bold, size: 15.0)
                cell.logoutButton.addTarget(self, action: #selector(changeThemeClicked(_:)), for: .touchUpInside);
                cell.backgroundColor = UIColor.clear;
                return cell;
            }
        }
        else if(indexPath.section == 2)
        {
            if let cell = mainTable.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as? homeCell
            {
                if(indexPath.row == maxCategoryNumber)
                {
                    cell.categoryLabel.text = "More".localized
                }
                else
                {
                    cell.categoryLabel.text = categoriesData[indexPath.row]["category_name"];
                }
                cell.backgroundColor = UIColor.clear;
                return cell;
            }
        }
        else if(indexPath.section == 3)
        {
            if let cell = mainTable.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? profileCell
            {
                cell.profileButton.addTarget(self, action: #selector(profileClicked(_:)), for: .touchUpInside)
                cell.myOrdersButton.addTarget(self, action: #selector(myOrdersClicked(_:)), for: .touchUpInside);
                cell.wishlistButton.addTarget(self, action: #selector(wishListClicked(_:)), for: .touchUpInside)
                cell.myDownloadsButton.addTarget(self, action: #selector(myDownloadsClicked(_:)), for: .touchUpInside)
                cell.notifications.addTarget(self, action: #selector(notificationsClicked(_:)), for: .touchUpInside)
                cell.storeButton.addTarget(self, action: #selector(storeClicked(_:)), for: .touchUpInside)
                cell.backgroundColor = UIColor.clear;
                return cell;
            }
        }
        else if(indexPath.section==4)
        {
            if let cell = mainTable.dequeueReusableCell(withIdentifier: "logoutCell", for: indexPath) as? logoutCell
            {
                cell.logoutButton.setTitle("Logout".localized, for: .normal)
                cell.logoutButton.addTarget(self, action: #selector(logoutClicked(_:)), for: .touchUpInside);
                cell.backgroundColor = UIColor.clear;
                return cell;
            }
        }
        return UITableViewCell();
    }
    
    @objc func emailButtonClicked(_ sender: UIButton)
    {
        if let nav = self.sideDrawerViewController?.mainViewController as? cedMageTabBar
        {
            print(nav.viewControllers![0])
            if let navigation = nav.viewControllers![0] as? UINavigationController
            {
                emailClick(navigation: navigation, sender: sender)
                
            }
            if let navigation = nav.viewControllers![1] as? cedMageWishlistNavigation
            {
                emailClick(navigation: navigation, sender: sender)
                
            }
            if let navigation = nav.viewControllers![2] as? cedMageNotificationNavigation
            {
                emailClick(navigation: navigation, sender: sender)
                
            }
            if let navigation = nav.viewControllers![3] as? cedMageAccountNavigation
            {
                emailClick(navigation: navigation, sender: sender)
                
            }
        }
        
    }
    
    func homeButtonClicked(navigation: UINavigationController)
    {
        //let navigation = sideDrawerViewController?.mainViewController as! wooMageNavigation
        let vc=mageWooCommon().getHomepage()
        
        navigation.setViewControllers([vc], animated: true)
        self.sideDrawerViewController?.toggleDrawer()
    }
    
    
    @objc func profileClicked(_ sender: UIButton)
    {
        if let nav = self.sideDrawerViewController?.mainViewController as? cedMageTabBar
        {
            print(nav.viewControllers![0])
            if let navigation = nav.viewControllers![0] as? UINavigationController
            {
                navToProfile(navigation: navigation)
                
            }
            if let navigation = nav.viewControllers![1] as? cedMageWishlistNavigation
            {
                navToProfile(navigation: navigation)
                
            }
            if let navigation = nav.viewControllers![2] as? cedMageNotificationNavigation
            {
                navToProfile(navigation: navigation)
                
            }
            if let navigation = nav.viewControllers![3] as? cedMageAccountNavigation
            {
                navToProfile(navigation: navigation)
                
            }
        }
        
    }
    
    @objc func wishListClicked(_ sender: UIButton)
    {
        if let nav = self.sideDrawerViewController?.mainViewController as? cedMageTabBar
        {
            
            if let navigation = nav.viewControllers![0] as? wooMageNavigation
            {
                navToWishlist(navigation: navigation)
            }
            if let navigation = nav.viewControllers![1] as? cedMageWishlistNavigation
            {
                navToWishlist(navigation: navigation)
            }
            if let navigation = nav.viewControllers![2] as? cedMageNotificationNavigation
            {
                navToWishlist(navigation: navigation)
            }
            if let navigation = nav.viewControllers![3] as? cedMageAccountNavigation
            {
                navToWishlist(navigation: navigation)
            }
        }
        
    }
    
    @objc func storeClicked(_ sender: UIButton)
    {
        /*self.Stores = [[String:String]]()
        cedMageLoaders.addDefaultLoader(me: self)
        User().getStores(controller: self) { (storeData) in
            cedMageLoaders.removeLoadingIndicator(me: self);
            self.Stores = storeData;
            self.showStores();
            //self.mainTable.reloadData();
        }*/
        self.Stores = [[String:String]]()
        cedMageLoaders.addDefaultLoader(me: self)
        User().getStores(controller: self) { (storeData) in
            cedMageLoaders.removeLoadingIndicator(me: self);
            self.Stores = storeData;
            self.showStores();
            //self.mainTable.reloadData();
        }
    }
    
    func showStores(){
        let actionsheet = UIAlertController(title: "Select Store".localized, message: nil, preferredStyle: .actionSheet)
        
        for buttons in self.Stores {
            actionsheet.addAction(UIAlertAction(title: buttons["name"], style: UIAlertAction.Style.default,handler: {
                action -> Void in
                let lang = buttons["id"]
                if lang?.lowercased() == "en".lowercased() || lang?.lowercased() == "en-US".lowercased() || lang?.lowercased() == "en_US".lowercased()
                {
                    
                    UserDefaults.standard.setValue("en", forKey: "wooAppLanguage")
                }
                else
                {
                    UserDefaults.standard.setValue(lang, forKey: "wooAppLanguage")
                }
                UserDefaults.standard.set(lang, forKey: "store_id")
                User().clearCartWishlist(controller: self, completion: { (status) in
                    if(status)
                    {
                        UserDefaults.standard.removeObject(forKey: "cart_id");
                        UserDefaults.standard.removeObject(forKey: "CartQuantity");
                        
                        (UIApplication.shared.delegate as! AppDelegate).changeLanguage()
                    }
                    else
                    {
                        self.view.makeToast("Unable to change store".localized, duration: 2.0, position: .center)
                    }
                })
            }))
            
        }
        actionsheet.addAction(UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel, handler: {
            action -> Void in
        }))
        if(UIDevice().model.lowercased() == "iPad".lowercased()){
           // actionsheet.popoverPresentationController?.sourceView = self.mainTable.cellForRow(at: IndexPath(row: 2, section: 0))
            actionsheet.popoverPresentationController?.sourceView = self.mainTable.cellForRow(at: IndexPath(row: 0, section: 2))
        }
        self.present(actionsheet, animated: true, completion: nil)
    }
    
    @objc func myOrdersClicked(_ sender: UIButton)
    {
        if let nav = self.sideDrawerViewController?.mainViewController as? cedMageTabBar
        {
            if let navigation = nav.viewControllers![0] as? wooMageNavigation
            {
                navToOrders(navigation: navigation)
                
            }
            if let navigation = nav.viewControllers![1] as? cedMageWishlistNavigation
            {
                navToOrders(navigation: navigation)
                
            }
            if let navigation = nav.viewControllers![2] as? cedMageNotificationNavigation
            {
                navToOrders(navigation: navigation)
                
            }
            if let navigation = nav.viewControllers![3] as? cedMageAccountNavigation
            {
                navToOrders(navigation: navigation)
                
            }
        }
        
    }
    
    @objc func myDownloadsClicked(_ sender: UIButton)
    {
        if let nav = self.sideDrawerViewController?.mainViewController as? cedMageTabBar
        {
            if let navigation = nav.viewControllers![0] as? wooMageNavigation
            {
                navToDownload(navigation: navigation)
                
            }
            if let navigation = nav.viewControllers![1] as? cedMageWishlistNavigation
            {
                navToDownload(navigation: navigation)
                
            }
            if let navigation = nav.viewControllers![2] as? cedMageNotificationNavigation
            {
                navToDownload(navigation: navigation)
                
            }
            if let navigation = nav.viewControllers![3] as? cedMageAccountNavigation
            {
                navToDownload(navigation: navigation)
                
            }
        }
    }
    
    @objc func notificationsClicked(_ sender:UIButton)
    {
        if let nav = self.sideDrawerViewController?.mainViewController as? cedMageTabBar
        {
            if let navigation = nav.viewControllers![0] as? wooMageNavigation
            {
                navToNotifications(navigation: navigation)
                
            }
            if let navigation = nav.viewControllers![1] as? cedMageWishlistNavigation
            {
                navToNotifications(navigation: navigation)
                
            }
            if let navigation = nav.viewControllers![2] as? cedMageNotificationNavigation
            {
                navToNotifications(navigation: navigation)
                
            }
            if let navigation = nav.viewControllers![3] as? cedMageAccountNavigation
            {
                navToDownload(navigation: navigation)
                
            }
        }
        
    }
    
    @objc func logoutClicked(_ sender: UIButton)
    {
        let confirmationAlert=UIAlertController(title: "", message: "Are you sure you want to logout..?".localized, preferredStyle: .alert)
        let yesAction=UIAlertAction(title: "Yes".localized, style: .default,handler: {
            alert -> Void in
            UserDefaults.standard.removeObject(forKey: "mageWooUser");
            UserDefaults.standard.removeObject(forKey: "cart_id");
            UserDefaults.standard.removeObject(forKey: "CartQuantity");
            self.updateBadge();
            sender.setTitle("Logout".localized, for: .normal);
            UserDefaults.standard.set(false, forKey: "mageWooLogin")
            
            //let navigation = self.sideDrawerViewController?.mainViewController as! wooMageNavigation
            if let nav = self.sideDrawerViewController?.mainViewController as? cedMageTabBar
            {
                nav.selectedIndex = 0;
                if let navigation = nav.viewControllers![0] as? wooMageNavigation
                {
                    self.homeButtonClicked(navigation: navigation)
                    
                }
                if let navigation = nav.viewControllers![1] as? cedMageWishlistNavigation
                {
                    self.homeButtonClicked(navigation: navigation)
                    
                }
                if let navigation = nav.viewControllers![2] as? cedMageNotificationNavigation
                {
                    self.homeButtonClicked(navigation: navigation)
                    
                }
                if let navigation = nav.viewControllers![3] as? cedMageAccountNavigation
                {
                    self.homeButtonClicked(navigation: navigation)
                    
                }
            }
            
            self.mainTable.reloadData();
            self.sideDrawerViewController?.toggleDrawer()
        })
        let cancel=UIAlertAction(title: "Cancel".localized, style: .destructive, handler: nil)
        confirmationAlert.addAction(yesAction)
        confirmationAlert.addAction(cancel)
        self.present(confirmationAlert, animated: true, completion: nil)
        return
    }
    
    func goToLogin(navigation: UINavigationController)
    {
        
        //let navigation = sideDrawerViewController?.mainViewController as! wooMageNavigation
        let viewControl = UIStoryboard(name: "mageWooLogin", bundle: nil).instantiateViewController(withIdentifier: "loginController") as! wooMageLogin
        navigation.pushViewController(viewControl, animated: true)
        self.sideDrawerViewController?.toggleDrawer()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0)
        {
            return 140
        }
        else if(indexPath.section == 1)
        {
            return 0
        }
            //indexPath.section == 1 ||
        else if( indexPath.section == 2)
        {
            return 50
        }
        else if(indexPath.section==3)
        {
            return 380;
        }
        return 70;
    }
    
    func categoryClicked(_ sender: UIButton)
    {
        if let nav = self.sideDrawerViewController?.mainViewController as? cedMageTabBar
        {
            if let navigation = nav.viewControllers![0] as? wooMageNavigation
            {
                let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageSubCategories") as! cedMageSubCategories
                vc.categoryId = "\(sender.tag)";
                
                navigation.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sideDrawerViewController?.toggleDrawer()
        if(indexPath.section == 2)
        {
            if let nav = self.sideDrawerViewController?.mainViewController as? cedMageTabBar
            {
                if(indexPath.row == maxCategoryNumber)
                {
                    
                    print(nav.viewControllers![0])
                    if let navigation = nav.viewControllers![0] as? wooMageNavigation
                    {
                        navToCategory(navigation: navigation)
                        
                    }
                    if let navigation = nav.viewControllers![1] as? cedMageWishlistNavigation
                    {
                        navToCategory(navigation: navigation)
                        
                    }
                    if let navigation = nav.viewControllers![2] as? cedMageNotificationNavigation
                    {
                        navToCategory(navigation: navigation);
                        
                    }
                    if let navigation = nav.viewControllers![3] as? cedMageAccountNavigation
                    {
                        navToCategory(navigation: navigation);
                        
                    }
                }
                else
                {
                    if let navigation = nav.viewControllers![0] as? wooMageNavigation
                    {
                        navToSubCategories(navigation: navigation, tag: indexPath.row)
                        
                    }
                    if let navigation = nav.viewControllers![1] as? cedMageWishlistNavigation
                    {
                        navToSubCategories(navigation: navigation, tag: indexPath.row)
                        
                    }
                    if let navigation = nav.viewControllers![2] as? cedMageNotificationNavigation
                    {
                        navToSubCategories(navigation: navigation, tag: indexPath.row)
                        
                    }
                    if let navigation = nav.viewControllers![3] as? cedMageAccountNavigation
                    {
                        navToSubCategories(navigation: navigation, tag: indexPath.row)
                        
                    }
                }
            }
        }
    }
    
    func navToCategory(navigation: UINavigationController)
    {
       let viewControl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mageWooMaincategory") as! mageWooMaincategory
        navigation.pushViewController(viewControl, animated: true);
        
        
        
//        let viewControl = TreeViewController()
//        navigation.pushViewController(viewControl, animated: true);
    }
    
    func navToSubCategories(navigation: UINavigationController, tag: Int)
    {
        let data=categoriesData[tag]
        let categoryId=data["categoryId"]
        let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageSubCategories") as! cedMageSubCategories
        vc.categoryId = categoryId!;
        navigation.pushViewController(vc, animated: true)
        /*let category = ["name":self.categoriesData[tag]["category_name"],"image":self.categoriesData[tag]["category_image"]];
        if let categData = category as? [String:String]{
            vc.categData = categData;
            
            vc.categoryId = categoryId!;
            navigation.pushViewController(vc, animated: true)
        }*/
        /*if(data["has_child"] == "true")
        {
            let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageSubCategories") as! cedMageSubCategories
            let category = ["name":self.categoriesData[tag]["category_name"],"image":self.categoriesData[tag]["category_image"]];
            if let categData = category as? [String:String]{
                vc.categData = categData;
                
                vc.categoryId = categoryId!;
                navigation.pushViewController(vc, animated: true)
            }
        }
        else
        {
            let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "categoryProducts") as! CategoryProductsView
            vc.categoryId = categoryId!;
            navigation.pushViewController(vc, animated: true)
        }*/
        
        /*cedMageLoaders.addDefaultLoader(me: self)
        let page = 1;
        User().subCategoryRequest(categoryId: categoryId!, page: page, controller: self) { (subcat) in
            cedMageLoaders.removeLoadingIndicator(me: self);
            let categoryData = subcat["category"]!;
            let productsData = subcat["product"]!;
            if categoryData.count==0 && productsData.count > 0{
                let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "categoryProducts") as! CategoryProductsView
                //vc.productsData=productsData
                vc.categoryId=self.categoriesData[tag]["categoryId"]!
                navigation.pushViewController(vc, animated: true)
            }
            else if(categoryData.count==0 && productsData.count == 0){
                navigation.view.makeToast("No products available", duration: 2.0, position: .bottom);
            }
            else
            {
                let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageSubCategories") as! cedMageSubCategories
                let category = ["name":self.categoriesData[tag]["category_name"],"image":self.categoriesData[tag]["category_image"]];
                if let categData = category as? [String:String]{
                    vc.categData = categData;
                    
                    vc.categoryId = categoryId!;
                    navigation.pushViewController(vc, animated: true)
                }
            }
        }*/
    }
    
    func navToProfile(navigation: UINavigationController)
    {
        self.sideDrawerViewController?.toggleDrawer()
        navigation.tabBarController?.selectedIndex = 3;
        /*if defaults.bool(forKey: "mageWooLogin") {
            let viewControl = UIStoryboard(name: "mageWooProfile", bundle: nil).instantiateViewController(withIdentifier: "editProfile") as! mageWooEditProfile
            navigation.pushViewController(viewControl, animated: true)
        }
        else{
            goToLogin(navigation: navigation);
        }*/
    }
    
    func navToDownload(navigation: UINavigationController)
    {
        if defaults.bool(forKey: "mageWooLogin") {
            let viewControl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mydownloads") as! cedMageMyDownloadView
            navigation.pushViewController(viewControl, animated: true)
            self.sideDrawerViewController?.toggleDrawer()
        }
        else{
            goToLogin(navigation: navigation);
        }
    }
    
    func navToNotifications(navigation: UINavigationController)
    {
        self.sideDrawerViewController?.toggleDrawer()
        navigation.tabBarController?.selectedIndex = 2;
        /*let viewControl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "notifications") as! mageWooNotifications
        navigation.pushViewController(viewControl, animated: true)*/
        
    }
    
    func emailClick(navigation: UINavigationController, sender: UIButton)
    {
        self.sideDrawerViewController?.toggleDrawer()
        if defaults.bool(forKey: "mageWooLogin") {
            UserDefaults.standard.removeObject(forKey: "mageWooUser");
            UserDefaults.standard.removeObject(forKey: "cart_id");
            UserDefaults.standard.removeObject(forKey: "CartQuantity");
            sender.setTitle("LOGIN/SIGNUP".localized, for: .normal);
            UserDefaults.standard.set(false, forKey: "mageWooLogin")
            mainTable.reloadData();
            navigation.popToRootViewController(animated: true);
            
        }
        else
        {
            goToLogin(navigation: navigation);
        }
    }
    
    func navToOrders(navigation: UINavigationController)
    {
        if defaults.bool(forKey: "mageWooLogin")
        {
            
            //let viewControl = UIStoryboard(name: "mageWooOrder", bundle: nil).instantiateViewController(withIdentifier: "orderList") as! wooMageOrderList
            let viewControl = UIStoryboard(name: "mageWooOrder", bundle: nil).instantiateViewController(withIdentifier: "cedMageOrderListing") as! cedMageOrderListing
            navigation.pushViewController(viewControl, animated: true)
            self.sideDrawerViewController?.toggleDrawer()
        }
        else
        {
            goToLogin(navigation: navigation);
        }
    }
    
    
    func navToWishlist(navigation: UINavigationController)
    {
        self.sideDrawerViewController?.toggleDrawer()
        navigation.tabBarController?.selectedIndex = 1;
        /*if defaults.bool(forKey: "mageWooLogin") {
            let viewControl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mageWishList") as! mageWooWishList
            navigation.pushViewController(viewControl, animated: true)
            self.sideDrawerViewController?.toggleDrawer()
        }
        else{
            goToLogin(navigation: navigation);
        }*/
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
