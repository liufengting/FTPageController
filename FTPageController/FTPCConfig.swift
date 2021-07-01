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

public enum FTPCSetupMode : Int {
    case Manually
    case DataSource
}

/// FTPCSegmentMode
/// decides how to caculate the width of each item
/// - auto: item width decided by title, font and margin
/// - fixed: fixed item width
/// - fill: devide whole screen width into 4(coloumns)

public enum FTPCSegmentMode : Int {
    case auto
    case fixed
    case fill
}

/// FTPCIndicatorMode
/// decides width of the indicator
/// - auto: same with the title width (with margins)
/// - fixed: fixed width
/// - fill: width fill item

public enum FTPCIndicatorMode : Int {
    case auto
    case fixed
    case fill
}

/// FTPCIndicatorPosition
/// decides position of indicator
/// - center: vertical center of segment
/// - top: top of segment
/// - bottom: bottom of segment

public enum FTPCIndicatorPosition : Int {
    case center
    case top
    case bottom
}

/// FTPCIndicatorAnimationOption
/// decides animation of indicator
/// - linnear: linnear
/// - expand: expand

public enum FTPCIndicatorAnimationOption : Int {
    case linnear
    case expand
}

//MARK: - FTPCConfig -

public class FTPCConfig: NSObject {
    
    public var segmentConfig: FTPCSegmentConfig = FTPCSegmentConfig(autoMode: true, titleMargin: 25.0)
    public var indicatorConfig: FTPCIndicatorConfig = FTPCIndicatorConfig(autoMode: .bottom, animationOption: .expand, horizontalOffset: 5.0)

    public override init() {
        super.init()
    }
    
    init(segmentConfig: FTPCSegmentConfig, indicatorConfig: FTPCIndicatorConfig) {
        super.init()
        self.segmentConfig = segmentConfig
        self.indicatorConfig = indicatorConfig
    }
    
}

//MARK: - FTPCSegmentConfig -

public class FTPCSegmentConfig: NSObject {
    
    public var mode: FTPCSegmentMode = .auto
    public var isScrollEnabled: Bool = true
    public var columns: Int = 2
    public var fixedWidth: CGFloat = 40.0
    public var titleMargin: CGFloat = 25.0
    public var backgroundColor: UIColor = UIColor.systemBackground
    public var cornerRadius: CGFloat = 0.0
    public var borderColor: UIColor = UIColor.red
    public var borderWidth: CGFloat = 0.0
    
    public init(autoMode isScrollEnabled: Bool, titleMargin: CGFloat) {
        super.init()
        self.mode = .auto
        self.isScrollEnabled = isScrollEnabled
        self.titleMargin = titleMargin
    }
    
    public init(fixedMode isScrollEnabled: Bool, fixedWidth: CGFloat) {
        super.init()
        self.mode = .fixed
        self.isScrollEnabled = isScrollEnabled
        self.fixedWidth = fixedWidth
    }
    
    public init(fillMode isScrollEnabled: Bool, columns: Int) {
        super.init()
        self.mode = .fill
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
    public var horizontalOffset: CGFloat = 5.0
    public var cornerRadius: CGFloat = 0.0
    public var borderColor: UIColor = UIColor.red
    public var borderWidth: CGFloat = 0.0
    
    public init(autoMode position: FTPCIndicatorPosition, animationOption: FTPCIndicatorAnimationOption, horizontalOffset: CGFloat) {
        super.init()
        self.mode = .auto
        self.position = position
        self.animationOption = animationOption
        self.horizontalOffset = horizontalOffset
    }

    public init(fixedMode position: FTPCIndicatorPosition, animationOption: FTPCIndicatorAnimationOption, width: CGFloat) {
        super.init()
        self.mode = .fixed
        self.position = position
        self.animationOption = animationOption
        self.width = width
    }
    
    public init(fillMode position: FTPCIndicatorPosition, animationOption: FTPCIndicatorAnimationOption) {
        super.init()
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

//MARK: - extension for UIColor -

public extension UIColor {
    
    func isEqual(color: UIColor) -> Bool {
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
    
    static func transit(fromColor: UIColor, toColor: UIColor, percent: CGFloat) -> UIColor {
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
