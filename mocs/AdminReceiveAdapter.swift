//
//  AdminReceiveAdapter.swift
//  mocs
//
//  Created by Admin on 3/12/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class AdminReceiveAdapter: UITableViewCell {

    @IBOutlet weak var refId: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblBusiness: UILabel!
    @IBOutlet weak var lblBeneficiary: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblAmountUSD: UILabel!
    
    @IBOutlet weak var vwInner: UIView!
    weak var delegate:onButtonClickListener?
    var data:ARIData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwInner.layer.borderWidth = 1
        self.vwInner.layer.borderColor = AppColor.universalHeaderColor.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setDataToView(data:ARIData){
        refId.text! = data.refId
        lblCompany.text! = data.company
        lblLocation.text! = data.location
        lblBusiness.text! = data.businessUnit
        lblBeneficiary.text! = data.beneficiaryName
        lblDate.text! = data.date
        lblAmount.text! = data.requestAmt
        lblAmountUSD.text! = data.requestAmtUSD
        self.data = data
    }
    
    @IBAction func view_click(_ sender: Any) {
        if(self.delegate?.responds(to: Selector(("onViewClick:"))) != nil){
            delegate?.onViewClick(data: data!)
        }
    }
    @IBAction func mail_click(_ sender: Any) {
        if(self.delegate?.responds(to: Selector(("onMailClick:"))) != nil){
            delegate?.onMailClick(data: data!)
        }
    }
    @IBAction func approve_click(_ sender: Any) {
        if(self.delegate?.responds(to: Selector(("onApproveClick:"))) != nil){
            delegate?.onApproveClick(data: data!)
        }
    }
    @IBAction func decline_click(_ sender: Any) {
        if(self.delegate?.responds(to: Selector(("onDeclineClick:"))) != nil){
            delegate?.onDeclineClick(data: data!)
        }
    }
}
