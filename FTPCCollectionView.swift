//
//  FTPCCollectionView.swift
//  FTPageController
//
//  Created by liufengting on 2019/3/8.
//

import UIKit

@objc open class FTPCCollectionView: UICollectionView {

    @objc public weak var scrollViewConfig: FTPCScrollViewConfig!
    
    @objc public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.initialSetup()
    }
    
    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetup()
    }
    
    @objc private func initialSetup() {
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.alwaysBounceHorizontal = true
        self.alwaysBounceVertical = false
        self.alwaysBounceVertical = false
        self.scrollsToTop = false
        self.isPagingEnabled = true
        self.decelerationRate = UIScrollView.DecelerationRate.normal
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
    
    @objc public func setupWith(scrollViewConfig: FTPCScrollViewConfig, pageCount: NSInteger) {
        self.scrollViewConfig = scrollViewConfig
        self.frame = self.scrollViewConfig.frame;
        self.isScrollEnabled = self.scrollViewConfig.isScrollEnabled
    }
    
}
