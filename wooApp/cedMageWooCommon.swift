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

class mageWooCommon: NSObject {
    static let singletonInstance = mageWooCommon();
    class func UIColorFromRGB( colorCode: String, alpha: Float = 1.0) -> UIColor {
        var colorCode = colorCode
        colorCode = colorCode.components(separatedBy: "#").last!
        let scanner = Scanner(string:colorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
    
    func getHomepage()->UIViewController{
        print("switch HomePage")
        if(wooSetting.selectedHomepage == .customTheme){
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mageWooAppSiteTheme") as! mageWooAppSiteTheme
            return vc;
        }
        else{
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainhomevc") as! mageWooHome
            return vc;
        }
    }
    

    
    func naviGate(fromViewControl:UIViewController,toStory:String,toViewControl:String) -> () {
//           let navigation = sideDrawerViewController?.mainViewController as! wooMageNavigation
//        let viewControl = UIStoryboard(name: toStory, bundle: nil).instantiateViewController(withIdentifier: toViewControl)
//        fromViewControl.navigationController?.pushViewController(viewControl, animated: true)
        
    }
    
    var selectedWidgetIndexe = NSInteger()
    
    /*
     Get data from plist file cedMage Common File
     */
    /*class func getInfoPlist(fileName:String?,indexString:NSString) ->AnyObject?{
        
        
        let path = Bundle.main.path(forResource: fileName, ofType: "plist")
        let storedvalues = NSDictionary(contentsOfFile: path!)
        let response: AnyObject? = storedvalues?.object(forKey: indexString) as AnyObject?
        return response
    }*/
    
    /*
     store the slider Index siglet
     */
    func storeParameterInteger(parameter:NSInteger){
        selectedWidgetIndexe = parameter
    }
    
    /*
     Return sigleton instance
     */
    func getInfo() -> NSInteger{
        return selectedWidgetIndexe
    }
    
    class func delay(delay:Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
        
    }
    //Mark: Get random Color
    class func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
    func setcartCount(tabBar:UITabBarController?){
        let cart_items = UserDefaults.standard.string(forKey: "CartQuantity")
        tabBar?.tabBar.items?[1].badgeValue = cart_items
    }
    
    
    enum fontType{
        case regular;
        case medium;
        case bold;
    }
    class func setCustomFont(type: fontType, size: CGFloat) -> UIFont
    {
        switch type {
        case .bold:
            guard let font = UIFont(name: "Roboto-Bold", size: size) else {
                return UIFont.boldSystemFont(ofSize: 14)
            }
            return font
        case .medium:
            guard let font = UIFont(name: "Roboto-Medium", size: size) else {
                return UIFont.boldSystemFont(ofSize: 14)
            }
            return font
        default:
            guard let font = UIFont(name: "Roboto-Regular", size: size) else {
                return UIFont.boldSystemFont(ofSize: 14)
            }
            return font
        }
    }
    
    func createFolder(name:String)->String?{
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: String = paths[0]
        let dataPath = documentsDirectory.appending(name)
        print("**\(dataPath)")
        
        do {
            try FileManager.default.createDirectory(atPath: dataPath , withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        let writePath = dataPath.appending("/test.png")
        do { try UIImage(named: "login")!.pngData()?.write(to: URL(fileURLWithPath:writePath), options: NSData.WritingOptions.completeFileProtectionUnlessOpen)
        }
        catch{
            
        }
        return dataPath
        
    }
    func reSizeImageAccording2View(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width:size.width * heightRatio, height:size.height * heightRatio)
        } else {
            newSize = CGSize(width:size.width * widthRatio,  height:size.height * widthRatio)
        }
        
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func addGradient(view:UIView){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [UIColor.green.cgColor, UIColor.black.cgColor,UIColor.blue.cgColor]
        gradient.locations = [0.0, 0.25, 0.75, 1.0]
        view.layer.addSublayer(gradient)
    }
    
    func translateAccordingToDevice(_ value:CGFloat)->CGFloat{
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            // iPad
            return value*1.5;
        }
        return value;
    }

}



extension UIView{
    public func cardView(){
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.gray.cgColor
        
        self.layer.shadowOpacity = 0.3
        self.layer.cornerRadius = 2
    
    }
    
}

extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    func setBottomBorder() {
        self.textColor=UIColor.white;
        self.backgroundColor = UIColor.clear
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: borderWidth)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}


extension UILabel {
    func setFont(fontFamily:String,fontSize:CGFloat){
        self.font = UIFont(name: fontFamily, size: fontSize)
        
    }
    
}
extension Dictionary{
    func convtToJson() -> NSString {
        do {
            let json = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            return NSString(data: json, encoding: String.Encoding.utf8.rawValue)!
        }catch {
            return ""
        }
    }
}
extension UIView{
    func setThemeColor(){
        self.backgroundColor = wooSetting.themeColor
    }
    func makeViewCircled(size:CGFloat){
        self.layer.cornerRadius = 0.5 * size;
    }
    
    
    func makeCornerRounded(cornerRadius:CGFloat){
        //self.layer.cornerRadius = translateAccordingToDevice(cornerRadius) ;
    }
    
    func makeCard(_ view:UIView,cornerRadius:CGFloat,color:UIColor,shadowOpacity:Float){
        let cornerRadius: CGFloat = cornerRadius
        let shadowColor: UIColor? = color
        let shadowOpacity: Float = shadowOpacity
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowColor = shadowColor?.cgColor
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = cornerRadius
        view.layer.cornerRadius = cornerRadius
        
    }
}


@IBDesignable class GradientView: UIView {
    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.black
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        
        topColor = mageWooCommon.UIColorFromRGB(colorCode: "#6c3483")
        (layer as! CAGradientLayer).locations = [0.0, 1.0]
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
    }
}
extension UIColor {
    public convenience init?(hexString: String) {
        var cString:String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines as NSCharacterSet as CharacterSet).uppercased();
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
        }
        if ((cString.count) != 6) {
            return nil;
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0;
        let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0;
        let b = CGFloat(rgbValue & 0x0000FF) / 255.0;
        let a =  CGFloat(1.0);
        self.init(red: r, green: g, blue: b, alpha: a)
        return
    }
}
extension UIViewController{
    public func showAlert(title: String, msg: String)
    {
        let alert=UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action=UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        return
    }
    public func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx);
        
        return (emailTest.evaluate(with: testStr));
        
    }
    public func isValidName(testStr:String) -> Bool
    {
        let RegEx = "[a-zA-Z ]*$";
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx);
        return Test.evaluate(with: testStr);
        
    }
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude));
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping;
        label.font = font;
        label.text = text;
        label.sizeToFit();
        return label.frame.height;
    }
    
    func updateBadge()
    {
        
        if UserDefaults.standard.value(forKey: "CartQuantity") != nil
        {
            let qty=UserDefaults.standard.value(forKey: "CartQuantity") as? String
            self.navigationItem.rightBarButtonItems?[0].badgeValue=qty
        }
        else
        {
            self.navigationItem.rightBarButtonItems?[0].badgeValue="0";
        }
    }

}
func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let debug = wooSetting.debug
    if(debug == "true"){
        Swift.print(items[0], separator:separator, terminator: terminator)
    }
}
extension SkyFloatingLabelTextField{
    public func decorateField(){
        
        if #available(iOS 13.0, *) {
            self.placeholderColor=UIColor.label
            self.textColor=UIColor.label
            self.lineColor=UIColor.label
            self.titleColor = UIColor.label
            self.selectedTitleColor = UIColor.label
            self.selectedLineColor = UIColor.label
        } else {
            self.placeholderColor=UIColor.black
            self.textColor=UIColor.black
            self.lineColor=UIColor.black
            self.titleColor = UIColor.black
            self.selectedTitleColor = UIColor.black
            self.selectedLineColor = UIColor.black
        }
    }
    
}
extension UITextField{
    public func makeCircledField()
    {
        self.layer.cornerRadius = 22
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColor.gray.cgColor
        /*if #available(iOS 12.0, *) {
            if(traitCollection.userInterfaceStyle == .dark){
                self.layer.borderColor = wooSetting.darkModeSubTextColor?.cgColor
            }
        }*/
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(10), height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.placeHolderColor = UIColor.gray
        //self.placeholderColor=UIColor.gray
        //self.selectedTitleColor=UIColor.gray
    }
}
extension UIViewController {
    func changeImageViewImageDirection(subviews: [UIView]) {
        if subviews.count > 0 {
            for subView in subviews {
                if (subView is UIImageView) && subView.tag < 0 {
                    let image = subView as! UIImageView
                    if let _img = image.image {
                        image.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImage.Orientation.upMirrored)
                    }
                }
                changeImageViewImageDirection(subviews: subView.subviews)
            }
        }
    }
}
class changeViewControlLayout: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //let appLanguage = NSLocale.current.languageCode;
        if(UserDefaults.standard.value(forKey: "wooAppLanguage") != nil)
        {
            let appLanguage = UserDefaults.standard.value(forKey: "wooAppLanguage") as? String
            print("common--")
            print(appLanguage)
            if appLanguage == "ar" {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                changeImageViewImageDirection(subviews: self.view.subviews)
                self.navigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
                //.setLanguage("en")
                
            }else{
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                self.navigationController?.navigationBar.semanticContentAttribute = .forceLeftToRight
                //Bundle.setLanguage("en")
            }
        }
        else
        {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            self.navigationController?.navigationBar.semanticContentAttribute = .forceLeftToRight
            //Bundle.setLanguage("en")
        }
        
    }
}

extension String {
    var capitalizingFirstLetter: String {
        let first = String(self.prefix(1)).capitalized
        let other = String(self.dropFirst())
        return first + other
    }
    
    var localized: String {
        
        var lang = ""
        if(UserDefaults.standard.value(forKey: "wooAppLanguage") != nil)
        {
            let applanguage = UserDefaults.standard.value(forKey: "wooAppLanguage") as? String
            if(applanguage?.lowercased() == "en")
            {
                lang = "en";
            }
            else
            {
                lang = applanguage!;
            }
        }
        else
        {
            lang = "en";
        }
        
        if let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        {
            let bundle = Bundle(path: path);
            return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "");
        }
        else
        {
            
            return self;
        }
        
        
    }
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}
extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.5) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2.0)
        rotateAnimation.duration = duration
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
extension UITabBar: Explodable{
    func fadeIn(_ duration: TimeInterval = 0.2, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UITabBar.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(_ duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UITabBar.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}
extension UINavigationController {
    func pushToViewController(_ viewController: UIViewController, animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    func popViewController(animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: true)
        CATransaction.commit()
    }
    
    func popToViewController(_ viewController: UIViewController, animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popToViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    func popToRootViewController(animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popToRootViewController(animated: animated)
        CATransaction.commit()
    }
}
