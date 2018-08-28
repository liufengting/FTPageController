//
//  DetailViewController.swift
//  FTPageControllerDemo
//
//  Created by liufengting on 2018/8/23.
//  Copyright © 2018年 liufengting. All rights reserved.
//

import UIKit
import FTPageController

class DetailViewController: UIViewController {

    var pageController = FTPageController()

    lazy var viewControllers: [UIViewController] = {
        var array: [UIViewController] = []
        for i in 0...5 {
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
        pageController.setupWith(superViewController: self, viewControllers: self.viewControllers)
        self.view.addSubview(pageController.segement)
        self.view.addSubview(pageController.scrollView)
    }
    
    @IBAction func doneBarButtonItemTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            
        }
    }
    

}
