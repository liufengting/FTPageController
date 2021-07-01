//
//  DetailViewController.swift
//  FTPageControllerDemo
//
//  Created by liufengting on 2018/8/23.
//  Copyright © 2018年 liufengting. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var pageController = FTPageController()
    
    @IBOutlet weak var segment: FTPCSegment!
    @IBOutlet weak var container: FTPCContainerView!
    
    lazy var viewControllers: [UIViewController] = {
        var array: [UIViewController] = []
        for i in 0...5 {
            if let sub: SubViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubViewController") as? SubViewController {
                sub.index = i
                array.append(sub);
            }
        }
        return array;
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        pageController.setupWith(segment: self.segment, container: self.container, superViewController: self, viewControllers: self.viewControllers)
    }

}
