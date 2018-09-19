//
//  ItineraryListCell.swift
//  mocs
//
//  Created by Talat Baig on 9/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class ItineraryListCell: UITableViewCell {

    
    @IBOutlet weak var vwOuter: UIView!
    
    @IBOutlet weak var lblDest: UILabel!
    
    @IBOutlet weak var lblDepDate: UILabel!
    
    @IBOutlet weak var lblRetDate: UILabel!

    @IBOutlet weak var lblEstDays: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()

        self.vwOuter.layer.borderWidth = 1
        self.vwOuter.layer.borderColor = AppColor.universalHeaderColor.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
