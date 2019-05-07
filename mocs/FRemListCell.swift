//
//  FRemListCell.swift
//  mocs
//
//  Created by Talat Baig on 4/4/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class FRemListCell: UITableViewCell {

    
    @IBOutlet weak var headerVw: UIView!
    @IBOutlet weak var outrVw: UIView!
    
    @IBOutlet weak var lblRefId: UILabel!
    
    @IBOutlet weak var lblRemBank: UILabel!
    @IBOutlet weak var lblRemAC: UILabel!
    @IBOutlet weak var lblRemTo: UILabel!
    @IBOutlet weak var lblRemToBnk: UILabel!
    @IBOutlet weak var lblRemToAC: UILabel!
    @IBOutlet weak var lblModeOfRem: UILabel!
    @IBOutlet weak var lblRemAmt: UILabel!
    @IBOutlet weak var lblRemCurr: UILabel!
    @IBOutlet weak var lblTotalRemCharges: UILabel!
    @IBOutlet weak var lblCurrPair: UILabel!
    @IBOutlet weak var lblFXRate: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblCurr: UILabel!
    @IBOutlet weak var lblRemAmtFCY: UILabel!
    @IBOutlet weak var lblTransDate: UILabel!
    
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
    
    
    func setDataToView(data : FRListData?) {
        
        lblRefId.text = data?.refID != "" ? data?.refID : "-"
        lblTransDate.text = data?.trnsDate != "" ? data?.trnsDate : "-"
        lblRemBank.text = data?.remBank != "" ? data?.remBank : "-"
        lblRemAC.text = data?.remAccnt != "" ? data?.remAccnt : "-"
        lblRemTo.text = data?.remTo != "" ? data?.remTo : "-"
        
        lblRemToBnk.text = data?.remToBnk != "" ? data?.remToBnk : "-"
        lblRemToAC.text = data?.remToAC != "" ? data?.remToAC : "-"
        
        lblModeOfRem.text = data?.modeOfRem != "" ? data?.modeOfRem : "-"
        lblRemAmt.text = data?.remAmt != "" ? data?.remAmt : "-"
        lblRemCurr.text = data?.remCurr != "" ? data?.remCurr : "-"
        lblTotalRemCharges.text = data?.remCharges != "" ? data?.remCharges : "-"
        lblCurrPair.text = data?.currPair != "" ? data?.currPair : "-"
        lblFXRate.text = data?.fxRate != "" ? data?.fxRate : "-"
        lblRemAmtFCY.text = data?.remAmtFCY != "" ? data?.remAmtFCY : "-"
        lblCurr.text = data?.curr != "" ? data?.curr : "-"
        lblReason.text = data?.reason != "" ? data?.reason : "-"
    }
    
}
