//
//  FPSRefListCell.swift
//  mocs
//
//  Created by Talat Baig on 1/2/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class FPSRefListCell: UITableViewCell {

    @IBOutlet weak var lblRefId: UILabel!
    @IBOutlet weak var lblCountpty: UILabel!
    
    @IBOutlet weak var headerVw: UIView!
    @IBOutlet weak var outrVw: UIView!
    
    @IBOutlet weak var lblReqAmt: UILabel!
    @IBOutlet weak var lblPaidAmt: UILabel!
    @IBOutlet weak var lblBalAmt: UILabel!
    @IBOutlet weak var lblCurr: UILabel!

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
 
    
    func setDataToView(data : FPSRefData?) {
       
        lblRefId.text = data?.refId
        lblBalAmt.text = data?.balAmt
        lblReqAmt.text = data?.reqAmt
        lblCountpty.text = data?.cpName
        lblPaidAmt.text = data?.paidAmt
        lblCurr.text = data?.currency
    }
    
}
