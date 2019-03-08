//
//  FTPCSegmentCell.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/8.
//

import UIKit

open class FTPCSegmentCell: UICollectionViewCell {

    @objc static let identifier = "\(FTPCSegmentCell.classForCoder())"
    
    @objc public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    @objc public weak var titleModel: FTPCTitleModel!
    @objc public weak var segmentConfig: FTPCSegmentConfig!
    @objc public var indexPath: IndexPath!

    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleLabel)
    }
    
    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(self.titleLabel)
    }
    
    @objc open override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = self.bounds
    }
    
    @objc func setupWith(titleModel: FTPCTitleModel, segmentConfig: FTPCSegmentConfig, indexPath: IndexPath, selected: Bool) {
        self.titleModel = titleModel
        self.titleLabel.text = titleModel.title
        self.titleLabel.font = titleModel.defaultFont;
        self.segmentConfig = segmentConfig
        self.indexPath = indexPath
        self.setSelected(selected: selected)
    }
    
    @objc func setSelected(selected: Bool) {
        let textColor = selected ? self.titleModel.selectedColor : self.titleModel.defaultColor
        let scale = (self.titleModel.selectedFont.pointSize/self.titleModel.defaultFont.pointSize)
        self.titleLabel.textColor = textColor
        self.titleLabel.transform = selected ? CGAffineTransform(scaleX: scale, y: scale) : CGAffineTransform.identity
    }
    
    @objc func handleTransition(percent: CGFloat) {
        let color = UIColor.transition(fromColor: self.titleModel.selectedColor, toColor: self.titleModel.defaultColor, percent: percent)
        self.titleLabel.textColor = color
        let scale = self.titleModel.selectedFont.pointSize/self.titleModel.defaultFont.pointSize - ((self.titleModel.selectedFont.pointSize/self.titleModel.defaultFont.pointSize - 1)*percent)
        self.titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale);
    }

}
