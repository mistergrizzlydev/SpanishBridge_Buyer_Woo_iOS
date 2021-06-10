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

class mageWooReviews: mageBaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var reviewTableView: UITableView!
    var reviewRelatedData = [String:String]()
    var reviewData = [[String:String]]()
    var starButtons = [UIButton]()
    var productId = String();
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May    self.tracking(name: "review list");
        reviewTableView.delegate=self;
        reviewTableView.dataSource=self;
        fetchReviewData()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
    }
    
    func fetchReviewData()
    {
        var params = Dictionary<String, String>()
        params["product-id"] = productId
        var userId = "";
        if let user = User().getLoginUser() {
            userId = user["userId"]!
            params["user-id"] = user["userId"]
        }
        cedMageLoaders.addDefaultLoader(me: self)
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/fetchproductreview",method: "POST", params:params, controller: self, completionHandler: {
            data,url,error in
            if let data = data {
                cedMageLoaders.removeLoadingIndicator(me: self);
                if let json  = try? JSON(data:data)
                {
                    print(json)
                    if(json["status"].stringValue == "200Ok")
                    {
                        if(json["product_data"]["enable-review"].stringValue == "yes")
                        {
                            let prod = json["product_data"];
                            self.reviewRelatedData["enable_review"] = prod["enable-review"].stringValue;
                            self.reviewRelatedData["enable_star_review"] = prod["enable-star-review"].stringValue;
                            self.reviewRelatedData["enable_star_review_required"] = prod["enable-star-review-required"].stringValue
                            self.reviewRelatedData["only_verified_review"] = prod["only-verified-review"].stringValue
                            self.reviewRelatedData["review_logged_in"] = prod["review_logged_in"].stringValue;
                            self.reviewRelatedData["customer_bought"] = "false";
                            if(userId != "")
                            {
                                self.reviewRelatedData["customer_bought"]=prod["customer-bought"].stringValue;
                            }
                            //var x = 0;
                            for review in json["product_data"]["review-data"].arrayValue
                            {
                                if(review["comment_approved"] == "1")
                                {
                                    self.reviewData.append(["comment_id":review["comment_ID"].stringValue, "comment_author":review["comment_author"].stringValue, "comment_author_email":review["comment_author_email"].stringValue,"comment_approved":review["comment_approved"].stringValue, "comment_date":review["comment_date"].stringValue, "rating": review["rating"].stringValue, "user_id":review["user_id"].stringValue, "comment_content": review["comment_content"].stringValue]);
                                    
                                    
                                    
                                }
                                //x += 1;
                                
                            }
                        }
                        if(self.reviewData.count == 0)
                        {
                            self.view.makeToast("No reviews found".localized, duration: 2.0, position: .center);
                        }
                    }
                }
                
            }
            self.reviewTableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3;
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
            if(self.reviewRelatedData["only_verified_review"] == "yes" && self.reviewRelatedData["customer_bought"] == "no")
            {
                return 0;
            }
        }
        if(section == 2)
        {
            return reviewData.count;
        }
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section==0)
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "writeReviewCell", for: indexPath) as? mageReviewCell
            {
                cell.writeAReviewButton.addTarget(self, action: #selector(goToWriteReview(_:)), for: .touchUpInside)
                cell.writeAReviewButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .bold, size: 16)
                cell.writeAReviewButton.setThemeColor();
                cell.writeAReviewButton.setTitleColor(wooSetting.textColor, for: .normal);
                
                /*if #available(iOS 12.0, *) {
                    if(traitCollection.userInterfaceStyle == .dark)
                    {
                        cell.writeAReviewButton.setTitleColor(wooSetting.darkModeTextColor, for: .normal);
                    }
                }*/
                return cell;
            }
        }
        else if(indexPath.section==1)
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "headingCell", for: indexPath) as? mageReviewCell
            {
                return cell;
            }
        }
        else if(indexPath.section==2)
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "fieldsCell", for: indexPath) as? mageReviewCell
            {
                cell.date.text = reviewData[indexPath.row]["comment_date"];
                cell.date.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
                cell.name.text = reviewData[indexPath.row]["comment_author"];
                cell.name.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
                cell.review.text = reviewData[indexPath.row]["comment_content"];
                cell.review.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
                if(reviewRelatedData["enable_star_review"] == "yes")
                {
                    let rating = Int(reviewData[indexPath.row]["rating"]!);
                    for subviews in cell.ratingStackView.arrangedSubviews
                    {
                        
                        subviews.removeFromSuperview()
                    }
                    for i in 1..<6
                    {
                        let starView = starRatingView(frame: CGRect(x: 0, y: 0, width: 25, height: 25));
                        cell.ratingStackView.addArrangedSubview(starView);
                        if(i<=rating!)
                        {
                            starView.starButton.setImage(UIImage(named: "StarFilled"), for: .normal)
                        }
                    }
                }
                cell.cellView.cardView();
                return cell;
            }
        }
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section==2)
        {
            return 165
        }
        return 60
    }
    
    @objc func goToWriteReview(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "addAReview") as? mageWooAddReviews
        vc?.productId = productId;
        vc?.reviewRelatedData = reviewRelatedData;
        self.navigationController?.pushViewController(vc!, animated: true);
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
