//
//  FTPageController.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/8.
//

import UIKit

// MARK: - FTPageControllerDelegate -

public protocol FTPageControllerDelegate: NSObjectProtocol {

    func pageController(_ pageController: FTPageController, didScollToPage page: Int)
    func pageController(_ pageController: FTPageController, isScolling fromPage: Int, toPage: Int, percent: CGFloat)

}

// MARK: - FTPageControllerDataSource -

public protocol FTPageControllerDataSource: NSObjectProtocol {
    
    func numberOfViewControllers(_ pageController: FTPageController) -> Int
    func pageController(_ pageController: FTPageController, viewControllerForIndex index: Int) -> UIViewController?
    func pageController(_ pageController: FTPageController, titleModelForIndex index: Int) -> FTPCTitleModel?

}

// MARK: - FTPageController -

public class FTPageController: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, FTPCSegmentDelegate {

    public var currentPage: Int = 0
    public weak var delegate: FTPageControllerDelegate?
    public weak var dataSource: FTPageControllerDataSource? {
        willSet {
            if newValue != nil {
                self.setupMode = .DataSource
            }
        }
    }
    public var viewControllers: [UIViewController] = [] {
        willSet {
            if newValue.count > 0 {
                self.setupMode = .Manually
            }
        }
    }
    
    public weak var segment: FTPCSegment?
    public weak var container: FTPCContainerView?
    
    private(set) var setupMode: FTPCSetupMode = .Manually
    private weak var superViewContoller: UIViewController?
    private var config: FTPCConfig = FTPCConfig()

    public func setupWith(segment: FTPCSegment, container: FTPCContainerView, superViewController: UIViewController, dataSource: FTPageControllerDataSource, delegate: FTPageControllerDelegate? = nil, initialIndex: Int = 0, config: FTPCConfig? = nil) {
        self.segment = segment
        self.container = container
        self.superViewContoller = superViewController
        self.dataSource = dataSource
        self.delegate = delegate
        self.currentPage = initialIndex
        if let configration: FTPCConfig = config {
            self.config = configration
        }
        self.setupConponents()
    }

    public func setupWith(segment: FTPCSegment, container: FTPCContainerView, superViewController: UIViewController, viewControllers: [UIViewController], delegate: FTPageControllerDelegate? = nil, initialIndex: Int = 0, config: FTPCConfig? = nil) {
        self.segment = segment
        self.container = container
        self.superViewContoller = superViewController
        self.viewControllers = viewControllers
        self.delegate = delegate
        self.currentPage = initialIndex
        if let configration: FTPCConfig = config {
            self.config = configration
        }
        self.setupConponents()
    }
    
    public func applyConfigAndReload(config: FTPCConfig) {
        self.config = config
        self.setupConponents()
    }
    
    func setupConponents() {
        self.container?.setupWith(controller: self)
        self.segment?.setupWithTitles(titles: self.titleModelArray(), config: self.config, delegate: self, selectedPage: self.currentPage)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.scrollToPage(page: self.currentPage, animated: false)
            self.didSelectPage(page: self.currentPage, animated: false)
        }
    }
    
    func titleModelArray() -> [FTPCTitleModel] {
        var titles: [FTPCTitleModel] = []
        if self.setupMode == .Manually {
            for vc in self.viewControllers {
                let title = vc.title ?? "Title"
                let titleModel = FTPCTitleModel(title: title)
                titles.append(titleModel)
            }
        } else {
            for i in 0..<numberOfPages() {
                var titleModel: FTPCTitleModel?
                if let model = self.dataSource?.pageController(self, titleModelForIndex: i) {
                    titleModel = model
                } else if let vc = self.viewControllerForPage(page: i) {
                    titleModel = FTPCTitleModel(title: vc.title ?? "Title")
                }
                if titleModel == nil {
                    titleModel = FTPCTitleModel(title: "Title")
                }
                titles.append(titleModel!)
            }
        }
        return titles
    }
    
    func numberOfPages() -> Int {
        if self.setupMode == .DataSource {
            if self.dataSource != nil {
                return (self.dataSource?.numberOfViewControllers(self))!
            }
        } else {
            return self.viewControllers.count
        }
        return 0
    }

    func viewControllerForPage(page: Int) -> UIViewController? {
        if self.setupMode == .DataSource {
            if self.dataSource != nil {
                return self.dataSource?.pageController(self, viewControllerForIndex: page)
            }
        } else {
            if page >= 0 && page < self.viewControllers.count {
                return self.viewControllers[page]
            }
        }
        return nil
    }
    
    func cellAtIndex(_ index: Int) -> UICollectionViewCell {
        return self.collectionView(self.container!, cellForItemAt: IndexPath(item: index, section: 0))
    }
    
    public func scrollToPage(page: Int, animated: Bool) {
        self.container?.scrollToItem(at: IndexPath(item: page, section: 0), at: .left, animated: animated)
    }

    public func didSelectPage(page: Int, animated: Bool) {
        if page != self.currentPage {
            self.currentPage = page
        }
        if let vc: UIViewController = self.viewControllerForPage(page: page) {
            if vc.isViewLoaded {
                vc.viewDidAppear(true)
            }
        }
        self.segment?.selectPage(page: page, animated: animated)
        self.delegate?.pageController(self, didScollToPage: page)
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
        return collectionView.bounds.size
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfPages()
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let vc: UIViewController = self.viewControllerForPage(page: indexPath.item) {
            let vcRect = CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
            if vc.parent == nil {
                vc.willMove(toParent: self.superViewContoller)
                vc.view.frame = vcRect
                self.superViewContoller?.addChild(vc)
                if vc.view.superview != nil {
                    vc.view.removeFromSuperview()
                }
                if vc.parent != nil {
                    vc.removeFromParent()
                }
                cell.contentView.addSubview(vc.view)
                vc.didMove(toParent: self.superViewContoller)
                vc.view.layoutSubviews()
            } else {
                if vc.view.superview != nil {
                    vc.view.removeFromSuperview()
                }
                if vc.parent != nil {
                    vc.removeFromParent()
                }
                vc.view.frame = vcRect
                cell.contentView.addSubview(vc.view)
                vc.viewWillAppear(true)
                vc.view.layoutSubviews()
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let vc: UIViewController = self.viewControllerForPage(page: indexPath.item) {
            if vc.isViewLoaded {
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
    
   public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageOffset = scrollView.contentOffset.x/scrollView.bounds.size.width
        // out of range
        if pageOffset <= 0.0 || pageOffset >= CGFloat(self.numberOfPages() - 1) {
            return
        }
        let formerPage = Int(floor(Double(pageOffset)))
        let latterPage = Int(ceil(Double(pageOffset)))
        // continunesly scroll for more than one page
        if fabs(Double(pageOffset - CGFloat(self.currentPage))) >= 1 {
            self.currentPage = formerPage
            return
        }
        // segment handle transition
        self.segment?.handleTransition(fromPage: formerPage, toPage: latterPage, currentPage: self.currentPage, percent: (pageOffset - CGFloat(formerPage)))

        let toPage = self.currentPage == formerPage ? latterPage : formerPage
        self.delegate?.pageController(self, isScolling: self.currentPage, toPage: toPage, percent: (pageOffset - CGFloat(formerPage)))
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let vc: UIViewController = self.viewControllerForPage(page: self.currentPage) {
            if vc.isViewLoaded {
                vc.viewWillDisappear(true)
            }
        }
    }
    
   public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)  {
        let page = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
        self.didSelectPage(page: page, animated: true)
    }

   public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
        self.didSelectPage(page: page, animated: true)
    }
    
    //    MARK: - FTPCSegmentDelegate -
    
    public func ftPCSegment(_ segment: FTPCSegment, didSelect page: Int) {
        self.scrollToPage(page: page, animated: true)
    }
    
}
