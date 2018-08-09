//
//  FTPageController.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/8.
//

import UIKit

public protocol FTPageControllerDelegate: NSObjectProtocol {
    func pageController(pageController: FTPageController, didScollToPage page: NSInteger)
    func pageController(pageController: FTPageController, isScolling fromPage: NSInteger, toPage: NSInteger, percent: CGFloat)
}

public protocol FTPageControllerDataSource: NSObjectProtocol {
    
    func numberOfViewControllers(pageController: FTPageController) -> NSInteger
    func pageController(pageController: FTPageController, viewControllerForIndex index: NSInteger) -> UIViewController

}

public enum FTPCSetupMode {
    case Manually
    case Delegate
}

public enum FTPCSegementWidthMode {
    case auto
    case fixed
    case fill
}

public extension UIScreen {
    
    public static func width() -> CGFloat {
        return self.main.bounds.size.width
    }
    
    public static func height() -> CGFloat {
        return self.main.bounds.size.height
    }
    
}

public struct FTPCConfig {
    
    public var segementViewFrame: CGRect = CGRect(x: 0.0, y: 0.0, width: UIScreen.width(), height: 40.0)
    public var scrollViewFrame: CGRect = CGRect(x: 0.0, y: 0.0, width: UIScreen.height(), height: 40.0)
    public var segementEnableScrolling: Bool = true
    public var contentEnableScrolling: Bool = true
    public var segementModel: FTPCSegementWidthMode = .auto
    public var titleMargin: CGFloat = 25.0
    public var titleDefaultColor: UIColor = UIColor.darkGray
    public var titleSelectedColor: UIColor = UIColor.black
    public var titleDefaultFontSize: CGFloat = 14.0
    public var titleSelectedFontSize: CGFloat = 15.0
    public var indicatorHeight: CGFloat = 2.0
    public var indicatorColor: UIColor = UIColor.red
    
    static func defaultConfig() -> FTPCConfig {
        let config = FTPCConfig()
        return config
    }

}

open class FTPCScrollView: UIScrollView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.alwaysBounceHorizontal = true
        self.alwaysBounceVertical = false
        self.alwaysBounceVertical = false
        self.scrollsToTop = false
        self.isPagingEnabled = true
    }
    
}


open class FTPageController: UIViewController {

    private(set) var setupMode: FTPCSetupMode = .Manually
    private var config: FTPCConfig!
    private var currentPage: NSInteger = 0
    private weak var superViewContoller: UIViewController?
    public var viewControllers: [UIViewController] = [] {
        willSet {
            if newValue.count > 0 {
                self.setupMode = .Manually
            }
        }
    }
    public weak var delegate: FTPageControllerDelegate?
    public weak var dataSource: FTPageControllerDataSource? {
        willSet {
            if newValue != nil {
                self.setupMode = .Delegate
            }
        }
    }
    
    public lazy var segement: FTPCSegement = {
        let view = FTPCSegement()
        return view
    }()
    
    public lazy var scrollView: FTPCScrollView = {
        let view = FTPCScrollView(frame: CGRect.zero)
        return view
    }()
    
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.scrollView)
    }
    
    public func setupWith(superViewController: UIViewController, dataSource: FTPageControllerDataSource, delegate: FTPageControllerDelegate? = nil, initialIndex: NSInteger? = 0, config: FTPCConfig? = nil) {
        self.superViewContoller = superViewController
        self.dataSource = dataSource
        
        self.currentPage = initialIndex!
        self.config = config
        self.delegate = delegate
    }
    
    public func setupWith(superViewController: UIViewController, viewControllers: [UIViewController], delegate: FTPageControllerDelegate? = nil, initialIndex: NSInteger? = 0, config: FTPCConfig? = nil) {

        self.superViewContoller = superViewController
        self.viewControllers = viewControllers
        
        self.currentPage = initialIndex!
        if config != nil {
            self.config = config
        }
        self.delegate = delegate
    }
    
    func setupConponents() {
        
        
    }
    
    
    
    
    
    
    
    
    
}
