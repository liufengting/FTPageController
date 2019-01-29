//
//  FTPageController.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/8.
//

import UIKit

// MARK: - FTPageControllerDelegate -

@objc public protocol FTPageControllerDelegate: NSObjectProtocol {

    @objc optional func pageController(pageController: FTPageController, didScollToPage page: NSInteger)
    @objc optional func pageController(pageController: FTPageController, isScolling fromPage: NSInteger, toPage: NSInteger, percent: CGFloat)

}

// MARK: - FTPageControllerDataSource -

@objc public protocol FTPageControllerDataSource: NSObjectProtocol {
    
    func numberOfViewControllers(pageController: FTPageController) -> NSInteger
    func pageController(pageController: FTPageController, viewControllerForIndex index: NSInteger) -> UIViewController?
    @objc optional func pageController(pageController: FTPageController, titleModelForIndex index: NSInteger) -> FTPCTitleModel?

}

// MARK: - FTPageController -

@objc public class FTPageController: NSObject, UIScrollViewDelegate, FTPCSegementDelegate {

    @objc public var currentPage: NSInteger = 0
    @objc public var viewControllers: [UIViewController] = [] {
        willSet {
            if newValue.count > 0 {
                self.setupMode = .Manually
            }
        }
    }
    @objc public weak var delegate: FTPageControllerDelegate?
    @objc public weak var dataSource: FTPageControllerDataSource? {
        willSet {
            if newValue != nil {
                self.setupMode = .DataSource
            }
        }
    }
    
    @objc public lazy var segement: FTPCSegement = {
        let view: FTPCSegement = FTPCSegement(frame: CGRect(x: 0, y: 0, width: UIScreen.width(), height: 40.0))
        return view
    }()
    
    @objc public lazy var scrollView: FTPCScrollView = {
        let view = FTPCScrollView(frame: CGRect.zero)
        view.delegate = self
        return view
    }()
    
    private(set) var setupMode: FTPCSetupMode = .Manually
    private weak var superViewContoller: UIViewController?
    private var config: FTPCConfig = FTPCConfig.defaultConfig()

    @objc public func setupWith(superViewController: UIViewController, dataSource: FTPageControllerDataSource, delegate: FTPageControllerDelegate? = nil, initialIndex: NSInteger = 0, config: FTPCConfig? = nil) {
        self.superViewContoller = superViewController
        self.dataSource = dataSource
        
        self.currentPage = initialIndex
        if let configration: FTPCConfig = config {
            self.config = configration
        }
        self.delegate = delegate
        self.setupConponents()
    }
    
    @objc public func setupWith(superViewController: UIViewController, viewControllers: [UIViewController], delegate: FTPageControllerDelegate? = nil, initialIndex: NSInteger = 0, config: FTPCConfig? = nil) {

        self.superViewContoller = superViewController
        self.viewControllers = viewControllers
        
        self.currentPage = initialIndex
        if let configration: FTPCConfig = config {
            self.config = configration
        }
        self.delegate = delegate
        self.setupConponents()
    }
    
    @objc public func applyConfigAndReload(config: FTPCConfig) {
        self.config = config
        self.setupConponents()
    }
    
    func setupConponents() {
        self.segement.setupWithTitles(titles: self.titleModelArray(), config: self.config, delegate: self, selectedPage: self.currentPage);
        self.scrollView.setupWith(scrollViewConfig: self.config.scrollViewConfig, pageCount: self.numberOfPages())

        self.scrollToPage(page: self.currentPage, animated: false)
        self.didSelectPage(page: self.currentPage, animated: false)
    }
    
    func titleModelArray() -> [FTPCTitleModel] {
        var titles: [FTPCTitleModel] = []
        if self.setupMode == .Manually {
            for vc in self.viewControllers {
                let titleModel = FTPCTitleModel(title: vc.title, defaultFont: UIFont.systemFont(ofSize: 12.0))
                titles.append(titleModel)
            }
        } else {
            for i in 0...numberOfPages() - 1  {
                var titleModel: FTPCTitleModel? = nil
                if self.dataSource != nil && (self.dataSource?.responds(to: #selector(FTPageControllerDataSource.pageController(pageController:titleModelForIndex:))))!{
                    if let model = self.dataSource?.pageController!(pageController: self, titleModelForIndex: i) {
                        titleModel = model
                    }
                }else if let vc = self.viewControllerForPage(page: i) {
                    titleModel = FTPCTitleModel(title: vc.title)
                }
                if titleModel == nil {
                    titleModel = FTPCTitleModel(title: "")
                }
                titles.append(titleModel!)
            }
        }
        return titles
    }
    
    @objc public func numberOfPages() -> NSInteger {
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
    
    @objc public func scrollToPage(page: NSInteger, animated: Bool) {
        if page < 0 || page >= self.numberOfPages() {
            return
        }
        let width = self.scrollView.bounds.size.width
        let vcRect = CGRect(x: width*CGFloat(page), y: 0, width: width, height: self.scrollView.bounds.size.height)
        self.scrollView.scrollRectToVisible(vcRect, animated: animated)
    }

    @objc public func didSelectPage(page: NSInteger, animated: Bool) {
        let width = self.scrollView.bounds.size.width
        let vcRect = CGRect(x: width*CGFloat(page), y: 0, width: width, height: self.scrollView.bounds.size.height)
        if let vc: UIViewController = self.viewControllerForPage(page: page) {
            if vc.parent == nil {
                vc.willMove(toParent: self.superViewContoller)
                vc.view.frame = vcRect
                self.superViewContoller?.addChild(vc)
                self.scrollView.addSubview(vc.view)
                vc.didMove(toParent: self.superViewContoller)
            }
        }
        self.segement.selectPage(page: page, animated: animated)
        if self.delegate != nil && (self.delegate?.responds(to: #selector(FTPageControllerDelegate.pageController(pageController:didScollToPage:))))! {
            self.delegate?.pageController!(pageController: self, didScollToPage: page)
        }
    }
    
    //    MARK: - UIScrollViewDelegate -
    
    @objc public func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
        self.segement.handleTransition(fromPage: formerPage, toPage: latterPage, currentPage: self.currentPage, percent: (pageOffset - CGFloat(formerPage)))
        if self.delegate != nil && (self.delegate?.responds(to: #selector(FTPageControllerDelegate.pageController(pageController:isScolling:toPage:percent:))))! {
            self.delegate?.pageController!(pageController: self, isScolling: formerPage, toPage: latterPage, percent: (pageOffset - CGFloat(formerPage)))
        }
    }

    @objc public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)  {
        self.currentPage = NSInteger(scrollView.contentOffset.x/scrollView.bounds.size.width)
        self.didSelectPage(page: self.currentPage, animated: true)
    }

    @objc public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.currentPage = NSInteger(scrollView.contentOffset.x/scrollView.bounds.size.width)
        self.didSelectPage(page: self.currentPage, animated: true)
    }
    
    //    MARK: - FTPCSegementDelegate -
    
    @objc public func ftPCSegement(segement: FTPCSegement, didSelect page: NSInteger) {
        self.scrollToPage(page: page, animated: true)
    }
    
}
