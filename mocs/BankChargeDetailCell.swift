//
//  BankChargeDetailCell.swift
//  mocs
//
//  Created by Talat Baig on 3/11/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class BankChargeDetailCell: UITableViewCell {

    @IBOutlet weak var outerVw: UIView!
    
    @IBOutlet weak var lblCType: UILabel!
    
    @IBOutlet weak var lblCAmt: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblBnkAccNo: UILabel!
    @IBOutlet weak var lblCurr: UILabel!
    @IBOutlet weak var lblTaxVal: UILabel!
    @IBOutlet weak var lblBnkName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        outerVw.layer.borderColor = AppColor.universalHeaderColor.cgColor
        outerVw.layer.borderWidth = 1.0
        
//        outerVw.layer.shadowOpacity = 0.25
//        outerVw.layer.shadowOffset = CGSize(width: 0, height: 2)
//        outerVw.layer.shadowRadius = 1
//        outerVw.layer.shadowColor = UIColor.black.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
