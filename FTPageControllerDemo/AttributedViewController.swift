//
//  AttributedViewController.swift
//  FTPageControllerDemo
//
//  Created by liufengting on 2018/8/27.
//  Copyright © 2018年 liufengting. All rights reserved.
//

import UIKit

class AttributedViewController: UIViewController, FTPageControllerDataSource, FTPageControllerDelegate {
    
    var pageController = FTPageController()
    @IBOutlet weak var container: FTPCContainerView!
    lazy var segment: FTPCSegment = {
       let se = FTPCSegment(frame: CGRect(x: 0, y: 0, width: 240, height: 40.0), collectionViewLayout: UICollectionViewFlowLayout())
        return se
    }()
    
    let defaultTitleColor = [UIColor.red, UIColor.red, UIColor.red]
    
    let selectedTitleColors = [UIColor.green, UIColor.red, UIColor.cyan]

    let indicatorColor = [UIColor.yellow, UIColor.cyan, UIColor.brown]
    
    lazy var titleModels: [FTPCTitleModel] = {
        var array: [FTPCTitleModel] = []
        for i in 0...2 {
            let model = FTPCTitleModel(title: "Title\(i)", defaultTitleColor: defaultTitleColor[i], selectedTitleColor: selectedTitleColors[i])
            model.indicatorColor = indicatorColor[i]
            array.append(model);
        }
        return array;
    }()
    
    lazy var viewControllers: [UIViewController] = {
        var array: [UIViewController] = []
        for i in 0...2 {
            if let sub: SubViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubViewController") as? SubViewController {
                sub.index = i
                array.append(sub)
            }
        }
        return array;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let segmentHeight: CGFloat = 40.0
        let segmentCornerRadius = segmentHeight/2.0
        let segmentBGColor = UIColor(red: 11/255.0, green: 71/255.0, blue: 232/255.0, alpha: 1.0)
        let segmentBRColor = UIColor.red
        let indicatorBorderColor = UIColor.black

        let segmentConfig = FTPCSegmentConfig(fillMode: true, columns: self.viewControllers.count)
        segmentConfig.setupWith(backgroundColor: segmentBGColor, cornerRadius: segmentCornerRadius, borderColor: segmentBRColor, borderWidth: 1)

        let indicatorConfig = FTPCIndicatorConfig(fillMode: .center, animationOption: .linnear)
        indicatorConfig.setupWith(height: segmentHeight, cornerRadius: segmentCornerRadius, borderColor: indicatorBorderColor, borderWidth: 1)

        let config = FTPCConfig(segmentConfig: segmentConfig, indicatorConfig: indicatorConfig)

        pageController.setupWith(segment: self.segment, container: self.container, superViewController: self, dataSource: self, delegate: self, config: config)
        
        self.navigationItem.titleView = pageController.segment
    }
    
    
    //    MARK: - FTPageControllerDataSource -
    
    func numberOfViewControllers(_ pageController: FTPageController) -> Int {
        return self.viewControllers.count
    }
    
    func pageController(_ pageController: FTPageController, viewControllerForIndex index: Int) -> UIViewController? {
        return self.viewControllers[index]
    }
    
    func pageController(_ pageController: FTPageController, titleModelForIndex index: Int) -> FTPCTitleModel? {
        return self.titleModels[index]
    }
    
    //FTPageControllerDelegate
    
    func pageController(_ pageController: FTPageController, didScollToPage page: Int) {
        print("didScollToPage :\(page)")
    }
    
    func pageController(_ pageController: FTPageController, isScolling fromPage: Int, toPage: Int, percent: CGFloat) {
        print("isScolling fromPage: \(fromPage), toPage: \(toPage), percent: \(percent)")
    }

}
