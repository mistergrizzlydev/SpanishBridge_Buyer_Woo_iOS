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

class cedMageSingleProductImage: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    var dataObject = String()
    var imageArray = [String]()
    override func  viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        //print(imageArray)
        self.scrollview.minimumZoomScale=1;
        self.scrollview.maximumZoomScale=4.0;
       
        self.scrollview.delegate=self
        let pinchzoom = UIPinchGestureRecognizer(target: self, action: #selector(cedMageSingleProductImage.pinchZoom(sender:)))
        
        self.imageView.addGestureRecognizer(pinchzoom)
        pinchzoom.delegate = self
        let tapzomm = UITapGestureRecognizer(target: self, action: #selector(cedMageSingleProductImage.tapZoom(sender:)))
        tapzomm.delegate = self
        tapzomm.numberOfTapsRequired = 2
        tapzomm.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(tapzomm)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colImg", for: indexPath)
        let imagView = cell.viewWithTag(110) as? UIImageView
        imagView?.sd_setImage(with: URL(string: imageArray[indexPath.row]), placeholderImage: UIImage(named: "placeholder"))
        
    /*cedMageImageLoader().loadImgFromUrl(urlString: imageArray[indexPath.row], completionHandler: {
            image,url in
            imagView?.image = image
            if(self.imageArray[indexPath.row] == self.dataObject){
                self.imageView.image = image
          
            }
        })*/
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageView.sd_setImage(with: URL(string: imageArray[indexPath.row]), placeholderImage: UIImage(named: "placeholder"))
    }
    
    @objc func tapZoom(sender: UITapGestureRecognizer) {
        if(self.scrollview.zoomScale == 4){
            self.scrollview.zoomScale = 1.0
        }
        else{
            self.scrollview.zoomScale = 4.0
        }
    }
    
    @objc func pinchZoom(sender: UIPinchGestureRecognizer) {
        self.imageView.transform = self.imageView.transform.scaledBy(x: sender.scale, y: sender.scale);
        print("Zooming")
        sender.scale = 1.0
        
    }
    
    
     func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}
