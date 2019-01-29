//
//  FTPCSegementCell.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/8.
//

import UIKit

open class FTPCSegementCell: UICollectionViewCell {

    @objc static let identifier = "\(FTPCSegementCell.classForCoder())"
    
    @objc public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    @objc public weak var titleModel: FTPCTitleModel!
    @objc public weak var segementConfig: FTPCSegementConfig!
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
    
    @objc func setupWith(titleModel: FTPCTitleModel, segementConfig: FTPCSegementConfig, indexPath: IndexPath, selected: Bool) {
        self.titleModel = titleModel
        self.titleLabel.text = titleModel.title
        self.segementConfig = segementConfig
        self.indexPath = indexPath
        self.setSelected(selected: selected)
    }
    
    @objc func setSelected(selected: Bool) {
        let font = selected ? self.titleModel.selectedFont : self.titleModel.defaultFont
        let textColor = selected ? self.titleModel.selectedColor : self.titleModel.defaultColor
        UIView.animate(withDuration: 0.3) {
            self.titleLabel.font = font
            self.titleLabel.textColor = textColor
        }
    }
    
    @objc func handleTransition(percent: CGFloat) {
        let fontSize = self.titleModel.selectedFont.pointSize - ((self.titleModel.selectedFont.pointSize - self.titleModel.defaultFont.pointSize) * percent)
        let color = UIColor.transition(fromColor: self.titleModel.selectedColor, toColor: self.titleModel.defaultColor, percent: percent)
        let font = UIFont(name: self.titleModel.defaultFont.fontName, size: fontSize)
        self.titleLabel.font = font
        self.titleLabel.textColor = color
        self.titleLabel.setNeedsLayout()
    }

}
