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

import Foundation

//Mark : APP SERVER Settings baseUrls and basic app dynamic settings
struct wooSetting {
//    static let baseUrl = "https://yourwine.ie/wp-json/"
//    static let headerKey = "9d2b27b35f0724fee9456f878e90fe"
    static let baseUrl = "https://myspanishbridge.com/wp-json/"
   static let headerKey = "mobiconnect123"
    static var themeColor = UIColor(hexString: "#9C5D90")
    //static var darkModeThemeColor = "#85c1e9"
    static var textColor = UIColor(hexString: "#FFFFFF");
    static var subTextColor = UIColor(hexString: "#7a4770");
    static var bartintColor = UIColor(hexString: "#9C5D90")
    static var tintColor = UIColor(hexString: "#FFFFFF")
    /*static var darkModeTextColor = UIColor(hexString: "#000000")
    static var darkModeSubTextColor = UIColor(hexString: "#FFFFFF")*/
    static let trackingId = "UA-115300483-1"
    static let debug = "true"
    static var bannerPlaceholder = ""
    static var categoryPlaceholder = ""
    static var productPlaceholder = ""
    static var selectedHomepage: HomepageType{
        if(UserDefaults.standard.value(forKey: "selectedTheme") == nil){
            return .defaultTheme
        }
        else{
            if let val = UserDefaults.standard.value(forKey: "selectedTheme") as? String{
                if(val == "default"){
                    return .defaultTheme
                }
                else{
                    return .customTheme
                }
            }
        }
        return .defaultTheme
    }
}

enum HomepageType{
    case defaultTheme
    case customTheme
}
