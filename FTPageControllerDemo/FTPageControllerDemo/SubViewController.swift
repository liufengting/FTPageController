//
//  SubViewController.swift
//  FTPageControllerDemo
//
//  Created by liufengting on 2018/8/23.
//  Copyright © 2018年 liufengting. All rights reserved.
//

import UIKit

class SubViewController: UIViewController {
    
    public var text = ""
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Container"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "Container"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.text.count > 0 {
            nameLabel.text = text
        }
        
    }

}
