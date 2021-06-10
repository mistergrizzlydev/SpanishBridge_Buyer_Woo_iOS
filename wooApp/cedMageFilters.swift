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

class mageWooFilters: mageBaseViewController {

    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var leftView: UIView!
    
    @IBOutlet weak var rightView: UIView!
    
    var filterData = [String:[String:String]]();
    var jsonForFilters:JSON!;
    
    var scrollViewLeft : UIScrollView!;
    var scrollViewRight : UIScrollView!;
    var stackViewLeft : UIStackView!;
    var stackViewRight : UIStackView!;
    
    var heightOfChildFilterCheckbox = CGFloat();
    
    var filter_label = [String:String]();
    var filterArray = [String:[String]]();
    var selectedFiltersArray = [String:[String]]();
    var currentParentFilter = "";
    var currentParentFilterIndex = -1;
    
    let defaultColor = UIColor.lightGray;
    let currentTappedColor = UIColor.darkGray;
    var selectedColor : UIColor!;
    
    var defaults = UserDefaults.standard;
    override func viewDidLoad() {
        super.viewDidLoad()
        heightOfChildFilterCheckbox=translateAccordingToDevice(CGFloat(40))
        selectedColor = mageWooCommon.UIColorFromRGB(colorCode: "#F9C53D");
        
        /*if(defaults.object(forKey: "previousSelectedFilters") != nil){
            self.selectedFiltersArray = (defaults.object(forKey: "previousSelectedFilters") as? [String:[String]])!;
            print("previous::selectedFiltersArray");
            print(self.selectedFiltersArray);
            
        }
        
        for (_,val) in jsonForFilters["data"]["filter_label"]{
            self.filter_label[val["att_label"].stringValue] = val["att_code"].stringValue;
        }
        
        for (_,val) in jsonForFilters["data"]["filter"]{
            for(key,dataArray) in val{
                self.filterArray[key] = dataArray.arrayObject as? [String];
                if(defaults.object(forKey: "previousSelectedFilters") == nil){
                    self.selectedFiltersArray[key] = [String]();
                }
            }
        }*/
        
        
        applyButton.layer.borderColor = UIColor(hexString: "#407A52")?.cgColor
        applyButton.cardView()
        clearButton.cardView()
        applyButton.layer.borderWidth = 2
        applyButton.setTitleColor(UIColor.black, for: UIControl.State.normal);
        applyButton.setTitle("Apply Filter".localized, for: UIControl.State.normal);
        applyButton.addTarget(self, action: #selector(applyButtonPressed(_:)), for: UIControl.Event.touchUpInside);
        
        clearButton.layer.borderWidth = 2
        clearButton.layer.borderColor = UIColor(hexString: "#DC3023")?.cgColor
        clearButton.setTitleColor(UIColor.black, for: UIControl.State.normal);
        clearButton.setTitle("Clear Filter".localized, for: UIControl.State.normal);
        clearButton.addTarget(self, action: #selector(clearButtonPressed(_:)), for: UIControl.Event.touchUpInside);
        self.basicFoundationToRenderView(bottomMargin: CGFloat(0.0));
        /*if(self.filter_label.count > 0){
            self.basicFoundationToRenderView(bottomMargin: CGFloat(0.0));
        }
        else{
            self.renderNoDataImage(imageName: "");
        }*/
        
    }
    
    func basicFoundationToRenderView(bottomMargin:CGFloat){
        
        // left side section
        scrollViewLeft = UIScrollView();
        scrollViewLeft.translatesAutoresizingMaskIntoConstraints = false;
        scrollViewLeft.showsHorizontalScrollIndicator = false;
        scrollViewLeft.showsVerticalScrollIndicator = false;
        self.leftView.addSubview(scrollViewLeft);
        self.leftView.addConstraint(NSLayoutConstraint(item: scrollViewLeft, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.leftView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0));
        self.leftView.addConstraint(NSLayoutConstraint(item: scrollViewLeft, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.leftView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0));
        self.leftView.addConstraint(NSLayoutConstraint(item: scrollViewLeft, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.leftView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0));
        self.leftView.addConstraint(NSLayoutConstraint(item: scrollViewLeft, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.leftView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -(bottomMargin)));
        
        // adding stackview for left side
        stackViewLeft = UIStackView();
        stackViewLeft.translatesAutoresizingMaskIntoConstraints = false;
        stackViewLeft.axis  = NSLayoutConstraint.Axis.vertical;
        stackViewLeft.distribution  = UIStackView.Distribution.equalSpacing;
        stackViewLeft.alignment = UIStackView.Alignment.center;
        stackViewLeft.spacing   = 2.0;
        scrollViewLeft.addSubview(stackViewLeft);
        self.leftView.addConstraint(NSLayoutConstraint(item: stackViewLeft, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.leftView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0));
        self.leftView.addConstraint(NSLayoutConstraint(item: stackViewLeft, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.leftView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0));
        scrollViewLeft.addConstraint(NSLayoutConstraint(item: stackViewLeft, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: scrollViewLeft, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0));
        scrollViewLeft.addConstraint(NSLayoutConstraint(item: stackViewLeft, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: scrollViewLeft, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0));
        
        
        // right side section
        scrollViewRight = UIScrollView();
        scrollViewRight.translatesAutoresizingMaskIntoConstraints = false;
        scrollViewRight.showsHorizontalScrollIndicator = false;
        scrollViewRight.showsVerticalScrollIndicator = false;
        self.rightView.addSubview(scrollViewRight);
        self.rightView.addConstraint(NSLayoutConstraint(item: scrollViewRight, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.rightView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0));
        self.rightView.addConstraint(NSLayoutConstraint(item: scrollViewRight, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.rightView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0));
        self.rightView.addConstraint(NSLayoutConstraint(item: scrollViewRight, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.rightView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0));
        self.rightView.addConstraint(NSLayoutConstraint(item: scrollViewRight, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.rightView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -(bottomMargin)));
        
        // adding stackview for right side
        stackViewRight = UIStackView();
        stackViewRight.translatesAutoresizingMaskIntoConstraints = false;
        stackViewRight.axis  = NSLayoutConstraint.Axis.vertical;
        stackViewRight.distribution  = UIStackView.Distribution.equalSpacing;
        stackViewRight.alignment = UIStackView.Alignment.center;
        stackViewRight.spacing   = 2.0;
        scrollViewRight.addSubview(stackViewRight);
        self.rightView.addConstraint(NSLayoutConstraint(item: stackViewRight, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.rightView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0));
        self.rightView.addConstraint(NSLayoutConstraint(item: stackViewRight, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.rightView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0));
        scrollViewRight.addConstraint(NSLayoutConstraint(item: stackViewRight, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: scrollViewRight, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0));
        scrollViewRight.addConstraint(NSLayoutConstraint(item: stackViewRight, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: scrollViewRight, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0));
        var parentTag = 0;
        for(key,value) in filterData
        {
            let checkboxButton = productfilterView();
            stackViewLeft.addArrangedSubview(checkboxButton);
            //checkboxButton.labelName.isHidden=true;
            checkboxButton.labelName.text = key
            checkboxButton.checkBoxImage.image = UIImage(named: "unchecked");
            //checkboxButton.checkBoxImage.isHidden=true;
            //checkboxButton.filterButton.setImage(UIImage(named: "unchecked"), for: .normal);
            //checkboxButton.filterButton.setTitle(key, for: .normal);
            //checkboxButton.filterButton.setTitleColor(UIColor.black, for: .normal)
            checkboxButton.filterButton.addTarget(self, action: #selector(parentFilterSelected(_:)), for: UIControl.Event.touchUpInside);
            checkboxButton.filterButton.tag = 1000 + parentTag;
            checkboxButton.tag = parentTag;
            parentTag += 1;
            if(defaults.value(forKey: "filters") != nil)
            {
                let filter = defaults.value(forKey: "filters") as? [String:String];
                for(key1,_) in filter!
                {
                    for(keyname,_) in value
                    {
                        if(key1 == keyname)
                        {
                            checkboxButton.checkBoxImage.image = UIImage(named: "checked");
                        }
                    }
                    
                }
                
            }
            if(checkboxButton.checkBoxImage.image == UIImage(named: "checked"))
            {
                //var i = 10000
                for(key1,value1) in value
                {
                    let textBox = SkyFloatingLabelTextField(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
                    stackViewRight.addArrangedSubview(textBox)
                    textBox.placeholder = value1;
                    if(key1 == "minprice")
                    {
                        textBox.tag = 10000;
                    }
                    else{
                        textBox.tag = 10001;
                    }
                    //textBox.tag = i;
                    //i += 1;
                }

            }
        }
        
        scrollViewLeft.contentSize = CGSize(width: stackViewLeft.frame.width, height: stackViewLeft.frame.height);
        scrollViewRight.contentSize = CGSize(width: stackViewRight.frame.width, height: stackViewRight.frame.height);
        
    }

    @objc func parentFilterSelected(_ sender:UIButton){
        //let title = sender.currentTitle;
        let checkboxView = sender.superview?.superview as? productfilterView
        let title = checkboxView?.labelName.text;
        var parentTag = 0;
        for(key,value) in filterData
        {
            if(key == title)
            {
                //checkboxImageView?.image = UIImage(named: "checked");
                if(checkboxView?.checkBoxImage.image == UIImage(named: "unchecked"))
                {
                    checkboxView?.checkBoxImage.image = UIImage(named: "checked")
                    for(key1,value1) in value
                    {
                        let textBox = SkyFloatingLabelTextField(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
                        stackViewRight.addArrangedSubview(textBox)
                        textBox.placeholder = value1;
                        if(key1 == "minprice")
                        {
                            textBox.tag = 10000;
                        }
                        else{
                            textBox.tag = 10001;
                        }
                        
                        
                    }

                }
                
            }
            parentTag += 1;
        }
    }
    
    @objc func applyButtonPressed(_ sender:UIButton){
        print("applyButtonPressed");
        let minPrice = (self.view.viewWithTag(10000) as? SkyFloatingLabelTextField)?.text
        let maxPrice = (self.view.viewWithTag(10001) as? SkyFloatingLabelTextField)?.text
        let title = "pricefilter".localized
        if(minPrice != "" && maxPrice != "")
        {
            for(key,value) in filterData
            {
                if(key == title)
                {
                    var filterToSend = [String:String]();
                    for(key1,_) in value
                    {
                        if(key1 == "minprice")
                        {
                            filterToSend[key1]=minPrice;
                        }
                        else
                        {
                            filterToSend[key1]=maxPrice;
                        }
                        
                    }
                    defaults.set(filterToSend, forKey: "filters")
                }
            }

        }
        NotificationCenter.default.post(name:  NSNotification.Name("loadProducts"), object: nil);
        self.navigationController!.popViewController(animated: true);
        
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

    @objc func clearButtonPressed(_ sender:UIButton){
        print("clearButtonPressed");
        //defaults.removeObject(forKey: "previousSelectedFilters");
        defaults.removeObject(forKey: "filters");
        NotificationCenter.default.post(name: NSNotification.Name("loadProducts"), object: nil);
        self.navigationController!.popViewController(animated: true);
    }
    
 
    /*func renderNoDataImage(imageName:String){
        let noDataImageView = UIImageView();
        noDataImageView.translatesAutoresizingMaskIntoConstraints = false;
        noDataImageView.image = UIImage(named: imageName);
        self.view.addSubview(noDataImageView);
        self.view.addConstraint(NSLayoutConstraint(item: noDataImageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0));
        self.view.addConstraint(NSLayoutConstraint(item: noDataImageView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0));
        self.view.addConstraint(NSLayoutConstraint(item: noDataImageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0));
        self.view.addConstraint(NSLayoutConstraint(item: noDataImageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0));
    }
    
    func basicFoundationToRenderView(bottomMargin:CGFloat){
        
        // left side section
        scrollViewLeft = UIScrollView();
        scrollViewLeft.translatesAutoresizingMaskIntoConstraints = false;
        scrollViewLeft.showsHorizontalScrollIndicator = false;
        scrollViewLeft.showsVerticalScrollIndicator = false;
        self.leftView.addSubview(scrollViewLeft);
        self.leftView.addConstraint(NSLayoutConstraint(item: scrollViewLeft, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.leftView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0));
        self.leftView.addConstraint(NSLayoutConstraint(item: scrollViewLeft, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.leftView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0));
        self.leftView.addConstraint(NSLayoutConstraint(item: scrollViewLeft, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.leftView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0));
        self.leftView.addConstraint(NSLayoutConstraint(item: scrollViewLeft, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.leftView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -(bottomMargin)));
        
        // adding stackview for left side
        stackViewLeft = UIStackView();
        stackViewLeft.translatesAutoresizingMaskIntoConstraints = false;
        stackViewLeft.axis  = UILayoutConstraintAxis.vertical;
        stackViewLeft.distribution  = UIStackViewDistribution.equalSpacing;
        stackViewLeft.alignment = UIStackViewAlignment.center;
        stackViewLeft.spacing   = 2.0;
        scrollViewLeft.addSubview(stackViewLeft);
        self.leftView.addConstraint(NSLayoutConstraint(item: stackViewLeft, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.leftView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0));
        self.leftView.addConstraint(NSLayoutConstraint(item: stackViewLeft, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.leftView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0));
        scrollViewLeft.addConstraint(NSLayoutConstraint(item: stackViewLeft, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: scrollViewLeft, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0));
        scrollViewLeft.addConstraint(NSLayoutConstraint(item: stackViewLeft, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: scrollViewLeft, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0));
        
        
        // right side section
        scrollViewRight = UIScrollView();
        scrollViewRight.translatesAutoresizingMaskIntoConstraints = false;
        scrollViewRight.showsHorizontalScrollIndicator = false;
        scrollViewRight.showsVerticalScrollIndicator = false;
        self.rightView.addSubview(scrollViewRight);
        self.rightView.addConstraint(NSLayoutConstraint(item: scrollViewRight, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.rightView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0));
        self.rightView.addConstraint(NSLayoutConstraint(item: scrollViewRight, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.rightView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0));
        self.rightView.addConstraint(NSLayoutConstraint(item: scrollViewRight, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.rightView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0));
        self.rightView.addConstraint(NSLayoutConstraint(item: scrollViewRight, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.rightView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -(bottomMargin)));
        
        // adding stackview for right side
        stackViewRight = UIStackView();
        stackViewRight.translatesAutoresizingMaskIntoConstraints = false;
        stackViewRight.axis  = UILayoutConstraintAxis.vertical;
        stackViewRight.distribution  = UIStackViewDistribution.equalSpacing;
        stackViewRight.alignment = UIStackViewAlignment.center;
        stackViewRight.spacing   = 2.0;
        scrollViewRight.addSubview(stackViewRight);
        self.rightView.addConstraint(NSLayoutConstraint(item: stackViewRight, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.rightView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0));
        self.rightView.addConstraint(NSLayoutConstraint(item: stackViewRight, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.rightView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0));
        scrollViewRight.addConstraint(NSLayoutConstraint(item: stackViewRight, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: scrollViewRight, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0));
        scrollViewRight.addConstraint(NSLayoutConstraint(item: stackViewRight, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: scrollViewRight, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0));
        
        var firstParentFilter = "";
        var currentIndex = 0;
        for (key,_) in filter_label{
            if(self.filterArray[filter_label[key]!] == nil){
                continue;
            }
            
            let button = UIButton();
            button.translatesAutoresizingMaskIntoConstraints = false;
            //button.titleLabel?.font = UIFont(fontName: "", fontSize: CGFloat(14.0));
            
            let keyToUse = (filter_label[key]!);
            print("filter_label[key]");
            print(keyToUse);
            print(selectedFiltersArray);
            print(self.selectedFiltersArray[keyToUse]?.count);
            
            if(firstParentFilter == ""){
                button.backgroundColor = currentTappedColor;
            }
            else{
                button.backgroundColor = defaultColor;
            }
            if(firstParentFilter == ""){
                firstParentFilter = filter_label[key]!;
                self.currentParentFilter = firstParentFilter;
                self.currentParentFilterIndex = currentIndex;
            }
            currentIndex = currentIndex+1;
            
            if let count  = self.selectedFiltersArray[keyToUse]?.count {
                if(count > 0 ){
                    button.backgroundColor = selectedColor;
                }
            }
            button.setTitleColor(UIColor.black, for: UIControlState.normal);
            button.setTitle(key, for: UIControlState.normal);
            button.addTarget(self, action: #selector(parentFilterSelected(_:)), for: UIControlEvents.touchUpInside);
            stackViewLeft.addArrangedSubview(button);
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true;
            self.setLeadingAndTralingSpaceFormParentView(button, parentView:stackViewLeft);
        }
        
        let arrayToLoopForSubfilters = self.filterArray[firstParentFilter]!;
        if(arrayToLoopForSubfilters.count == 0){
            let msg = "No Filter Found";
            self.view.makeToast(msg, duration: 2.0, position: .bottom, title: nil, image: nil, style: nil, completion: nil);
            return;
        }
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
            
            checkboxView.labelName.textAlignment = NSTextAlignment.left
            let titleToSet = key.components(separatedBy: "#").last!;
            print(titleToSet);
            print(selectedFiltersArray);
            print(currentParentFilter);
            if let _ = selectedFiltersArray[self.currentParentFilter]?.index(of: key) {
                checkboxView.checkBoxImage.image = UIImage(named: "CheckedCheckbox");
            }
            do  {
                let string = try NSMutableAttributedString(data: (titleToSet.data(using: String.Encoding.unicode)!), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName: UIFont.systemFont(ofSize: 13)], documentAttributes: nil)
                checkboxView.labelName.attributedText = string
            } catch {
                
            }
            
            
            checkboxView.filterButton.addTarget(self, action: #selector(childFilterSelected(_:)), for: UIControlEvents.touchUpInside);
            stackViewRight.addArrangedSubview(checkboxView);
            checkboxView.heightAnchor.constraint(equalToConstant: heightOfChildFilterCheckbox).isActive = true;
            self.setLeadingAndTralingSpaceFormParentView(checkboxView, parentView:stackViewRight);
        }
        scrollViewLeft.contentSize = CGSize(width: stackViewLeft.frame.width, height: stackViewLeft.frame.height);
        scrollViewRight.contentSize = CGSize(width: stackViewRight.frame.width, height: stackViewRight.frame.height);
        
    }
    
    func parentFilterSelected(_ sender:UIButton){
        print("parentFilterSelected");
        
        print(currentParentFilterIndex);
        if let previousParentFilter = stackViewLeft.arrangedSubviews[currentParentFilterIndex] as? UIButton {
            print(previousParentFilter.backgroundColor);
            if(previousParentFilter.backgroundColor == currentTappedColor){
                previousParentFilter.backgroundColor = defaultColor;
            }
        }
        
        if let index = stackViewLeft.arrangedSubviews.index(of: sender){
            self.currentParentFilterIndex = index;
        }
        sender.backgroundColor = currentTappedColor;
        
        stackViewRight.subviews.forEach({ $0.removeFromSuperview() });
        print(sender.titleLabel?.text!);
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
            //checkboxView.labelName.font = UIFont(fontName: "", fontSize: CGFloat(12.0));
            checkboxView.labelName.textAlignment = NSTextAlignment.left;
            let titleToSet = key.components(separatedBy: "#").last!;
            do  {
                let string = try NSMutableAttributedString(data: (titleToSet.data(using: String.Encoding.unicode)!), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName: UIFont.systemFont(ofSize: 13)], documentAttributes: nil)
                checkboxView.labelName.attributedText = string
            } catch {
                
            }
            
            if let _ = selectedFiltersArray[self.currentParentFilter]?.index(of: key) {
                checkboxView.checkBoxImage.image = UIImage(named: "checked");
                sender.backgroundColor = selectedColor;
            }
            
            checkboxView.filterButton.addTarget(self, action: #selector(childFilterSelected(_:)), for: UIControlEvents.touchUpInside);
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
            if(checkboxView.checkBoxImage!.image == UIImage(named:"unchecked")){
                checkboxView.checkBoxImage.image = UIImage(named: "checked");
            }
            else{
                checkboxView.checkBoxImage.image = UIImage(named: "unchecked");
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
    
    func applyButtonPressed(_ sender:UIButton){
        print("applyButtonPressed");
        var filtersToSend = "{";
        for (key,val) in selectedFiltersArray{
            if(val.count == 0){
                continue;
            }
            filtersToSend += "\""+key+"\":{";
            for innerVal in val{
                
                let tempData = innerVal.components(separatedBy: "#");
                filtersToSend += "\""+tempData.first!+"\":"+"\""+tempData.last!+"\",";
            }
            if(filtersToSend.characters.last! == ","){
                filtersToSend = filtersToSend.substring(to: filtersToSend.index(before: filtersToSend.endIndex));
            }
            filtersToSend += "},";
        }
        if(filtersToSend.characters.last! == ","){
            filtersToSend = filtersToSend.substring(to: filtersToSend.index(before: filtersToSend.endIndex));
        }
        filtersToSend += "}";
        
        print("filtersToSend");
        print(filtersToSend);
        
        defaults.set(self.selectedFiltersArray, forKey: "previousSelectedFilters");
        defaults.set(filtersToSend, forKey: "filtersToSend");
        NotificationCenter.default.post(name:  NSNotification.Name("loadProductsAgainId"), object: nil);
        self.navigationController!.popViewController(animated: true);
    }
    
    func clearButtonPressed(_ sender:UIButton){
        print("clearButtonPressed");
        defaults.removeObject(forKey: "previousSelectedFilters");
        defaults.removeObject(forKey: "filtersToSend");
        NotificationCenter.default.post(name: NSNotification.Name("loadProductsAgainId"), object: nil);
        self.navigationController!.popViewController(animated: true);
    }
    
    
    func setLeadingAndTralingSpaceFormParentView(_ view:UIView,parentView:UIView){
        parentView.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: parentView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0));
        parentView.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: parentView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0));
    }*/
    override func viewDidLayoutSubviews() {
        //super.viewDidLayoutSubviews()
        //scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func translateAccordingToDevice(_ value:CGFloat)->CGFloat{
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            // iPad
            return value*1.5;
        }
        return value;
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
