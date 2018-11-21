//
//  FTPCScrollView.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/25.
//

import UIKit

@objc open class FTPCScrollView: UIScrollView {
    
    @objc public weak var scrollViewConfig: FTPCScrollViewConfig!
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
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
        self.contentSize = CGSize(width: self.scrollViewConfig.frame.width * CGFloat(pageCount), height: self.scrollViewConfig.frame.height)
    }
    
}
