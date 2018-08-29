//
//  FTPCConfig.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/25.
//

import UIKit

/// FTPCSetupMode
/// describes how the controller was setup
/// - Manually: [UIViewControllers]
/// - DataSource: setup with dataSource
public enum FTPCSetupMode {
    case Manually
    case DataSource
}

/// FTPCSegementMode
/// decides how to caculate the width of each item
/// - auto: item width decided by title, font and margin
/// - fixed: fixed item width
/// - fill: devide whole screen width into 4(coloumns)
public enum FTPCSegementMode {
    case auto
    case fixed
    case fill
}

/// FTPCIndicatorMode
/// decides width of the indicator
/// - auto: same with the title width (with margins)
/// - fixed: fixed width
/// - fill: width fill item
public enum FTPCIndicatorMode {
    case auto
    case fixed
    case fill
}

/// FTPCIndicatorPosition
/// decides position of indicator
/// - center: vertical center of segement
/// - top: top of segement
/// - bottom: bottom of segement
public enum FTPCIndicatorPosition {
    case center
    case top
    case bottom
}

/// FTPCIndicatorAnimationOption
/// decides animation of indicator
/// - linnear: linnear
/// - expand: expand
public enum FTPCIndicatorAnimationOption {
    case linnear
    case expand
}

//MARK: - FTPCConfig -

public class FTPCConfig: NSObject {
    
    public var scrollViewConfig: FTPCScrollViewConfig = FTPCScrollViewConfig()
    public var segementConfig: FTPCSegementConfig = FTPCSegementConfig()
    public var indicatorConfig: FTPCIndicatorConfig = FTPCIndicatorConfig()
    
    static func defaultConfig() -> FTPCConfig {
        return FTPCConfig()
    }
    
    public convenience init(scrollViewConfig: FTPCScrollViewConfig, segementConfig: FTPCSegementConfig, indicatorConfig: FTPCIndicatorConfig) {
        self.init()
        self.scrollViewConfig = scrollViewConfig
        self.segementConfig = segementConfig
        self.indicatorConfig = indicatorConfig
    }
    
}

//MARK: - FTPCScrollViewConfig -

public class FTPCScrollViewConfig: NSObject {
    
    public var frame: CGRect = CGRect(x: 0.0, y: CGFloat.navigationBarHeight() + 40, width: UIScreen.width(), height: UIScreen.height() - (CGFloat.navigationBarHeight() + 40))
    public var isScrollEnabled: Bool = true
    
    public convenience init(frame: CGRect, isScrollEnabled: Bool) {
        self.init()
        self.frame = frame
        self.isScrollEnabled = isScrollEnabled
    }
    
    static func configWith(frame: CGRect, isScrollEnabled: Bool) -> FTPCScrollViewConfig {
        return FTPCScrollViewConfig.init(frame: frame, isScrollEnabled: isScrollEnabled)
    }
    
}

//MARK: - FTPCSegementConfig -

public class FTPCSegementConfig: NSObject {
    
    public var frame: CGRect = CGRect(x: 0.0, y: CGFloat.navigationBarHeight(), width: UIScreen.width(), height: 40.0)
    public var mode: FTPCSegementMode = .auto
    public var isScrollEnabled: Bool = true
    public var columns: NSInteger = 2
    public var fixedWidth: CGFloat = 40.0
    public var titleMargin: CGFloat = 25.0
    
    public var backgroundColor: UIColor = UIColor.white
    public var cornerRadius: CGFloat = 0.0
    public var borderColor: UIColor = UIColor.red
    public var borderWidth: CGFloat = 0.0
    
    public convenience init(autoMode frame: CGRect, isScrollEnabled: Bool, titleMargin: CGFloat) {
        self.init()
        self.mode = .auto
        self.frame = frame
        self.isScrollEnabled = isScrollEnabled
        self.titleMargin = titleMargin
    }
    
    public convenience init(fixedMode frame: CGRect, isScrollEnabled: Bool, fixedWidth: CGFloat) {
        self.init()
        self.mode = .fixed
        self.frame = frame
        self.isScrollEnabled = isScrollEnabled
        self.fixedWidth = fixedWidth
    }
    
    public convenience init(fillMode frame: CGRect, isScrollEnabled: Bool, columns: NSInteger) {
        self.init()
        self.mode = .fill
        self.frame = frame
        self.isScrollEnabled = isScrollEnabled
        self.columns = columns
    }
    
    public func setupWith(backgroundColor: UIColor, cornerRadius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
}

//MARK: - FTPCIndicatorConfig -

public class FTPCIndicatorConfig: NSObject {
    
    public var mode: FTPCIndicatorMode = .auto
    public var position: FTPCIndicatorPosition = .bottom
    public var animationOption: FTPCIndicatorAnimationOption = .expand
    public var height: CGFloat = 2.0
    public var width: CGFloat = 20.0
    public var horizontalOffsetToTitle: CGFloat = 5.0
    
    public var cornerRadius: CGFloat = 0.0
    public var borderColor: UIColor = UIColor.red
    public var borderWidth: CGFloat = 0.0

    public convenience init(autoMode position: FTPCIndicatorPosition, animationOption: FTPCIndicatorAnimationOption, horizontalOffsetToTitle: CGFloat) {
        self.init()
        self.mode = .auto
        self.position = position
        self.animationOption = animationOption
        self.horizontalOffsetToTitle = horizontalOffsetToTitle
    }
    
    public convenience init(fixedMode position: FTPCIndicatorPosition, animationOption: FTPCIndicatorAnimationOption, width: CGFloat) {
        self.init()
        self.mode = .fixed
        self.position = position
        self.animationOption = animationOption
        self.width = width
    }
    
    public convenience init(fillMode position: FTPCIndicatorPosition, animationOption: FTPCIndicatorAnimationOption) {
        self.init()
        self.mode = .fill
        self.animationOption = animationOption
        self.position = position
    }
    
    public func setupWith(height: CGFloat, cornerRadius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.height = height
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
    
}

public extension UIScreen {
    
    public static func width() -> CGFloat {
        return self.main.bounds.size.width
    }
    
    public static func height() -> CGFloat {
        return self.main.bounds.size.height
    }
    
}

public extension UIDevice {
    
    public func is_iPhone_X() -> Bool {
        if UIScreen.main.bounds.height == 812.0 {
            return true
        }
        return false
    }
    
}

extension CGFloat {
    
    public static func navigationBarHeight() -> CGFloat {
        if UIDevice.current.is_iPhone_X() {
            return 88.0
        }
        return 64.0
    }
    
}

extension UIColor {
    
    func isEqual(color: UIColor) -> Bool {
        var fromR: CGFloat = 0;
        var fromG: CGFloat = 0;
        var fromB: CGFloat = 0;
        var fromA: CGFloat = 0;
        self.getRed(&fromR, green: &fromG, blue: &fromB, alpha: &fromA)
        var toR: CGFloat = 0;
        var toG: CGFloat = 0;
        var toB: CGFloat = 0;
        var toA: CGFloat = 0;
        color.getRed(&toR, green: &toG, blue: &toB, alpha: &toA)
        return (fromR == toR) && (fromG == toG) && (fromB == toB) && (fromA == toA);
    }
    
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
