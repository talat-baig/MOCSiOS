//
//  CashBankCell.swift
//  mocs
//
//  Created by Talat Baig on 2/22/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class CashBankCell: UITableViewCell {

    @IBOutlet weak var outerVw: UIView!
    @IBOutlet weak var headrVw: UIView!

    @IBOutlet weak var lblCPName: UILabel!
    
    @IBOutlet weak var lblCPId: UILabel!
    @IBOutlet weak var lblParticulars: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDebit: UILabel!
    @IBOutlet weak var lblCredit: UILabel!
    @IBOutlet weak var lblBal: UILabel!
    @IBOutlet weak var lblRemarks: UILabel!

    @IBOutlet weak var lblJournal: UILabel!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblRef: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        outerVw.layer.shadowOpacity = 0.25
        outerVw.layer.shadowOffset = CGSize(width: 0, height: 2)
        outerVw.layer.shadowRadius = 1
        outerVw.layer.shadowColor = UIColor.black.cgColor
        
        headrVw.layer.shadowOpacity = 0.25
        headrVw.layer.shadowOffset = CGSize(width: 1, height: 2)
        headrVw.layer.shadowRadius = 1
        headrVw.layer.shadowColor = UIColor.black.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutIfNeeded()
    }
    
    func setDataToView(data:PaymentLedgerData){
        
        lblCPId.text = data.cpID != "" ? data.cpID : "-" //
        lblCPName.text = data.vendorName != "" ? data.vendorName : "-" //
        
        lblDate.text = data.date
        lblBal.text = data.balance
        lblBankName.text = data.bankName
        lblAccount.text = data.account
        lblRemarks.text = data.remarks
        lblJournal.text = data.journal
        lblParticulars.text = data.particular
        lblCredit.text = data.debit
        lblDebit.text = data.debit
        lblRef.text = data.refNo
        
    }

    
}
