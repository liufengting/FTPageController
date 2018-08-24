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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Container"
        
        if self.text.count > 0 {
            nameLabel.text = text
        }
        
    }

}
