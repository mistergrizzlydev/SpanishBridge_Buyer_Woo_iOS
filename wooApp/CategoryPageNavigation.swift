//
//  CategoryPageNavigation.swift
//  wooApp
//
//  Created by cedcoss on 11/01/18.
//  Copyright © 2018 MageNative. All rights reserved.
//

import UIKit

class CategoryPageNavigation: wooMageNavigation {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        let viewControl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mageWooMaincategory") as! mageWooMaincategory
        let vc = [viewControl]
        self.setViewControllers(vc, animated: false)
        
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
