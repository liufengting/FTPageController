//
//  FTPCTitleModel.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/27.
//

import UIKit

public class FTPCTitleModel {
    
    public var title: String = ""
    public var defaultFont: UIFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
    public var selectedFont: UIFont = UIFont.systemFont(ofSize: 16.0, weight: .medium)
    public var defaultTitleColor: UIColor = UIColor.secondaryLabel
    public var selectedTitleColor: UIColor = UIColor.label
    public var indicatorColor: UIColor = UIColor.red
    public var backgroundColor: UIColor = UIColor.clear // color for current cell background
    public var selectedBackgroundColor: UIColor = UIColor.clear // color for current cell background when selected
    public var selectedMenuBackgroundColor: UIColor? // color for menu background when selected
    public var selected: Bool = false
    private(set) var titleWidth:  CGFloat = 0
    
    public init(title: String, defaultTitleColor: UIColor = UIColor.secondaryLabel, selectedTitleColor: UIColor = UIColor.label) {
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

extension UIViewController {
    
    struct Holder {
        static var superNavigationController: UINavigationController? = nil
    }
    
    var superNavigationController: UINavigationController? {
        get {
            return Holder.superNavigationController
        }
        set(newValue) {
            Holder.superNavigationController = newValue
        }
    }
    
}
