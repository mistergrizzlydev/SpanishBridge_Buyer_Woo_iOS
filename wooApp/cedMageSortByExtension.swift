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

extension CategoryProductsView{
    
    @objc func sortbyButtonPressed(_ sender:UIButton){
        print("sortbyButtonPressed");
        print(sortByArray)
        let visualEffectView = UIView();
        visualEffectView.tag = 151;
        self.addGesturesTohideView(v: visualEffectView);
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        
        //visualEffectView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.5);
        visualEffectView.addSubview(blurEffectView)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(visualEffectView);
        self.view.addConstraint(NSLayoutConstraint(item: visualEffectView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0));
        self.view.addConstraint(NSLayoutConstraint(item: visualEffectView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0));
        self.view.addConstraint(NSLayoutConstraint(item: visualEffectView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0));
        self.view.addConstraint(NSLayoutConstraint(item: visualEffectView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0));
        
        // rendering sort by section
        let sortByWrapperView = SortByView();
        sortByWrapperView.tag = 181;
        sortByWrapperView.translatesAutoresizingMaskIntoConstraints  = false;
        
        sortByWrapperView.topLabel.text = "Sort Items By :".localized;
        sortByWrapperView.topLabel.textColor = UIColor.white;
        sortByWrapperView.topLabel.setThemeColor();
        sortByWrapperView.topLabelHeight.constant = CGFloat(40.0);
        sortByWrapperView.topLabel.textColor = wooSetting.textColor;
        /*if #available(iOS 12.0, *) {
            if(traitCollection.userInterfaceStyle == .dark)
            {
                sortByWrapperView.topLabel.textColor = wooSetting.darkModeTextColor
            }
        }*/
        visualEffectView.addSubview(sortByWrapperView);
        visualEffectView.addConstraint(NSLayoutConstraint(item: sortByWrapperView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: visualEffectView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0));
        visualEffectView.addConstraint(NSLayoutConstraint(item: sortByWrapperView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: visualEffectView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0));
        visualEffectView.addConstraint(NSLayoutConstraint(item: sortByWrapperView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: translateAccordingToDevice(280)));
        
        
        
        // adding stackview
        let sortByStackView = UIStackView();
        sortByStackView.translatesAutoresizingMaskIntoConstraints = false;
        sortByStackView.axis  = NSLayoutConstraint.Axis.vertical;
        sortByStackView.distribution  = UIStackView.Distribution.equalSpacing;
        sortByStackView.alignment = UIStackView.Alignment.center;
        sortByStackView.spacing   = 2.0;
        sortByWrapperView.sortByWrapperScrollView.addSubview(sortByStackView);
        sortByWrapperView.addConstraint(NSLayoutConstraint(item: sortByStackView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: sortByWrapperView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0));
        sortByWrapperView.addConstraint(NSLayoutConstraint(item: sortByStackView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: sortByWrapperView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0));
        sortByWrapperView.sortByWrapperScrollView.addConstraint(NSLayoutConstraint(item: sortByStackView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: sortByWrapperView.sortByWrapperScrollView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0));
        sortByWrapperView.sortByWrapperScrollView.addConstraint(NSLayoutConstraint(item: sortByStackView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: sortByWrapperView.sortByWrapperScrollView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0));
        
        let buttonHeight = translateAccordingToDevice(CGFloat(30.0));
        print(sortByArray);
        var sortTitleTag = 2500
        for (_,value) in self.sortByArray{
            let button = UIButton();
            button.translatesAutoresizingMaskIntoConstraints = false;
            //button.titleLabel?.font = UIFont(fontName: "", fontSize: CGFloat(15.0));
            button.backgroundColor = UIColor.clear;
            button.setTitleColor(UIColor.black, for: UIControl.State.normal);
            button.setTitle(value.localized, for: UIControl.State.normal);
            button.tag = sortTitleTag;
            button.addTarget(self, action: #selector(sortByOptionSelected(_:)), for: UIControl.Event.touchUpInside);
            sortByStackView.addArrangedSubview(button);
            button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true;
            sortTitleTag += 1;
            //self.setLeadingAndTralingSpaceFormParentView(button, parentView:sortByStackView);
        }
        
        let heightOfSortBySection = translateAccordingToDevice(CGFloat(40.0))+(CGFloat(sortByArray.count)*translateAccordingToDevice(CGFloat(30.0)))+(CGFloat(sortByArray.count)*(CGFloat(5.0)))+5;
        if(heightOfSortBySection < 300){
            visualEffectView.addConstraint(NSLayoutConstraint(item: sortByWrapperView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: heightOfSortBySection));
        }
        else{
            visualEffectView.addConstraint(NSLayoutConstraint(item: sortByWrapperView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: translateAccordingToDevice(300)));
        }
    }
    func addGesturesTohideView(v:UIView){
        //        //code to add gestures to dismiss the popover
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideView(_:)));
        v.addGestureRecognizer(tapGesture);
        tapGesture.delegate=self;
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(hideView(_:)));
        upSwipe.direction = UISwipeGestureRecognizer.Direction.up;
        v.addGestureRecognizer(upSwipe)
        upSwipe.delegate=self;
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(hideView(_:)));
        downSwipe.direction = UISwipeGestureRecognizer.Direction.down;
        v.addGestureRecognizer(downSwipe)
        downSwipe.delegate=self;
        
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(hideView(_:)));
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right;
        v.addGestureRecognizer(rightSwipe)
        rightSwipe.delegate=self;
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(hideView(_:)));
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left;
        v.addGestureRecognizer(leftSwipe)
        leftSwipe.delegate=self;
    }
    //function to dismiss the custom popover
    @objc func hideView(_ recognizer: UITapGestureRecognizer){
        self.view.viewWithTag(151)?.removeFromSuperview();
    }
    
    //delegate function to handle touch events on the custom popover
    @objc(gestureRecognizer:shouldReceiveTouch:) func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool{
        if let innerView = self.view.viewWithTag(181) as? SortByView {
            if(touch.view!.isDescendant(of: innerView))
            {
                return false;
            }
            return true;
        }
        return true;
    }
    @objc func sortByOptionSelected(_ sender:UIButton){
        //let title = sender.titleLabel?.text!;
        let tag = sender.tag;
        var sortTitleTag = 2500;
        for(key,_) in sortByArray
        {
            if(tag == sortTitleTag)
            {
                sortBy = key;
            }
            sortTitleTag += 1;
        }
        self.view.viewWithTag(151)?.removeFromSuperview();
        NotificationCenter.default.post(name:  NSNotification.Name("loadProducts"), object: nil);
        /*let val = self.sortByArray[key!]!;
        let sortValuePicked = (key?.components(separatedBy: ":").first!)!;
        
        print(key);
        print(val);
        print(sortValuePicked);
        
        
        
        if(searchString != ""){
            //self.flag_sortby=true
            self.makeRequestToAPI("mobiconnect/category/categoryProducts/",dataToPost: ["q":searchString, "page":String(describing: currentpage), "order":sortValuePicked, "dir":val]);
        }
        else{
            self.flag_sortby=true
            self.clearViewAndVariables()
            
            self.makeRequestToAPI("mobiconnect/catalog/products/",dataToPost: ["id":selectedCategory, "page":String(describing: currentpage), "order":sortValuePicked, "dir":val]);
        }*/
    }
    
}
