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

class mageWooAddReviews: mageBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var reviewTableView: UITableView!
    var reviewRelatedData = [String:String]();
    var starButtons = [UIButton]();
    var rating = "0";
    var productId = String();
    var dataLoaded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May      self.tracking(name: "add reviews");
        reviewTableView.delegate=self;
        reviewTableView.dataSource=self;
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(reviewRelatedData["enable_star_review"] == "no")
        {
            if(section == 1)
            {
                return 0;
            }
        }
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section==0)
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "headingCell", for: indexPath) as? mageAddReviewCell
            {
                return cell;
            }
        }
        else if(indexPath.section==1)
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "starRatings", for: indexPath) as? mageAddReviewCell
            {
                if(dataLoaded == false)
                {
                    for i in 1..<6
                    {
                        let starView = starRatingView();
                        cell.ratingStackView.addArrangedSubview(starView);
                        starView.starButton.addTarget(self, action: #selector(starButtonClicked(_:)), for: .touchUpInside)
                        starView.starButton.tag=i
                        starButtons.append(starView.starButton)
                        
                    }
                    dataLoaded=true;
                }
                return cell;
            }
        }
        else if(indexPath.section==2)
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "fieldCell", for: indexPath) as? mageAddReviewCell
            {
                cell.email.tag=10;
                cell.name.tag=11;
                cell.review.tag=12;
                if let _ = User().getLoginUser() {
                    cell.email.isHidden = true;
                    cell.name.isHidden = true;
                }
                return cell;
            }
        }
        else if(indexPath.section==3)
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as? mageAddReviewCell
            {
                cell.writeAReviewButton.addTarget(self, action: #selector(writeReviewClicked(_:)), for: .touchUpInside)
                cell.writeAReviewButton.setThemeColor();
                cell.writeAReviewButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .bold, size: 17)
                cell.writeAReviewButton.setTitleColor(wooSetting.textColor, for: .normal);
                /*if #available(iOS 12.0, *) {
                    if(traitCollection.userInterfaceStyle == .dark){
                        cell.writeAReviewButton.setTitleColor(wooSetting.darkModeTextColor, for: .normal);
                    }
                }*/
                return cell;
            }
        }
        return UITableViewCell();
    }
    
    @objc func starButtonClicked(_ sender: UIButton)
    {
        let tag = sender.tag;
        rating=String(tag)
        for button in starButtons
        {
            if(button.tag == tag)
            {
                for x in starButtons
                {
                    if(x.tag <= tag)
                    {
                        x.setImage(UIImage(named: "StarFilled"), for: .normal);
                    }
                    else
                    {
                        x.setImage(UIImage(named: "StarEmpty"), for: .normal);
                    }
                }
            }
        }
    }
    
    @objc func writeReviewClicked(_ sender: UIButton)
    {
        if(reviewRelatedData["enable_star_review_required"]=="yes" && rating == "0")
        {
            self.view.makeToast("Please provide rating".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            return;
        }
        
        let email = (self.view.viewWithTag(10) as? SkyFloatingLabelTextField)?.text
        let name = (self.view.viewWithTag(11) as? SkyFloatingLabelTextField)?.text
        let review = (self.view.viewWithTag(12) as? SkyFloatingLabelTextField)?.text
        if(review == "")
        {
            self.view.makeToast("Required fields cannot be blank".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            return;
        }
        
        var params = Dictionary<String, String>()
        if(reviewRelatedData["enable_star_review"] == "yes")
        {
            params["rating"] = rating;
        }
        params["product-id"] = productId
        params["message"] = review;
        if let user = User().getLoginUser() {
            
            params["customer_id"] = user["userId"]
        }
        else
        {
            if(email == "" || name == "")
            {
                self.view.makeToast("Required fields cannot be blank".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                return;
            }
            if(!isValidEmail(testStr: email!))
            {
                self.view.makeToast("Email is invalid".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                return;
            }
            params["email"] = email;
            params["name"] = name;
        }
        cedMageLoaders.addDefaultLoader(me: self)
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/productreview",method: "POST", params:params, controller: self, completionHandler: {
            data,url,error in
            if let data = data {
                cedMageLoaders.removeLoadingIndicator(me: self);
                if let json  = try? JSON(data:data)
                {
                    print(json)
                    if(json["status"].stringValue == "200ok")
                    {
                        self.view.makeToast(json["message"].stringValue, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                        mageWooCommon.delay(delay: 2.0, closure: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                    else
                    {
                        self.view.makeToast(json["message"].stringValue, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                    }
                }
                
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section==0)
        {
            return 50
        }
        else if(indexPath.section==1)
        {
            return 90
        }
        else if(indexPath.section==2)
        {
            if let _ = User().getLoginUser() {
                return 55
            }
            return 165
        }
        return 50
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

