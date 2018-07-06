//
//  ExpenseListAdapter.swift
//  mocs
//
//  Created by Talat Baig on 3/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Toast_Swift


protocol onExpOptionItemClickListener: NSObjectProtocol {
    
    func onEditClick(data:ExpenseListData) -> Void
    func onDeleteClick(data:ExpenseListData) -> Void
}

class ExpenseListAdapter: UITableViewCell {
    
    weak var data: ExpenseListData!
    weak var delegate: onMoreClickListener?
    
    @IBOutlet weak var nwOuter: UIView!
    weak var expOptionClickListener: onExpOptionItemClickListener?

    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var lblExpDate: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblVendor: UILabel!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblComments: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nwOuter.layer.shadowOpacity = 0.25
        nwOuter.layer.shadowOffset = CGSize(width: 0, height: 2)
        nwOuter.layer.shadowRadius = 1
        nwOuter.layer.shadowColor = UIColor.black.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataToView(data:ExpenseListData){
        lblExpDate.text = data.expDate
        lblCategory.text = data.expCategory
        lblVendor.text = data.expVendor
        lblPayment.text = String.init(format: "%@ %@ by %@", data.expCurrency,data.expAmount,data.expPaymentType)
        lblComments.text = data.expComments
        self.data = data
    }
    
    @IBAction func moreClick(_ sender: UIButton) {
        if (delegate?.responds(to: Selector(("onClick:"))) != nil){
            
            let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
            let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (alert:UIAlertAction!)-> Void in
                if (self.expOptionClickListener?.responds(to: Selector(("onEditClick:"))) != nil){
                    self.expOptionClickListener?.onEditClick(data: self.data)
                }
            })
            let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { (UIAlertAction) -> Void in
                if (self.expOptionClickListener?.responds(to: Selector(("onDeleteClick:"))) != nil){
                    self.expOptionClickListener?.onDeleteClick(data: self.data)
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
