//
//  CUDebitCell.swift
//  mocs
//
//  Created by Talat Baig on 3/26/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class CUDebitCell: UITableViewCell {

    @IBOutlet weak var outrVw: UIView!
    
    @IBOutlet weak var headerVw: UIView!
    
    @IBOutlet weak var lblRefId: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblUOM: UILabel!
    @IBOutlet weak var lblCurr: UILabel!
    @IBOutlet weak var lblInvValCCY: UILabel!
    @IBOutlet weak var lblInvVal: UILabel!
    @IBOutlet weak var lblInvQty: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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
    
    func setDataToView(data : CUDebitData) {
        
        lblRefId.text = data.refID != "" ? data.refID : "-"
        lblUOM.text = data.uom != "" ? data.uom : "-"
        lblDate.text = data.date != "" ? data.date : "-"
        lblInvQty.text = data.invQty != "" ? data.invQty : "-"
        lblCurr.text = data.curr != "" ? data.curr : "-"
        lblInvVal.text = data.invVal != "" ? data.invVal : "-"
        lblInvValCCY.text = data.invValCCY != "" ? data.invValCCY : "-"
    }
    
}
