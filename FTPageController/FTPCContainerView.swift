//
//  FTPCContainerView.swift
//  FTPageController
//
//  Created by liufengting on 2019/3/8.
//

import UIKit

public class FTPCContainerView: UICollectionView {
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
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
        self.decelerationRate = UIScrollView.DecelerationRate.normal
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
    
    public func setupWith(controller: FTPageController) {
        self.delegate = controller
        self.dataSource = controller
        self.register(FTPCContainerCell.classForCoder(), forCellWithReuseIdentifier: FTPCContainerCell.identifier)
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        self.reloadData()
    }
    
}
