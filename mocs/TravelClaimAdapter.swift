//
//  TravelClaimAdapter.swift
//  mocs
//
//  Created by Rv on 28/01/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Toast_Swift

protocol onMoreClickListener: NSObjectProtocol {
    func onClick(optionMenu:UIViewController, sender : UIButton ) -> Void
}

protocol onOptionIemClickListener: NSObjectProtocol {
    func onViewClick(data:TravelClaimData) -> Void
    func onEditClick(data:TravelClaimData) -> Void
    func onDeleteClick(data:TravelClaimData) -> Void
    func onSubmitClick(data:TravelClaimData) -> Void
    func onEmailClick(data:TravelClaimData) -> Void
}


class TravelClaimAdapter: UITableViewCell {

    @IBOutlet weak var headRefID: UILabel!
    @IBOutlet weak var headStatus: UILabel!
    
    @IBOutlet weak var vwOuter: UIView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var empDepartment: UILabel!
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var toDate: UILabel!
    @IBOutlet weak var claimRaisedOn: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    
    @IBOutlet weak var btnMenu: UIButton!
    
    weak var delegate:onMoreClickListener?
    weak var optionClickListener:onOptionIemClickListener?
    
    weak var data:TravelClaimData!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vwOuter.layer.shadowOpacity = 0.25
        vwOuter.layer.shadowOffset = CGSize(width: 0, height: 2)
        vwOuter.layer.shadowRadius = 1
        vwOuter.layer.shadowColor = UIColor.black.cgColor
    }
    
    func setDataToView(data:TravelClaimData){
        headRefID.text = data.headRef
        headStatus.text = "(" + data.headStatus + ")"
        companyName.text = data.companyName
        empDepartment.text = data.employeeDepartment
        let date = data.periodOfTravel.components(separatedBy: "-")
        fromDate.text = date[0]
        toDate.text = date[1]
        claimRaisedOn.text = data.claimRaisedOn
        totalAmount.text = data.totalAmount
        self.data = data
    }
    
    @IBAction func moreClick(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: data.headRef, preferredStyle: .actionSheet)
       
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.optionClickListener?.responds(to: Selector(("onEditClick:"))) != nil){
                self.optionClickListener?.onEditClick(data: self.data)
            }
        })

        let deleteActon = UIAlertAction(title: "Delete", style: .default, handler: { (UIAlertAction)-> Void in
            if (self.optionClickListener?.responds(to: Selector(("onDeleteClick:"))) != nil){
                self.optionClickListener?.onDeleteClick(data: self.data)
            }
        })

        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.optionClickListener?.responds(to: Selector(("onSubmitClick:"))) != nil){
                self.optionClickListener?.onSubmitClick(data: self.data)
            }
        })
        
        let viewAction = UIAlertAction(title: "View", style: .default, handler: { (alert:UIAlertAction!)-> Void in
            if (self.optionClickListener?.responds(to: Selector(("onViewClick:"))) != nil){
                self.optionClickListener?.onViewClick(data: self.data)
            }
        })
       
        let emailAction = UIAlertAction(title: "Email", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.optionClickListener?.responds(to: Selector(("onEmailClick:"))) != nil){
                self.optionClickListener?.onEmailClick(data: self.data)
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
