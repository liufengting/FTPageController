//
//  HeaderView.swift
//  FTPageControllerDemo
//
//  Created by liufengting on 2018/8/30.
//  Copyright © 2018年 liufengting. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    func setup() {
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        self.imageView.image = UIImage(named: "aaa")
    }
    
}
