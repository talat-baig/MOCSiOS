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
    func onViewClick(data:ECRClaimData) -> Void
    func onEditClick(data:ECRClaimData) -> Void
    func onDeleteClick(data:ECRClaimData) -> Void
    func onSubmitClick(data:ECRClaimData) -> Void
    func onEmailClick(data:ECRClaimData) -> Void
}



class EmployeeClaimAdapter: UITableViewCell {
    
    @IBOutlet weak var vwOuter: UIView!
    weak var data: ECRClaimData?
    @IBOutlet weak var btnOptionMenu: UIButton!
    weak var optionECRTapDelegate:onOptionECRTapDelegate?
    weak var delegate: onMoreClickListener?
    
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
    
    func setDataToView(data:ECRExpenseListData?){
        //        lblExpDate.text = data.expDate
        //        lblCategory.text = data.expCategory
        //        lblVendor.text = data.expVendor
        //        lblPayment.text = String.init(format: "%@ %@ by %@", data.expCurrency,data.expAmount,data.expPaymentType)
        //        lblComments.text = data.expComments
        //        self.data = data
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
        
        //        if data.headStatus.caseInsensitiveCompare("draft") == ComparisonResult.orderedSame{
        optionMenu.addAction(editAction)
        optionMenu.addAction(deleteActon)
        optionMenu.addAction(submitAction)
        //        }
        optionMenu.addAction(viewAction)
        optionMenu.addAction(emailAction)
        optionMenu.addAction(cancelAction)
        
        if ((delegate?.responds(to: Selector(("onClick:")))) != nil){
            delegate?.onClick(optionMenu: optionMenu , sender: sender)
        }
        
        
    }
    
}
