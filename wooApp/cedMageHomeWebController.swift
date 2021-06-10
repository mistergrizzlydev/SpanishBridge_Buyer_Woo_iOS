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

class mageHomeWebController: mageBaseViewController,WKScriptMessageHandler, WKNavigationDelegate {

    var notificationCheck = false;
    //@IBOutlet weak var webView: UIWebView!
    var url=""
    var webView = WKWebView()
    required init?(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRect.zero)
        super.init(coder: aDecoder)
        self.webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May    self.tracking(name: "WebView")
        let temp=URL(string: url)
        let myRequest = URLRequest(url: temp!)
        let webconfgi = WKWebViewConfiguration()
        webconfgi.userContentController.add(self,                                                                    name: "redir")
        
        let bounds = self.view.bounds
        let toplayoutguide = self.navigationController!.view.frame.origin.y ;
        let frame  = CGRect(x: 0, y: toplayoutguide, width: bounds.width, height: bounds.height)
        webView = WKWebView(frame: frame, configuration: webconfgi)
        webView.load(myRequest)
        self.view.addSubview(webView)
        webView.navigationDelegate = self
        cedMageLoaders.addDefaultLoader(me: self)
        
        /*webView.delegate=self
        webView.loadRequest(myRequest)*/
        // Do any additional setup after loading the view.
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
