//
//  PaymentLedgerCell.swift
//  mocs
//
//  Created by Talat Baig on 2/20/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class PaymentLedgerCell: UITableViewCell {

    @IBOutlet weak var outerVw: UIView!
    @IBOutlet weak var headerVw: UIView!

    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var lblCPID: UILabel!
    @IBOutlet weak var refNo: UILabel!
    @IBOutlet weak var vendorName: UILabel!
    @IBOutlet weak var instrumentNo: UILabel!
    
    @IBOutlet weak var remarks: UILabel!
    @IBOutlet weak var credit: UILabel!
    @IBOutlet weak var currency: UILabel!
    
    @IBOutlet weak var particular: UILabel!
    @IBOutlet weak var journal: UILabel!
    @IBOutlet weak var debit: UILabel!
    @IBOutlet weak var balance: UILabel!
    
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
        
//        lblCPID.text! = data.cpID
        
        lblCPID.text! = data.cpID != "" ? data.cpID : "-"
        journal.text! = data.journal
        currency.text! = data.curr
        credit.text! = data.credit
        debit.text! = data.debit
        balance.text! = data.balance
        journal.text! = data.journal
        date.text! = data.date
        remarks.text! = data.remarks
        instrumentNo.text! = data.instNo
        particular.text! = data.particular
        refNo.text! = data.refNo

    }
    
}
