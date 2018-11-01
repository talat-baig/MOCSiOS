//
//  APInvoiceCell.swift
//  mocs
//
//  Created by Talat Baig on 10/29/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class APInvoiceCell: UITableViewCell {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblInvNo: UILabel!
    @IBOutlet weak var btnSendEmail: UIButton!

    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblBUnit: UILabel!
    @IBOutlet weak var lblCounterpty: UILabel!
//    @IBOutlet weak var lblCounterptyId: UILabel!

    @IBOutlet weak var lblInvDate: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var lblInvVal: UILabel!
    @IBOutlet weak var lblBalPyble: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    ///
    public func setDataToView(data: APInvoiceData, isSelected:Bool?=false){

        self.lblInvNo.text = data.invNo
        self.lblCompany.text = data.company
        self.lblLocation.text = data.location
        self.lblBUnit.text = data.bVertical
        self.lblCounterpty.text = data.counterpty

        self.lblInvDate.text = data.invtDate
        self.lblDueDate.text = data.dueDate

        self.lblInvVal.text = data.invVal
        self.lblBalPyble.text = data.invBalPayble

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
