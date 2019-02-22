//
//  ECRRefIDDetailsCell.swift
//  mocs
//
//  Created by Talat Baig on 2/19/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class ECRRefIDDetailsCell: UITableViewCell {

    @IBOutlet weak var outerVw: UIView!
    @IBOutlet weak var headrVw: UIView!
    
    @IBOutlet weak var lblNOE: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblDeptApproval: UILabel!
    @IBOutlet weak var lblFinanceApproval: UILabel!
    @IBOutlet weak var lblReqAmt: UILabel!
    @IBOutlet weak var lblPaidAmt: UILabel!
    @IBOutlet weak var lblReqType: UILabel!
    @IBOutlet weak var lblChargeHead: UILabel!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblAccount: UILabel!

    @IBOutlet weak var lblRef: UILabel!
    @IBOutlet weak var lblRemarks: UILabel!

    
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
        
        self.layoutIfNeeded()
        self.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


    func setDataToView(data:ECRRefData){
        
        lblNOE.text! = data.natureExpense
        lblReqAmt.text! = data.amtReq
        lblPaidAmt.text! = data.amtPaid
        lblReqType.text! = data.reqType
        lblCurrency.text! = data.curr
        lblChargeHead.text! = data.charge
        lblAccount.text! = data.account
        lblBankName.text! = data.bankName
        lblDeptApproval.text! = data.deptApproval
        lblFinanceApproval.text! = data.financeApproval
        lblRemarks.text! = data.remarks
        lblRef.text! = data.refNo

    }
}
