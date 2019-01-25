//
//  LMSReqDataCell.swift
//  mocs
//
//  Created by Talat Baig on 1/18/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

protocol onLMSOptionClickListener: NSObjectProtocol {
    func onViewClick(data:LMSReqData) -> Void
    func onEditClick(data:LMSReqData) -> Void
    func onDeleteClick(data:LMSReqData) -> Void

}

class LMSReqDataCell: UITableViewCell {
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDateApplied: UILabel!
    @IBOutlet weak var lblTOF: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblTo: UILabel!
    @IBOutlet weak var lblNoOfDays: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var vwOuter: UIView!
    @IBOutlet weak var imgVwStatus: UIImageView!
    
    @IBOutlet weak var vwHeader: UIView!
    var data : LMSReqData!
    weak var delegate:onMoreClickListener?
    weak var optionClickListener:onLMSOptionClickListener?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vwOuter.layer.cornerRadius = 3
        vwOuter.layer.shadowOpacity = 0.25
        vwOuter.layer.shadowOffset = CGSize(width: 0, height: 2)
        vwOuter.layer.shadowRadius = 1
        vwOuter.layer.shadowColor = UIColor.black.cgColor
        
        vwHeader.layer.masksToBounds = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataToViews(data : LMSReqData) {
        
        lblTo.text = data.to
        lblFrom.text = data.from
        lblTOF.text = data.leaveType
        lblReason.text = data.reason
        lblStatus.text = data.appStatus
        lblNoOfDays.text = data.noOfDays
        lblDateApplied.text = data.appliedDate
        
        if data.appStatus == "Approved" {
            imgVwStatus.image = #imageLiteral(resourceName: "approve")
            
        } else if data.appStatus == "Rejected" {
            
            imgVwStatus.image = #imageLiteral(resourceName: "decline")
            
        } else if data.appStatus == "Pending"  {
            
            imgVwStatus.image = #imageLiteral(resourceName: "pending")
            
        } else {
            
            imgVwStatus.image = #imageLiteral(resourceName: "cancelled")
        }
        
        self.data = data
    }
    
    
    
    @IBAction func moreClick(_ sender: UIButton) {
        
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.optionClickListener?.responds(to: Selector(("onEditClick:"))) != nil){
                self.optionClickListener?.onEditClick(data: self.data)
            }
        })
        
        let viewAction = UIAlertAction(title: "View", style: .default, handler: { (alert:UIAlertAction!)-> Void in
            if (self.optionClickListener?.responds(to: Selector(("onViewClick:"))) != nil){
                self.optionClickListener?.onViewClick(data: self.data)
            }
        })
        
        let delAction = UIAlertAction(title: "Cancel", style: .default, handler: { (alert:UIAlertAction!)-> Void in
            if (self.optionClickListener?.responds(to: Selector(("onDeleteClick:"))) != nil){
                self.optionClickListener?.onDeleteClick(data: self.data)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) -> Void in
        })
        
        
        if data.appStatus.caseInsensitiveCompare("pending") == ComparisonResult.orderedSame {
            
            optionMenu.addAction(editAction)
            optionMenu.addAction(delAction)
        }
//        optionMenu.addAction(editAction)
        optionMenu.addAction(viewAction)
//        optionMenu.addAction(delAction)
        
        optionMenu.addAction(cancelAction)
        
        if ((delegate?.responds(to: Selector(("onClick:")))) != nil) {
            delegate?.onClick(optionMenu: optionMenu , sender: sender)
        }
        
        
    }
}
