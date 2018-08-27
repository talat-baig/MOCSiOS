//
//  EmployeeClaimAdapter.swift
//  mocs
//
//  Created by Talat Baig on 6/12/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Toast_Swift

protocol onOptionECRTapDelegate: NSObjectProtocol {
    func onViewClick(data:EmployeeClaimData) -> Void
    func onEditClick(data:EmployeeClaimData) -> Void
    func onDeleteClick(data:EmployeeClaimData) -> Void
    func onSubmitClick(data:EmployeeClaimData) -> Void
    func onEmailClick(data:EmployeeClaimData) -> Void
}



class EmployeeClaimAdapter: UITableViewCell {
    
    @IBOutlet weak var vwOuter: UIView!
    @IBOutlet weak var btnOptionMenu: UIButton!
    weak var optionECRTapDelegate:onOptionECRTapDelegate?
    weak var delegate: onMoreClickListener?
    
    
    weak var data:EmployeeClaimData!
    
    
    @IBOutlet weak var lblRefId: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    
    @IBOutlet weak var lblReqDate: UILabel!
    @IBOutlet weak var lblEmpDept: UILabel!
    
    
    @IBOutlet weak var lblReqAmnt: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    
    
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var lblPaidAmt: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vwOuter.layer.shadowOpacity = 0.25
        vwOuter.layer.shadowOffset = CGSize(width: 0, height: 2)
        vwOuter.layer.shadowRadius = 1
        vwOuter.layer.shadowColor = UIColor.black.cgColor
        //
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setDataToView(data:EmployeeClaimData){
        
        
        lblRefId.text = data.headRef
        lblStatus.text = "(" + data.headStatus + ")"
        
        lblCompany.text = data.companyName
        lblEmpDept.text = data.employeeDepartment
        lblLocation.text = data.location
        lblReqAmnt.text = data.reqAmount
        lblCurrency.text = data.currency
        lblBalance.text = data.balance
        lblPaidAmt.text = data.paidAmount
        
        lblReqDate.text = data.requestedDate
        self.data = data
        
    }
    
    
    @IBAction func moreClick(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.optionECRTapDelegate?.responds(to: Selector(("onEditClick:"))) != nil){
                self.optionECRTapDelegate?.onEditClick(data:self.data!)
            }
        })
        
        let deleteActon = UIAlertAction(title: "Delete", style: .default, handler: { (UIAlertAction)-> Void in
            if (self.optionECRTapDelegate?.responds(to: Selector(("onDeleteClick:"))) != nil){
                self.optionECRTapDelegate?.onDeleteClick(data: self.data!)
            }
        })
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.optionECRTapDelegate?.responds(to: Selector(("onSubmitClick:"))) != nil){
                self.optionECRTapDelegate?.onSubmitClick(data: self.data!)
            }
        })
        
        let viewAction = UIAlertAction(title: "View", style: .default, handler: { (alert:UIAlertAction!)-> Void in
            if (self.optionECRTapDelegate?.responds(to: Selector(("onViewClick:"))) != nil){
                self.optionECRTapDelegate?.onViewClick(data: self.data!)
            }
        })
        
        let emailAction = UIAlertAction(title: "Email", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.optionECRTapDelegate?.responds(to: Selector(("onEmailClick:"))) != nil){
                self.optionECRTapDelegate?.onEmailClick(data: self.data!)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) -> Void in
            
        })
        
        if data.headStatus.caseInsensitiveCompare("draft") == ComparisonResult.orderedSame{
            optionMenu.addAction(editAction)
            optionMenu.addAction(deleteActon)
            optionMenu.addAction(submitAction)
        }
        optionMenu.addAction(viewAction)
        optionMenu.addAction(emailAction)
        optionMenu.addAction(cancelAction)
        
        if ((delegate?.responds(to: Selector(("onClick:")))) != nil){
            delegate?.onClick(optionMenu: optionMenu , sender: sender)
        }
        
        
    }
    
}
