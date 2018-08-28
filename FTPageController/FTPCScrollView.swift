//
//  FTPCScrollView.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/25.
//

import UIKit

open class FTPCScrollView: UIScrollView {
    
    public weak var scrollViewConfig: FTPCScrollViewConfig!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetup()
    }
    
    private func initialSetup() {
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.alwaysBounceHorizontal = true
        self.alwaysBounceVertical = false
        self.alwaysBounceVertical = false
        self.scrollsToTop = false
        self.isPagingEnabled = true
        self.decelerationRate = UIScrollViewDecelerationRateNormal
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
    
    public func setupWith(scrollViewConfig: FTPCScrollViewConfig, pageCount: NSInteger) {
        self.scrollViewConfig = scrollViewConfig
        self.frame = self.scrollViewConfig.frame;
        self.isScrollEnabled = self.scrollViewConfig.isScrollEnabled
        self.contentSize = CGSize(width: self.scrollViewConfig.frame.width * CGFloat(pageCount), height: self.scrollViewConfig.frame.height)
    }
    
}
