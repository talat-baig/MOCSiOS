//
//  BankChargesListCell.swift
//  mocs
//
//  Created by Talat Baig on 3/11/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class BankChargesListCell: UITableViewCell {

    @IBOutlet weak var lblRefId: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTotalAmt: UILabel!

    @IBOutlet weak var outerVw: UIView!
    @IBOutlet weak var headerVw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outerVw.layer.shadowOpacity = 0.25
        outerVw.layer.shadowOffset = CGSize(width: 0, height: 2)
        outerVw.layer.shadowRadius = 1
        outerVw.layer.shadowColor = UIColor.black.cgColor
        
        headerVw.layer.shadowOpacity = 0.25
        headerVw.layer.shadowOffset = CGSize(width: 1, height: 2)
        headerVw.layer.shadowRadius = 1
        headerVw.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    func setDataToView(data : BCRefData?) {
        
        lblRefId.text = data?.refID
        lblDate.text = data?.chrgDate
        lblTotalAmt.text = data?.chrgAmt
    }
}
