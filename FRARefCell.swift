//
//  FRARefCell.swift
//  mocs
//
//  Created by Talat Baig on 12/21/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class FRARefCell: UITableViewCell {

    @IBOutlet weak var outerVw: UIView!
    @IBOutlet weak var headerVw: UIView!
    
    @IBOutlet weak var lblRefNo: UILabel!
    @IBOutlet weak var lblCountrpty: UILabel!
    @IBOutlet weak var lblAccNum: UILabel!
    @IBOutlet weak var lblGrossAmt: UILabel!
    @IBOutlet weak var lblNetAmt: UILabel!
    @IBOutlet weak var lblBnkName: UILabel!
    @IBOutlet weak var lblFRCCY: UILabel!
    @IBOutlet weak var lblTotalAmt: UILabel!
    @IBOutlet weak var lblRemarks: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
    func setDataToView(data : FRARefData?) {
        lblRefNo.text = data?.refNo
        lblAccNum.text = data?.accNum
        lblBnkName.text = data?.bnkName
        lblNetAmt.text = data?.netAmt
        lblFRCCY.text = data?.frCCY
        lblGrossAmt.text = data?.grossAmt
        lblRemarks.text = data?.remarks
        lblCountrpty.text = data?.counterparty
    }
    
}
