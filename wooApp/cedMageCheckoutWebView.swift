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
import WebKit
class checkoutWebView: mageBaseViewController,WKScriptMessageHandler, WKNavigationDelegate {
    
    var webView = WKWebView()
    var url=URL(string: "")
    required init?(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRect.zero)
        super.init(coder: aDecoder)
        self.webView.navigationDelegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateBadge();
        loadPage();
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    func loadPage()
    {
        let request = URLRequest(url: url!)
        /*let requestHeader = cedMage.getInfoPlist(fileName:"cedMage",indexString: "requestheader") as! String
        request.setValue(requestHeader, forHTTPHeaderField: "Mobiconnectheader")*/
        let webconfgi = WKWebViewConfiguration()
        webconfgi.userContentController.add(self,                                                                    name: "redir")
        
        let bounds = self.view.bounds
        let toplayoutguide = self.navigationController!.view.frame.origin.y ;
        let frame  = CGRect(x: 0, y: toplayoutguide, width: bounds.width, height: bounds.height)
        webView = WKWebView(frame: frame, configuration: webconfgi)
        webView.load(request)
        self.view.addSubview(webView)
        webView.navigationDelegate = self
        cedMageLoaders.addDefaultLoader(me: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        cedMageLoaders.removeLoadingIndicator(me: self)
    }
    
    func userContentController(_ userContentController:
        WKUserContentController,
                               didReceive message: WKScriptMessage) {
        print(message.body)
        if(message.body as? String == "Continue Shopping"){
            
            var params = Dictionary<String,String>();
            if let user = User().getLoginUser() {
                params["customer_id"] = user["userId"]
            }
            else{
                if let cartId = UserDefaults.standard.value(forKey: "cart_id")
                {
                    params["cart_id"] = cartId as? String
                }
            }
            cedMageLoaders.addDefaultLoader(me: self);
            mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/empty_paypal_cart",method: "POST", params:params, controller: self, completionHandler: {
                data,url,error in
                if let data = data {
                    cedMageLoaders.removeLoadingIndicator(me: self);
                    if let json  = try? JSON(data:data){
                        print(json)
                        if(json["success"].stringValue == "true")
                        {
                            UserDefaults.standard.removeObject(forKey: "cart_id")
                            UserDefaults.standard.setValue("0", forKey: "CartQuantity")
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "orderCompletion") as? orderCompletion
                            self.navigationController?.pushViewController(vc!, animated: true);
                            
                        }
                        else
                        {
                            self.view.makeToast("Some error occured".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                        }
                    }
                    
                    
                }
            })
        }
        else if(message.body as? String == "Cancelled Redirecting to Cart")
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "orderFailed") as? orderFailed
            self.navigationController?.pushViewController(vc!, animated: true);
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
