//
//  FTPCSegement.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/8.
//

import UIKit

open class FTPCSegement: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    public var titleArray: [String] = []

    override open func awakeFromNib() {
        super.awakeFromNib()
        
    }

    public func selectIndex(index: NSInteger) {
        
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
        return CGSize(width: 0, height: self.bounds.size.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : FTPCSegementCell = collectionView.dequeueReusableCell(withReuseIdentifier: FTPCSegementCell.identifier, for: indexPath) as! FTPCSegementCell

        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    
}
