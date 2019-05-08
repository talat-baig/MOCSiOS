//
//  HomeMenuCell.swift
//  mocs
//
//  Created by Talat Baig on 5/7/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class HomeMenuCell: UICollectionViewCell {
    
    @IBOutlet weak var outrVw: UIView!
    @IBOutlet weak var imgVw: UIImageView!
    
    @IBOutlet weak var innerVw: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        imgVw.layer.borderWidth = 0.5
        imgVw.layer.masksToBounds = true
        imgVw.layer.borderColor = AppColor.universalHeaderColor.cgColor
        imgVw.layer.cornerRadius = imgVw.frame.height/2
        imgVw.clipsToBounds = false
        
        imgVw.layer.shadowColor = UIColor.lightGray.cgColor
        imgVw.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        imgVw.layer.shadowRadius = 3
        imgVw.layer.shadowOpacity = 1

        self.innerVw.layer.cornerRadius = 10
        self.innerVw.layer.shadowColor = UIColor.lightGray.cgColor
        self.innerVw.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        self.innerVw.layer.shadowRadius = 3
        self.innerVw.layer.shadowOpacity = 1.0
    }

}
