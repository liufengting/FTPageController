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
        self.contentView.addSubview(self.titleLabel)
    }
    
    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentView.addSubview(self.titleLabel)
    }
    
    @objc open override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = self.bounds
    }
    
    @objc func setupWith(titleModel: FTPCTitleModel, segmentConfig: FTPCSegmentConfig, indexPath: IndexPath, selected: Bool) {
        self.titleModel = titleModel
        self.backgroundColor = titleModel.backgroundColor
        self.titleLabel.text = titleModel.title
        self.titleLabel.font = titleModel.defaultFont;
        self.segmentConfig = segmentConfig
        self.indexPath = indexPath
        self.setSelected(selected: selected)
    }
    
    @objc func setSelected(selected: Bool) {
        self.isSelected = selected
        let backgroundColor = selected ? self.titleModel.selectedBackgroundColor : self.titleModel.backgroundColor
        let textColor = selected ? self.titleModel.selectedTitleColor : self.titleModel.defaultTitleColor
        let font = selected ? self.titleModel.selectedFont : self.titleModel.defaultFont
        self.backgroundColor = backgroundColor
        self.titleLabel.textColor = textColor
        self.titleLabel.font = font
        self.titleLabel.transform = CGAffineTransform.identity
    }
    
    @objc func handleTransition(percent: CGFloat) {
        // backgroundColor
        if self.titleModel.backgroundColor.isEqual(color: self.titleModel.selectedBackgroundColor) == false {
            let bgColor = UIColor.transit(fromColor: self.titleModel.selectedBackgroundColor, toColor: self.titleModel.backgroundColor, percent: percent)
            self.backgroundColor = bgColor
        }
        // titleLabel.textColor
        if self.titleModel.selectedTitleColor.isEqual(color: self.titleModel.defaultTitleColor) == false {
            let textColor = UIColor.transit(fromColor: self.titleModel.selectedTitleColor, toColor: self.titleModel.defaultTitleColor, percent: percent)
            self.titleLabel.textColor = textColor
        }
        // titleLabel.transform
        if self.titleModel.selectedFont.pointSize != self.titleModel.defaultFont.pointSize {
            if self.titleLabel.font != self.titleModel.defaultFont {
                self.titleLabel.font = self.titleModel.defaultFont
            }
            let scale = self.titleModel.selectedFont.pointSize/self.titleModel.defaultFont.pointSize - ((self.titleModel.selectedFont.pointSize/self.titleModel.defaultFont.pointSize - 1)*percent)
            self.titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale);
        }
    }

}
