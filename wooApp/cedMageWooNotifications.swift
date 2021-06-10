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

class mageWooNotifications: mageBaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {

    @IBOutlet weak var emptyImageView: UIImageView!
    
    var notificationData = [[String: String]]();
    var selectedQty = "1"
    @IBOutlet weak var notificationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //--edited10May   self.tracking(name: "notifications");
        notificationTableView.delegate = self;
        notificationTableView.dataSource=self;
        loadData();
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = false;
        self.updateBadge();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    func loadData()
    {
        cedMageLoaders.addDefaultLoader(me: self)
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/customer_account/notificationcenter", method: "GET",  controller: self, completionHandler: {
            data,url,error in
            cedMageLoaders.removeLoadingIndicator(me: self)
            if let data = data {
                if let json  = try? JSON(data:data)
                {
                    print(json)
                    if(json["status"].stringValue == "200ok")
                    {
                        for notif in json["data"].arrayValue
                        {
                            self.notificationData.append(["title": notif["title"].stringValue, "image": notif["image"].stringValue, "message": notif["message"].stringValue, "link_to": notif["link_to"].stringValue, "link_to_data": notif["link_to_data"].stringValue, "id": notif["id"].stringValue, "status": notif["status"].stringValue]);
                        }
                    }
                }
                
            }
            self.notificationTableView.reloadData();
        })
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0
        {
           return 50
        }
        else
        {
           // return 150
            return 200
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if(notificationData.count==0)
        {
            emptyImageView.isHidden = false;
            tableView.isHidden = true;
        }
        else
        {
            tableView.isHidden = false;
            emptyImageView.isHidden = true;
            
        }
        return notificationData.count;
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notificationHead", for: indexPath)
            
            return cell
        }else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as? notificationCell {
                let notification = notificationData[indexPath.row]
                cell.titleLabel.text = notification["title"];
                cell.titleLabel.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
                cell.bodyLabel.text = notification["message"];
               cell.bodyLabel.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
                let imageUrl=notification["image"]
                if(imageUrl != "")
                {
                    cell.notificationImageView.sd_setImage(with: URL(string: imageUrl!), placeholderImage: UIImage(contentsOfFile: wooSetting.productPlaceholder))
                    /*if let userdefaults = UserDefaults.standard.value(forKey: "themeSettings") as? [String:String]
                    {
                        if let placeholderImage = userdefaults["ced_theme_product_placeholder_image"]
                        {
                            cell.notificationImageView.sd_setImage(with: URL(string: imageUrl!), placeholderImage: UIImage(url: URL(string: placeholderImage)))
                            
                        }
                        else
                        {
                            cell.notificationImageView.sd_setImage(with: URL(string: imageUrl!), placeholderImage: UIImage(named: "placeholder"))
                            
                        }
                        
                    }*/
                    
                }
                else
                {
                    cell.notificationImageView.image = UIImage(named: "placeholder")
                }
                
                cell.qtyView.productQty.text = "1"
                cell.qtyView.productQty.delegate = self
                cell.qtyView.superView.layer.cornerRadius=15
                cell.qtyView.incrementButton.clipsToBounds = true;
                cell.qtyView.superView.backgroundColor = .clear
                cell.qtyView.incrementButton.tag = indexPath.row
                cell.qtyView.decrementButon.tag = indexPath.row
                
                cell.qtyView.incrementButton.addTarget(self, action: #selector(incrementProductQty(_:)), for: .touchUpInside)
                cell.qtyView.decrementButon.addTarget(self, action: #selector(decrementProductQty(_:)), for: .touchUpInside)
                cell.addToCartButton.tag = indexPath.row
                cell.addToCartButton.addTarget(self, action: #selector(addTocart(sender:)), for: .touchUpInside)
                cell.addToCartButton.setThemeColor()
                cell.addToCartButton.setTitleColor(wooSetting.textColor, for: .normal)
                cell.addToCartButton.layer.cornerRadius = 5.0
                
                cell.notificationView.cardView()
                return cell;
            }
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1)
        {
            if(notificationData[indexPath.row]["link_to"] == "product")
            {
                let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
                viewControl.productId = notificationData[indexPath.row]["link_to_data"]!;
                self.navigationController?.pushViewController(viewControl, animated: true)
            }
            else if(notificationData[indexPath.row]["link_to"] == "category")
            {
                let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cedMageSubCategories") as! cedMageSubCategories
                vc.categoryId=notificationData[indexPath.row]["link_to_data"]!
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else if(notificationData[indexPath.row]["link_to"] == "website")
            {
                let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webController") as! mageHomeWebController
                vc.url=notificationData[indexPath.row]["link_to_data"]!;
                self.navigationController?.pushViewController(vc, animated: true)
            }
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

extension mageWooNotifications
{
    @objc func incrementProductQty(_ sender:UIButton){
        print("incrementProductQty")
        print(sender.tag)
        if let outerView = sender.superview?.superview?.superview as? ProductQtyView
        {
            //print(outerView.productQty.text)
            if(outerView.productQty.text == ""){
                outerView.productQty.text = String("1");
                return;
            }
            
            if(outerView.productQty.text != ""){
                var currentQty = Int(outerView.productQty.text!)!;
                currentQty = currentQty+1;
                
                outerView.productQty.text = String(currentQty);
            }
            selectedQty=outerView.productQty.text!
            print(selectedQty)
        }
    }
    
    @objc func decrementProductQty(_ sender:UIButton){
        print("decrementProductQty")
        print(sender.tag)
        if let outerView = sender.superview?.superview?.superview as? ProductQtyView
        {
            //print(outerView.productQty.text)
            if(outerView.productQty.text != "" && outerView.productQty.text != "1"){
                var currentQty = Int(outerView.productQty.text!)!;
                currentQty = currentQty-1;
                outerView.productQty.text = String(currentQty);
            }
            selectedQty=outerView.productQty.text!
            print(selectedQty)
            
        }
    }
    
    @objc func addTocart(sender:UIButton) {
        print("addTocart clicked")
        let index = sender.tag
        print(index)
       
        print("type = \(notificationData[index])")
        //        print(selectedQty)
        if(notificationData[index]["productType"]=="variable")
        {
            let data=notificationData[index]
            let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
            viewControl.productId = data["productId"]!
            self.navigationController?.pushViewController(viewControl, animated: true)
            return;
        }
        else
        {
            var params = Dictionary<String, String>()
            params["product_id"] = notificationData[index]["productId"]!
            params["qty"]        = selectedQty
            if let user = User().getLoginUser() {
                params["customer_id"] = user["userId"]
            }
            else{
                if let cartId = UserDefaults.standard.value(forKey: "cart_id")
                {
                    params["cart_id"] = cartId as? String
                }
            }
            
            mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/addtocart",method: "POST", params:params, controller: self, completionHandler: {
                data,url,error in
                if let data = data {
                    if let json  = try? JSON(data:data)
                    {
                        print(json)
                        if(json["cart_id"]["success"].stringValue == "true")
                        {
                            self.view.makeToast(json["cart_id"]["message"].stringValue, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                            UserDefaults.standard.setValue(json["cart_id"]["cart_id"].stringValue, forKey: "cart_id")
                            if let cartCount = UserDefaults.standard.value(forKey: "CartQuantity") as? String
                            {
                                let qtyCount = Int(cartCount)! + Int(json["cart_id"]["items_count"].stringValue)!;
                                UserDefaults.standard.setValue(String(qtyCount), forKey: "CartQuantity");
                            }
                            else
                            {
                                let qtyCount = json["cart_id"]["items_count"].stringValue;
                                UserDefaults.standard.setValue(qtyCount, forKey: "CartQuantity");
                            }
                            UserDefaults.standard.synchronize()
                            self.updateBadge();
                        }
                        else
                        {
                            self.view.makeToast(json["cart_id"]["message"].stringValue, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                        }
                    }
                }
            })
        }
    }
}

