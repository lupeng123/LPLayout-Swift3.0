//
//  LPCell.swift
//  LPLayoutDemo(swift)
//
//  Created by iOS on 16/7/20.
//  Copyright © 2016年 iOS. All rights reserved.
//

import UIKit

class LPCell: UICollectionViewCell {
    @IBOutlet weak var titleLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLab.layer.cornerRadius = 10
        titleLab.clipsToBounds = true
    }

}
