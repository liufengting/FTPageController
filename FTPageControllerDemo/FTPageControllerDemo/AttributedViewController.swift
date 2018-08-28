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
    
    let bgColors = [UIColor.red,
                    UIColor.cyan,
                    UIColor.green]
    
    let titleColors = [UIColor.gray,
                       UIColor.blue,
                       UIColor.red]
    
    
    lazy var titleModels: [FTPCTitleModel] = {
        var array: [FTPCTitleModel] = []
        for i in 0...2 {
            let model = FTPCTitleModel(title: "Title\(i)", defaultFont: nil, selectedFont: nil, defaultColor: nil, selectedColor: titleColors[i], indicatorColor: bgColors[i])
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
        
        let height: CGFloat = 32.0;
        let cornerRadius = height/2.0;

        let scrollViewConfig = FTPCScrollViewConfig.init(frame: CGRect(x: 0, y: CGFloat.navigationBarHeight(), width: UIScreen.width(), height: UIScreen.height() - CGFloat.navigationBarHeight()), isScrollEnabled: true)
        
        let segementConfig = FTPCSegementConfig.init(fillMode: CGRect(x: 0, y: 0, width: 180.0, height: height), isScrollEnabled: true, columns: self.viewControllers.count)
        segementConfig.setupWith(backgroundColor: UIColor.gray, cornerRadius: cornerRadius, borderColor: UIColor.yellow, borderWidth: 1.0)

        let indicatorConfig = FTPCIndicatorConfig.init(fillMode: .center)
        indicatorConfig.setupWith(height: height, cornerRadius: cornerRadius, borderColor: UIColor.orange, borderWidth: 1)

        let config = FTPCConfig.init(scrollViewConfig: scrollViewConfig, segementConfig: segementConfig, indicatorConfig: indicatorConfig)

        pageController.setupWith(superViewController: self, dataSource: self, delegate: self, initialIndex: 1, config: config)
        pageController.segement.layer.cornerRadius = cornerRadius
        self.navigationItem.titleView = pageController.segement
        self.view.addSubview(pageController.scrollView)
    }
    
    
    //    MARK: - FTPageControllerDataSource -
    
    func numberOfViewControllers(pageController: FTPageController) -> NSInteger {
        return self.viewControllers.count
    }
    
    func pageController(pageController: FTPageController, viewControllerForIndex index: NSInteger) -> UIViewController? {
        if index < self.viewControllers.count {
            return self.viewControllers[index]
        }
        return nil
    }
    
    func pageController(pageController: FTPageController, titleModelForIndex index: NSInteger) -> FTPCTitleModel? {
        if index < self.titleModels.count {
            return self.titleModels[index]
        }
        return nil
    }
    
    //FTPageControllerDelegate
    
    func pageController(pageController: FTPageController, didScollToPage page: NSInteger) {
        
    }
    
    func pageController(pageController: FTPageController, isScolling fromPage: NSInteger, toPage: NSInteger, percent: CGFloat) {
        
    }
    

    

    @IBAction func doneBarButtonItemTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            
        }
    }
    
}
