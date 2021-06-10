//
//  cedMageWishlistNavigation.swift
//  wooApp
//
//  Created by cedcoss on 24/01/18.
//  Copyright © 2018 MageNative. All rights reserved.
//

import UIKit

class cedMageWishlistNavigation: wooMageNavigation {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "mageWooLogin") {
            let viewControl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mageWishList") as! mageWooWishList                 
            let vc = [viewControl]
            self.setViewControllers(vc, animated: false)
        }
        else{
            let viewControl = UIStoryboard(name: "mageWooLogin", bundle: nil).instantiateViewController(withIdentifier: "loginController") as! wooMageLogin
            let vc = [viewControl]
            self.setViewControllers(vc, animated: false)
        }
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
