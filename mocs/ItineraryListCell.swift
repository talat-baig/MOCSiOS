//
//  ItineraryListCell.swift
//  mocs
//
//  Created by Talat Baig on 9/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit


protocol onItineraryOptionClickListener: NSObjectProtocol {
    
    func onCancelClick() -> Void
    func onDeleteClick(data : ItineraryListData) -> Void
    func onEditClick(data : ItineraryListData) -> Void
    
}


class ItineraryListCell: UITableViewCell {
    
    
    @IBOutlet weak var vwOuter: UIView!
    
    @IBOutlet weak var lblDest: UILabel!
    
    @IBOutlet weak var lblDepDate: UILabel!
    
    @IBOutlet weak var lblRetDate: UILabel!
    
    @IBOutlet weak var lblItinryDate: UILabel!
    @IBOutlet weak var lblEstDays: UILabel!
    
    weak var itnryMenuDelegate : onMoreClickListener?
    weak var itnryItemMenuDelegate : onItineraryOptionClickListener?
    
    weak var data: ItineraryListData!

    
    @IBOutlet weak var btnMenu: UIButton!
    
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.vwOuter.layer.borderWidth = 1
        self.vwOuter.layer.borderColor = AppColor.universalHeaderColor.cgColor
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setdataToView(data : ItineraryListData) {
        
        lblDest.text = data.dest
        lblDepDate.text = data.depDate
        lblRetDate.text = data.retDate
        lblEstDays.text = data.estDays
        lblItinryDate.text = data.createdDate
//        lblDate.text = data.createdDate
        self.data = data
    }
    
    
    @IBAction func btnMenuTapped(_ sender: UIButton) {
        
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.itnryItemMenuDelegate?.responds(to: Selector(("onEditClick"))) != nil){
                self.itnryItemMenuDelegate?.onEditClick(data: self.data)
            }
        })
        
        optionMenu.addAction(editAction)
        
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.itnryItemMenuDelegate?.responds(to: Selector(("onDeleteClick"))) != nil){
                self.itnryItemMenuDelegate?.onDeleteClick(data: self.data)
            }
        })
        
        optionMenu.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.itnryItemMenuDelegate?.responds(to: Selector(("onCancelClick"))) != nil){
                self.itnryItemMenuDelegate?.onCancelClick()
            }
        })
        optionMenu.addAction(cancelAction)
        
        if ((itnryMenuDelegate?.responds(to: Selector(("onClick:")))) != nil ){
            itnryMenuDelegate?.onClick(optionMenu: optionMenu , sender: sender)
        }
    }
    
}
