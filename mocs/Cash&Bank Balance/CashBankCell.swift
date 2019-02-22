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

    @IBOutlet weak var cpName: UILabel!
    
    @IBOutlet weak var cpId: UILabel!
    @IBOutlet weak var particulars: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var debit: UILabel!
    @IBOutlet weak var credit: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var remarks: UILabel!

    @IBOutlet weak var lblCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        outerVw.layer.shadowOpacity = 0.25
        outerVw.layer.shadowOffset = CGSize(width: 0, height: 2)
        outerVw.layer.shadowRadius = 1
        outerVw.layer.shadowColor = UIColor.black.cgColor
        
        headrVw.layer.shadowOpacity = 0.25
        headrVw.layer.shadowOffset = CGSize(width: 1, height: 2)
        headrVw.layer.shadowRadius = 1
        headrVw.layer.shadowColor = UIColor.black.cgColor    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataToView(data:ECRRefData){
        
//        lblDeptApproval.text! = data.deptApproval
//        lblFinanceApproval.text! = data.financeApproval
//        lblRemarks.text! = data.remarks
//        lblRef.text! = data.refNo
    }

    
}
