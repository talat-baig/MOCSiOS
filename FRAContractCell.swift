//
//  FRAContractCell.swift
//  mocs
//
//  Created by Talat Baig on 12/21/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class FRAContractCell: UITableViewCell {
    
    
    @IBOutlet weak var lblInvNo: UILabel!
    
    @IBOutlet weak var lblInvCurr: UILabel!
    @IBOutlet weak var lblAUllocAmt: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblRemarks: UILabel!
    @IBOutlet weak var lblInvAmt: UILabel!
    @IBOutlet weak var lblContrctNo: UILabel!
    @IBOutlet weak var lblGainLossAmt: UILabel!
    @IBOutlet weak var outerVw: UIView!
    @IBOutlet weak var headerVw: UIView!

    
    
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
 
    func setDataToView(data : FRAContractData?) {
        lblContrctNo.text = data?.refNo
        lblInvNo.text = data?.invNo
        lblInvNo.text = data?.invNo
        lblInvAmt.text = data?.invAmt
        lblInvCurr.text = data?.invCurr
        lblValue.text = data?.invVal
        lblAUllocAmt.text = data?.unallocAmt
        lblGainLossAmt.text = data?.gainLossAmt
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
