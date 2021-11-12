//
//  SubViewController.swift
//  FTPageControllerDemo
//
//  Created by liufengting on 2018/8/23.
//  Copyright © 2018年 liufengting. All rights reserved.
//

import UIKit
import FTPageController

class SubViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var index = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad \(index)")
        
//        self.tableView.panGestureRecognizer.addTarget(self, action: #selector(handle(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear \(index)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear \(index)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear \(index)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear \(index)")
    }
    
    //    MARK: - UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCells", for: indexPath)
        cell.textLabel?.text = "Title \(self.index)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollViewDidScroll: ", scrollView.contentOffset.y)

//        let offsetY = scrollView.contentOffset.y
//
//        if offsetY >= 0 && offsetY <= self.superOffset {
//            self.superScrollViewProtocol?.ftContentViewController(self, didUpdate: offsetY)
////            scrollView.setContentOffset(.zero, animated: false)
//        }
//
//
//        if scrollView.contentOffset.y <= self.superOffset {
//            self.superScrollViewProtocol?.ftContentViewController(self, didUpdate: scrollView.contentOffset.y)
//            scrollView.setContentOffset(.zero, animated: false)
//        }
    }
    
    
//    @objc func handle(_ pan: UIPanGestureRecognizer) {
//
//        let trans = pan.translation(in: self.tableView)
//
//        print("trans.y : ", trans.y, "self.superOffset", self.superOffset)
//        if trans.y <= self.superOffset {
//            self.superScrollViewProtocol?.ftContentViewController(self, didUpdate: -trans.y)
//            self.tableView.setContentOffset(.zero, animated: false)
//        }
//
//    }

    
    
//
//    func ftContentViewController(_ controller: Any, didUpdate offset: CGFloat) {
//
//    }
//
    
//    var superScrollViewProtocol: FTContentViewControllerProtocol?
//
//    var superScrollView: UIScrollView?
//
//    var superOffset: CGFloat = 0
//
//    func stick(scrollView: UIScrollView, at offset: CGFloat) {
//        print(scrollView)
//        self.superScrollView = scrollView
//        self.superOffset = offset
//    }
//    
    
    
}
