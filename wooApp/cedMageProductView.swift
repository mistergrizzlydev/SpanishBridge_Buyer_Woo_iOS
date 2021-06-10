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
import SDWebImage
import ImageSlideshow
import WebKit

class mageWooProductView: mageBaseViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate, UITextFieldDelegate, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet weak var buyNow: UIButton!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var productTable: UITableView!
    var descCheck = 0;
    var longWebViewFlag = false
    var shortWebViewFlag = false
    var wishlistCheck = "no"
    var productId = String()
    var recentlyArray = [String]()
    var productData = [String:String]()
    var productColor = [String]();
    var productSize = [String]();
    var isVariable = false;
    var productOptionsData = [String:JSON]();
    var qtyView=ProductQtyView()
    var productPrice=UILabel()
    var stackView=UIStackView()
    var bounds = UIScreen.main.bounds;
    var selectedQty = "1";
    var imagedatasource=[SDWebImageSource]()
    var dropDown = DropDown();
    var optionSelected = [String:String]();
    var prodName = String();
    var prodRegularPrice = String();
    var prodSellPrice = String();
    var imageData=[SDWebImageSource]()
    var imageUrl = String();
    var prodImage = String();
    var variationId = String();
    var variationData = [[String:JSON]]();
    var colorButtons = [UIButton]();
    var sizeButtons = [UIButton]();
    var checkStock = false;
    var descriptionHeight = CGFloat(0);
    var available = true;
    var relatedData = [[String:String]]()
    var enableReview = "no";
    var notificationCheck = false;
    var longDescriptionCheck = false;
    var longDescriptionHeight = CGFloat(0);
    var additionalInfo = [String: String]();
    var additionalInfoHeight = CGFloat(0);
    var additionInfoCheck = false;
    var longWebViewHeight = 0;
    var shortWebViewHeight = 0;
    var saleCheck = "false";
    var galleryImages = [String]();
    var screenwidth = UIScreen.main.bounds.width;
    override func viewDidLoad() {
        super.viewDidLoad()
        //--edited10May    self.tracking(name: "product view");
        productTable.delegate = self
        productTable.dataSource = self
        buyNow.setThemeColor();
        self.productTable.isHidden = true;
        addToCart.backgroundColor = wooSetting.subTextColor
        if #available(iOS 13.0, *) {
            addToCart.setTitleColor(UIColor.systemBackground, for: .normal)
        } else {
            addToCart.setTitleColor(UIColor.white, for: .normal)
        }
        buyNow.setTitleColor(wooSetting.textColor, for: .normal)
        addToCart.layer.borderColor = UIColor.lightGray.cgColor
        buyNow.layer.borderColor = UIColor.lightGray.cgColor
        addToCart.layer.borderWidth = 1.0
        buyNow.layer.borderWidth = 1.0
        
        addToCart.addTarget(self, action: #selector(mageWooProductView.addTocart(sender:)), for: .touchUpInside)
        buyNow.addTarget(self, action: #selector(buyNowClicked(_:)), for: .touchUpInside);
        getProductData()
        //self.tabBarController?.tabBar.isHidden = true;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateBadge();
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        //self.tabBarController?.tabBar.isHidden = false;
        var prodataArray = [[String:String]]()
        let prodataDictionary = NSMutableDictionary()
        prodataArray = (UserDefaults.standard.object(forKey: "recentlyViewData")) as? [[String : String]] ?? [[:]]
        recentlyArray  = (UserDefaults.standard.object(forKey: "productsId")) as? [String] ?? []
        if prodataArray.count > 5
        {
            UserDefaults.standard.removeObject(forKey: "recentlyViewData")
            UserDefaults.standard.removeObject(forKey: "productsId")
            recentlyArray.removeAll()
            prodataArray.removeAll()
            prodataArray = (UserDefaults.standard.object(forKey: "recentlyViewData")) as? [[String : String]] ?? [[:]]
            recentlyArray  = (UserDefaults.standard.object(forKey: "productsId")) as? [String] ?? []
        }
               if !recentlyArray.contains(productId)
               {
                prodataDictionary.setValue(productData["productName"], forKey: "productName")
                prodataDictionary.setValue(productData["productImage"], forKey: "productImage")
                prodataDictionary.setValue(productData["productPrice"], forKey: "productPrice")
                 prodataDictionary.setValue(productData["productId"], forKey: "productId")
                prodataArray.append(prodataDictionary as? [String : String] ?? [:])
                   recentlyArray.append(productId)
                   UserDefaults.standard.set(recentlyArray, forKey: "productsId")
                  UserDefaults.standard.set(prodataArray, forKey: "recentlyViewData")
               }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 2)
        {
            if(isVariable == true)
            {
                return 1;
            }
            return 0;
        }
        if(relatedData.count==0)
        {
            if(section == 9)
            {
                return 0
            }
        }
        if(enableReview == "no")
        {
            if(section == 10)
            {
                return 0;
            }
        }
        if(section == 1 || section == 0 || section == 4 || section == 6)
        {
            if(productData.count==0)
            {
                return 0
            }
        }
        if(additionalInfo.count == 0)
        {
            if(section == 7 || section == 8)
            {
                return 0
            }
        }
        return 1;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier:  "productImage") as? mageProductViewCell
            if(cell?.dataLoaded == false)
            {
                cell?.dataLoaded = true
                if let imgUrl = productData["productImage"] {
                    print(imgUrl)
                    let img = URL(string: imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
                    if(imgUrl != "")
                    {
                        imageData.append(SDWebImageSource(url: img!))
                    }
                }
                if(galleryImages.count>0)
                {
                    for image in galleryImages
                    {
                        let imgUrl = URL(string: image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
                        imageData.append(SDWebImageSource(url: imgUrl!))
                    }
                }
                
                cell?.productImage.slideshowInterval = 2.0
                cell?.productImage.pauseTimer()
                cell?.productImage.pageControlPosition=PageControlPosition.insideScrollView
                cell?.productImage.contentScaleMode = UIView.ContentMode.scaleAspectFit
                cell?.productImage.tag = 10000;
                cell?.productImage.currentPageChanged = { page in
                    
                }
                cell?.productImage.pageControl.pageIndicatorTintColor = .red
                cell?.productImage.pageControl.currentPageIndicatorTintColor = .blue
                cell?.productImage.draggingEnabled=true
                if imageData.count==0{
                    cell?.productImage.setImageInputs([ImageSource(image: UIImage(contentsOfFile: wooSetting.productPlaceholder)!)])
                    
                    
                }
                else
                {
                    cell?.productImage.setImageInputs(imageData)
                }
                let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
                cell?.productImage.addGestureRecognizer(recognizer)
                cell?.productImage.bringSubviewToFront((cell?.saleLabel)!)
                //cell?.productImage.bringSubview(toFront: (cell?.wishListButton)!)
                cell?.saleLabel.tag = 10010
                cell?.saleLabel.font = mageWooCommon.setCustomFont(type: .medium, size: 14)
                if(productData["productType"]=="variable")
                {
                    
                    if(saleCheck == "true")
                    {
                        cell?.saleLabel.isHidden = false;
                    }
                    else{
                        cell?.saleLabel.isHidden = true;
                    }
                }
                else
                {
                    if(productData["salePrice"] != nil && productData["salePrice"] != "")
                    {
                        cell?.saleLabel.isHidden = false;
                    }
                    else
                    {
                        cell?.saleLabel.isHidden = true;
                    }
                }
                if(wishlistCheck == "yes")
                {
                    cell?.wishListButton.setImage(UIImage(named: "wishfilled"), for: .normal)
                }
                cell?.wishListButton.addTarget(self, action: #selector(wishButtonPressed), for: .touchUpInside);
                
                cell?.outOfStockLabel.text = "OUT OF STOCK!"
                cell?.outOfStockLabel.font = mageWooCommon.setCustomFont(type: .medium, size: 12.0)
                cell?.outOfStockLabel.isHidden = true
               // cell?.soldOutImage.isHidden = true
                if checkStock == false
                {
                    cell?.soldOutImage.isHidden = false
                  //  cell?.outOfStockLabel.isHidden = false
                    cell?.outOfStockLabel.backgroundColor = wooSetting.themeColor
                    cell?.outOfStockLabel.backgroundColor?.withAlphaComponent(0.6)
                    cell?.outOfStockLabel.alpha = 0.7
                    cell?.outOfStockLabel.textColor = UIColor.white
                }
                else
                {
                    cell?.soldOutImage.isHidden = true
                    cell?.outOfStockLabel.backgroundColor = UIColor.clear
                    
                }
                
                
                
                
            }
            return cell!
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier:  "productNamePrice") as? mageProductViewCell
            if(cell?.dataLoaded == false)
            {
                cell?.dataLoaded = true;
                if let prodName = productData["productName"] {
                    cell?.productfName.text = prodName;
                }
                cell?.productfName.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
                cell?.productfName.tag = 10001;
                cell?.price.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
                cell?.price.tag = 10002;
                cell?.compare.tag = 10003;
                cell?.compare.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
                if(productData["productType"]=="variable")
                {
                    if(productData["productPrice"] != "" && productData["productPrice"] != nil)
                    {
                        let min_price = productData["product_price_min"];
                        let max_price = productData["product_price_max"];
                        let min_reg_price = productData["product_price_min_reg"];
                        let max_reg_price = productData["product_price_max_reg"];
                        if(min_price != max_price)
                        {
                            cell?.price.text = productData["currencySymbol"]!+min_price!+" - "+productData["currencySymbol"]!+max_price!
                        }
                        else if(saleCheck == "true" && min_reg_price == max_reg_price)
                        {
                            cell?.price.text = productData["currencySymbol"]!+min_price!+" - "+productData["currencySymbol"]!+max_reg_price!
                        }
                        else
                        {
                            cell?.price.text = productData["currencySymbol"]!+min_price!
                        }
                        available = true;
                    }
                    else
                    {
                        available=false
                    }
                    
                }
                else
                {
                    if(productData["productPrice"] != nil && productData["productPrice"] != "")
                    {
                        cell?.price.text = productData["currencySymbol"]! + (productData["productPrice"])!;
                        if(productData["salePrice"] != nil && productData["salePrice"] != "")
                        {
                            if(productData["regularPrice"] != productData["productPrice"])
                            {
                                let offerPrice=NSMutableAttributedString(string: productData["currencySymbol"]! + (productData["regularPrice"])!);
                                offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                                cell?.compare.attributedText=offerPrice
                            }
                        }
                        available=true;
                    }
                    else
                    {
                        available=false;
                    }
                }
                if(productData["enable-qrcode"] == "true")
                {
                    let dataForQRCode=productData["handler"];
                    let data = dataForQRCode?.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
                    
                    let filter = CIFilter(name: "CIQRCodeGenerator")
                    
                    filter?.setValue(data, forKey: "inputMessage")
                    filter!.setValue("Q", forKey: "inputCorrectionLevel")
                    let colorFilter = CIFilter(name: "CIFalseColor")
                    colorFilter?.setValue(filter?.outputImage, forKey: "inputImage")
                    colorFilter?.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
                    colorFilter?.setValue(CIColor(color: UIColor.black), forKey: "inputColor0")
                    
                    let qrCodeImage = colorFilter?.outputImage
                    
                    let scaleX = (cell?.qrCodeImageView.frame.size.width)! / (qrCodeImage?.extent.size.width)!
                    let scaleY = (cell?.qrCodeImageView.frame.size.height)! / (qrCodeImage?.extent.size.height)!
                    
                    let transformedImage = colorFilter?.outputImage?.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
                    cell?.qrCodeImageView.image=UIImage(ciImage: transformedImage!)
                }
                else
                {
                    cell?.qrCodeImageView.isHidden = true;
                }
                cell?.shareButton.addTarget(self, action: #selector(shareProductButtonPressed(_:)), for: .touchUpInside)
                
                if let skuValue = productData["sku"]
                {
                    cell?.skuLabel.isHidden = false;
                    if skuValue != ""
                    {
                       // cell?.skuLabel.text = "SKU : \(skuValue)"
                        let myAttribute1 = [ NSAttributedString.Key.font: mageWooCommon.setCustomFont(type: .bold, size: 13.0) ]
                        let myString = NSMutableAttributedString(string: "SKU : ", attributes: myAttribute1 )
                        let myAttribute2 = [ NSAttributedString.Key.font: mageWooCommon.setCustomFont(type: .regular, size: 14) ]
                        let myskuValue = NSMutableAttributedString(string: "\(skuValue)", attributes: myAttribute2 )
                        myString.append(myskuValue)
                        cell?.skuLabel.attributedText = myString
                    }
                    else
                    {
                        cell?.skuLabel.text = ""
                    }
                }
                else
                {
                    cell?.skuLabel.text = ""
                    cell?.skuLabel.isHidden = true
                }
                
                
            }
            return cell!
        }else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier:  "productOptionCell") as? mageProductViewCell
            {
                if(cell.dataLoaded == false)
                {
                    if productOptionsData.count==0
                    {
                        cell.optionStackViewHeight.constant=0
                    }
                    else
                    {
                        for i in 0..<cell.optionStackView.arrangedSubviews.count{
                            cell.optionStackView.arrangedSubviews[i].removeFromSuperview()
                        }
                        //var i = 100;
                        var keyIndex = 0;
                        for(key,value) in productOptionsData
                        {
                            keyIndex += 1;
                            print(key)
                            
                            let customOptionDropdown = CustomOptionDropDownView()
                            customOptionDropdown.topLabel.text = value["label"].stringValue;
                            customOptionDropdown.translatesAutoresizingMaskIntoConstraints = false;
                            customOptionDropdown.dropDownButton.setTitle("--Select--", for: UIControl.State.normal);
                            customOptionDropdown.dropDownButton.addTarget(self, action: #selector(customDropDownClicked(_:)), for: UIControl.Event.touchUpInside)
                            customOptionDropdown.dropDownButton.tag = keyIndex;
                            cell.optionStackView.addArrangedSubview(customOptionDropdown);
                            cell.optionStackViewHeight.constant += 75;
                            
                            
                        }
                        self.stackView=(cell.optionStackView)!
                        cell.dataLoaded=true;
                    }
                }
                
                return cell
            }
            return UITableViewCell()
        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier:  "productQtyCell") as? mageProductViewCell
            qtyView.productQty.delegate=self
            qtyView.decrementButon.addTarget(self, action: #selector(decrementProductQty(_:)), for: .touchUpInside)
            qtyView.incrementButton.addTarget(self, action: #selector(incrementProductQty(_:)), for: .touchUpInside)
            
            qtyView.productQty.text="1"
            cell?.qtyStackViewWidth.constant=130
            cell?.qtyStackViewHeight.constant=30
            cell?.qtyStackView.addArrangedSubview(qtyView)
            return cell!
        }else if indexPath.section == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier:  "productDescription") as? mageProductViewCell
            
            cell?.descriptionText.isOpaque = false;
            cell?.descriptionText.tag = 1000000
            if let prodDesc = productData["short_description"] {
                
                let html = """
                <html><head><meta name='viewport' content='width=device-width,
                initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'><link rel="stylesheet" type="text/css" href="webfile.css"><source media="(prefers-color-scheme: dark)"><style>body{width:\(self.screenwidth-30); !important} p{width:\(self.screenwidth-30); !important} div{width:\(self.screenwidth-30) !important} iframe{width:\(self.screenwidth-30) !important} img{width:\(self.screenwidth-30) !important}</style></head><body>\(prodDesc)</body></html>
                """
                /*if #available(iOS 12.0, *) {
                    if(traitCollection.userInterfaceStyle == .dark)
                    {
                        html = """
                        <html><head><meta name='viewport' content='width=device-width,
                        initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'><link rel="stylesheet" type="text/css" href="webfile.css">
                        <span style="font-family: 'Roboto-Regular'; font-size: 21px;"><font color="white">\(prodDesc)</span></head></html>
                        """
                    }
                }*/
                cell?.descriptionText.loadHTMLString(html, baseURL: URL(fileURLWithPath: Bundle.main.path(forResource: "webfile", ofType: "css") ?? "" ))
                cell?.descriptionText.navigationDelegate = self;
               
            }
            return cell!
        }
        else if(indexPath.section == 5)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:  "longDescriptionButtonCell") as? mageProductViewCell
            
            cell?.longDescriptionButton.addTarget(self, action: #selector(descriptionButtonClicked(_:)), for: .touchUpInside)
            cell?.longDescriptionImageView.tag = 100000;
            
            return cell!;
        }
        else if(indexPath.section == 6)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:  "longDescriptionTextCell") as? mageProductViewCell
            //let screenWidth = UIScreen.main.bounds.width;
            if let longDesc = productData["productDesc"]{
                let html = """
                <html><head><meta name='viewport' content='width=device-width,
                initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'><link rel="stylesheet" type="text/css" href="webfile.css"><source media="(prefers-color-scheme: dark)"><source media="(prefers-color-scheme: dark)"><style>body{width:\(self.screenwidth-30); !important} p{width:\(self.screenwidth-30); !important} div{width:\(self.screenwidth-30) !important} iframe{width:\(self.screenwidth-30) !important} img{width:\(self.screenwidth-30) !important}</style></head><body>\(longDesc)</body></html>
                """
                /*if #available(iOS 12.0, *) {
                    if(traitCollection.userInterfaceStyle == .dark){
                        html = """
                        <html><head><meta name='viewport' content='width=device-width,
                        initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'><link rel="stylesheet" type="text/css" href="webfile.css">
                        <span style="font-family: 'Roboto-Regular'; font-size: 21px;"><font color="white">\(longDesc)</span></head></html>
                        """
                    }
                }*/
                cell?.longDescriptionWebView.navigationDelegate=self
                cell?.longDescriptionWebView.tag = 1000001
                cell?.longDescriptionWebView.loadHTMLString(html, baseURL: URL(fileURLWithPath: Bundle.main.path(forResource: "webfile", ofType: "css") ?? "" ))
            }
            
            return cell!;
        }
        else if(indexPath.section == 7)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:  "additionInformationButtonCell") as? mageProductViewCell
            cell?.additionInfoButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
            cell?.additionInfoButton.addTarget(self, action: #selector(additionalInfoClicked(_:)), for: .touchUpInside)
            cell?.additionInfoImageView.tag = 100002;
            return cell!;
        }
        else if(indexPath.section == 8)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:  "additionalInfoCell") as? mageProductViewCell
            for subview in (cell?.additionInfoStackView.arrangedSubviews)!
            {
                cell?.additionInfoStackView.removeArrangedSubview(subview);
                subview.removeFromSuperview()
            }
            cell?.additionInfoStackHeight.constant = 0;
            for(key,value) in additionalInfo
            {
                let additionalInfoView = AdditionalInfoView();
                cell?.additionInfoStackView.addArrangedSubview(additionalInfoView)
                
                cell?.additionInfoStackHeight.constant += 40;
                additionalInfoView.addInfoName.text = key+" - ";
                additionalInfoView.addInfoValue.text = value;
            }
            return cell!;
        }
        else if(indexPath.section == 9)
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier:  "relatedProducts") as? relatedProductCell
            {
                cell.parent=self;
                cell.relatedData=relatedData;
                if(productData["currencySymbol"] != nil && productData["currencySymbol"] != "")
                {
                    cell.currencySymbol = productData["currencySymbol"]!;
                }
                cell.fetch();
                return cell;
            }
            
        }
        else if(indexPath.section == 10)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:  "reviewCell") as? mageProductViewCell
            cell?.reviewButton.addTarget(self, action: #selector(showReview(_:)), for: .touchUpInside)
            cell?.reviewButton.setThemeColor();
            cell?.reviewButton.setTitleColor(wooSetting.textColor, for: .normal)
            
            return cell!;
        }
        
        return UITableViewCell();
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //cedMageLoaders.removeLoadingIndicator(me: self)
        
        //webView.frame.size = webView.sizeThatFits(.zero)
        print(webView.frame.height)
        
        print("webViewHeight")
        
        if let shortWebView = self.view.viewWithTag(1000000) as? WKWebView
        {
            if webView == shortWebView
            {
                if shortWebViewFlag==false{
                    webView.evaluateJavaScript("document.body.offsetHeight", completionHandler: { (height, error) in
                        webView.frame.size.height = 1
                        guard let height = height as? CGFloat else{return;}
                        self.shortWebViewHeight = Int(height) + 70;
                        self.productTable.reloadSections(NSIndexSet(index: 4) as IndexSet, with: .none)
                        
                    })
                    /*shortWebViewHeight=Int(webView.frame.height)
                    webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
                        if complete != nil {
                            webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                                //self.shortWebViewHeight = Int(webView.scrollView.contentSize.height)
                            })
                        }
                    })
                    self.productTable.reloadSections(NSIndexSet(index: 4) as IndexSet, with: .none)*/
                    //shortWebViewFlag = true
                }
            }
        }
        if let longWebView = self.view.viewWithTag(1000001) as? WKWebView
        {
            if longWebView == webView
            {
                if longWebViewFlag==false{
                    
                    webView.evaluateJavaScript("document.body.offsetHeight", completionHandler: { (height, error) in
                        webView.frame.size.height = 1
                        guard let height = height as? CGFloat else{return;}
                        self.longWebViewHeight = Int(height) + 20;
                        self.productTable.reloadSections(NSIndexSet(index: 6) as IndexSet, with: .none)
                        
                    })
                }
            }
        }
    }
    
    /*func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(.zero)
        print(webView.frame.height)
        
        print("webViewHeight")
        
        if let shortWebView = self.view.viewWithTag(1000000) as? UIWebView
        {
            if webView == shortWebView
            {
                if shortWebViewFlag==false{
                    shortWebViewHeight=Int(webView.frame.height)
                    
                    self.productTable.reloadSections(NSIndexSet(index: 4) as IndexSet, with: .none)
                    shortWebViewFlag = true
                    
                    
                }
            }
            
            
        }
        if let longWebView = self.view.viewWithTag(1000001) as? UIWebView
        {
            if longWebView == webView
            {
                if longWebViewFlag==false{
                    longWebViewHeight=Int(webView.frame.height)
                    longWebViewFlag = true
                    self.productTable.reloadSections(NSIndexSet(index: 6) as IndexSet, with: .none)
                    
                }
            }
        }
        
        
        
    }*/
    
    @objc func additionalInfoClicked(_ sender: UIButton)
    {
        additionInfoCheck = !additionInfoCheck
        self.productTable?.beginUpdates()
        let indexPath = NSIndexPath(row: 0, section: 8)
        self.productTable.reloadRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.top)
        self.productTable?.endUpdates()
        if let additionalInfoImageView = self.view.viewWithTag(100002) as? UIImageView
        {
            if(additionInfoCheck)
            {
                additionalInfoImageView.image = UIImage(named: "ExpandArrow")
            }
            else
            {
                additionalInfoImageView.image = UIImage(named: "IQButtonBarArrowRight")
            }
        }
    }
    
    @objc func descriptionButtonClicked(_ sender: UIButton)
    {
        longDescriptionCheck = !longDescriptionCheck
        self.productTable?.beginUpdates()
        let indexPath = NSIndexPath(row: 0, section: 6)
        self.productTable.reloadRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.top)
        self.productTable?.endUpdates()
        if let longDescriptionImageView = self.view.viewWithTag(100000) as? UIImageView
        {
            if(longDescriptionCheck)
            {
                longDescriptionImageView.image = UIImage(named: "ExpandArrow")
            }
            else
            {
                longDescriptionImageView.image = UIImage(named: "IQButtonBarArrowRight")
            }
        }
    }
    
    @objc func showReview(_ sender: UIButton)
    {
        let vc=UIStoryboard(name: "mageWooReview", bundle: nil).instantiateViewController(withIdentifier: "reviewsList") as! mageWooReviews
        vc.productId = productData["productId"]!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func shareProductButtonPressed(_ sender: UIButton) {
        
        let activityViewController = UIActivityViewController(activityItems: [productData["handler"] ?? ""], applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.mail,.postToTwitter,.message,.postToFacebook]
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = self.view;
            activityViewController.popoverPresentationController?.permittedArrowDirections = .any
        }
        activityViewController.modalPresentationStyle = .fullScreen;
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    
    @objc func customDropDownClicked(_ sender: UIButton)
    {
        var index = 0;
        for(key, value) in productOptionsData
        {
            index += 1;
            if(sender.tag == index)
            {
                var customDropdownData = [String]()
                var customArrayData = [String: String]()
                for(key1, value1) in value["data"]
                {
                    if(value1.stringValue != "" && value1.stringValue != nil)
                    {
                        customDropdownData.append(value1.stringValue)
                        customArrayData[value1.stringValue] = key1
                    }
                    else
                    {
                        available=false
                        self.view.makeToast("Product not available", duration: 2.0, position: .center);
                        return;
                    }
                }
                var tempDataSource = customDropdownData;
                print(tempDataSource);
                tempDataSource = tempDataSource.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
                dropDown.dataSource = tempDataSource;
                
                dropDown.selectionAction = {(index, item) in
                    sender.setTitle(item, for: UIControl.State());
                    self.optionSelected[key]=customArrayData[item];
                    self.changeViewAfterCustoms();
                }
                
                dropDown.anchorView = sender
                dropDown.bottomOffset = CGPoint(x: 0, y:sender.bounds.height)
                if dropDown.isHidden {
                    let _ = dropDown.show();
                } else {
                    dropDown.hide();
                }
                break;
            }
        }
        
        
    }
    
    
    func changeViewAfterCustoms()
    {
        for index in variationData
        {
            var resultCheck=[Bool]();
            let attributeKey = "attribute_"
            if let attributes = index["attributes"]
            {
                for(key,value) in attributes
                {
                    for(optionKey,optionValue) in optionSelected
                    {
                        var opKey = optionKey
                        if(optionKey.contains(" "))
                        {
                            opKey = optionKey.replacingOccurrences(of: " ", with: "-")
                        }
                        if(key == (attributeKey+(opKey.lowercased())))
                        {
                            if((optionValue == value.stringValue) || (value.stringValue == ""))
                            {
                                resultCheck.append(true);
                            }
                        }
                    }
                    
                }
            }
            if(resultCheck.count == productOptionsData.count)
            {
                print("-----success-----")
                if(index["is_in_stock"]?.stringValue == "true")
                {
                    checkStock=true;
                }
                else
                {
                    checkStock=false;
                }
                variationId=(index["variation_id"]?.stringValue)!;
                imageData = [];
                let productImageView = self.view.viewWithTag(10000) as? ImageSlideshow
                if(index["image"]?.stringValue != "")
                {
                    imageData.append(SDWebImageSource(url: URL(string: (index["image"]?.stringValue)!)!))
                    productImageView?.setImageInputs(imageData)
                }
                else
                {
                    productImageView?.setImageInputs([ImageSource(image: UIImage(contentsOfFile: wooSetting.productPlaceholder)!)])
                }
                if let productPrice = self.view.viewWithTag(10002) as? UILabel
                {
                    if(index["display_price"]?.stringValue == "")
                    {
                        productPrice.text = ""
                        available=false;
                        
                    }
                    else
                    {
                        productPrice.text = productData["currencySymbol"]! + (index["display_price"]?.stringValue)!;
                        //regularPrice.text = "";
                        available = true;
                    }
                    
                }
                if let regularPrice = self.view.viewWithTag(10003) as? UILabel, let saleLabel = self.view.viewWithTag(10010) as? UILabel
                {
                    regularPrice.text = ""
                    if(index["sale_price"] != nil && index["sale_price"] != "")
                    {
                        saleLabel.isHidden = false;
                    }
                    else
                    {
                        saleLabel.isHidden = true;
                    }
                    if(index["regular_price"] != index["display_price"])
                    {
                        
                        let offerPrice=NSMutableAttributedString(string: productData["currencySymbol"]! + (index["regular_price"]?.stringValue)!);
                        offerPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, offerPrice.length))
                        regularPrice.attributedText = offerPrice;
                    }
                    
                    
                }
                
            }
            resultCheck=[Bool]();
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        let qtyCharactersCheck=qtyView.productQty.text?.count
        
        if qtyCharactersCheck! > 3{
            
            
            selectedQty="1"
            qtyView.productQty.text="1"
            self.showAlert(title: "Wrong Input.".localized, msg: "Please enter quantity of maximum 3 digits.".localized)
            
            return
        }
        
        let qty=Int(qtyView.productQty.text!)
        if qty==nil{
            qtyView.productQty.text="1"
            selectedQty="1"
            self.showAlert(title: "Wrong Input.".localized, msg: "Please enter positive integer number for quantity.".localized)
            
            return
        }
        let qtyFloatCheck=qtyView.productQty.text?.contains(".")
        if qtyView.productQty.text==""
        {
            selectedQty="1"
            qtyView.productQty.text="1"
            self.showAlert(title: "Wrong Input.".localized, msg: "Please enter 1 or more quantity for product to add to cart.".localized)
            
            return
            
        }else if qtyFloatCheck!{
            selectedQty="1"
            qtyView.productQty.text="1"
            self.showAlert(title: "Wrong Input.".localized, msg: "Please enter 1 or more quantity with whole number.".localized)
            
            return
        }
        else if qty! < 1{
            selectedQty="1"
            qtyView.productQty.text="1"
            self.showAlert(title: "Wrong Input.".localized, msg: "Please add atleast 1 as quantity.".localized)
            
            return
        }
        selectedQty=qtyView.productQty.text!
        
        
    }
    
    @objc func wishButtonPressed(_ sender: UIButton){
        let productId=productData["productId"]!
        if User().getLoginUser() != nil {
            
            User().wooAddToWishList(productId: productId, control: self, completion: {
                data in
                if let data = data {
                    if let json = try? JSON(data:data)
                    {
                        print(json)
                        if let jsonData=json["message"].string{
                            if jsonData=="Product removed from wishlist"{
                                sender.setImage(UIImage(named: "wishempty"), for: .normal)
                                self.view.makeToast(jsonData, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                            }
                            else if jsonData=="Product added to wishlist"
                            {
                                sender.setImage(UIImage(named: "wishfilled"), for: .normal)
                                self.view.makeToast(jsonData, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                            }
                        }
                    }
                    
                }
            })
            
        }
        else{
            self.view.makeToast("Please Login First...!".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
        }
        
    }
    
    
    @objc func incrementProductQty(_ sender:UIButton){
        
        if(qtyView.productQty.text == ""){
            qtyView.productQty.text = String("1");
            return;
        }
        if(qtyView.productQty.text != ""){
            var currentQty = Int(qtyView.productQty.text!)!;
            currentQty = currentQty+1;
            
            qtyView.productQty.text = String(currentQty);
        }
        
        
        selectedQty=qtyView.productQty.text!
    }
    
    @objc func decrementProductQty(_ sender:UIButton){
        
        if(qtyView.productQty.text != "" && qtyView.productQty.text != "1"){
            var currentQty = Int(qtyView.productQty.text!)!;
            currentQty = currentQty-1;
            qtyView.productQty.text = String(currentQty);
        }
        selectedQty=qtyView.productQty.text!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section==0{
            return 300
        }else if indexPath.section==1{
          //  return 165
            return 185
        }else if indexPath.section==2{
            return CGFloat(productOptionsData.count*75) + 10
        }else if indexPath.section==3{
            return 50
        }
        else if(indexPath.section==4)
        {
            return CGFloat(shortWebViewHeight);
        }
        else if(indexPath.section==6)
        {
            if(longDescriptionCheck)
            {
                return CGFloat(longWebViewHeight)//UITableView.automaticDimension//CGFloat(longWebViewHeight) + CGFloat(50)
            }
            else
            {
                return CGFloat(0)
            }
            
            
        }
        else if(indexPath.section == 8)
        {
            if(additionInfoCheck)
            {
                return CGFloat(additionalInfo.count * 40) + CGFloat(10);
            }
            else
            {
                return CGFloat(0)
            }
        }
        else if(indexPath.section==9)
        {
            return 250
        }
        else{
            
            return CGFloat(50)
        }
    }
    
    func getProductData(){
        cedMageLoaders.addDefaultLoader(me: self)
        var params = [String:String]()
        params["product-id"] = productId;
        if let user = User().getLoginUser() {
            params["user-id"] = user["userId"]
        }
        print(params)
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/get_single_product",method: "POST", params:params, controller: self, completionHandler: {
            data,url,error in
            if let data = data {
                cedMageLoaders.removeLoadingIndicator(me: self)
                
                if let json  = try? JSON(data:data){
                    print(NSString(data:data,encoding:String.Encoding.utf8.rawValue) ?? "")
                    self.fetchProductData(json: json)
                    self.productTable.isHidden = false;
                }
            }
        })
    }
    
    func dissmissViewcontroller(sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
        
    }
    
    
    @objc func addTocart(sender:UIButton) {
        if(available==false)
        {
            self.view.makeToast("Product not available".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            return;
        }
        if(productData["productType"]=="variable")
        {
            if(optionSelected.count != productOptionsData.count)
            {
                self.view.makeToast("Please select all the variants".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                return;
            }
            else if(variationId == "")
            {
                self.view.makeToast("Product not available".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                return;
            }
        }
        
        if(checkStock==false)
        {
            self.view.makeToast("Out Of Stock!".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            return;
        }
        var params = Dictionary<String, String>()
        params["product_id"] = productId
        params["qty"]        = selectedQty
        if let user = User().getLoginUser() {
            params["customer_id"] = user["userId"]
        }
        else{
            if let cartId = UserDefaults.standard.value(forKey: "cart_id")
            {
                params["cart_id"] = cartId as? String
            }
        }
        if(variationId != "")
        {
            params["variation_id"] = variationId
        }
        
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/addtocart",method: "POST", params:params, controller: self, completionHandler: {
            data,url,error in
            if let data = data {
                if let json  = try? JSON(data:data)
                {
                    print(json)
                    if(json["cart_id"]["success"].stringValue == "true")
                    {
                        self.view.makeToast(json["cart_id"]["message"].stringValue, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                        UserDefaults.standard.setValue(json["cart_id"]["cart_id"].stringValue, forKey: "cart_id")
                        if let cartCount = UserDefaults.standard.value(forKey: "CartQuantity") as? String
                        {
                            let qtyCount = Int(cartCount)! + Int(json["cart_id"]["items_count"].stringValue)!;
                            UserDefaults.standard.setValue(String(qtyCount), forKey: "CartQuantity");
                        }
                        else
                        {
                            let qtyCount = json["cart_id"]["items_count"].stringValue;
                            UserDefaults.standard.setValue(qtyCount, forKey: "CartQuantity");
                        }
                        UserDefaults.standard.synchronize()
                        self.updateBadge();
                    }
                    else
                    {
                        self.view.makeToast(json["cart_id"]["message"].stringValue, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                    }
                }
                
            }
        })
    }
    
    @objc func buyNowClicked(_ sender:UIButton){
        if(available==false)
        {
            self.view.makeToast("Product not available", duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            return;
        }
        if(productData["productType"]=="variable")
        {
            if(optionSelected.count != productOptionsData.count)
            {
                self.view.makeToast("Please select all the variants".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                return;
            }
            else if(variationId == "")
            {
                self.view.makeToast("Product not available".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                return;
            }
        }
        if(checkStock==false)
        {
            self.view.makeToast("Out Of Stock!".localized, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
            return;
        }
        var params = Dictionary<String, String>()
        params["product_id"] = productId
        params["qty"] = selectedQty
        if let user = User().getLoginUser() {
            params["customer_id"] = user["userId"]
        }
        else{
            if let cartId = UserDefaults.standard.value(forKey: "cart_id")
            {
                params["cart_id"] = cartId as? String
            }
        }
        if(variationId != "")
        {
            params["variation_id"] = variationId
        }
        
        mageRequets.sendHttpRequest(endPoint: "mobiconnect/checkout/addtocart",method: "POST", params:params, controller: self, completionHandler: {
            data,url,error in
            if let data = data {
                print(NSString(data:data,encoding:String.Encoding.utf8.rawValue) ?? "")
                if let json  = try? JSON(data:data)
                {
                    print(json)
                    if(json["cart_id"]["success"].stringValue == "true")
                    {
                        self.view.makeToast(json["cart_id"]["message"].stringValue, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                        UserDefaults.standard.setValue(json["cart_id"]["cart_id"].stringValue, forKey: "cart_id")
                        if let cartCount = UserDefaults.standard.value(forKey: "CartQuantity") as? String
                        {
                            let qtyCount = Int(cartCount)! + Int(json["cart_id"]["items_count"].stringValue)!;
                            UserDefaults.standard.setValue(String(qtyCount), forKey: "CartQuantity");
                        }
                        else
                        {
                            UserDefaults.standard.setValue("1", forKey: "CartQuantity");
                        }
                        UserDefaults.standard.synchronize()
                        self.updateBadge();
                        self.navigateForBuyNow()
                    }
                    else
                    {
                        self.view.makeToast(json["cart_id"]["message"].stringValue, duration: 2.0, position: .center, title: nil, image: nil, style: nil, completion: nil);
                    }
                }
                
            }
        })
    }
    func navigateForBuyNow() {
        if let cartViewControl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cartlist") as? CartProductListView {
            self.navigationController?.pushViewController(cartViewControl, animated: true)
        }
        /*if let _ = User().getLoginUser()
        {
            
            let vc=UIStoryboard(name: "mageWooCheckout", bundle: nil).instantiateViewController(withIdentifier: "addaddress") as? addAddressController
            self.navigationController?.pushViewController(vc!, animated: true);
        }
        else
        {
            let vc=UIStoryboard(name: "mageWooCheckout", bundle: nil).instantiateViewController(withIdentifier: "checkas") as! checkOutAsController
            self.navigationController?.pushViewController(vc, animated: true)
        }*/
        
    }
    
    @objc func didTap() {
        print("hello")
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "hello") as! FullScreenSlideshowViewController
        vc.inputs=imageData
        self.present(vc, animated: true, completion: nil)
    }
}

