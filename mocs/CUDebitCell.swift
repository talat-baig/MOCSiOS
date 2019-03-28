//
//  CUDebitCell.swift
//  mocs
//
//  Created by Talat Baig on 3/26/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class CUDebitCell: UITableViewCell {

    @IBOutlet weak var outrVw: UIView!
    
    @IBOutlet weak var headerVw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        outrVw.layer.shadowOpacity = 0.25
        outrVw.layer.shadowOffset = CGSize(width: 0, height: 2)
        outrVw.layer.shadowRadius = 1
        outrVw.layer.shadowColor = UIColor.black.cgColor
        
        headerVw.layer.shadowOpacity = 0.25
        headerVw.layer.shadowOffset = CGSize(width: 1, height: 2)
        headerVw.layer.shadowRadius = 1
        headerVw.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}