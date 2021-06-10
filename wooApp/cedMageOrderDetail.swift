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

class wooMageOrderDetail: mageBaseViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var orderTableView: UITableView!
    var orderId = String();
    var orderData = [[String:String]]();
    var currency = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May   self.tracking(name: "Order Detail");
        orderTableView.delegate=self;
        orderTableView.dataSource=self;
        getData();
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        updateBadge();
        self.tabBarController?.tabBar.isHidden = false;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    func getData()
    {
        var params = Dictionary<String, String>()
        if let user = User().getLoginUser() {
            params["user-id"] = user["userId"]
        }
        params["order-id"] = orderId;
        cedMageLoaders.addDefaultLoader(me: self);
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/fetch_user_ordersdetails",method: "POST", params:params, controller: self, completionHandler: {
            data,url,error in
            if let data = data {
                cedMageLoaders.removeLoadingIndicator(me: self);
                if let json  = try? JSON(data:data)
                {
                    print(json)
                    if(json["status"].stringValue == "200ok")
                    {
                        for i in 0..<(json["orders-data"]["order-items"].count)
                        {
                            var order = [String:String]();
                            for(key,value) in json["orders-data"]["order-items"][i]
                            {
                                order[key]=value.stringValue;
                            }
                            self.orderData.append(order);
                        }
                        self.currency = json["orders-data"]["currency_symbol"].stringValue
                        self.orderTableView.reloadData();
                    }
                }
                
            }
        })

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(orderData)
        return orderData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "orderproductcell", for: indexPath) as? OrderProductCell
        {
            cell.img.sd_setImage(with: URL(string: orderData[indexPath.row]["item-image"]!), placeholderImage: UIImage(contentsOfFile: wooSetting.productPlaceholder))
            cell.name.text=orderData[indexPath.row]["item-name"];
            cell.name.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
            let currentRatio = Double (orderData[indexPath.row]["item-total"]!)!
            cell.price.text = currency + String(format: "%.2f", currentRatio)
            //cell.price.text=currency+orderData[indexPath.row]["item-total"]!;
            cell.price.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
            cell.quantity.text="Quantity:"+orderData[indexPath.row]["item-qty"]!
            cell.quantity.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
            cell.orderProductView.cardView();
            return cell;
        }
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data=orderData[indexPath.row]
        let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
        viewControl.productId = data["product-id"]!
        self.navigationController?.pushViewController(viewControl, animated: true)
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
