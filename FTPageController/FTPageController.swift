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

@objc public class FTPageController: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, FTPCSegmentDelegate {

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
    
    @objc public lazy var segment: FTPCSegment = {
        let view: FTPCSegment = FTPCSegment(frame: CGRect(x: 0, y: 0, width: UIScreen.ft_width(), height: 40.0))
        return view
    }()
    
    @objc public lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    @objc public lazy var containerView: FTPCContainerView = {
        let view = FTPCContainerView(frame: CGRect.zero, collectionViewLayout: self.collectionViewLayout)
        view.backgroundColor = UIColor.clear
        view.register(FTPCContainerCell.classForCoder(), forCellWithReuseIdentifier: FTPCContainerCell.identifier)
        view.delegate = self
        view.dataSource = self
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
        self.segment.setupWithTitles(titles: self.titleModelArray(), config: self.config, delegate: self, selectedPage: self.currentPage);
        self.containerView.setupWith(scrollViewConfig: self.config.scrollViewConfig, pageCount: self.numberOfPages())
        self.containerView.reloadData()
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
        self.containerView.scrollToItem(at: IndexPath(item: page, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    func cellAtIndex(_ index: NSInteger) -> UICollectionViewCell {
        return self.collectionView(self.containerView, cellForItemAt: IndexPath(item: index, section: 0))
    }

    @objc public func didSelectPage(page: NSInteger, animated: Bool) {
        if page != self.currentPage {
            self.currentPage = page;
        }
        if let vc: UIViewController = self.viewControllerForPage(page: page) {
            if (vc.isViewLoaded) {
                vc.viewDidAppear(true)
            }
        }
        self.segment.selectPage(page: page, animated: animated)
        if self.delegate != nil && (self.delegate?.responds(to: #selector(FTPageControllerDelegate.pageController(pageController:didScollToPage:))))! {
            self.delegate?.pageController!(pageController: self, didScollToPage: page)
        }
    }
    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout -
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.config.scrollViewConfig.frame.size
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfPages()
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let vc: UIViewController = self.viewControllerForPage(page: indexPath.item) {
            let vcRect = CGRect(x: 0, y: 0, width: self.containerView.bounds.size.width, height: self.containerView.bounds.size.height)
            if vc.parent == nil {
                vc.willMove(toParent: self.superViewContoller)
                vc.view.frame = vcRect
                self.superViewContoller?.addChild(vc)
                if vc.view.superview != nil {
                    vc.removeFromParent()
                }
                cell.contentView.addSubview(vc.view)
                vc.didMove(toParent: self.superViewContoller)
            } else {
                if vc.view.superview != nil {
                    vc.removeFromParent()
                }
                cell.contentView.addSubview(vc.view)
                vc.viewWillAppear(true)
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let vc: UIViewController = self.viewControllerForPage(page: indexPath.item) {
            if (vc.isViewLoaded) {
                vc.viewDidDisappear(true)
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : FTPCContainerCell = collectionView.dequeueReusableCell(withReuseIdentifier: FTPCContainerCell.identifier, for: indexPath) as! FTPCContainerCell
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
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
        // segment handle transition
        self.segment.handleTransition(fromPage: formerPage, toPage: latterPage, currentPage: self.currentPage, percent: (pageOffset - CGFloat(formerPage)))

        let toPage = self.currentPage == formerPage ? latterPage : formerPage;
        if self.delegate != nil && (self.delegate?.responds(to: #selector(FTPageControllerDelegate.pageController(pageController:isScolling:toPage:percent:))))! {
            self.delegate?.pageController!(pageController: self, isScolling: self.currentPage, toPage: toPage, percent: (pageOffset - CGFloat(formerPage)))
        }
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let vc: UIViewController = self.viewControllerForPage(page: self.currentPage) {
            if (vc.isViewLoaded) {
                vc.viewWillDisappear(true)
            }
        }
    }
    
    @objc public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)  {
        let page = NSInteger(scrollView.contentOffset.x/scrollView.bounds.size.width)
        self.didSelectPage(page: page, animated: true)
    }

    @objc public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = NSInteger(scrollView.contentOffset.x/scrollView.bounds.size.width)
        self.didSelectPage(page: page, animated: true)
    }
    
    //    MARK: - FTPCSegmentDelegate -
    
    @objc public func ftPCSegment(segment: FTPCSegment, didSelect page: NSInteger) {
        self.scrollToPage(page: page, animated: true)
    }
    
}
