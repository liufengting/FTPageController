//
//  FTPCTitleModel.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/27.
//

import UIKit

open class FTPCTitleModel: NSObject {
    
    public var title: String = ""
    public var defaultFont: UIFont = UIFont.systemFont(ofSize: 12.0)
    public var selectedFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    public var defaultColor: UIColor = UIColor.lightGray
    public var selectedColor: UIColor = UIColor.black
    public var indicatorColor: UIColor = UIColor.red
    private(set) var titleWidth: CGFloat = 20.0
    
    public convenience init(title: String?, defaultFont: UIFont? = nil, selectedFont: UIFont? = nil, defaultColor: UIColor? = nil, selectedColor: UIColor? = nil, indicatorColor: UIColor? = nil) {
        self.init()
        self.title = (title != nil && (title?.count)! > 0) ? title! : "Title"
        self.defaultFont = defaultFont ?? UIFont.systemFont(ofSize: 12.0)
        self.selectedFont = selectedFont ?? UIFont.systemFont(ofSize: 15.0)
        self.defaultColor = defaultColor ?? UIColor.darkGray
        self.selectedColor = selectedColor ?? UIColor.black
        self.indicatorColor = indicatorColor ?? UIColor.red
        self.calculateTitleWidth()
    }
    
    private func calculateTitleWidth() {
        if self.title.count <= 0 || self.defaultFont.pointSize < 0 {
            return
        }
        let size = self.title.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 100.0), options: .usesLineFragmentOrigin, attributes:[NSAttributedString.Key.font : self.defaultFont] , context: nil)
        self.titleWidth = size.width
    }
    
}
