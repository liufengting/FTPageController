//
//  TableViewController.swift
//  FTPageControllerDemo
//
//  Created by liufengting on 2018/8/30.
//  Copyright © 2018年 liufengting. All rights reserved.
//

import UIKit
import FTPageController

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var pageController: FTPageController = {
        let pager = FTPageController()
        pager.setupWith(superViewController: self, viewControllers: self.viewControllers)
        return pager
    }()
    
    lazy var viewControllers: [UIViewController] = {
        var array: [UIViewController] = []
        for i in 0...5 {
            let sub: SubViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubViewController") as! SubViewController
            array.append(sub);
        }
        return array;
    }()
    
    lazy var headerView: HeaderView = {
       let header = HeaderView(frame: CGRect.zero)
        return header
    }()
    
    var originalImageHeight = 1085*UIScreen.ft_width()/1920
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.contentInsetAdjustmentBehavior = .never
        
        let width = UIScreen.ft_width()
        self.headerView.frame = CGRect(x: 0, y: 0, width: width, height: originalImageHeight)
        self.view.addSubview(self.headerView)
        self.view.bringSubviewToFront(self.tableView)
        self.tableView.contentInset = UIEdgeInsets(top: originalImageHeight - UIDevice.ft_navigationBarHeight(), left: 0, bottom: 0, right: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //    MARK: - UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.ft_height() - UIDevice.ft_navigationBarHeight() - 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.pageController.segment
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if self.pageController.containerView.superview != nil {
            self.pageController.containerView.removeFromSuperview()
        }
        self.pageController.containerView.frame = CGRect(x: 0, y: 0, width: UIScreen.ft_width(), height: UIScreen.ft_height() - UIDevice.ft_navigationBarHeight() - 40.0)
        cell.addSubview(self.pageController.containerView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        print(y);
        if y <= UIDevice.ft_navigationBarHeight() - originalImageHeight {
            self.headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.ft_width(), height: UIDevice.ft_navigationBarHeight() - y)
        } else if y <= 0 {
            self.headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.ft_width(), height: originalImageHeight)
            self.tableView.contentInset = UIEdgeInsets(top: max(0, -y), left: 0, bottom: 0, right: 0)
        }
    }
    
}
