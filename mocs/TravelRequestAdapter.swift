//
//  TravelRequestAdapter.swift
//  mocs
//
//  Created by Talat Baig on 9/12/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit


protocol onTReqItemClickListener: NSObjectProtocol {
    
    func onViewClick(data:TravelRequestData) -> Void
    func onEditClick(data:TravelRequestData) -> Void
    func onDeleteClick(data:TravelRequestData) -> Void
    func onSubmitClick(data:TravelRequestData) -> Void
    func onEmailClick(data:TravelRequestData) -> Void
}


protocol onTRFApprovItemClickListener: NSObjectProtocol {
    
    func onViewClick(data:TravelRequestData) -> Void
    func onApproveTRF(data:TravelRequestData) -> Void
    func onDeclineTRF(data:TravelRequestData) -> Void
}


class TravelRequestAdapter: UITableViewCell {
    
    @IBOutlet weak var lblRefNo: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var outerVw: UIView!
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var empName: UILabel!
    @IBOutlet weak var empDept: UILabel!
    @IBOutlet weak var reqDate: UILabel!
    @IBOutlet weak var desgntn: UILabel!
    @IBOutlet weak var reason: UILabel!
    
    @IBOutlet weak var lblEmpName: UILabel!
    @IBOutlet weak var lblDept: UILabel!
    @IBOutlet weak var lblReqDate: UILabel!
    @IBOutlet weak var lblDesgntn: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    
    weak var delegate:onMoreClickListener?
    weak var data:TravelRequestData!
    weak var trfApprvListener :onTRFApprovItemClickListener!
    weak var trvlReqItemClickListener:onTReqItemClickListener?
    var isFromApprov = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakerfromnib")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataToView(data: TravelRequestData?, isFromApprove : Bool) {
        
        lblRefNo.text = data?.reqNo
        lblStatus.text = data?.status
        empName.text = data?.empName
        empDept.text = data?.empDept
        reqDate.text = data?.reqDate
        desgntn.text = data?.empDesgntn
        reason.text = data?.reason
        self.data = data
        
        if isFromApprove {
            
            self.outerVw.layer.borderWidth = 1
            self.outerVw.layer.borderColor = AppColor.universalHeaderColor.cgColor
            
            lblDept.textColor = UIColor.black
            lblEmpName.textColor = UIColor.black
            lblReqDate.textColor = UIColor.black
            lblDesgntn.textColor = UIColor.black
            lblReason.textColor = UIColor.black
            
            lblDept.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            lblEmpName.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            lblReqDate.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            lblDesgntn.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            lblReason.font = UIFont.systemFont(ofSize: 13, weight: .medium)

            empDept.textColor = AppColor.universalHeaderColor
            empName.textColor = AppColor.universalHeaderColor
            reqDate.textColor = AppColor.universalHeaderColor
            reason.textColor = AppColor.universalHeaderColor
            desgntn.textColor = AppColor.universalHeaderColor
            
            empDept.font =  UIFont.systemFont(ofSize: 15, weight: .bold)
            empName.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            reqDate.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            reason.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            desgntn.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            
            
        } else {
            
            
            outerVw.layer.shadowOpacity = 0.25
            outerVw.layer.shadowOffset = CGSize(width: 0, height: 2)
            outerVw.layer.shadowRadius = 1
            outerVw.layer.shadowColor = UIColor.black.cgColor
            
            lblDept.textColor = AppColor.scrollVwColor
            lblEmpName.textColor = AppColor.scrollVwColor
            lblReqDate.textColor = AppColor.scrollVwColor
            lblDesgntn.textColor = AppColor.scrollVwColor
            lblReason.textColor = AppColor.scrollVwColor
            
            lblDept.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            lblEmpName.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            lblReqDate.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            lblDesgntn.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            lblReason.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            
            empDept.textColor =  UIColor.black
            empName.textColor =  UIColor.black
            reqDate.textColor =  UIColor.black
            reason.textColor = UIColor.black
            desgntn.textColor = UIColor.black
            
            empDept.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            empName.font =  UIFont.systemFont(ofSize: 15, weight: .semibold)
            reqDate.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            reason.font =  UIFont.systemFont(ofSize: 15, weight: .semibold)
            desgntn.font =  UIFont.systemFont(ofSize: 15, weight: .semibold)
        }
    }
    
    
    @IBAction func moreClick(_ sender: UIButton) {
        
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.trvlReqItemClickListener?.responds(to: Selector(("onEditClick:"))) != nil){
                self.trvlReqItemClickListener?.onEditClick(data: self.data)
            }
        })
        
        let deleteActon = UIAlertAction(title: "Delete", style: .default, handler: { (UIAlertAction)-> Void in
            if (self.trvlReqItemClickListener?.responds(to: Selector(("onDeleteClick:"))) != nil){
                self.trvlReqItemClickListener?.onDeleteClick(data: self.data)
            }
        })
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.trvlReqItemClickListener?.responds(to: Selector(("onSubmitClick:"))) != nil){
                self.trvlReqItemClickListener?.onSubmitClick(data: self.data)
            }
        })
        
        let viewAction = UIAlertAction(title: "View", style: .default, handler: { (alert:UIAlertAction!)-> Void in
            if (self.trvlReqItemClickListener?.responds(to: Selector(("onViewClick:"))) != nil){
                self.trvlReqItemClickListener?.onViewClick(data: self.data)
            }
        })
        
        
        let emailAction = UIAlertAction(title: "Email", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.trvlReqItemClickListener?.responds(to: Selector(("onEmailClick:"))) != nil){
                self.trvlReqItemClickListener?.onEmailClick(data: self.data)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) -> Void in
            
        })
        
        let cancelAction2 = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) -> Void in
            
        })
        
        
        let viewAction2 = UIAlertAction(title: "View", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.trfApprvListener?.responds(to: Selector(("onViewClick:"))) != nil){
                self.trfApprvListener?.onViewClick(data: self.data)
            }
        })
        
        let approvAction = UIAlertAction(title: "Approve", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.trfApprvListener?.responds(to: Selector(("onApproveTRF:"))) != nil){
                self.trfApprvListener?.onApproveTRF(data: self.data)
            }
        })
        
        let declAction = UIAlertAction(title: "Decline", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.trfApprvListener?.responds(to: Selector(("onDeclineTRF:"))) != nil){
                self.trfApprvListener?.onDeclineTRF(data: self.data)
            }
        })
        
        
        if isFromApprov {
            
            optionMenu.addAction(approvAction)
            optionMenu.addAction(declAction)
            optionMenu.addAction(viewAction2)
            optionMenu.addAction(cancelAction2)
            
        } else {
            
            if data.status.caseInsensitiveCompare("saved") == ComparisonResult.orderedSame{
                optionMenu.addAction(editAction)
                optionMenu.addAction(deleteActon)
                optionMenu.addAction(submitAction)
            }
            optionMenu.addAction(viewAction)
            optionMenu.addAction(emailAction)
            optionMenu.addAction(cancelAction)
        }
        
        
        if ((delegate?.responds(to: Selector(("onClick:")))) != nil){
            delegate?.onClick(optionMenu: optionMenu , sender: sender)
        }
        
        
    }
    
}
