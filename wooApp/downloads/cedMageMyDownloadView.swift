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

class cedMageMyDownloadView: mageBaseViewController,UITableViewDelegate,UITableViewDataSource,URLSessionDownloadDelegate {
    
    @IBOutlet weak var emptyDownload: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var cedMageMyDownloads: UITableView!
    var downloadedOrder = [[String:String]]()
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        return session
    }()
    
    var activeDownloads = [String: Download]()
    var filename: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May  self.tracking(name: "download view");
        cedMageMyDownloads.delegate = self
        cedMageMyDownloads.dataSource = self
        getDownloadData();
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
        updateBadge();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    func getDownloadData()
    {
        downloadedOrder = [[String:String]]()
        var params = Dictionary<String, String>()
        if let user = User().getLoginUser() {
            params["user-id"] = user["userId"]
        }
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/fetch_downloadables",method: "POST", params:params, controller: self, completionHandler: {
            data,url,error in
            if let data = data {
                if let json = try? JSON(data: data){
                    print(json)
                    if(json["data"]["order"]["message"].stringValue == "No downloads available yet."){
                        if(self.downloadedOrder.count == 0){
                            //self.renderNoDataImage(view: self, imageName: "NoData")
                            self.emptyDownload.isHidden = false
                            self.cedMageMyDownloads.isHidden = true
                            return
                        }
                    }
                    else{
                        let downloadcount = json["data"]["order"]["data"].count
                        self.topLabel.setThemeColor()
                        self.topLabel.textColor = wooSetting.textColor;
                        
                        self.topLabel.text = "Total \(downloadcount) Products"
                        self.topLabel.cardView()
                        for result in json["data"]["order"]["data"].arrayValue {
                            //let status = result["status"].stringValue
                            let order_key = result["order_key"].stringValue;
                            let product_id = result["product_id"].stringValue;
                            let download_id = result["download_id"].stringValue;
                            let order_id = result["order_id"].stringValue
                            let link_title = result["file"]["name"].stringValue
                            let download_url = result["download_url"].stringValue
                            let title = result["product_name"].stringValue
                            let access_expires = result["access_expires"].stringValue;
                            //let date = result["date"].stringValue
                            let filename = result["download_name"].stringValue
                            let remaining_dowload = result["downloads_remaining"].stringValue
                            let products_obj = ["title":title,"link_title":link_title,"download_url":download_url,"order_id":order_id,"filename":filename,"remaining_dowload":remaining_dowload,"access_expires":access_expires,"order_key":order_key,"product_id":product_id,"download_id":download_id]
                            self.downloadedOrder.append(products_obj)
                        }
                        self.cedMageMyDownloads.reloadData()
                    }
                }
                
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "downloadCell") as! cedMageMydownloadcell
        let order = downloadedOrder[indexPath.row]
        var string =  " Order Id: ".localized + order["order_id"]!
        //string += "\n\n"+" Date: "+order["date"]!+"\n\n"
        string += " Title: ".localized + order["title"]!+"\n\n"+" Link Title: ".localized + order["link_title"]!+"\n\n"
        string += "\n\n"+" Access Expires on: ".localized + order["access_expires"]!+"\n\n"
        cell.textView.text = "\(string)\n\n"+" Remaining Downloads:".localized + order["remaining_dowload"]!
        cell.textView.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        cell.clickToDownload.tag=indexPath.row;
        cell.clickToDownload.addTarget(self, action: #selector(cedMageMyDownloadView.ClickTodownload(sender:)), for: UIControl.Event.touchUpInside)
        cell.clickToDownload.setThemeColor()
        cell.clickToDownload.titleLabel?.font = mageWooCommon.setCustomFont(type: .bold, size: 17)
        cell.clickToDownload.setTitleColor(wooSetting.textColor, for: .normal);
        
        cell.clickToDownload.layer.cornerRadius=7;
        cell.clickToDownload.setTitle("Click Here To Download".localized, for: UIControl.State.normal)
        
        return cell
    }
    
    
    
    @objc func ClickTodownload(sender:UIButton){
        var params = Dictionary<String, String>()
        params["product_id"] = self.downloadedOrder[sender.tag]["product_id"]
        params["order_key"] = self.downloadedOrder[sender.tag]["order_key"]
        params["download_id"] = self.downloadedOrder[sender.tag]["download_id"]
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/getdownloadlink",method: "POST", params:params, controller: self, completionHandler: {
            data,url,error in
            if let data = data {
                if let jsondata = try? JSON(data: data){
                    if(jsondata["data"]["status"].stringValue == "true")
                    {
                        let urlString = jsondata["data"]["download_url"].stringValue;
                        let url = URL(string: urlString)
                        var request = URLRequest(url:url!)
                        request.httpMethod = "GET"
                        request.setValue(wooSetting.headerKey, forHTTPHeaderField: "uid")
                        let download = Download(url: urlString,file: self.downloadedOrder[sender.tag]["filename"]!)
                        
                        self.filename = self.downloadedOrder[sender.tag]["filename"]
                        download.downloadTask = self.downloadsSession.downloadTask(with: request)
                        download.downloadTask?.resume()
                        download.isDownloading = true
                        let bgCView = UIView();
                        bgCView.tag=151;
                        bgCView.frame = UIScreen.main.bounds;
                        bgCView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight , UIView.AutoresizingMask.flexibleWidth];
                        bgCView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.5);
                        let filterbyView = ced_downloadView();
                        filterbyView.tag = 181;
                        filterbyView.progressView.progress = 0
                        
                        filterbyView.toplabel.setThemeColor()
                        filterbyView.toplabel.textColor = wooSetting.textColor;
                        filterbyView.backgroundColor = UIColor.black;
                        /*if #available(iOS 12.0, *) {
                            if(self.traitCollection.userInterfaceStyle == .dark)
                            {
                                filterbyView.toplabel.textColor = wooSetting.darkModeTextColor;
                            }
                        }*/
                        filterbyView.frame = CGRect(x:20, y:20, width:self.view.frame.width - 40, height:200)
                        filterbyView.center = self.view.center
                        bgCView.addSubview(filterbyView)
                        self.view.addSubview(bgCView);
                    }
                }
                
            }
        })
        
        /*let task = session.dataTask(with: request, completionHandler: {
            data,response,error in
            
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("Success: \(statusCode)")
                
                // This is your file-variable:
                // data
                 DispatchQueue.main.async{
                    cedMageLoaders.removeLoadingIndicator(me: self)
                    
                }
                
            }
            else {
                // Failure
                //print("Failure: %@", error?.localizedDescription);
            }
        })
        task.resume()*/
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.viewWithTag(151)?.removeFromSuperview()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let originalURL = downloadTask.originalRequest?.url?.absoluteString,
            let destinationURL = localFilePathForUrl(previewUrl: originalURL) {
            print("-\(originalURL)-")
            let baseUrl =  destinationURL.deletingLastPathComponent
            print("--dest--\(destinationURL)")
            let newurl =  baseUrl?.appendingPathComponent(filename)
            //print("--\(newurl)")
            DispatchQueue.main.async
                {
                    let view =  self.view.viewWithTag(181) as? ced_downloadView
                    view?.progressView.progress = 1
                    view?.downloadLabel.text = "Download Complete".localized
                    view?.downloadLabel.font = mageWooCommon.setCustomFont(type: .bold, size: 17)
                    self.view.makeToast(self.filename + " Download Complete.", duration: 1.5, position: .center, title: nil, image: nil, style: nil, completion: nil)
                    mageWooCommon.delay(delay: 2.0, closure: {
                        self.getDownloadData()
                    })
            }
            // 2
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(at: newurl!)
            } catch {
                // Non-fatal: file probably doesn't exist
            }
            do {
                try fileManager.copyItem(at: location, to: newurl!)
                print(location)
            } catch let error as NSError {
                print("Could not copy file to disk: \(error.localizedDescription)")
            }
        }
        
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString,
            let download = activeDownloads[downloadUrl] {
            // 2
            download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
            DispatchQueue.main.async
                {
                    let view =  self.view.viewWithTag(181) as? ced_downloadView
                    view?.progressView.progress =  download.progress
                    view?.downloadLabel.text = "Downloading...".localized
            }
        }
        
    }
    
    func localFilePathForUrl(previewUrl: String) -> NSURL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        if let url = NSURL(string: previewUrl), let lastPathComponent = url.lastPathComponent {
            let fullPath = documentsPath.appendingPathComponent(lastPathComponent)
            return NSURL(fileURLWithPath:fullPath)
        }
        return nil
    }
    
    
    func localFileExistsForTrack(track: String?) -> Bool {
        if let urlString = track, let localUrl = localFilePathForUrl(previewUrl: urlString) {
            var isDir : ObjCBool = false
            if let path = localUrl.path {
                return FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
            }
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = downloadedOrder[indexPath.row]["download_url"]
        if localFileExistsForTrack(track: url!) {
            if let url = URL(string: url!) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]),
                                              completionHandler: {
                                                (success) in
                                                print("\(success)")
                    })
                } else {
                     UIApplication.shared.openURL(url)
                }
            }
            
            //UIApplication.shared.openURL(URL(string: url!)!)
        }
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
