//
//  cedMageTabBar.swift
//  wooApp
//
//  Created by cedcoss on 25/01/18.
//  Copyright © 2018 MageNative. All rights reserved.
//

import UIKit

class cedMageTabBar: UITabBarController, UITabBarControllerDelegate {
   
    var titleArray = ["Home","Wishlist","Notification","Account","More"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self;
        /*for index in 0..<self.viewControllers!.count{
            self.viewControllers?[index].title = titleArray[index].localized
        }*/
        //self.tabBar.barTintColor = wooSetting.themeColor
        if #available(iOS 13.0, *) {
            self.tabBar.barTintColor = UIColor.systemBackground
        } else {
            self.tabBar.barTintColor = UIColor.white;
        };
        self.tabBar.tintColor = wooSetting.themeColor;
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(self.viewControllers?.count != 5)
        {
            let item1 = cedMageSideDrawer()
            let icon1 = UITabBarItem(title: "More", image: UIImage(named: "more"), selectedImage: UIImage(named: "more"))
            item1.tabBarItem = icon1
            //let controllers = [item1]  //array of the root view controllers displayed by the tab bar interface
            self.viewControllers?.append(item1)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.title == "More")
        {
            self.sideDrawerViewController?.toggleDrawer();
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController == tabBarController.viewControllers?[4] {
            return false
        } else {
            return true
        }
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

