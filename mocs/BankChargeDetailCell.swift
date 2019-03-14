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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataToView(data : BCDetailData?) {
        
        lblCType.text = data?.chrgType != "" ? data?.chrgType : "-"
        lblCAmt.text = data?.chrgAmt != "" ? data?.chrgAmt : "-"
        lblDesc.text = data?.desc != "" ? data?.desc : "-"
        lblBnkAccNo.text = data?.bankAccNo != "" ? data?.bankAccNo : "-"
        lblCurr.text = data?.currency != "" ? data?.currency : "-"
        lblTaxVal.text = data?.taxVal != "" ? data?.taxVal : "-"
        lblBnkName.text = data?.bankName != "" ? data?.bankName : "-"
    }
}
