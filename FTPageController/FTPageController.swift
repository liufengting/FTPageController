//
//  FTPageController.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/8.
//

import UIKit

@objc public protocol FTPageControllerDelegate: NSObjectProtocol {

    @objc optional func pageController(pageController: FTPageController, didScollToPage page: NSInteger)
    @objc optional func pageController(pageController: FTPageController, isScolling fromPage: NSInteger, toPage: NSInteger, percent: CGFloat)

}

public protocol FTPageControllerDataSource: NSObjectProtocol {
    
    func numberOfViewControllers(pageController: FTPageController) -> NSInteger
    func pageController(pageController: FTPageController, viewControllerForIndex index: NSInteger) -> UIViewController?

}

public enum FTPCSetupMode {
    case Manually
    case DataSource
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

public extension UIDevice {

    public func is_iPhone_X() -> Bool {
        if UIScreen.main.bounds.height == 812.0 {
            return true
        }
        return false
    }

}

extension CGFloat {
    
    public static func navigationBarHeight() -> CGFloat {
        if UIDevice.current.is_iPhone_X() {
            return 88.0
        }
        return 64.0
    }
    
}

public class FTPCConfig {
    
    public var segementFrame: CGRect = CGRect(x: 0.0, y: CGFloat.navigationBarHeight(), width: UIScreen.width(), height: 40.0)
    public var scrollViewFrame: CGRect = CGRect(x: 0.0, y: CGFloat.navigationBarHeight() + 40, width: UIScreen.width(), height: UIScreen.height() - (CGFloat.navigationBarHeight() + 40))
    public var segementEnableScrolling: Bool = true
    public var contentEnableScrolling: Bool = true
    public var segementMode: FTPCSegementWidthMode = .auto
    public var segementColumns: NSInteger = 4
    public var segementFixedWidth: CGFloat = 100.0
    public var titleMargin: CGFloat = 25.0
    public var titleDefaultColor: UIColor = .red//UIColor.darkGray
    public var titleSelectedColor: UIColor = .green//UIColor.black
    public var titleDefaultFont: UIFont = UIFont.systemFont(ofSize: 12.0)
    public var titleSelectedFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    public var indicatorHeight: CGFloat = 2.0
    public var indicatorColor: UIColor = UIColor.red
    
    static func defaultConfig() -> FTPCConfig {
        return FTPCConfig()
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


open class FTPageController: NSObject, UIScrollViewDelegate, FTPCSegementDelegate {

    private(set) var setupMode: FTPCSetupMode = .Manually
    private var config: FTPCConfig = FTPCConfig.defaultConfig()
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
                self.setupMode = .DataSource
            }
        }
    }
    
    public lazy var segement: FTPCSegement = {
        let view: FTPCSegement = Bundle(for: self.classForCoder).loadNibNamed("FTPCSegement", owner: nil, options: nil)?.first as! FTPCSegement
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.width(), height: 40.0)
        return view
    }()
    
    public lazy var scrollView: FTPCScrollView = {
        let view = FTPCScrollView(frame: CGRect.zero)
        view.delegate = self
        return view
    }()
    
//    public init() {
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    public required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//
//    open override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.view.addSubview(self.scrollView)
//    }
    
    public func setupWith(superViewController: UIViewController, dataSource: FTPageControllerDataSource, delegate: FTPageControllerDelegate? = nil, initialIndex: NSInteger? = 0, config: FTPCConfig? = nil) {
        self.superViewContoller = superViewController
        self.dataSource = dataSource
        
        self.currentPage = initialIndex!
        if let configration: FTPCConfig = config {
            self.config = configration
        }
        self.delegate = delegate
        self.setupConponents()
    }
    
    public func setupWith(superViewController: UIViewController, viewControllers: [UIViewController], delegate: FTPageControllerDelegate? = nil, initialIndex: NSInteger? = 0, config: FTPCConfig? = nil) {

        self.superViewContoller = superViewController
        self.viewControllers = viewControllers
        
        self.currentPage = initialIndex!
        if let configration: FTPCConfig = config {
            self.config = configration
        }
        self.delegate = delegate
        self.setupConponents()
    }
    
    func setupConponents() {
        self.segement.frame = self.config.segementFrame
        self.segement.setupWithTitles(titles: self.titleModelArray(), config: self.config, delegate: self, selectedPage: self.currentPage);
        self.scrollView.frame = self.config.scrollViewFrame;
        self.scrollView.contentSize = CGSize(width: self.config.scrollViewFrame.width * CGFloat(self.numberOfPages()), height: self.config.scrollViewFrame.height)
        
        if self.segement.superview == nil {
            self.superViewContoller?.view.addSubview(self.segement)
        }
        if self.scrollView.superview == nil {
            self.superViewContoller?.view.addSubview(self.scrollView)
        }
        
        self.scrollToPage(page: self.currentPage, animated: false)
    }
    
    func titleModelArray() -> [FTPCTitleModel] {
        var titles: [FTPCTitleModel] = []
        if self.setupMode == .Manually {
            for vc in self.viewControllers {
                let titleModel = FTPCTitleModel(title: vc.title, font: self.config.titleDefaultFont)
                titles.append(titleModel)
            }
        } else {
            for i in 0...numberOfPages() {
                if let vc = self.viewControllerForPage(page: i) {
                    let titleModel = FTPCTitleModel(title: vc.title, font: self.config.titleDefaultFont)
                    titles.append(titleModel)
                }
            }
        }
        return titles
    }
    
    func numberOfPages() -> NSInteger {
        if self.setupMode == .DataSource {
            if self.dataSource != nil {
                return (self.dataSource?.numberOfViewControllers(pageController: self))!
            }
        } else {
            return self.viewControllers.count
        }
        return 0
    }
    
    func viewControllerForPage(page: NSInteger) -> UIViewController? {
        if self.setupMode == .DataSource {
            if self.dataSource != nil {
                return self.dataSource?.pageController(pageController: self, viewControllerForIndex: page)
            }
        } else {
            if page >= 0 && page < self.viewControllers.count {
                return self.viewControllers[page]
            }
        }
        return nil
    }
    
    public func scrollToPage(page: NSInteger, animated: Bool) {
        let width = self.scrollView.bounds.size.width
        let vcRect = CGRect(x: width*CGFloat(page), y: 0, width: width, height: self.scrollView.bounds.size.height)
        if let vc: UIViewController = self.viewControllerForPage(page: page) {
            if vc.parent == nil {
                vc.willMove(toParentViewController: self.superViewContoller)
                vc.view.frame = vcRect
                self.superViewContoller?.addChildViewController(vc)
                self.scrollView.addSubview(vc.view)
                vc.didMove(toParentViewController: self.superViewContoller)
            }
        }
        self.scrollView.scrollRectToVisible(vcRect, animated: animated)
        self.segement.selectPage(page: page, animated: animated)
        if self.delegate != nil && (self.delegate?.responds(to: #selector(FTPageControllerDelegate.pageController(pageController:didScollToPage:))))! {
            self.delegate?.pageController!(pageController: self, didScollToPage: page)
        }
    }

    //    MARK: - UIScrollViewDelegate -
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)  {
        print("scrollViewDidEndScrollingAnimation")
        self.currentPage = NSInteger(scrollView.contentOffset.x/scrollView.bounds.size.width)
        self.scrollToPage(page: self.currentPage, animated: false)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        self.currentPage = NSInteger(scrollView.contentOffset.x/scrollView.bounds.size.width)
        self.scrollToPage(page: self.currentPage , animated: false)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageOffset = scrollView.contentOffset.x/scrollView.bounds.size.width
        // out of range
        if pageOffset <= 0.0 || pageOffset >= CGFloat(self.numberOfPages() - 1) {
            return
        }
        let formerPage = NSInteger(floor(Double(pageOffset)))
        let latterPage = NSInteger(ceil(Double(pageOffset)))
        // continunesly scroll for more than one page
        if fabs(Double(pageOffset - CGFloat(self.currentPage))) >= 1 {
            self.currentPage = formerPage
            return
        }
        self.segement.handleTransition(fromPage: formerPage, toPage: latterPage, percent: (pageOffset - CGFloat(formerPage)))
    }
    
    //    MARK: - FTPCSegementDelegate -
    
    public func ftPCSegement(segement: FTPCSegement, didSelect page: NSInteger) {
        self.scrollToPage(page: page, animated: true)
    }
    
}
