//
//  HeaderView.swift
//  FTPageControllerDemo
//
//  Created by liufengting on 2018/8/30.
//  Copyright © 2018年 liufengting. All rights reserved.
//

import UIKit

class HeaderView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        self.image = UIImage(named: "bridge_bg")
    }
    
}
