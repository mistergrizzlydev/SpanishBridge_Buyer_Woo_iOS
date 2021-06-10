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

public extension UIViewController {
    /**
     A convenience property that provides access to the SideNavigationViewController.
     This is the recommended method of accessing the SideNavigationViewController
     through child UIViewControllers.
     */
    public var sideDrawerViewController: cedMageSideDrawer? {
        var viewController: UIViewController? = self
        while viewController != nil {
            if viewController is cedMageSideDrawer {
                return viewController as? cedMageSideDrawer
            }
            viewController = viewController?.parent
        }
        return nil
    }
}

@objc public protocol cedMageSideDrawerControllerDelegate {
    @objc optional func drawerController(drawerController: cedMageSideDrawer, stateChanged state: cedMageSideDrawer.DrawerState)
}

public class cedMageSideDrawer: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Types
    
    @objc public enum DrawerDirection: Int {
        case Left, Right
    }
    
    @objc public enum DrawerState: Int {
        case Opened, Closed
    }
    
    private let _kContainerViewMaxAlpha : CGFloat = 0.2
    
    private let _kDrawerAnimationDuration: TimeInterval = 0.25
    
    // MARK: - Properties
    
    @IBInspectable var mainSegueIdentifier: String?
    
    @IBInspectable var drawerSegueIdentifier: String?
    
    private var _drawerConstraint: NSLayoutConstraint!
    
    private var _drawerWidthConstraint: NSLayoutConstraint!
    
    private var _panStartLocation = CGPoint.zero
    
    private var _panDelta: CGFloat = 0
    let blurryView:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
    lazy private var _containerView: UIView = {
        let view = UIView(frame: self.view.frame)
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(cedMageSideDrawer.didtapContainerView(gesture:))
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.0, alpha: 0)
       
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        return view
    }()
    
    public var screenEdgePanGestreEnabled = true
    public var currentFrontimage: UIImage!
    
    lazy private(set) var screenEdgePanGesture: UIScreenEdgePanGestureRecognizer = {
        let gesture = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: #selector(cedMageSideDrawer.handlePanGesture(sender:))
        )
        switch self.drawerDirection {
        case .Left: gesture.edges = .left
        case .Right: gesture.edges = .right
        }
        gesture.delegate = self
        return gesture
    }()
    
    lazy private(set) var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(cedMageSideDrawer.handlePanGesture(sender:))
        )
        gesture.delegate = self
        return gesture
    }()
    
    public weak var delegate: cedMageSideDrawerControllerDelegate?
    
    public var drawerDirection: DrawerDirection = .Left {
        didSet {
            switch drawerDirection {
            case .Left: screenEdgePanGesture.edges = .left
            case .Right: screenEdgePanGesture.edges = .right
            }
            let tmp = drawerViewController
            drawerViewController = tmp
        }
    }
    
    public var drawerState: DrawerState {
        get { return _containerView.isHidden ? .Closed : .Opened }
        set { setDrawerState(state: drawerState, animated: false) }
    }
    
    @IBInspectable public var drawerWidth: CGFloat = 240 {
        didSet { _drawerWidthConstraint?.constant = drawerWidth }
    }
    
    public var mainViewController: UIViewController! {
        
        didSet {
            if let oldController = oldValue {
                oldController.willMove(toParent: nil)
                oldController.view.removeFromSuperview()
                oldController.removeFromParent()
                
            }
            guard let mainViewController = mainViewController else { return }
            let viewDictionary = ["mainView" : mainViewController.view as AnyObject]
            mainViewController.view.translatesAutoresizingMaskIntoConstraints = false
            addChild(mainViewController)
            view.insertSubview(mainViewController.view, at: 0)
            view.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|-0-[mainView]-0-|",
                    options: [],
                    metrics: nil,
                    views: viewDictionary
                )
            )
            view.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|-0-[mainView]-0-|",
                    options: [],
                    metrics: nil,
                    views: viewDictionary
                )
            )
            mainViewController.didMove(toParent: self)
        }
    }
    
    public var drawerViewController : UIViewController? {
        didSet {
            if let oldController = oldValue {
               
                
                oldController.willMove(toParent: nil)
                oldController.view.removeFromSuperview()
                oldController.removeFromParent()
                
            }
            guard let drawerViewController = drawerViewController else { return }
            let viewDictionary = ["drawerView" : drawerViewController.view as AnyObject]
            let itemAttribute: NSLayoutConstraint.Attribute
            let toItemAttribute: NSLayoutConstraint.Attribute
            switch drawerDirection {
            case .Left:
                itemAttribute = .right
                toItemAttribute = .left
            case .Right:
                itemAttribute = .left
                toItemAttribute = .right
            }
            
           // drawerViewController.view.layer.shadowColor = UIColor.black.cgColor
           // drawerViewController.view.layer.shadowOpacity = 0.6
            //drawerViewController.view.layer.shadowRadius = 5.0
            drawerViewController.view.layer.opacity = 1
            
            drawerViewController.view.translatesAutoresizingMaskIntoConstraints = false
            addChild(drawerViewController)
            _containerView.addSubview(drawerViewController.view)
            _drawerWidthConstraint = NSLayoutConstraint(
                item: drawerViewController.view,
                attribute: NSLayoutConstraint.Attribute.width,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: nil,
                attribute: NSLayoutConstraint.Attribute.width,
                multiplier: 1,
                constant: drawerWidth
            )
            drawerViewController.view.addConstraint(_drawerWidthConstraint)
            
            _drawerConstraint = NSLayoutConstraint(
                item: drawerViewController.view,
                attribute: itemAttribute,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: _containerView,
                attribute: toItemAttribute,
                multiplier: 1,
                constant: 0
            )
            _containerView.addConstraint(_drawerConstraint)
            _containerView.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|-0-[drawerView]-0-|",
                    options: [],
                    metrics: nil,
                    views: viewDictionary
                )
            )
            
            _containerView.updateConstraints()
            drawerViewController.updateViewConstraints()
            drawerViewController.didMove(toParent: self)
           
        }
    }
    
    // MARK: - initialize
    
    public convenience init(drawerDirection: DrawerDirection, drawerWidth: CGFloat) {
        self.init()
        self.drawerDirection = drawerDirection
        self.drawerWidth = drawerWidth
    }
    
    // MARK: - Life Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let viewDictionary = ["_containerView": _containerView]
          self.blurryView.tag = 122
        view.addGestureRecognizer(screenEdgePanGesture)
        view.addGestureRecognizer(panGesture)
        view.addSubview(_containerView)
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[_containerView]-0-|",
                options: [],
                metrics: nil,
                views: viewDictionary
            )
        )
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[_containerView]-0-|",
                options: [],
                metrics: nil,
                views: viewDictionary
            )
        )
        _containerView.isHidden = true
        
        if let mainSegueID = mainSegueIdentifier {
            performSegue(withIdentifier: mainSegueID, sender: self)
        }
        if let drawerSegueID = drawerSegueIdentifier {
            performSegue(withIdentifier: drawerSegueID, sender: self)
        }
    }
    
    // MARK: - Public Method
    
    public func setDrawerState(state: DrawerState, animated: Bool) {
        _containerView.isHidden = false
        let duration: TimeInterval = animated ? _kDrawerAnimationDuration : 0
        setWindowLevel(windowLevel: state == .Opened ? UIWindow.Level.statusBar + 1 : UIWindow.Level.normal)
        UIView.animate(withDuration: duration,
                                   delay: 0,
                                   options: .curveEaseOut,
                                   animations: { () -> Void in
                                    switch state {
                                    case .Closed:
                                        
                                        self._drawerConstraint.constant = 0
                                        self._containerView.backgroundColor = UIColor(white: 0, alpha: 0)
                                        self._containerView.viewWithTag(122)?.removeFromSuperview()
                                    case .Opened:
                                        let constant: CGFloat
                                        switch self.drawerDirection {
                                        case .Left:
                                            constant = self.drawerWidth
                                        case .Right:
                                            constant = -self.drawerWidth
                                        }
                                        self._drawerConstraint.constant = constant
                                        self._containerView.backgroundColor = UIColor(
                                            white: 0
                                            , alpha: self._kContainerViewMaxAlpha
                                        )
                                     
//                                        self.blurryView.frame = CGRect(x:0,y:0,width:constant,height:( self._containerView.frame.height))
//                                      
//                                         self._containerView.insertSubview(self.blurryView, belowSubview: (self.drawerViewController?.view)!)
                                    }
                                    self._containerView.layoutIfNeeded()
        }) { (finished: Bool) -> Void in
            if state == .Closed {
                self._containerView.viewWithTag(122)?.removeFromSuperview()
                self._containerView.isHidden = true
            }
            self.delegate?.drawerController?(drawerController: self, stateChanged: state)
        }
    }
    
    public func transitionFromMainViewController(toViewController: UIViewController, duration: TimeInterval, options: UIView.AnimationOptions, animations: (() -> Void)?, completion: ((Bool) -> Void)?) {
        mainViewController.willMove(toParent: nil)
        addChild(toViewController)
        toViewController.view.frame = view.bounds
        transition(
            from: mainViewController,
            to: toViewController,
            duration: duration,
            options: options,
            animations: animations,
            completion: { [unowned self](result: Bool) in
                toViewController.didMove(toParent: self)
                self.mainViewController.removeFromParent()
                self.mainViewController = toViewController
                if let completion = completion {
                    completion(result)
                }
            })
    }
    
    public func toggleDrawer(animated: Bool = true) {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        currentFrontimage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        setDrawerState(
            state: drawerState == .Opened ? .Closed : .Opened,
            animated: animated)
    }
    
    // MARK: - Private Method
    
    @objc final func handlePanGesture(sender: UIGestureRecognizer) {
        _containerView.isHidden = false
        if sender.state == .began {
            _panStartLocation = sender.location(in: view)
        }
        
        let delta = CGFloat(sender.location(in: view).x - _panStartLocation.x)
        let constant : CGFloat
        let backGroundAlpha : CGFloat
        let drawerState : DrawerState
        
        switch drawerDirection {
        case .Left:
            drawerState = _panDelta < 0 ? .Closed : .Opened
            constant = min(_drawerConstraint.constant + delta, drawerWidth)
            backGroundAlpha = min(
                _kContainerViewMaxAlpha,
                _kContainerViewMaxAlpha * (abs(constant) / drawerWidth)
            )
        case .Right:
            drawerState = _panDelta > 0 ? .Closed : .Opened
            constant = max(_drawerConstraint.constant + delta, -drawerWidth)
            backGroundAlpha = min(
                _kContainerViewMaxAlpha,
                _kContainerViewMaxAlpha * (abs(constant) / drawerWidth)
            )
        }
        
        if (sender.state == .began) {
            if drawerState == .Closed {
                setWindowLevel(windowLevel: UIWindow.Level.statusBar + 1)
            }
        }
        
        _drawerConstraint.constant = constant
        _containerView.backgroundColor = UIColor(
            white: 0,
            alpha: backGroundAlpha
        )
        
        switch sender.state {
        case .changed:
            _panStartLocation = sender.location(in: view)
            _panDelta = delta
        case .ended, .cancelled:
            setDrawerState(state: drawerState, animated: true)
        default:
            break
        }
    }
    
    @objc final func didtapContainerView(gesture: UITapGestureRecognizer) {
        self.view.viewWithTag(1234)?.removeFromSuperview()
        setDrawerState(state: .Closed, animated: true)
    }
    
    private func setWindowLevel(windowLevel: UIWindow.Level) {
        if let delegate = UIApplication.shared.delegate {
            if let window = delegate.window {
                if let window = window {
                    window.windowLevel = windowLevel
                }
            }
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        switch gestureRecognizer {
        case panGesture:
            return drawerState == .Opened
        case screenEdgePanGesture:
            return screenEdgePanGestreEnabled ? drawerState == .Closed : false
        default:
            return touch.view == gestureRecognizer.view
        }
    }
}
