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
import TTRangeSlider
class ProductFiltersViewController: mageBaseViewController, TTRangeSliderDelegate {
    
    var jsonForFilters:JSON!;
    
    @IBOutlet weak var clearFilterButton: UIButton!
    @IBOutlet weak var applyFilterButton: UIButton!
    
    @IBOutlet weak var filterSlider: TTRangeSlider!
    
    //@IBOutlet weak var leftView: UIView!
    //@IBOutlet weak var rightView: UIView!
    @IBOutlet weak var maxTextField: UITextField!
    
    @IBOutlet weak var minTextField: UITextField!
    
    @IBOutlet weak var minLabel: UILabel!
    
    @IBOutlet weak var maxLabel: UILabel!
    
    
    var scrollViewLeft : UIScrollView!;
    var scrollViewRight : UIScrollView!;
    var stackViewLeft : UIStackView!;
    var stackViewRight : UIStackView!;
    
    var heightOfChildFilterCheckbox = CGFloat();
    
    var filter_label = [String:String]();
    var filterArray = [String:[String]]();
    var selectedFiltersArray = [String:String]();
    var currentParentFilter = "";
    var currentParentFilterIndex = -1;
    
    let defaultColor = UIColor.lightGray;
    let currentTappedColor = UIColor.darkGray;
    var selectedColor : UIColor!;
    
    var filterData = [String: [String:String]]()
    var currencySymbol = "";
    var vc: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterSlider.delegate = self;
        minLabel.text = currencySymbol+"0.00";
        maxLabel.text = currencySymbol+"100000.00";
        minLabel.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        maxLabel.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        heightOfChildFilterCheckbox = translateAccordingToDevice(CGFloat(40))
        selectedColor = mageWooCommon.UIColorFromRGB(colorCode: "#F9C53D");
        filterSlider.minValue=0.00
        filterSlider.maxValue=100000.00
        filterSlider.addTarget(self, action: #selector(filterSliderValueChanged(_:)), for: .valueChanged)
        if let array = UserDefaults.standard.object(forKey: "filters")as? [String:String]
        {
            print(array)
            minTextField.text = array["minprice"]
            let numberFormatter = NumberFormatter()
            let minnumber = numberFormatter.number(from: array["minprice"]!)
            if let min = minnumber?.floatValue
            {
                filterSlider.selectedMinimum = min
            }
            maxTextField.text = array["maxprice"]
            let maxnumber = numberFormatter.number(from: array["maxprice"]!)
            if let max = maxnumber?.floatValue
            {
                filterSlider.selectedMaximum = max;
            }
            
        }
        
        /*
         if(defaults.object(forKey: "previousSelectedFilters") != nil){
         self.selectedFiltersArray = (defaults.object(forKey: "previousSelectedFilters") as? [String:[String]])!;
         print("previous::selectedFiltersArray");
         print(self.selectedFiltersArray);
         
         }
         
         print(jsonForFilters)
         
         if jsonForFilters.count ==  0 {
         cedMageHttpException.showAlertView(me: self, msg: "No Filters available", title: "Error")
         return
         }*/
        
        /*for (_,val) in jsonForFilters["data"]["filter_label"]{
         self.filter_label[val["att_label"].stringValue] = val["att_code"].stringValue;
         }
         if  jsonForFilters["data"]["filter"].count > 0 {
         
         for (_,val) in jsonForFilters["data"]["filter"]{
         for(key,dataArray) in val{
         self.filterArray[key] = dataArray.arrayObject as? [String];
         if(defaults.object(forKey: "previousSelectedFilters") == nil){
         self.selectedFiltersArray[key] = [String]();
         }
         }
         }
         }
         */
        
        applyFilterButton.layer.borderColor = UIColor(hexString: "#407A52")?.cgColor
        applyFilterButton.cardView()
        clearFilterButton.cardView()
        clearFilterButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        applyFilterButton.titleLabel?.font = mageWooCommon.setCustomFont(type: .medium, size: 15)
        applyFilterButton.layer.borderWidth = 2
        applyFilterButton.setTitleColor(UIColor.black, for: UIControl.State.normal);
        applyFilterButton.setTitle("Apply Filter".localized, for: UIControl.State.normal);
        applyFilterButton.addTarget(self, action: #selector(ProductFiltersViewController.applyFilterButtonPressed(_:)), for: UIControl.Event.touchUpInside);
        
        clearFilterButton.layer.borderWidth = 2
        clearFilterButton.layer.borderColor = UIColor(hexString: "#DC3023")?.cgColor
        clearFilterButton.setTitleColor(UIColor.black, for: UIControl.State.normal);
        clearFilterButton.setTitle("Clear Filter".localized, for: UIControl.State.normal);
        clearFilterButton.addTarget(self, action: #selector(ProductFiltersViewController.clearFilterButtonPressed(_:)), for: UIControl.Event.touchUpInside);
        if #available(iOS 12.0, *) {
            if(traitCollection.userInterfaceStyle == .dark){
                applyFilterButton.setTitleColor(UIColor.white, for: .normal)
                clearFilterButton.setTitleColor(UIColor.white, for: .normal)
            }
        }
        /*if(self.filter_label.count > 0){
         self.basicFoundationToRenderView(bottomMargin: CGFloat(0.0));
         }
         else{
         self.renderNoDataImage(imageName: "");
         }*/
        
        //let temp=["Price":["Rs.0.0#Rs.150.0"]]
        selectedFiltersArray=[String:String]()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateBadge();
    }
    
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        minTextField.text=String(selectedMinimum)
        maxTextField.text=String(selectedMaximum)
    }
    
    @objc func filterSliderValueChanged(_ slider: TTRangeSlider){
        minTextField.text=String(slider.selectedMinimum)
        maxTextField.text=String(slider.selectedMaximum)
    }
    func renderNoDataImage(imageName:String){
        let noDataImageView = UIImageView();
        noDataImageView.translatesAutoresizingMaskIntoConstraints = false;
        noDataImageView.image = UIImage(named: imageName);
        self.view.addSubview(noDataImageView);
        self.view.addConstraint(NSLayoutConstraint(item: noDataImageView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0));
        self.view.addConstraint(NSLayoutConstraint(item: noDataImageView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0));
        self.view.addConstraint(NSLayoutConstraint(item: noDataImageView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0));
        self.view.addConstraint(NSLayoutConstraint(item: noDataImageView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0));
    }
    
    /*func parentFilterSelected(_ sender:UIButton){
     print("parentFilterSelected");
     
     print(currentParentFilterIndex);
     if let previousParentFilter = stackViewLeft.arrangedSubviews[currentParentFilterIndex] as? UIButton {
     print(previousParentFilter.backgroundColor as Any);
     if(previousParentFilter.backgroundColor == currentTappedColor){
     previousParentFilter.backgroundColor = defaultColor;
     }
     }
     
     if let index = stackViewLeft.arrangedSubviews.index(of: sender){
     self.currentParentFilterIndex = index;
     }
     sender.backgroundColor = currentTappedColor;
     
     stackViewRight.subviews.forEach({ $0.removeFromSuperview() });
     print(sender.titleLabel?.text! as Any);
     print(self.filterArray);
     let key = (sender.titleLabel?.text)!;
     let keyToUse = self.filter_label[key]!;
     self.currentParentFilter = keyToUse;
     let arrayToLoopForSubfilters = self.filterArray[keyToUse]!;
     for (key) in arrayToLoopForSubfilters{
     let hiddenLabel = UILabel();
     hiddenLabel.translatesAutoresizingMaskIntoConstraints = false;
     hiddenLabel.text = key;
     stackViewRight.addArrangedSubview(hiddenLabel);
     hiddenLabel.heightAnchor.constraint(equalToConstant: heightOfChildFilterCheckbox).isActive = true;
     self.setLeadingAndTralingSpaceFormParentView(hiddenLabel, parentView:stackViewRight);
     hiddenLabel.isHidden = true;
     
     let checkboxView = productfilterView();
     checkboxView.translatesAutoresizingMaskIntoConstraints = false;
     checkboxView.labelName.font = UIFont(fontName: "", fontSize: CGFloat(12.0));
     checkboxView.labelName.textAlignment = NSTextAlignment.left;
     let titleToSet = key.components(separatedBy: "#").last!;
     do  {
     let string = try NSMutableAttributedString(data: (titleToSet.data(using: String.Encoding.unicode)!), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName: UIFont.systemFont(ofSize: 13)], documentAttributes: nil)
     checkboxView.labelName.attributedText = string
     } catch {
     
     }
     
     if let _ = selectedFiltersArray[self.currentParentFilter]?.index(of: key) {
     checkboxView.checkBoxImage.image = UIImage(named: "CheckedCheckbox");
     sender.backgroundColor = selectedColor;
     }
     
     checkboxView.filterButton.addTarget(self, action: #selector(ProductFiltersViewController.childFilterSelected(_:)), for: UIControlEvents.touchUpInside);
     stackViewRight.addArrangedSubview(checkboxView);
     checkboxView.heightAnchor.constraint(equalToConstant: heightOfChildFilterCheckbox).isActive = true;
     self.setLeadingAndTralingSpaceFormParentView(checkboxView, parentView:stackViewRight);
     }
     scrollViewRight.contentSize = CGSize(width: stackViewRight.frame.width, height: stackViewRight.frame.height);
     
     }
     
     func childFilterSelected(_ sender:UIButton){
     print("childFilterSelected");
     if let checkboxView = sender.superview?.superview as? productfilterView {
     
     var textToUse = "";
     if let index = stackViewRight.arrangedSubviews.index(of: checkboxView) {
     
     //print(stackView.arrangedSubviews[index])
     if let hiddenLabel = stackViewRight.arrangedSubviews[index-1] as? UILabel {
     textToUse = hiddenLabel.text!;
     }
     }
     print(textToUse);
     if(checkboxView.checkBoxImage!.image == UIImage(named:"UncheckedCheckbox")){
     checkboxView.checkBoxImage.image = UIImage(named: "CheckedCheckbox");
     }
     else{
     checkboxView.checkBoxImage.image = UIImage(named: "UncheckedCheckbox");
     }
     
     print(selectedFiltersArray);
     print(self.currentParentFilter);
     if let index = selectedFiltersArray[self.currentParentFilter]?.index(of: textToUse) {
     selectedFiltersArray[self.currentParentFilter]?.remove(at: index);
     }
     else{
     print(textToUse);
     selectedFiltersArray[self.currentParentFilter]?.append(textToUse);
     }
     
     print(stackViewLeft.arrangedSubviews[self.currentParentFilterIndex]);
     
     if let parentFilterButton = stackViewLeft.arrangedSubviews[self.currentParentFilterIndex] as? UIButton {
     if((selectedFiltersArray[self.currentParentFilter]?.count)! > 0){
     parentFilterButton.backgroundColor = selectedColor;
     }
     else{
     parentFilterButton.backgroundColor = currentTappedColor;
     }
     }
     
     }
     }
     */
    @objc func applyFilterButtonPressed(_ sender:UIButton){
        if(minTextField.text == "")
        {
            self.view.makeToast("Please enter minimum price".localized, duration: 2.0, position: .bottom, title: nil, image: nil, style: nil, completion: nil);
            return;
        }
        if(maxTextField.text == "")
        {
            self.view.makeToast("Please enter maximum price".localized, duration: 2.0, position: .bottom, title: nil, image: nil, style: nil, completion: nil);
            return;
        }
        if let minPrice = Double(minTextField.text!)
        {
            if let maxPrice = Double(maxTextField.text!)
            {
                if(maxPrice<minPrice)
                {
                    self.view.makeToast("Maximum price cannot be less than minimum price".localized, duration: 2.0, position: .bottom, title: nil, image: nil, style: nil, completion: nil);
                    return;
                }
            }
        }
        selectedFiltersArray = ["minprice": minTextField.text!, "maxprice": maxTextField.text!];
        //selectedFiltersArray=["price":["Rs."+minTextField.text!+"#Rs."+maxTextField.text!]]
        UserDefaults.standard.set(self.selectedFiltersArray, forKey: "filters");
        if let pc = vc as? cedMageSubCategories{
            self.navigationController?.popViewController(animated: true, completion: {
                pc.loadFilteredData()
            })
            
        }
    }
    
    @objc func clearFilterButtonPressed(_ sender:UIButton){
        
        print("clearFilterButtonPressed");
        UserDefaults.standard.removeObject(forKey: "filters");
        //defaults.removeObject(forKey: "filtersToSend");
        //NotificationCenter.default.post(name: NSNotification.Name("loadFilteredProducts"), object: nil);
        if let pc = vc as? cedMageSubCategories{
            self.navigationController?.popViewController(animated: true, completion: {
                pc.loadFilteredData()
            })
            
        }
    }
    
    
    func setLeadingAndTralingSpaceFormParentView(_ view:UIView,parentView:UIView){
        parentView.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0));
        parentView.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0));
    }
    
    func translateAccordingToDevice(_ value:CGFloat)->CGFloat{
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            // iPad
            return value*1.5;
        }
        return value;
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

