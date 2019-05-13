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
@objc public enum FTPCSetupMode : Int {
    case Manually
    case DataSource
}

/// FTPCSegmentMode
/// decides how to caculate the width of each item
/// - auto: item width decided by title, font and margin
/// - fixed: fixed item width
/// - fill: devide whole screen width into 4(coloumns)
@objc public enum FTPCSegmentMode : Int {
    case auto
    case fixed
    case fill
}

/// FTPCIndicatorMode
/// decides width of the indicator
/// - auto: same with the title width (with margins)
/// - fixed: fixed width
/// - fill: width fill item
@objc public enum FTPCIndicatorMode : Int {
    case auto
    case fixed
    case fill
}

/// FTPCIndicatorPosition
/// decides position of indicator
/// - center: vertical center of segment
/// - top: top of segment
/// - bottom: bottom of segment
@objc public enum FTPCIndicatorPosition : Int {
    case center
    case top
    case bottom
}

/// FTPCIndicatorAnimationOption
/// decides animation of indicator
/// - linnear: linnear
/// - expand: expand
@objc public enum FTPCIndicatorAnimationOption : Int {
    case linnear
    case expand
}

@objc public extension UIScreen {
    
    @objc static func ft_width() -> CGFloat {
        return self.main.bounds.size.width
    }
    
    @objc static func ft_height() -> CGFloat {
        return self.main.bounds.size.height
    }
    
}

@objc public extension UIDevice {
    
    @objc static func ft_is_iPhone_X_or_up() -> Bool {
        guard #available(iOS 11.0, *) else {
            return false
        }
        return UIApplication.shared.windows[0].safeAreaInsets != UIEdgeInsets.zero
    }
    
    @objc static func ft_navigationBarHeight() -> CGFloat {
        if self.ft_is_iPhone_X_or_up() {
            return 88.0
        }
        return 64.0
    }
    
}

@objc extension UIColor {
    
    @objc func isEqual(color: UIColor) -> Bool {
        var fromR: CGFloat = 0
        var fromG: CGFloat = 0
        var fromB: CGFloat = 0
        var fromA: CGFloat = 0
        self.getRed(&fromR, green: &fromG, blue: &fromB, alpha: &fromA)
        var toR: CGFloat = 0
        var toG: CGFloat = 0
        var toB: CGFloat = 0
        var toA: CGFloat = 0
        color.getRed(&toR, green: &toG, blue: &toB, alpha: &toA)
        return (fromR == toR) && (fromG == toG) && (fromB == toB) && (fromA == toA)
    }
    
    @objc static func transit(fromColor: UIColor, toColor: UIColor, percent: CGFloat) -> UIColor {
        var fromR: CGFloat = 0
        var fromG: CGFloat = 0
        var fromB: CGFloat = 0
        var fromA: CGFloat = 0
        fromColor.getRed(&fromR, green: &fromG, blue: &fromB, alpha: &fromA)
        var toR: CGFloat = 0
        var toG: CGFloat = 0
        var toB: CGFloat = 0
        var toA: CGFloat = 0
        toColor.getRed(&toR, green: &toG, blue: &toB, alpha: &toA)
        return UIColor(red: fromR - ((fromR - toR) * percent),
                       green: fromG - ((fromG - toG) * percent),
                       blue: fromB - ((fromB - toB) * percent),
                       alpha: fromA - ((fromA - toA) * percent))
    }
    
}

//MARK: - FTPCConfig -

@objc public class FTPCConfig: NSObject {
    
    @objc public var scrollViewConfig: FTPCContainerViewConfig = FTPCContainerViewConfig()
    @objc public var segmentConfig: FTPCSegmentConfig = FTPCSegmentConfig()
    @objc public var indicatorConfig: FTPCIndicatorConfig = FTPCIndicatorConfig()
    
    @objc static func defaultConfig() -> FTPCConfig {
        return FTPCConfig()
    }
    
    @objc public convenience init(scrollViewConfig: FTPCContainerViewConfig, segmentConfig: FTPCSegmentConfig, indicatorConfig: FTPCIndicatorConfig) {
        self.init()
        self.scrollViewConfig = scrollViewConfig
        self.segmentConfig = segmentConfig
        self.indicatorConfig = indicatorConfig
    }
    
}

//MARK: - FTPCContainerViewConfig -

@objc public class FTPCContainerViewConfig: NSObject {
    
    @objc public var frame: CGRect = CGRect(x: 0.0, y: UIDevice.ft_navigationBarHeight() + 40, width: UIScreen.ft_width(), height: UIScreen.ft_height() - (UIDevice.ft_navigationBarHeight() + 40))
    @objc public var isScrollEnabled: Bool = true
    
    @objc public convenience init(frame: CGRect, isScrollEnabled: Bool) {
        self.init()
        self.frame = frame
        self.isScrollEnabled = isScrollEnabled
    }
    
    @objc static func configWith(frame: CGRect, isScrollEnabled: Bool) -> FTPCContainerViewConfig {
        return FTPCContainerViewConfig.init(frame: frame, isScrollEnabled: isScrollEnabled)
    }
    
}

//MARK: - FTPCSegmentConfig -

@objc public class FTPCSegmentConfig: NSObject {
    
    @objc public var frame: CGRect = CGRect(x: 0.0, y: UIDevice.ft_navigationBarHeight(), width: UIScreen.ft_width(), height: 40.0)
    @objc public var mode: FTPCSegmentMode = .auto
    @objc public var isScrollEnabled: Bool = true
    @objc public var columns: NSInteger = 2
    @objc public var fixedWidth: CGFloat = 40.0
    @objc public var titleMargin: CGFloat = 25.0
    
    @objc public var backgroundColor: UIColor = UIColor.white
    @objc public var cornerRadius: CGFloat = 0.0
    @objc public var borderColor: UIColor = UIColor.red
    @objc public var borderWidth: CGFloat = 0.0
    
    @objc public convenience init(autoMode frame: CGRect, isScrollEnabled: Bool, titleMargin: CGFloat) {
        self.init()
        self.mode = .auto
        self.frame = frame
        self.isScrollEnabled = isScrollEnabled
        self.titleMargin = titleMargin
    }
    
    @objc public convenience init(fixedMode frame: CGRect, isScrollEnabled: Bool, fixedWidth: CGFloat) {
        self.init()
        self.mode = .fixed
        self.frame = frame
        self.isScrollEnabled = isScrollEnabled
        self.fixedWidth = fixedWidth
    }
    
    @objc public convenience init(fillMode frame: CGRect, isScrollEnabled: Bool, columns: NSInteger) {
        self.init()
        self.mode = .fill
        self.frame = frame
        self.isScrollEnabled = isScrollEnabled
        self.columns = columns
    }
    
    @objc public func setupWith(backgroundColor: UIColor, cornerRadius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
    
}

//MARK: - FTPCIndicatorConfig -

@objc public class FTPCIndicatorConfig: NSObject {
    
    @objc public var mode: FTPCIndicatorMode = .auto
    @objc public var position: FTPCIndicatorPosition = .bottom
    @objc public var animationOption: FTPCIndicatorAnimationOption = .expand
    @objc public var height: CGFloat = 2.0
    @objc public var width: CGFloat = 20.0
    @objc public var horizontalOffsetToTitle: CGFloat = 5.0
    
    @objc public var cornerRadius: CGFloat = 0.0
    @objc public var borderColor: UIColor = UIColor.red
    @objc public var borderWidth: CGFloat = 0.0

    @objc public convenience init(autoMode position: FTPCIndicatorPosition, animationOption: FTPCIndicatorAnimationOption, horizontalOffsetToTitle: CGFloat) {
        self.init()
        self.mode = .auto
        self.position = position
        self.animationOption = animationOption
        self.horizontalOffsetToTitle = horizontalOffsetToTitle
    }
    
    @objc public convenience init(fixedMode position: FTPCIndicatorPosition, animationOption: FTPCIndicatorAnimationOption, width: CGFloat) {
        self.init()
        self.mode = .fixed
        self.position = position
        self.animationOption = animationOption
        self.width = width
    }
    
    @objc public convenience init(fillMode position: FTPCIndicatorPosition, animationOption: FTPCIndicatorAnimationOption) {
        self.init()
        self.mode = .fill
        self.animationOption = animationOption
        self.position = position
    }
    
    @objc public func setupWith(height: CGFloat, cornerRadius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.height = height
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
    
}
