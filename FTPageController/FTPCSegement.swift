//
//  FTPCSegment.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/8.
//

import UIKit

public protocol FTPCSegmentDelegate: AnyObject {
    
    func ftPCSegment(_ segment: FTPCSegment, didSelect page: Int)
    
}

public class FTPCSegment: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public var indicator: UIView = UIView()
    public weak var segmentDelegate: FTPCSegmentDelegate?
    public var segmentConfig: FTPCSegmentConfig!
    public var indicatorConfig: FTPCIndicatorConfig!
    public var selectedPage: Int = 0
    public var titleArray: [FTPCTitleModel] = []
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize() {
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        self.backgroundColor = UIColor.clear
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = UIScrollView.DecelerationRate.normal
        self.delegate = self
        self.dataSource = self
        self.register(FTPCSegmentCell.classForCoder(), forCellWithReuseIdentifier: FTPCSegmentCell.identifier)
        self.insertSubview(self.indicator, at: 0)
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }

    public func setupWithTitles(titles: [FTPCTitleModel], config: FTPCConfig, delegate: FTPCSegmentDelegate?, selectedPage: Int)  {
        self.titleArray = titles
        self.segmentDelegate = delegate
        self.selectedPage = selectedPage
        self.applyConfigs(config: config)
    }

    public func selectPage(page: Int, animated: Bool) {
        self.selectedPage = page
        if let selectedMenuBackgroundColor = self.titleArray[self.selectedPage].selectedMenuBackgroundColor {
            self.backgroundColor = selectedMenuBackgroundColor
        }
        self.indicator.frame = self.frameForIndicatorAtIndex(index: self.selectedPage)
        for indexPath in self.indexPathsForVisibleItems {
            if let realCell = self.cellForItem(at: indexPath) as? FTPCSegmentCell {
                realCell.setSelected(selected: indexPath.item == page)
            }
        }
        self.scrollToItem(at: IndexPath(item: page, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: animated)
    }
    
    public func scrollIndictorToPage(page: Int, animated: Bool) {
        self.indicator.backgroundColor = self.titleArray[page].indicatorColor
        self.indicator.frame = self.frameForIndicatorAtIndex(index: page)
    }
    
    public func handleTransition(fromPage: Int, toPage: Int, currentPage: Int, percent: CGFloat) {
        self.cellAtIndex(index: fromPage)?.handleTransition(percent: percent)
        self.cellAtIndex(index: toPage)?.handleTransition(percent:(1.0 - percent))
        self.updateIndicatorFrame(fromPage: fromPage, toPage: toPage, currentPage: currentPage, percent: percent)
        self.updateIndicatorColor(fromPage: fromPage, toPage: toPage, currentPage: currentPage, percent: percent)
        self.updateMenuBackgroundColor(fromPage: fromPage, toPage: toPage, currentPage: currentPage, percent: percent)
    }

    func updateIndicatorFrame(fromPage: Int, toPage: Int, currentPage: Int, percent: CGFloat) {
        let y = self.yPositionForIndicatorAtIndex(index: fromPage)
        var x: CGFloat = 0
        var width: CGFloat = 0
        let frX = self.xPositionForIndicatorAtIndex(index: fromPage)
        let toX = self.xPositionForIndicatorAtIndex(index: toPage)
        let frW = self.widthForIndicatorAtIndex(index: fromPage)
        let toW = self.widthForIndicatorAtIndex(index: toPage)
        switch self.indicatorConfig.animationOption {
        case .linnear:
            x = frX + ((toX - frX) * percent)
            width = frW + ((toW - frW) * percent)
        case .expand:
            if percent <= 0.5 {
                x = frX
                let totalRange = toX + toW - frX
                width = frW + percent * 2.0 * (totalRange - frW)
            } else {
                x = frX + (toX - frX) * (percent - 0.5) * 2.0
                width = toX + toW - x
            }
        }
        self.indicator.frame = CGRect(x: x, y: y, width: width, height: self.heightForIndicatorAtIndex(index: fromPage))
    }
    
    func updateIndicatorColor(fromPage: Int, toPage: Int, currentPage: Int, percent: CGFloat) {
        let fromColor = (currentPage == fromPage) ? self.titleArray[fromPage].indicatorColor : self.titleArray[toPage].indicatorColor
        let toColor = (currentPage == fromPage) ? self.titleArray[toPage].indicatorColor : self.titleArray[fromPage].indicatorColor
        if fromColor.isEqual(color: toColor) == false {
            let color = UIColor.transit(fromColor: fromColor, toColor: toColor, percent: (currentPage == fromPage) ? percent : (1 - percent))
            self.indicator.backgroundColor = color
        }
    }
    
    func updateMenuBackgroundColor(fromPage: Int, toPage: Int, currentPage: Int, percent: CGFloat) {
        guard let from = self.titleArray[fromPage].selectedMenuBackgroundColor else { return }
        guard let to = self.titleArray[toPage].selectedMenuBackgroundColor else { return }
        let fromColor = (currentPage == fromPage) ? from : to
        let toColor = (currentPage == fromPage) ? to : from
        if fromColor.isEqual(color: toColor) == false {
            let color = UIColor.transit(fromColor: fromColor, toColor: toColor, percent: (currentPage == fromPage) ? percent : (1 - percent))
            self.backgroundColor = color
        }
    }
    
    func applyConfigs(config: FTPCConfig) {
        self.segmentConfig = config.segmentConfig
        self.indicatorConfig = config.indicatorConfig
        
        self.backgroundColor = self.segmentConfig.backgroundColor
        
        self.indicator.backgroundColor = self.titleArray[self.selectedPage].indicatorColor
        self.indicator.frame = self.frameForIndicatorAtIndex(index: self.selectedPage)
        
        if self.segmentConfig.borderWidth > 0 {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = self.segmentConfig.cornerRadius
            self.layer.borderWidth = self.segmentConfig.borderWidth
            self.layer.borderColor = self.segmentConfig.borderColor.cgColor
        }
        
        if self.indicatorConfig.borderWidth > 0 {
            self.indicator.layer.masksToBounds = true
            self.indicator.layer.cornerRadius = self.indicatorConfig.cornerRadius
            self.indicator.layer.borderWidth = self.indicatorConfig.borderWidth
            self.indicator.layer.borderColor = self.indicatorConfig.borderColor.cgColor
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
        return CGSize(width: self.widthForItemAtIndex(index: indexPath.item), height: self.bounds.size.height)
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.sendSubviewToBack(self.indicator)
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titleArray.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : FTPCSegmentCell = collectionView.dequeueReusableCell(withReuseIdentifier: FTPCSegmentCell.identifier, for: indexPath) as! FTPCSegmentCell
        cell.setupWith(titleModel: self.titleArray[indexPath.item], indexPath: indexPath, selected: (indexPath.item == self.selectedPage))
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.handleCellTapAtIndexPath(indexPath: indexPath)
    }
    
    func handleCellTapAtIndexPath(indexPath: IndexPath) {
        if self.selectedPage != indexPath.item {
            self.segmentDelegate?.ftPCSegment(self, didSelect: indexPath.item)
        }
    }
    
    //    MARK: - privite methods -
    
    func cellAtIndex(index: Int) -> FTPCSegmentCell? {
        return self.cellForItem(at: IndexPath(item: index, section: 0)) as? FTPCSegmentCell
    }
    
    func titleWidthForItemAtIndex(index: Int) -> CGFloat {
        return self.titleArray[index].titleWidth
    }
    
    func widthForItemAtIndex(index: Int) -> CGFloat {
        var width: CGFloat = 0.0
        switch self.segmentConfig.mode {
        case .auto:
            width = (self.titleArray[index].titleWidth + self.segmentConfig.titleMargin * 2.0)
        case .fixed:
            width = self.segmentConfig.fixedWidth
        case .fill:
            width = self.bounds.size.width / CGFloat(self.segmentConfig.columns)
        }
        return width
    }
    
    func xPositionForIndicatorAtIndex(index: Int) -> CGFloat {
        var x: CGFloat = 0
        if index > 0 {
            for i in 0..<index {
                x += self.widthForItemAtIndex(index: i)
            }
        }
        let itemWidth = self.widthForItemAtIndex(index: index)
        let indicatorWidth = self.widthForIndicatorAtIndex(index: index)
        x += (itemWidth - indicatorWidth)/2.0
        return x
    }
    
    func yPositionForIndicatorAtIndex(index: Int) -> CGFloat {
        var y: CGFloat = 0
        switch self.indicatorConfig.position {
        case .top:
            y = 0
        case .center:
            y = (self.bounds.size.height - self.indicatorConfig.height)/2
        case .bottom:
            y = self.bounds.size.height - self.indicatorConfig.height
        }
        return y
    }
    
    func widthForIndicatorAtIndex(index: Int) -> CGFloat {
        var width: CGFloat = 0.0
        switch self.indicatorConfig.mode {
        case .auto:
            width = self.titleWidthForItemAtIndex(index: index) - (self.indicatorConfig.horizontalOffset * 2.0)
        case .fill:
            width = self.widthForItemAtIndex(index: index)
        case .fixed:
            width = self.indicatorConfig.width
        }
        return width
    }
    
    func heightForIndicatorAtIndex(index: Int) -> CGFloat {
        return self.indicatorConfig.height
    }
    
    func frameForIndicatorAtIndex(index: Int) -> CGRect {
        return CGRect(x: self.xPositionForIndicatorAtIndex(index: index),
                      y: self.yPositionForIndicatorAtIndex(index: index),
                      width: self.widthForIndicatorAtIndex(index: index),
                      height: self.heightForIndicatorAtIndex(index: index))
    }
    
    open override var intrinsicContentSize: CGSize {
        return self.bounds.size
    }
    
}
