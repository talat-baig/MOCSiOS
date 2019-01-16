//
//  LMSLeaveDetailsCell.swift
//  mocs
//
//  Created by Talat Baig on 1/14/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class LMSLeaveDetailsCell: UITableViewCell {

    @IBOutlet weak var lblReqId: UILabel!
    @IBOutlet weak var lblTypeOfLeave: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblToDate: UILabel!
    @IBOutlet weak var lblFromDate: UILabel!
    @IBOutlet weak var lblNoOfDays: UILabel!
    @IBOutlet weak var headerVw: UIView!
    @IBOutlet weak var outrVw: UIView!

    weak var delegate:onButtonClickListener?

    var data:LMSLeaveData?

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
    
    func setDataToViews(data : LMSLeaveData?) {
        
        lblReqId.text = data?.reqDate
        lblTypeOfLeave.text = data?.type
        lblContact.text = data?.contact
        lblReason.text = data?.reason
        lblToDate.text = data?.toDate
        lblFromDate.text = data?.fromDate
        lblNoOfDays.text = data?.noOfDays
        lblStatus.text = data?.status
        self.data = data
    }
    
    
    @IBAction func btnApproveTapped(_ sender: Any) {
        if(self.delegate?.responds(to: Selector(("onApproveClick:"))) != nil){
            delegate?.onApproveClick(data: data!)
        }
    }
    
    
    @IBAction func btnDeclineTapped(_ sender: Any) {
        if(self.delegate?.responds(to: Selector(("onDeclineClick:"))) != nil){
            delegate?.onDeclineClick(data: data!)
        }
    }
    
   
    
}
