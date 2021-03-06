//
//  FTPCTitleModel.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/27.
//

import UIKit

public class FTPCTitleModel {
    
    public var title: String = ""
    public var defaultFont: UIFont = UIFont.systemFont(ofSize: 14.0)
    public var selectedFont: UIFont = UIFont.systemFont(ofSize: 16.0)
    public var defaultTitleColor: UIColor = UIColor.lightText
    public var selectedTitleColor: UIColor = UIColor.lightText
    public var indicatorColor: UIColor = UIColor.red
    public var backgroundColor: UIColor = UIColor.clear // color for current cell background
    public var selectedBackgroundColor: UIColor = UIColor.clear // color for current cell background when selected
    public var selectedMenuBackgroundColor: UIColor = UIColor.systemBackground // color for menu background when selected
    public var selected: Bool = false
    private(set) var titleWidth:  CGFloat = 0
    
    public init(title: String, defaultTitleColor: UIColor = UIColor.lightText, selectedTitleColor: UIColor = UIColor.lightText) {
        self.title = title
        self.defaultTitleColor = defaultTitleColor
        self.selectedTitleColor = selectedTitleColor
        self.calculateTitleWidth()
    }
    
    private func calculateTitleWidth() {
        if self.title.count <= 0 || self.defaultFont.pointSize < 0 {
            return
        }
        self.titleWidth = self.title.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 100.0), options: .usesLineFragmentOrigin, attributes:[.font : self.defaultFont] , context: nil).width
    }
    
}
