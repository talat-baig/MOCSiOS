//
//  TravelTicketCell.swift
//  mocs
//
//  Created by Talat Baig on 9/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit


protocol onTTItemClickListener: NSObjectProtocol {
    
    func onViewClick(data : TravelTicketData) -> Void
    func onEditClick(data : TravelTicketData) -> Void
    func onDeleteClick(data:TravelTicketData) -> Void
    func onEmailClick(data:TravelTicketData) -> Void
}


class TravelTicketCell: UITableViewCell {
    
    @IBOutlet weak var lblRefNum: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var outerVw: UIView!
    
    @IBOutlet weak var lblTrvlrName: UILabel!
    @IBOutlet weak var lblDept: UILabel!
    @IBOutlet weak var lblCompName: UILabel!
    @IBOutlet weak var lblGuest: UILabel!
    @IBOutlet weak var lblTrvlType: UILabel!
    @IBOutlet weak var lblPurpose: UILabel!
    @IBOutlet weak var lblMode: UILabel!
    @IBOutlet weak var lblTicktCost: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    weak var ttReqClickListnr:onTTItemClickListener?
    weak var data:TravelTicketData!
    weak var delegate:onMoreClickListener?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outerVw.layer.shadowOpacity = 0.25
        outerVw.layer.shadowOffset = CGSize(width: 2, height: 2)
        outerVw.layer.shadowRadius = 1
        outerVw.layer.shadowColor = UIColor.black.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataToView(data: TravelTicketData ) {
        
        lblRefNum.text = data.trvlrRefNum
        lblTrvlrName.text = data.trvlrName
        
        if data.trvlrDept == "" {
            lblDept.text! = "-"
        } else {
            lblDept.text! = data.trvlrDept
        }
        
        lblCompName.text = data.tCompName
        
        if data.guest == 0 {
            lblGuest.text = "Guest"
        } else {
            lblGuest.text = "Employee"
        }
        
        lblTrvlType.text = data.trvlrType
        lblPurpose.text = data.trvlrPurpose
        lblMode.text = data.trvlrMode
        lblTicktCost.text = data.ticktCost + " " + data.tCurrency
        lblStatus.text = data.status
        self.data = data

    }
    
    @IBAction func moreClick(_ sender: UIButton) {
        
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.ttReqClickListnr?.responds(to: Selector(("onEditClick:"))) != nil){
                self.ttReqClickListnr?.onEditClick(data: self.data)
            }
        })
        
        let deleteActon = UIAlertAction(title: "Delete", style: .default, handler: { (UIAlertAction)-> Void in
            if (self.ttReqClickListnr?.responds(to: Selector(("onDeleteClick:"))) != nil){
                  self.ttReqClickListnr?.onDeleteClick(data: self.data)
            }
        })
   
        
        let viewAction = UIAlertAction(title: "View", style: .default, handler: { (alert:UIAlertAction!)-> Void in
            if (self.ttReqClickListnr?.responds(to: Selector(("onViewClick:"))) != nil){
                self.ttReqClickListnr?.onViewClick(data: self.data)
            }
        })
        
        let emailAction = UIAlertAction(title: "Email", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.ttReqClickListnr?.responds(to: Selector(("onEmailClick:"))) != nil){
                self.ttReqClickListnr?.onEmailClick(data: self.data)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) -> Void in
        })
        
        
//        optionMenu.addAction(editAction)
//        optionMenu.addAction(deleteActon)
//        optionMenu.addAction(viewAction)
//        optionMenu.addAction(emailAction)
//        optionMenu.addAction(cancelAction)
        
        
        if (data.status.caseInsensitiveCompare("Cancelled") == ComparisonResult.orderedSame){

        } else {
            optionMenu.addAction(editAction)
            optionMenu.addAction(deleteActon)
        }
        
        optionMenu.addAction(viewAction)
        optionMenu.addAction(emailAction)
        optionMenu.addAction(cancelAction)

        
        if ((delegate?.responds(to: Selector(("onClick:")))) != nil){
            delegate?.onClick(optionMenu: optionMenu , sender: sender)
        }
        
        
    }
    
}
