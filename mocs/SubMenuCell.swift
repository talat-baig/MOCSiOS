//
//  SubMenuCell.swift
//  mocs
//
//  Created by Talat Baig on 5/9/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class SubMenuCell: UICollectionViewCell {

    
    @IBOutlet weak var vwOutr: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

       
       
       vwOutr.layer.cornerRadius = 5.0
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 1.0
        
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
    }

}
