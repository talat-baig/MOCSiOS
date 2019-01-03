//
//  FPSOverallCell.swift
//  mocs
//
//  Created by Talat Baig on 1/3/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class FPSOverallCell: UITableViewCell {

    @IBOutlet weak var lblPaid: UILabel!
    @IBOutlet weak var lblRequested: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setDataToViews(data : SSListData) {
        
        self.lblPaid.text = data.totalPaid
        self.lblRequested.text = data.totalRequested
        self.lblBalance.text = data.totalValUSD
    }
}
