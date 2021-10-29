//
//  TableViewController.swift
//  FTPageControllerDemo
//
//  Created by liufengting on 2018/8/30.
//  Copyright © 2018年 liufengting. All rights reserved.
//

import UIKit
import FTPageController

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FTPageControllerDataSource, FTPageControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var pageController: FTPageController = FTPageController()
    
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
    
    lazy var headerView: HeaderView = {
        let header = Bundle.main.loadNibNamed("HeaderView", owner: nil, options: nil)?.first as! HeaderView
        return header
    }()
    
    var originalImageHeight: CGFloat = 200
    
    lazy var segment: FTPCSegment = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let header = FTPCSegment(frame: CGRect(x: 0, y: 0, width: UIScreen.ft_width(), height: 40), collectionViewLayout: flowLayout)
        return header
    }()
    
    lazy var container: FTPCContainerView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let header = FTPCContainerView(frame: CGRect(x: 0, y: 0, width: UIScreen.ft_width(), height: screenHeight - navigationBarHeight - 40.0), collectionViewLayout: layout)
        return header
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        }
        self.tableView.contentInsetAdjustmentBehavior = .never
        
//        let width = UIScreen.ft_width()
//        self.headerView.frame = CGRect(x: 0, y: 0, width: width, height: originalImageHeight)
//        self.view.addSubview(self.headerView)
//        self.view.bringSubviewToFront(self.tableView)
//        self.tableView.contentInset = UIEdgeInsets(top: originalImageHeight - navigationBarHeight, left: 0, bottom: 0, right: 0)
        
        self.tableView.tableHeaderView = self.headerView
        
        
        self.pageController.setupWith(segment: segment, container: container, superViewController: self, dataSource: self, delegate: self)
        
        self.pageController.stick(scrollView: self.tableView, at: originalImageHeight - navigationBarHeight)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (self.headerView.superview != nil) {
            var frame = self.headerView.frame
            frame.size.width = UIScreen.ft_width()
            frame.size.height = originalImageHeight
            self.headerView.frame = frame
        }
    }
    
    //    MARK: - UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight - navigationBarHeight - 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.pageController.segment
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if self.pageController.container?.superview != nil {
            self.pageController.container?.removeFromSuperview()
        }
        self.pageController.container?.frame = CGRect(x: 0, y: 0, width: UIScreen.ft_width(), height: UIScreen.ft_height() - navigationBarHeight - 40.0)
        cell.addSubview(self.pageController.container!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        print(y);
        if y <= navigationBarHeight - originalImageHeight {
            self.headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.ft_width(), height: navigationBarHeight - y)
        } else if y <= 0 {
            self.headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.ft_width(), height: originalImageHeight)
            self.tableView.contentInset = UIEdgeInsets(top: max(0, -y), left: 0, bottom: 0, right: 0)
        }
    }
    
    func numberOfViewControllers(_ pageController: FTPageController) -> Int {
        self.viewControllers.count
    }
    
    func pageController(_ pageController: FTPageController, viewControllerForIndex index: Int) -> UIViewController? {
        return self.viewControllers[index]
    }
    
    func pageController(_ pageController: FTPageController, titleModelForIndex index: Int) -> FTPCTitleModel? {
        return FTPCTitleModel(title: "SubVC")
    }
    
    func pageController(_ pageController: FTPageController, didScollToPage page: Int) {
        
    }
    
    func pageController(_ pageController: FTPageController, isScolling fromPage: Int, toPage: Int, percent: CGFloat) {
        
    }
    
    func pageController(_ pageController: FTPageController, controller: UIViewController, didUpdate offset: CGFloat) {
//        print(offset, " didUpdate")
//        let orig = originalImageHeight - navigationBarHeight
        let offsetY = self.tableView.contentOffset.y + offset
        
        print(offsetY, " didUpdate")

        self.tableView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
    }
    
    
    
}

var screenWidth: CGFloat {
    return UIScreen.main.bounds.size.width
}

var screenHeight: CGFloat {
    return UIScreen.main.bounds.size.height
}

var statusBarHeight: CGFloat {
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    } else {
        return UIApplication.shared.statusBarFrame.height
    }
}

var navigationBarHeight: CGFloat {
    return statusBarHeight + 44
}
