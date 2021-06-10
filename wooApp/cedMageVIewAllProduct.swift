//
//  cedMageVIewAllProduct.swift
//  wooApp
//
//  Created by cedcoss on 22/01/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import UIKit

class cedMageVIewAllProduct: mageBaseViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
   
    

    @IBOutlet var collectionView: UICollectionView!
    var allProducts = [[String:String]]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
        self.updateBadge();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
    }
  
}
extension cedMageVIewAllProduct
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return allProducts.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
       {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "viewAllCell", for: indexPath) as! cedMageViewAllCollectionViewCell
        UIView.animate(withDuration: 0.5, delay: 0.5 * Double(indexPath.row), usingSpringWithDamping: 5, initialSpringVelocity: 2, options: indexPath.row % 2 == 0 ? .transitionFlipFromLeft : .transitionFlipFromRight, animations: {

            if indexPath.row % 2 == 0 {
                UIViewController.viewSlideInFromLeft(toRight: cell)
            }
            else {
                UIViewController.viewSlideInFromRight(toLeft: cell)
            }

        }, completion: { (done) in
            //cell.isAnimated = true
        })
        let product = allProducts[indexPath.row]
        cell.productName.text =  product["productName"]
        cell.productPrice.text =  product["productPrice"]
        cell.productName.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        cell.productName.textColor = wooSetting.subTextColor
        cell.productPrice.font = mageWooCommon.setCustomFont(type: .regular, size: 14)
        cell.productPrice.textColor = UIColor.red
       if let imageUrl = product["productImage"]
       {
        if(imageUrl != "")
        {


            cell.productImg.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(contentsOfFile: wooSetting.productPlaceholder))

        }
        else
        {
            cell.productImg.image = UIImage(contentsOfFile: wooSetting.productPlaceholder)
        }
        }
        cell.cardView()
        return cell
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if let productId = allProducts[indexPath.row]["productId"]
        {
            let viewControl = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "wooProductView") as! mageWooProductView
            viewControl.productId = productId
            //parent.present(viewControl, animated: true, completion: nil)
            self.navigationController?.pushViewController(viewControl, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       return CGSize(width: collectionView.frame.width/2, height: 250)
    }
}

extension UIViewController:CAAnimationDelegate
{
    static let kSlideAnimationDuration: CFTimeInterval = 0.4

        static func viewSlideInFromRight(toLeft views: UIView)
        {
            var transition: CATransition? = nil
            transition = CATransition.init()
            transition?.duration = kSlideAnimationDuration
            transition?.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition?.type = CATransitionType.push
            transition?.subtype = CATransitionSubtype.fromRight
    //        transition?.delegate = (self as! CAAnimationDelegate)
            views.layer.add(transition!, forKey: nil)
        }

        static func viewSlideInFromLeft(toRight views: UIView)
        {
            var transition: CATransition? = nil
            transition = CATransition.init()
            transition?.duration = kSlideAnimationDuration
            transition?.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition?.type = CATransitionType.push
            transition?.subtype = CATransitionSubtype.fromLeft
    //        transition?.delegate = (self as! CAAnimationDelegate)
            views.layer.add(transition!, forKey: nil)
        }

        static func viewSlideInFromTop(toBottom views: UIView) {
            var transition: CATransition? = nil
            transition = CATransition.init()
            transition?.duration = kSlideAnimationDuration
            transition?.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition?.type = CATransitionType.push
            transition?.subtype = CATransitionSubtype.fromBottom
    //        transition?.delegate = (self as! CAAnimationDelegate)
            views.layer.add(transition!, forKey: nil)
        }

        static func viewSlideInFromBottom(toTop views: UIView) {
            var transition: CATransition? = nil
            transition = CATransition.init()
            transition?.duration = kSlideAnimationDuration
            transition?.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition?.type = CATransitionType.push
            transition?.subtype = CATransitionSubtype.fromTop
    //        transition?.delegate = (self as! CAAnimationDelegate)
            views.layer.add(transition!, forKey: nil)
        }
}
