//
//  ECRExpenseCell.swift
//  mocs
//
//  Created by Talat Baig on 6/13/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

protocol onEcrExpOptionMenuTap: NSObjectProtocol {
    
    func onEditClick() -> Void
    func onDeleteClick(data:ECRExpenseListData) -> Void
}

class ECRExpenseListAdapter: UITableViewCell {
    
    weak var data: ECRExpenseListData?
    @IBOutlet weak var vwOuter: UIView!
    
    @IBOutlet weak var btnMenu: UIButton!
    weak var delegate: onMoreClickListener?
    weak var ecrExpMenuTapDelegate: onEcrExpOptionMenuTap?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vwOuter.layer.shadowOpacity = 0.25
        vwOuter.layer.shadowOffset = CGSize(width: 0, height: 2)
        vwOuter.layer.shadowRadius = 1
        vwOuter.layer.shadowColor = UIColor.black.cgColor
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
        if (delegate?.responds(to: Selector(("onClick:"))) != nil){
            
            let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
            let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (alert:UIAlertAction!)-> Void in
                if (self.ecrExpMenuTapDelegate?.responds(to: Selector(("onEditClick:"))) != nil){
                 
                    
                    self.ecrExpMenuTapDelegate?.onEditClick()
                }
            })
            let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { (UIAlertAction) -> Void in
                if (self.ecrExpMenuTapDelegate?.responds(to: Selector(("onDeleteClick:"))) != nil){
//                    self.ecrExpMenuTapDelegate?.onDeleteClick(data: self.data!)
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) -> Void in
                
            })
            
            optionMenu.addAction(editAction)
            optionMenu.addAction(deleteAction)
            optionMenu.addAction(cancelAction)
            
            delegate!.onClick(optionMenu: optionMenu, sender : sender)
        }
    }
    
    
}
