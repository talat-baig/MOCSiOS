//
//  TCRAdapter.swift
//  mocs
//
//  Created by Admin on 3/5/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class TCRAdapter: UITableViewCell {

    @IBOutlet weak var refId: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var business: UILabel!
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var department: UILabel!
    @IBOutlet weak var purposeTravel: UILabel!
    @IBOutlet weak var period: UILabel!
    @IBOutlet weak var claimRaised: UILabel!
    @IBOutlet weak var vwInner: UIView!
    
    weak var delegate:onButtonClickListener?
    var data:TravelClaimData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwInner.layer.borderWidth = 1
        self.vwInner.layer.borderColor = AppColor.universalHeaderColor.cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setDataToView(_ data:TravelClaimData){
        refId.text! = data.headRef
        company.text! = data.companyName
        location.text! = data.location
        business.text! = data.businessVertical
        employeeName.text! = data.employeeName
        department.text! = data.employeeDepartment
        purposeTravel.text! = data.purposeOfTravel
        period.text! = data.periodOfTravel
        claimRaised.text! = data.claimRaisedOn
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
