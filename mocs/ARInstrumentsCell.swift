//
//  ARInstrumentsCellTableViewCell.swift
//  mocs
//
//  Created by Talat Baig on 4/5/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class ARInstrumentsCell: UITableViewCell {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblInstrumentNo: UILabel!
    @IBOutlet weak var btnSendEmail: UIButton!
    
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblBUnit: UILabel!
    @IBOutlet weak var lblCounterpty: UILabel!
    @IBOutlet weak var lblCounterptyId: UILabel!
    
    @IBOutlet weak var lblInsDate: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var lblInvQty: UILabel!
    @IBOutlet weak var lblInvVal: UILabel!
    @IBOutlet weak var lblAmtRecvd: UILabel!
    @IBOutlet weak var lblAmtRecvble: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    ///
    public func setDataToView(data: ARInstrumentsData, isSelected:Bool?=false){
        
        self.lblInstrumentNo.text = data.instNo
        
        self.lblCompany.text = data.company
        self.lblLocation.text = data.location
        self.lblBUnit.text = data.bVertical
        self.lblCounterpty.text = data.counterpty
        self.lblCounterptyId.text = data.buyerId
        
        self.lblInsDate.text = data.instDate
        self.lblDueDate.text = data.dueDate
        
        self.lblInvQty.text = data.invQty
        self.lblInvVal.text = data.invVal
        self.lblAmtRecvd.text = data.invAmtRecvd
        self.lblAmtRecvble.text = data.invAmtRecvble
        
        if isSelected!{
            self.btnSendEmail.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
            self.btnSendEmail.isUserInteractionEnabled = false
            self.headerView.backgroundColor = UIColor.gray

        } else {
            self.btnSendEmail.setImage(#imageLiteral(resourceName: "email"), for: .normal)
            self.btnSendEmail.isUserInteractionEnabled = true
            self.headerView.backgroundColor = AppColor.universalHeaderColor
        }
        
    }
    
    @IBAction func sendEmailTapped(_ sender: Any) {

    }
    
    
}
