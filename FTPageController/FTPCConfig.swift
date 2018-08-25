//
//  FTPCConfig.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/25.
//

import UIKit

/// FTPCSegementMode; decide how to caculate the width of each item
///
/// - auto: item width decided by title, font and margin
/// - fixed: fixed item width
/// - fill: devide whole screen width into 4(coloumns)
public enum FTPCSegementMode {
    case auto
    case fixed
    case fill
}

public enum FTPCIndicatorPosition {
    case center
    case top
    case bottom
}

public enum FTPCIndicatorMode {
    case auto
    case fixed
    case fill
}

//MARK: - FTPCConfig -

public class FTPCConfig {
    
    public var scrollViewConfig: FTPCScrollViewConfig = FTPCScrollViewConfig()
    public var segementConfig: FTPCSegementConfig = FTPCSegementConfig()
    public var indicatorConfig: FTPCIndicatorConfig = FTPCIndicatorConfig()
    
    static func defaultConfig() -> FTPCConfig {
        return FTPCConfig()
    }
    
}

//MARK: - FTPCScrollViewConfig -

public class FTPCScrollViewConfig {
    
    public var frame: CGRect = CGRect(x: 0.0, y: CGFloat.navigationBarHeight() + 40, width: UIScreen.width(), height: UIScreen.height() - (CGFloat.navigationBarHeight() + 40))
    public var isScrollEnabled: Bool = true
    
}

//MARK: - FTPCSegementConfig -

public class FTPCSegementConfig {
    
    public var frame: CGRect = CGRect(x: 0.0, y: CGFloat.navigationBarHeight(), width: UIScreen.width(), height: 40.0)
    public var enableScrolling: Bool = true
    public var mode: FTPCSegementMode = .auto
    public var columns: NSInteger = 4
    public var fixedWidth: CGFloat = 100.0
    public var titleMargin: CGFloat = 25.0
    public var titleDefaultColor: UIColor = .red//UIColor.darkGray
    public var titleSelectedColor: UIColor = .green//UIColor.black
    public var titleDefaultFont: UIFont = UIFont.systemFont(ofSize: 12.0)
    public var titleSelectedFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    
}

//MARK: - FTPCIndicatorConfig -

public class FTPCIndicatorConfig {
    
    public var mode: FTPCIndicatorMode = .auto
    public var position: FTPCIndicatorPosition = .bottom
    public var height: CGFloat = 2.0
    public var width: CGFloat = 20.0
    public var horizontalOffsetToTitle: CGFloat = 5.0
    public var cornerRadius: CGFloat = 0.0
    public var color: UIColor = UIColor.red
    
}
