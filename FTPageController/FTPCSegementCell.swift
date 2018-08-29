//
//  FTPCSegementCell.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/8.
//

import UIKit


open class FTPCSegementCell: UICollectionViewCell {

    static let identifier = "\(FTPCSegementCell.classForCoder())"
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    public weak var titleModel: FTPCTitleModel!
    public weak var segementConfig: FTPCSegementConfig!
    public var indexPath: IndexPath!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleLabel)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(self.titleLabel)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = self.bounds
    }
    
    func setupWith(titleModel: FTPCTitleModel, segementConfig: FTPCSegementConfig, indexPath: IndexPath, selected: Bool) {
        self.titleModel = titleModel
        self.titleLabel.text = titleModel.title
        self.segementConfig = segementConfig
        self.indexPath = indexPath
        self.setSelected(selected: selected)
    }
    
    func setSelected(selected: Bool) {
        let font = selected ? self.titleModel.selectedFont : self.titleModel.defaultFont
        let textColor = selected ? self.titleModel.selectedColor : self.titleModel.defaultColor
        UIView.animate(withDuration: 0.3) {
            self.titleLabel.font = font
            self.titleLabel.textColor = textColor
        }
    }
    
    func handleTransition(percent: CGFloat) {
        let fontSize = self.titleModel.selectedFont.pointSize - ((self.titleModel.selectedFont.pointSize - self.titleModel.defaultFont.pointSize) * percent)
        let color = UIColor.transition(fromColor: self.titleModel.selectedColor, toColor: self.titleModel.defaultColor, percent: percent)
        let font = UIFont(name: self.titleModel.defaultFont.fontName, size: fontSize)
        self.titleLabel.font = font
        self.titleLabel.textColor = color
        self.titleLabel.setNeedsLayout()
    }

}
