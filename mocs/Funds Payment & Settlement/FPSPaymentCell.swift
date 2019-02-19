//
//  FPSPaymentCell.swift
//  mocs
//
//  Created by Talat Baig on 1/2/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class FPSPaymentCell: UITableViewCell {

    @IBOutlet weak var lblPymntId: UILabel!
    @IBOutlet weak var lblPaymntAmt: UILabel!
    @IBOutlet weak var lblPaymntMode: UILabel!
    @IBOutlet weak var lblJournal: UILabel!
    @IBOutlet weak var lblPaidDate: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblRemarks: UILabel!
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
    
    func setDataToViews(data : FPSPaymentData) {
        
        lblPymntId.text = data.payId
        lblPaidDate.text = data.paidDate
        
        let val = data.paidAmt
        let valCurr = data.currency
        
        if valCurr == "" || valCurr == "-"{
            lblPaymntAmt.text = val
        } else {
            lblPaymntAmt.text = val + "(" + valCurr + ")"
        }
        
        lblJournal.text = data.journal
        lblRemarks.text = data.remarks
        lblReason.text = data.reason
        lblPaymntMode.text = data.payMode
    }
    
}
