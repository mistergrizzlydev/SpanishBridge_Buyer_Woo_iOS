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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}
/*--edited10May
extension UIViewController{
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) -> Data {
        //        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return}
            //            print(response?.suggestedFilename ?? url.lastPathComponent)
            //            print("Download Finished")
        DispatchQueue.main.async() { () -> Void in
                
                return data;
            }
        }
        return Data();
    }
    
    
}
*/

//extension UIViewController{
//    func getDataFromUrl(urlString: URL, completion: (Data?, URLResponse?, Error?)->Void) {
//        URLSession.shared.dataTask(with: urlString) { data, respopnse, error in
//            completion(data, respopnse, error)
//        }.resume()
//    }
//
//    func downloadImage(url: URL) -> Data{
//        getDataFromUrl(urlString: url) { (data, response, error) in
//            guard let data = data , error == nil else { return nil}
//
//           // DispatchQueue.main.async { () -> Void in
//                return data
//            //}
//         //   return data
//        }
//    }
//
//}
