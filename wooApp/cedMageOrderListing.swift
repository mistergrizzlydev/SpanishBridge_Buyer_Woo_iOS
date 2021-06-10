//
//  cedMageOrderListing.swift
//  wooApp
//
//  Created by cedcoss on 24/02/18.
//  Copyright © 2018 MageNative. All rights reserved.
//

import UIKit

class cedMageOrderListing: mageBaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var noDataImageView: UIImageView!
    var currentPage = 1;
    var orderListData = [[String:String]]();
    var openFlag = [Bool]();
    var flag=false
    var no_data=false;
    @IBOutlet weak var mainTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May   self.tracking(name: "Order Listing")
        mainTable.delegate=self;
        mainTable.dataSource=self;
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if no_data==false
        {
            if flag==true{
                flag=false
                currentPage += 1
                getData()
            }
        }
        
        
    }
    
    func getData()
    {
        var params = Dictionary<String, String>()
        if let user = User().getLoginUser() {
            params["user-id"] = user["userId"]
        }
        params["current_page"] = String(currentPage);
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/fetch_user_orderslist",method: "POST", params:params, controller: self, completionHandler: {
            data,url,error in
            if let data = data {
                if let json  = try? JSON(data:data){
                    print(json)
                    if(json["status"].stringValue == "200ok")
                    {
                        for i in 0..<(json["orders"].count)
                        {
                            var order = [String:String]();
                            for(key,value) in json["orders"][i]
                            {
                                order[key]=value.stringValue;
                                self.openFlag.append(false)
                            }
                            self.orderListData.append(order);
                        }
                        self.mainTable.reloadData();
                        self.noDataImageView.isHidden=true;
                        //self.currentPage += 1;
                        if(self.orderListData.count==0)
                        {
                            self.no_data=true;
                            self.noDataImageView.isHidden = false;
                            self.mainTable.isHidden=true;
                        }
                    }
                    else
                    {
                        self.no_data=true;
                        if(self.currentPage==1)
                        {
                            self.noDataImageView.isHidden = false;
                            self.mainTable.isHidden=true;
                        }
                    }
                }
                
            }
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section==1)
        {
            return orderListData.count;
        }
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0)
        {
            if let cell = mainTable.dequeueReusableCell(withIdentifier: "orderHeadingCell", for: indexPath) as? orderListCell
            {
                
                return cell;
            }
        }
        else if(indexPath.section==1)
        {
            if let cell = mainTable.dequeueReusableCell(withIdentifier: "orderListCell", for: indexPath) as? orderListCell
            {
                cell.orderDateLabel.text = orderListData[indexPath.row]["order-date"]!;
                cell.orderDateLabel.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
                
                cell.orderNoLabel.textColor = wooSetting.themeColor
                
                cell.orderNoLabel.text = orderListData[indexPath.row]["order-number"]!;
                cell.orderNoLabel.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
                cell.statusLabel.text = orderListData[indexPath.row]["order-status"]!;
                cell.statusLabel.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
                cell.amountLabel.text = orderListData[indexPath.row]["currency"]!+orderListData[indexPath.row]["order-total"]!;
                cell.amountLabel.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
                cell.viewButton.tag = indexPath.row;
                cell.viewButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .bold, size: 17)
                cell.viewButton.setTitleColor(wooSetting.themeColor, for: .normal)
                
                cell.viewButton.addTarget(self, action: #selector(navigateToOrderDetail(_:)), for: .touchUpInside)
                if(!openFlag[indexPath.row])
                {
                    cell.bottomView.isHidden = true;
                }
                else
                {
                    cell.bottomView.isHidden = false;
                }
                cell.cardView();
                return cell;
            }
        }
        return UITableViewCell();
    }
    
    @objc func navigateToOrderDetail(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "orderitemslist") as? wooMageOrderDetail
        vc?.orderId = orderListData[sender.tag]["order-number"]!;
        self.navigationController?.pushViewController(vc!, animated: true);
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.section==1)
        {
            openFlag[indexPath.row] = !openFlag[indexPath.row]
            let indexPath = IndexPath(item: indexPath.row, section: 1)
            self.mainTable.beginUpdates()
            mainTable.reloadRows(at: [indexPath], with: .top)
            self.mainTable.endUpdates()
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section==1)
        {
            if(openFlag[indexPath.row])
            {
                return 190;
            }
            return 90;
            
        }
        return 50;
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
