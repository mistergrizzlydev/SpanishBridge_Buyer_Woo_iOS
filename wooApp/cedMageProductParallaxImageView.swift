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
class ProductParallaxImageView: UIView,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate{
    
    var productImgsArray = [String]();
    
    // Our custom view from the XIB file
    var view: UIView!
    
    @IBOutlet weak var offerText: UILabel!
    //outlets
    var rootPage = UIViewController()
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imageWrapperView: UIView!
    @IBOutlet weak var showSimilarProductsButton: UIButton!
    @IBOutlet weak var wishlistButton: UIButton!
    @IBOutlet weak var productMainImage: UIImageView!
    @IBOutlet weak var productGalleryImagesCollectionView: UICollectionView!
    @IBOutlet weak var outOfStockImage: UIImageView!
    
    @IBOutlet weak var heightOfImagesSection: NSLayoutConstraint!
    
    override init(frame: CGRect)
    {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup()
    {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        //extra setup
        //imageWrapperView.makeCard(imageWrapperView, cornerRadius: 2, color: UIColor.black, shadowOpacity: 0.4);
       
        productMainImage.isUserInteractionEnabled = true;
        outOfStockImage.isHidden = true;
        productGalleryImagesCollectionView.delegate = self;
        productGalleryImagesCollectionView.dataSource = self;
        productGalleryImagesCollectionView.register(UINib(nibName: "ProductGalleryImagesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "productGalleryImagesCollectionCell");
        
      //  heightOfImagesSection.constant = translateAccordingToDevice(CGFloat(50.0));
        
        //showSimilarProductsButton.makeCard(showSimilarProductsButton.imageView!, cornerRadius: 2, color: UIColor.black, shadowOpacity: 0.4);
        //showSimilarProductsButton.makeViewCircled(size: CGFloat(30.0));
        //extra setup
        
        
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view);
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ProductParallaxImageView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    /* colection view function for product images */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
          pageControl.numberOfPages = productImgsArray.count
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productImgsArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productGalleryImagesCollectionCell", for: indexPath) as! ProductGalleryImagesCollectionCell;
        
        cell.productGalleryImage.sd_setImage(with: URL(string: productImgsArray[(indexPath as NSIndexPath).row]), placeholderImage: UIImage(named: "placeholder"))
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = UIStoryboard(name: "productsData", bundle: nil).instantiateViewController(withIdentifier: "imageRoot") as! imageSliderRoot
        //cedMage().storeParameterInteger(parameter: 0)
        viewController.pageData = productImgsArray as NSArray
        self.rootPage.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
       
        //let width = (collectionView.bounds.size.width - 5 * 3) / 2 //some width
        let height = collectionView.bounds.size.height-5 //ratio
        let width = collectionView.bounds.size.width //some width
        
        return CGSize(width: width, height: height);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5);
    }
    /* colection view function for product images */
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(self.productGalleryImagesCollectionView.contentOffset.x) / Int(self.productGalleryImagesCollectionView.frame.size.width);
    }
  
    
}
