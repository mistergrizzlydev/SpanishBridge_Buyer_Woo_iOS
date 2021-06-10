//
//  cedMageStore.swift
//  wooApp
//
//  Created by cedcoss on 18/04/18.
//  Copyright © 2018 MageNative. All rights reserved.
//

import UIKit

class cedMageStore: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    var Stores = [[String:String]]()
    @IBOutlet weak var mainTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        topLabel.backgroundColor = wooSetting.themeColor
        /*if #available(iOS 12.0, *) {
            if(traitCollection.userInterfaceStyle == .dark){
                topLabel.backgroundColor = UIColor(hexString: wooSetting.darkModeThemeColor)
            }
        }*/
        mainTable.delegate = self;
        mainTable.dataSource = self;
        self.Stores = [[String:String]]()
        cancelButton.clipsToBounds = true;
        cancelButton.backgroundColor = UIColor.white;
        cancelButton.layer.cornerRadius = (cancelButton.frame.width)/2;
        
        cancelButton.addTarget(self, action: #selector(dismissButtonClicked(_:)), for: .touchUpInside);
        cedMageLoaders.addDefaultLoader(me: self)
        User().getStores(controller: self) { (storeData) in
            cedMageLoaders.removeLoadingIndicator(me: self);
            self.Stores = storeData;
            self.mainTable.reloadData();
        }
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cedMageStoreCell") as? cedMageStoreCell
        {
            cell.storeName.text = self.Stores[indexPath.row]["name"];
            cell.storeName.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
            cell.storeImageView.image = UIImage(named: "unchecked");
            if let id = UserDefaults.standard.value(forKey: "store_id") as? String
            {
                if(self.Stores[indexPath.row]["id"] == id)
                {
                    cell.storeImageView.image = UIImage(named: "checked");
                }
            }
            return cell;
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lang = self.Stores[indexPath.row]["id"]
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
            self.view.viewWithTag(1234)?.removeFromSuperview()
            self.removeFromParent()
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Stores.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    @objc func dismissButtonClicked(_ sender: UIButton)
    {
        
        
        //self.willMove(toParentViewController: nil)
        self.view.viewWithTag(1234)?.removeFromSuperview()
        self.removeFromParent()
        //(UIApplication.shared.delegate as! AppDelegate).changeLanguage()
        
        //NotificationCenter.default.post(name: NSNotification.Name("loadDrawerAgain"),object: nil);
        
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
