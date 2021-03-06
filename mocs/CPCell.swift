//
//  CPCell.swift
//  mocs
//
//  Created by Talat Baig on 8/27/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

protocol onCPListMoreListener: NSObjectProtocol {
    func onClick(optionMenu:UIViewController, sender : UIButton ) -> Void
}

protocol onCPListMoreItemListener: NSObjectProtocol {
    
    func onViewClick(data: CPListData) -> Void
    func onMailClick(data: CPListData) -> Void
    func onCancelClick() -> Void
    
}

class CPCell: UITableViewCell {
    
    @IBOutlet weak var vwInner: UIView!
    
    @IBOutlet weak var lblCPName: UILabel!
    
    @IBOutlet weak var lblContactType: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblBranchCity: UILabel!
    @IBOutlet weak var lblPostalCode: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    
    @IBOutlet weak var lblCustomerId: UILabel!
    
    @IBOutlet weak var btnMore: UIButton!
    //    weak var delegate:onButtonClickListener?
    weak var cpMenuDelegate : onCPListMoreListener?
    weak var cpOptionItemDelegate : onCPListMoreItemListener?
    
    var data:CPListData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwInner.layer.borderWidth = 1
        self.vwInner.layer.borderColor = AppColor.universalHeaderColor.cgColor
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func setDataToView(data:CPListData){
        
        lblCustomerId.text! = data.custId != "" ? data.custId : "-"
        lblCPName.text! = data.cpName
        
        if data.email == "" {
            lblEmail.text! = "-"
        } else {
            lblEmail.text! = data.email
        }
        
        if data.email == "" {
            lblContactType.text! = "-"
        } else {
            lblContactType.text! = data.contactType
        }
        
        if data.zipPostalCode == "" {
            lblPostalCode.text! = "-"
        } else {
            lblPostalCode.text! = data.zipPostalCode
        }
        
        lblBranchCity.text! = data.branchCity
        lblCountry.text! = data.country
        self.data = data
    }
    
    //    @IBAction func onViewClick(_ sender: Any) {
    //        if(self.delegate?.responds(to: #selector(CPCell.onViewClick(_:))) != nil){
    //            delegate?.onViewClick(data: data!)
    //        }
    //    }
    //
    //    @IBAction func onMailClick(_ sender: Any) {
    //
    //        if(self.delegate?.responds(to: #selector(CPCell.onMailClick(_:))) != nil){
    //            delegate?.onMailClick(data: data!)
    //        }
    //    }
    //
    //    @IBAction func onApproveClick(_ sender: Any) {
    //
    //        if(self.delegate?.responds(to: #selector(CPCell.onApproveClick(_:))) != nil){
    //            delegate?.onApproveClick(data: data!)
    //        }
    //    }
    //
    //    @IBAction func onDeclineClick(_ sender: Any) {
    //
    //        if(self.delegate?.responds(to: #selector(CPCell.onDeclineClick(_:))) != nil){
    //            delegate?.onViewClick(data: data!)
    //        }
    //    }
    
    
    @IBAction func onMoretapped(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let viewAction = UIAlertAction(title: "View", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.cpOptionItemDelegate?.responds(to: Selector(("onViewClick"))) != nil){
                self.cpOptionItemDelegate?.onViewClick(data: self.data!)
            }
        })
        
        optionMenu.addAction(viewAction)
        
        let mailAction = UIAlertAction(title: "Mail", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.cpOptionItemDelegate?.responds(to: Selector(("onMailClick"))) != nil){
                self.cpOptionItemDelegate?.onMailClick(data: self.data!)
            }
        })
        
        
        optionMenu.addAction(mailAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.cpOptionItemDelegate?.responds(to: Selector(("onCancelClick"))) != nil){
                self.cpOptionItemDelegate?.onCancelClick()
            }
        })
        
        optionMenu.addAction(cancelAction)
        
        if ((cpMenuDelegate?.responds(to: Selector(("onClick:")))) != nil ){
            cpMenuDelegate?.onClick(optionMenu: optionMenu , sender: sender as! UIButton)
        }
        
    }
    
    
//
//    @IBAction func onViewTap(_ sender: Any) {
//        if(self.cpMenuDelegate?.responds(to: #selector(ROListCell.onViewTap(_:))) != nil){
//            print("onViewTap")
//            cpMenuDelegate?.onViewClick(data: data!)
//        }
//    }
    
    
//    @IBAction func onMailTap(_ sender: Any) {
//        if(self.cpMenuDelegate?.responds(to: #selector(ROListCell.onMailTap(_:))) != nil){
//            cpMenuDelegate?.onMailClick(data: data!)
//        }
//    }
//
    
    
    
    
    
}
