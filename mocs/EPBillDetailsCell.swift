//
//  EPBillDetailstCell.swift
//  mocs
//
//  Created by Talat Baig on 4/5/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class EPBillDetailsCell: UITableViewCell {

    @IBOutlet weak var headerVw: UIView!
    @IBOutlet weak var outrVw: UIView!
    
    @IBOutlet weak var lblLoadPort: UILabel!
    @IBOutlet weak var lblDeschargePort: UILabel!
    @IBOutlet weak var lblSOB: UILabel!
    @IBOutlet weak var lblETA: UILabel!
    @IBOutlet weak var lblDocsRcvdDate: UILabel!
    @IBOutlet weak var lblPaymentMode: UILabel!
    @IBOutlet weak var lblBnkName: UILabel!
    
    @IBOutlet weak var lblFundsRecptVal: UILabel!
    
    @IBOutlet weak var lblReason: UILabel!
    
    @IBOutlet weak var lblCCY: UILabel!
    
    @IBOutlet weak var lblBLNo: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
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
    
    func setDataToView(data : EPBillDetailData) {
        
        lblBLNo.text = data.uniqBLNo
        lblLoadPort.text = data.loadPort
        lblDeschargePort.text = data.descPort
        lblSOB.text = data.sob
        lblETA.text = data.eta
        lblCCY.text = data.ccy
        lblDocsRcvdDate.text = data.docsRcvdDate
        
        lblPaymentMode.text = data.paymentMethod
        lblBnkName.text = data.bankName
        lblFundsRecptVal.text = data.fundsRcptVal
        
        lblReason.text = data.bankName
    }
    
}
