//
//  DetailViewController.swift
//  FTPageControllerDemo
//
//  Created by liufengting on 2018/8/23.
//  Copyright © 2018年 liufengting. All rights reserved.
//

import UIKit
import FTPageController

class DetailViewController: UIViewController, FTPageControllerDataSource {

    var pageController = FTPageController()
    
    
    let colors = [UIColor.red,
                  UIColor.black,
                  UIColor.green,
                  UIColor.cyan]
    
    
    lazy var titleModels: [FTPCTitleModel] = {
        var array: [FTPCTitleModel] = []
        for i in 0...3 {
            let model = FTPCTitleModel(title: "Title\(i)", defaultFont: nil, selectedFont: nil, defaultColor: nil, selectedColor: colors[i])
            array.append(model);
        }
        return array;
    }()

    lazy var viewControllers: [UIViewController] = {
        var array: [UIViewController] = []
        for i in 0...3 {
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
        pageController.setupWith(superViewController: self, dataSource: self)
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
    
    @IBAction func doneBarButtonItemTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            
        }
    }
    

}
