//
//  CLListCell.swift
//  mocs
//
//  Created by Talat Baig on 2/20/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class CLListCell: UITableViewCell {

    @IBOutlet weak var outerVw: UIView!
    @IBOutlet weak var headerVw: UIView!
    
    
    @IBOutlet weak var lblCName: UILabel!
    @IBOutlet weak var lblCID: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblJournal: UILabel!
    @IBOutlet weak var lblRemarks: UILabel!
    @IBOutlet weak var lblCredit: UILabel!
    @IBOutlet weak var lblDebit: UILabel!
    @IBOutlet weak var lblBal: UILabel!
    @IBOutlet weak var lblCurr: UILabel!
    
    @IBOutlet weak var lblHead: UILabel!
    
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
    
    func setDataToView(data:PaymentLedgerData){
        
        lblCName.text = data.vendorName != "" ? data.vendorName : "-" //
        lblCID.text = data.cpID != "" ? data.cpID : "-" //
        lblDate.text = data.date
        lblBal.text = data.balance
        lblCredit.text = data.credit
        lblDebit.text = data.debit
        lblRemarks.text = data.remarks
        lblJournal.text = data.journal
        lblCurr.text = data.curr
//        lblRefNo.text = data.refNo
        lblHead.text = data.refNo
    }

}
