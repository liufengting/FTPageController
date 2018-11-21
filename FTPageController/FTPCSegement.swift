//
//  FTPCSegement.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/8.
//

import UIKit

@objc public protocol FTPCSegementDelegate: NSObjectProtocol {
    
    func ftPCSegement(segement: FTPCSegement, didSelect page: NSInteger)
    
}

@objc open class FTPCSegement: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @objc public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        let collection = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.clear
        collection.register(FTPCSegementCell.classForCoder(), forCellWithReuseIdentifier: FTPCSegementCell.identifier)
        if #available(iOS 11.0, *) {
            collection.contentInsetAdjustmentBehavior = .never
        }
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.decelerationRate = UIScrollView.DecelerationRate.normal
        collection.delegate = self
        collection.dataSource = self
        collection.insertSubview(self.indicator, at: 0)
        return collection
    }()
    
    @objc public var indicator: UIView = UIView()
    @objc public weak var delegate: FTPCSegementDelegate?
    @objc public weak var segementConfig: FTPCSegementConfig!
    @objc public weak var indicatorConfig: FTPCIndicatorConfig!
    @objc public var selectedPage: NSInteger = 0
    @objc public var titleArray: [FTPCTitleModel] = []
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.collectionView)
    }
    
    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(self.collectionView)
    }
    
    @objc open override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
    }
    
    @objc public func setupWithTitles(titles: [FTPCTitleModel], config: FTPCConfig, delegate: FTPCSegementDelegate?, selectedPage: NSInteger)  {
        self.titleArray = titles
        self.delegate = delegate
        self.selectedPage = selectedPage
        self.applyConfigs(config: config)
    }

    @objc public func selectPage(page: NSInteger, animated: Bool) {
        self.selectedPage = page
        for cell in self.collectionView.visibleCells {
            if let realCell: FTPCSegementCell = cell as? FTPCSegementCell {
                realCell.setSelected(selected: realCell.indexPath.item == page)
            }
        }
        self.collectionView.scrollToItem(at: IndexPath(item: page, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: animated)
    }
    
    @objc public func scrollIndictorToPage(page: NSInteger, animated: Bool) {
        self.indicator.backgroundColor = self.titleArray[page].indicatorColor
        self.indicator.frame = self.frameForIndicatorAtIndex(index: page)
    }
    
    @objc public func handleTransition(fromPage: NSInteger, toPage: NSInteger, currentPage: NSInteger, percent: CGFloat) {
        self.cellAtIndex(index: fromPage)?.handleTransition(percent: percent)
        self.cellAtIndex(index: toPage)?.handleTransition(percent:(1.0 - percent))
        self.updateIndicatorFrame(fromPage: fromPage, toPage: toPage, currentPage: currentPage, percent: percent)
        self.updateIndicatorColor(fromPage: fromPage, toPage: toPage, currentPage: currentPage, percent: percent)
    }

    @objc func updateIndicatorFrame(fromPage: NSInteger, toPage: NSInteger, currentPage: NSInteger, percent: CGFloat) {
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
                x = frX + (toX - frX) * (percent - 0.5) * 2
                width = toX + toW - x
            }
        }
        self.indicator.frame = CGRect(x: x, y: y, width: width, height: self.heightForIndicatorAtIndex(index: fromPage))
    }
    
    @objc func updateIndicatorColor(fromPage: NSInteger, toPage: NSInteger, currentPage: NSInteger, percent: CGFloat) {
        let fromColor = (currentPage == fromPage) ? self.titleArray[fromPage].indicatorColor : self.titleArray[toPage].indicatorColor
        let toColor = (currentPage == fromPage) ? self.titleArray[toPage].indicatorColor : self.titleArray[fromPage].indicatorColor
        if fromColor.isEqual(color: toColor) == false {
            let color = UIColor.transition(fromColor: fromColor, toColor: toColor, percent: (currentPage == fromPage) ? percent : (1 - percent))
            self.indicator.backgroundColor = color
        }
    }
    
    @objc func applyConfigs(config: FTPCConfig) {
        self.segementConfig = config.segementConfig
        self.indicatorConfig = config.indicatorConfig
        
        self.frame = self.segementConfig.frame
        self.backgroundColor = self.segementConfig.backgroundColor
        
        self.indicator.backgroundColor = self.titleArray[self.selectedPage].indicatorColor
        self.indicator.frame = self.frameForIndicatorAtIndex(index: self.selectedPage)
        
        if self.segementConfig.borderWidth > 0 {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = self.segementConfig.cornerRadius
            self.layer.borderWidth = self.segementConfig.borderWidth
            self.layer.borderColor = self.segementConfig.borderColor.cgColor
        }
        
        if self.indicatorConfig.borderWidth > 0 {
            self.indicator.layer.masksToBounds = true
            self.indicator.layer.cornerRadius = self.indicatorConfig.cornerRadius
            self.indicator.layer.borderWidth = self.indicatorConfig.borderWidth
            self.indicator.layer.borderColor = self.indicatorConfig.borderColor.cgColor
        }
    }

    // MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    
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
        self.collectionView.sendSubviewToBack(self.indicator)
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titleArray.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : FTPCSegementCell = collectionView.dequeueReusableCell(withReuseIdentifier: FTPCSegementCell.identifier, for: indexPath) as! FTPCSegementCell
        cell.setupWith(titleModel: self.titleArray[indexPath.item], segementConfig: self.segementConfig, indexPath: indexPath, selected: (indexPath.item == self.selectedPage))
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.handleCellTapAtIndexPath(indexPath: indexPath)
    }
    
    func handleCellTapAtIndexPath(indexPath: IndexPath) {
        if self.selectedPage != indexPath.item {
            if self.delegate != nil {
                self.delegate!.ftPCSegement(segement: self, didSelect: indexPath.item)
            }
        }
    }
    
    //    MARK: - privite methods
    
    func cellAtIndex(index: NSInteger) -> FTPCSegementCell? {
        return self.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? FTPCSegementCell
    }
    
    func titleWidthForItemAtIndex(index: NSInteger) -> CGFloat {
        return self.titleArray[index].titleWidth
    }
    
    func widthForItemAtIndex(index: NSInteger) -> CGFloat {
        var width: CGFloat = 0.0
        switch self.segementConfig.mode {
        case .auto:
            width = (self.titleArray[index].titleWidth + self.segementConfig.titleMargin * 2.0)
        case .fixed:
            width = self.segementConfig.fixedWidth
        case .fill:
            width = self.segementConfig.frame.size.width / CGFloat(self.segementConfig.columns)
        }
        return width
    }
    
    func xPositionForIndicatorAtIndex(index: NSInteger) -> CGFloat {
        var x: CGFloat = 0
        if index > 0 {
            for i in 0...(index-1) {
                x += self.widthForItemAtIndex(index: i)
            }
        }
        let itemWidth = self.widthForItemAtIndex(index: index)
        let indicatorWidth = self.widthForIndicatorAtIndex(index: index)
        x += (itemWidth - indicatorWidth)/2.0
        return x
    }
    
    func yPositionForIndicatorAtIndex(index: NSInteger) -> CGFloat {
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
    
    func widthForIndicatorAtIndex(index: NSInteger) -> CGFloat {
        var width: CGFloat = 0.0
        switch self.indicatorConfig.mode {
        case .auto:
            width = self.titleWidthForItemAtIndex(index: index) - (self.indicatorConfig.horizontalOffsetToTitle * 2.0)
        case .fill:
            width = self.widthForItemAtIndex(index: index)
        case .fixed:
            width = self.indicatorConfig.width
        }
        return width
    }
    
    func heightForIndicatorAtIndex(index: NSInteger) -> CGFloat {
        return self.indicatorConfig.height
    }
    
    func frameForIndicatorAtIndex(index: NSInteger) -> CGRect {
        return CGRect(x: self.xPositionForIndicatorAtIndex(index: index),
                      y: self.yPositionForIndicatorAtIndex(index: index),
                      width: self.widthForIndicatorAtIndex(index: index),
                      height: self.heightForIndicatorAtIndex(index: index))
    }
    
    open override var intrinsicContentSize: CGSize {
        return self.segementConfig.frame.size
    }
}
