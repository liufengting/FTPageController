//
//  FTPCSegementCell.swift
//  FTPageController
//
//  Created by liufengting on 2018/8/8.
//

import UIKit

open class FTPCSegementCell: UICollectionViewCell {

    static let identifier = "\(FTPCSegementCell.classForCoder())"

    @IBOutlet var nameLabel: UILabel!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
