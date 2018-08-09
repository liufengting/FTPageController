//
//  FTPCSegement.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/8.
//

import UIKit

open class FTPCTitleModel: NSObject {
    
    public var title: String = "" {
        didSet {
            self.calculateTitleWidth()
        }
    }
    public var font: UIFont = UIFont.systemFont(ofSize: 0) {
        didSet {
            self.calculateTitleWidth()
        }
    }
    
    public var titleWidth: CGFloat = 0.0
    
    public convenience init(title: String, font: UIFont) {
        self.init()
        self.title = title
        self.font = font
    }
    
    func calculateTitleWidth() {
        if self.title.count > 0 || self.font.pointSize > 0 {
            return
        }
        let size = self.title.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 100.0), options: .usesLineFragmentOrigin, attributes:[NSAttributedString.Key.font : self.font] , context: nil)
        self.titleWidth = size.width
    }
    
}

open class FTPCSegement: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    public var titleArray: [FTPCTitleModel] = []

    override open func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupWithTitles(titles: [FTPCTitleModel])  {
        self.titleArray = titles;
        self.collectionView.reloadData()
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
