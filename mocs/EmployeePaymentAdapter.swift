//
//  EmployeePaymentAdapter.swift
//  mocs
//
//  Created by Admin on 3/7/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class EmployeePaymentAdapter: UITableViewCell {

    @IBOutlet weak var refId: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var business: UILabel!
    @IBOutlet weak var raisedOn: UILabel!
    @IBOutlet weak var paymentType: UILabel!
    @IBOutlet weak var requestedAmount: UILabel!
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var headrVw: UIView!
    @IBOutlet weak var outrVw: UIView!
    weak var delegate:onButtonClickListener?
    var data:EPRData?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.outrVw.layer.borderWidth = 1
        self.outrVw.layer.borderColor = AppColor.universalHeaderColor.cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    func setViewToData(_ data:EPRData){
        refId.text! = data.refId
        company.text! = data.company
        location.text! = data.location
        business.text! = data.businessUnit
        raisedOn.text! = data.date
        paymentType.text! = data.paymentType
        requestedAmount.text! = data.requestAmount
        status.text! = data.status
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
