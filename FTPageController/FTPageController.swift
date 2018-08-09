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

public struct FTPCConfig {
    public var segementViewFrame: CGRect
    public var scrollViewFrame: CGRect
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
}

open class FTPCTitleModel: NSObject {
    
    public var title: String = "" {
        didSet {
            self.calculateTitleWidth()
        }
    }
    public var font: UIFont = UIFont.systemFont(ofSize: 0) {
        didSet {
            self.calculateTitleWidth()
        }
    }
    
    public var titleWidth: CGFloat = 0.0
    
    public convenience init(title: String, font: UIFont) {
        self.init()
        self.title = title
        self.font = font
    }
    
    func calculateTitleWidth() {
        if self.title.count > 0 || self.font.pointSize > 0 {
            return
        }
        let size = self.title.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 100.0), options: .usesLineFragmentOrigin, attributes:[NSAttributedString.Key.font : self.font] , context: nil)
        print(size)
        self.titleWidth = size.width

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
            self.setupMode = .Manually
        }
    }
    public weak var delegate: FTPageControllerDelegate?
    public weak var dataSource: FTPageControllerDataSource? {
        willSet {
            self.setupMode = .Delegate
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
    
    public func setupWith(superViewController: UIViewController, viewControllers: [UIViewController], initialIndex: NSInteger? = 0, config: FTPCConfig? = nil, delegate: FTPageControllerDelegate? = nil) {

        self.superViewContoller = superViewController
        self.viewControllers = viewControllers
        
        self.currentPage = initialIndex!
        self.config = config
        self.delegate = delegate
//
//        [self initializeConponents];
//
//        [self scrollToViewControllerAtIndex:initialViewControllerIndex];
        
    }
    
    
    
    
    
    
    
    
}
