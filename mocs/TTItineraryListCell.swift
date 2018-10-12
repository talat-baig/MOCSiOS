//
//  TTItineraryListCell.swift
//  mocs
//
//  Created by Talat Baig on 10/9/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit


protocol onTTItineraryOptionClickListener: NSObjectProtocol {
    
    func onCancelClick() -> Void
    func onDeleteClick(data : TTItineraryListData) -> Void
    func onEditClick(data: TTItineraryListData, index : Int) -> Void
    
}

class TTItineraryListCell: UITableViewCell {
    
    
    @IBOutlet weak var vwOuter: UIView!
    
    @IBOutlet weak var lblDepCity: UILabel!
    
    @IBOutlet weak var lblArrvCity: UILabel!

    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblHeaderDate: UILabel!
    @IBOutlet weak var lblDepTime: UILabel!
    
    @IBOutlet weak var lbltrvlStatus: UILabel!
    
    weak var itnryMenuDelegate : onMoreClickListener?
    weak var itnryItemMenuDelegate : onTTItineraryOptionClickListener?
    
    weak var data: TTItineraryListData!
    
    @IBOutlet weak var btnMenu: UIButton!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.vwOuter.layer.borderWidth = 1
        self.vwOuter.layer.borderColor = AppColor.universalHeaderColor.cgColor
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setdataToView(data : TTItineraryListData) {
        
        lblDepCity.text = data.destCity
        lblArrvCity.text = data.arrvlCity
        lblDate.text = data.depDate
        lblDepTime.text = data.depTime
        lbltrvlStatus.text = data.trvlStatus
        lblHeaderDate.text = data.depDate
        self.data = data
    }
    
    
    @IBAction func btnMenuTapped(_ sender: UIButton) {
        
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.itnryItemMenuDelegate?.responds(to: Selector(("onEditClick"))) != nil){
                self.itnryItemMenuDelegate?.onEditClick(data: self.data, index: sender.tag)
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
