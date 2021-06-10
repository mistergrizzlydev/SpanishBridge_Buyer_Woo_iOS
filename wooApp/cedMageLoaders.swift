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

class cedMageLoaders: NSObject {
    var i = 0
    class func addDefaultLoader(me:UIViewController)
    {
        
        let view=UIView();
        view.tag=123321123;
        view.frame = CGRect(x: 0, y: 0, width: 60, height: 60);
        view.center=me.view.center;
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth];
       //showLoadingpost(params: view)
        
        let loader = MMMaterialDesignSpinner()
        loader.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        loader.center = CGPoint(x: view.frame.size.width  / 2, y: view.frame.size.height/2-20)
        loader.lineWidth = 5
        loader.startAnimating()
        loader.layer.borderColor = UIColor.black.cgColor
        loader.layer.cornerRadius = 25
        loader.layer.opacity = 0.3
        view.addSubview(loader)
        me.view.addSubview(view);
        //addImageFliploader(me: me)
    }
    class func addDefaultLoader_withlockedbackground(me:UIViewController)
    {
        
        let view=UIView();
        view.tag=123321123;
         view.frame = UIScreen.main.bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth];
        //showLoadingpost(params: view)
        
        let loader = MMMaterialDesignSpinner()
        loader.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        loader.center = CGPoint(x: view.frame.size.width  / 2, y: view.frame.size.height/2-20)
        loader.lineWidth = 5
        loader.startAnimating()
        loader.layer.borderColor = UIColor.black.cgColor
        loader.layer.cornerRadius = 25
        loader.layer.opacity = 0.3
        view.addSubview(loader)
        me.view.addSubview(view);
        //addImageFliploader(me: me)
    }
    static func addImageFliploader(me:UIViewController) {
       
        let view=UIView();
        view.tag=88888585;
        view.frame = UIScreen.main.bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth];
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        view.addSubview(blurEffectView)
        let containerView = UIView(frame: CGRect(x: UIScreen.main.bounds.width/2 - 40, y: UIScreen.main.bounds.height/2 - 80, width: 80, height: 80));
        containerView.backgroundColor = UIColor.yellow
        //containerView.center = me.view.center
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.frame = CGRect(x: 10, y: 10, width: 60, height: 60);
        imageView.contentMode = .scaleAspectFit
        // imageView.frame.size = CGSize(width: 80, height: 80)
        imageView.cardView()
        containerView.addSubview(imageView)
        view.addSubview(containerView)
        me.view.addSubview(view)
        cedMageLoaders().animate(imageView: imageView, container: containerView)
        
    }
    
    func animate(imageView:UIImageView,container:UIView){
        var images = ["gramophone","guitar","piano","trumpet"]
        if(i > images.count || i == images.count){
            i = 0
        }
        
        //statsView.createButton("Button name") { [weak self] in
        if(i < images.count){
            UIView.transition(with: container, duration: 1, options: UIView.AnimationOptions.transitionFlipFromRight, animations: {
                () in
                imageView.image = UIImage(named: images[(self.i)])
                //imageView.backgroundColor = self.getRandomColor()
                }, completion: {
                    Void in
                    self.i = self.i + 1
                    self.animate(imageView: imageView,container:container)
                    
            })
        }
    }

    //code to rotate Image as loading Indicator
   class func runSpinAnimationOn(view: UIView, duration: Double, rotation: Double, `repeat`: Float) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = NSNumber(value: 0.0)
        animation.toValue = NSNumber(value: 3.14 * 2.0)
        animation.duration = duration
        animation.isCumulative = true
        animation.repeatCount = `repeat`
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards;
        view.layer.add(animation, forKey: "rotationAnimation")
    }
    //end of code to rotate
    
    //loading post images
    
   class func showLoadingpost(params:UIView)
    {
        let loadingAlert=UIView(); //making toast view
        
        //setting size and look of toast
        loadingAlert.frame=CGRect(x:0,y: 0, width:60, height:60);
        loadingAlert.backgroundColor = UIColor.clear
        loadingAlert.alpha = 0.7;
        loadingAlert.center = CGPoint(x:params.frame.size.width  / 2,y:params.frame.size.height/2);
        loadingAlert.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        //loadingAlert.layer.cornerRadius=8.0;
        loadingAlert.clipsToBounds=true;
        // loadingAlert.layer.shadowColor = UIColor.whiteColor().CGColor
        loadingAlert.layer.shadowOffset = CGSize.zero
        loadingAlert.layer.shadowOpacity = 0.5
        //loadingAlert.layer.shadowRadius = 5
        //toast setting end
        params.backgroundColor = .clear
        let imgView=UIImageView(image: UIImage(named: "loder"));  //making image view to act as custom loading indicator
        
        imgView.frame=CGRect(x:0, y:0, width:60,height:60);
        loadingAlert.tag = 654321
        loadingAlert.addSubview(imgView)
        self.runSpinAnimationOn(view: imgView, duration: 1, rotation: .pi / 2 / 60, repeat: MAXFLOAT)
        params.addSubview(loadingAlert);  //adding toast to view
    }
    
    class func removeLoadingIndicator(me:UIViewController)
    {
       
        me.view.viewWithTag(123321123)?.removeFromSuperview();
    }
}
