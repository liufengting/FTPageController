//
//  FTPCSegementCell.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/8.
//

import UIKit

extension UIColor {
    
    static func transition(fromColor: UIColor, toColor: UIColor, percent: CGFloat) -> UIColor {
        var fromR: CGFloat = 0;
        var fromG: CGFloat = 0;
        var fromB: CGFloat = 0;
        var fromA: CGFloat = 0;
        fromColor.getRed(&fromR, green: &fromG, blue: &fromB, alpha: &fromA)
        var toR: CGFloat = 0;
        var toG: CGFloat = 0;
        var toB: CGFloat = 0;
        var toA: CGFloat = 0;
        toColor.getRed(&toR, green: &toG, blue: &toB, alpha: &toA)
        return UIColor(red: fromR - ((fromR - toR) * percent),
                       green: fromG - ((fromG - toG) * percent),
                       blue: fromB - ((fromB - toB) * percent),
                       alpha: fromA - ((fromA - toA) * percent))
    }
    
}

open class FTPCSegementCell: UICollectionViewCell {

    static let identifier = "\(FTPCSegementCell.classForCoder())"
    
    @IBOutlet var nameLabel: UILabel!
    public weak var segementConfig: FTPCSegementConfig!
    public var indexPath: IndexPath!

    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupWith(titleModel: FTPCTitleModel, segementConfig: FTPCSegementConfig, indexPath: IndexPath, selected: Bool) {
        self.nameLabel.text = titleModel.title
        self.segementConfig = segementConfig
        self.indexPath = indexPath
        self.setSelected(selected: selected)
    }
    
    func setSelected(selected: Bool) {
        let font = selected ? self.segementConfig.titleSelectedFont : self.segementConfig.titleDefaultFont
        let textColor = selected ? self.segementConfig.titleSelectedColor : self.segementConfig.titleDefaultColor
        UIView.animate(withDuration: 0.3) {
            self.nameLabel.font = font
            self.nameLabel.textColor = textColor
        }
    }
    
    func handleTransition(percent: CGFloat) {
        let fontSize = self.segementConfig.titleSelectedFont.pointSize - ((self.segementConfig.titleSelectedFont.pointSize - self.segementConfig.titleDefaultFont.pointSize) * percent)
        let color = UIColor.transition(fromColor: self.segementConfig.titleSelectedColor, toColor: self.segementConfig.titleDefaultColor, percent: percent)
//        if isLeftToRight {
//            fontSize = self.config.titleSelectedFont.pointSize - ((self.config.titleSelectedFont.pointSize - self.config.titleDefaultFont.pointSize) * percent)
//            color = UIColor.transition(fromColor: self.config.titleSelectedColor, toColor: self.config.titleDefaultColor, percent: percent)
//        } else {
//            fontSize = self.config.titleDefaultFont.pointSize + ((self.config.titleSelectedFont.pointSize - self.config.titleDefaultFont.pointSize) * percent)
//            color = UIColor.transition(fromColor: self.config.titleDefaultColor, toColor: self.config.titleSelectedColor, percent: percent)
//        }
        let font = UIFont(name: self.segementConfig.titleDefaultFont.fontName, size: fontSize)
        self.nameLabel.font = font
        self.nameLabel.textColor = color
        self.nameLabel.setNeedsLayout()
    }
    
    

}
