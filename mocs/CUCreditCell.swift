//
//  CUCreditCell.swift
//  mocs
//
//  Created by Talat Baig on 3/26/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class CUCreditCell: UITableViewCell {

    @IBOutlet weak var outrVw: UIView!
    @IBOutlet weak var headerVw: UIView!

    @IBOutlet weak var lblRefId: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblBnkName: UILabel!
    @IBOutlet weak var lblCurr: UILabel!
    @IBOutlet weak var lblGrossCCY: UILabel!
    @IBOutlet weak var lblGross: UILabel!
    @IBOutlet weak var lblAccNo: UILabel!
    
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
    }
    
    func setDataToView(data : CUCreditData) {
        
        lblRefId.text = data.refID
        lblAccNo.text = data.accNo
        lblDate.text = data.date
        lblBnkName.text = data.bankShortName
        lblCurr.text = data.curr
        lblGrossCCY.text = data.grossAmtCCY
        lblGross.text = data.grossAmt
    }
    
    
}
