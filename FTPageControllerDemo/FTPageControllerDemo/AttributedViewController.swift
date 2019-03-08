//
//  AttributedViewController.swift
//  FTPageControllerDemo
//
//  Created by liufengting on 2018/8/27.
//  Copyright © 2018年 liufengting. All rights reserved.
//

import UIKit
import FTPageController

class AttributedViewController: UIViewController, FTPageControllerDataSource, FTPageControllerDelegate {
    
    var pageController = FTPageController()
    
    let bgColors = [UIColor.red, UIColor.cyan, UIColor.brown]
    
    let titleColors = [UIColor.green, UIColor.red, UIColor.cyan]
    
    
    lazy var titleModels: [FTPCTitleModel] = {
        var array: [FTPCTitleModel] = []
        for i in 0...2 {
            let model = FTPCTitleModel(title: "Title\(i)", defaultFont: nil, selectedFont: nil, defaultColor: UIColor.white, selectedColor: titleColors[i], indicatorColor: bgColors[i])
            array.append(model);
        }
        return array;
    }()
    
    lazy var viewControllers: [UIViewController] = {
        var array: [UIViewController] = []
        for i in 0...2 {
            let sub: SubViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubViewController") as! SubViewController
            sub.text = "index: \(i)"
            array.append(sub);
        }
        return array;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        
        let segmentHeight: CGFloat = 32.0;
        let segmentCornerRadius = segmentHeight/2.0;
        let segmentBGColor = UIColor(red: 11/255.0, green: 71/255.0, blue: 232/255.0, alpha: 1.0)
        let segmentBRColor = UIColor(red: 13/255.0, green: 162/255.0, blue: 255/255.0, alpha: 1.0)

        let indicatorHeight: CGFloat = 30.0;
        let indicatorCornerRadius = indicatorHeight/2.0;
        let indicatorBorderColor = UIColor(red: 255/255.0, green: 232/255.0, blue: 20/255.0, alpha: 1.0)


        let scrollViewConfig = FTPCScrollViewConfig.init(frame: CGRect(x: 0, y: UIDevice.navigationBarHeight(), width: UIScreen.width(), height: UIScreen.height() - UIDevice.navigationBarHeight()), isScrollEnabled: true)
        
        let segmentConfig = FTPCSegmentConfig.init(fillMode: CGRect(x: 0, y: 0, width: 180.0, height: segmentHeight), isScrollEnabled: true, columns: self.viewControllers.count)
        segmentConfig.setupWith(backgroundColor: segmentBGColor, cornerRadius: segmentCornerRadius, borderColor: segmentBRColor, borderWidth: 1.0)

        let indicatorConfig = FTPCIndicatorConfig.init(fillMode: .center, animationOption: .linnear)
        indicatorConfig.setupWith(height: indicatorHeight, cornerRadius: indicatorCornerRadius, borderColor: indicatorBorderColor, borderWidth: 1)

        let config = FTPCConfig.init(scrollViewConfig: scrollViewConfig, segmentConfig: segmentConfig, indicatorConfig: indicatorConfig)

        pageController.setupWith(superViewController: self, dataSource: self, delegate: self, initialIndex: 1, config: config)
        
        self.navigationItem.titleView = pageController.segment
        self.view.addSubview(pageController.scrollView)
    }
    
    
    //    MARK: - FTPageControllerDataSource -
    
    func numberOfViewControllers(pageController: FTPageController) -> NSInteger {
        return self.viewControllers.count
    }
    
    func pageController(pageController: FTPageController, viewControllerForIndex index: NSInteger) -> UIViewController? {
        return self.viewControllers[index]
    }
    
    func pageController(pageController: FTPageController, titleModelForIndex index: NSInteger) -> FTPCTitleModel? {
        return self.titleModels[index]
    }
    
    //FTPageControllerDelegate
    
    func pageController(pageController: FTPageController, didScollToPage page: NSInteger) {
        print("didScollToPage :\(page)")
    }
    
    func pageController(pageController: FTPageController, isScolling fromPage: NSInteger, toPage: NSInteger, percent: CGFloat) {
        print("isScolling fromPage: \(fromPage), toPage: \(toPage), percent: \(percent)")
    }

}
