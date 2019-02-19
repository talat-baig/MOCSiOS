//
//  ECRRefIDDetailsCell.swift
//  mocs
//
//  Created by Talat Baig on 2/19/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class ECRRefIDDetailsCell: UITableViewCell {

    @IBOutlet weak var outerVw: UIView!
    
    @IBOutlet weak var headrVw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outerVw.layer.shadowOpacity = 0.25
        outerVw.layer.shadowOffset = CGSize(width: 0, height: 2)
        outerVw.layer.shadowRadius = 1
        outerVw.layer.shadowColor = UIColor.black.cgColor
        
        headrVw.layer.shadowOpacity = 0.25
        headrVw.layer.shadowOffset = CGSize(width: 1, height: 2)
        headrVw.layer.shadowRadius = 1
        headrVw.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
