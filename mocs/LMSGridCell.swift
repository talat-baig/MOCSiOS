//
//  LMSGridCell.swift
//  mocs
//
//  Created by Talat Baig on 1/18/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class LMSGridCell: UITableViewCell {

    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setStaticData() {
        
        lbl1.text = "Leave Type"
        lbl2.text = "Available"
        lbl3.text = "Utilised"
        lbl4.text = "Total"
        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        lbl1.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        lbl3.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        lbl4.font = UIFont.systemFont(ofSize: 14, weight: .bold)

    }
    
    func setDataToView(gridData : LMSGridData) {
//        lbl1.text = gridData
        lbl1.text = gridData.typeOfLeave
        lbl2.text = gridData.available
        lbl3.text = gridData.utilized
        lbl4.text = gridData.total

    }
    
}
