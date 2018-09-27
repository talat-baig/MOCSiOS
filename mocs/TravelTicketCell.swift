//
//  TravelTicketCell.swift
//  mocs
//
//  Created by Talat Baig on 9/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit


protocol onTTItemClickListener: NSObjectProtocol {
    
    func onViewClick(data:TravelTicketData) -> Void
    func onEditClick() -> Void
    func onDeleteClick(data:TravelTicketData) -> Void
    func onSubmitClick(data:TravelTicketData) -> Void
    func onEmailClick(data:TravelTicketData) -> Void
}


class TravelTicketCell: UITableViewCell {
    
    @IBOutlet weak var lblRefNum: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var outerVw: UIView!
    
    weak var ttReqClickListnr:onTTItemClickListener?
    weak var data:TravelTicketData!
    weak var delegate:onMoreClickListener?


    override func awakeFromNib() {
        super.awakeFromNib()

        outerVw.layer.shadowOpacity = 0.25
        outerVw.layer.shadowOffset = CGSize(width: 0, height: 2)
        outerVw.layer.shadowRadius = 1
        outerVw.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setDataToView(data: TravelTicketData? ) {
        
      self.data = data
    }
    
    @IBAction func moreClick(_ sender: UIButton) {
        
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.ttReqClickListnr?.responds(to: Selector(("onEditClick:"))) != nil){
                self.ttReqClickListnr?.onEditClick()
            }
        })
        
        let deleteActon = UIAlertAction(title: "Delete", style: .default, handler: { (UIAlertAction)-> Void in
            if (self.ttReqClickListnr?.responds(to: Selector(("onDeleteClick:"))) != nil){
//                self.ttReqClickListnr?.onDeleteClick(data: self.data)
            }
        })
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.ttReqClickListnr?.responds(to: Selector(("onSubmitClick:"))) != nil){
//                self.ttReqClickListnr?.onSubmitClick(data: self.data)
            }
        })
        
        let viewAction = UIAlertAction(title: "View", style: .default, handler: { (alert:UIAlertAction!)-> Void in
            if (self.ttReqClickListnr?.responds(to: Selector(("onViewClick:"))) != nil){
//                self.ttReqClickListnr?.onViewClick(data: self.data)
            }
        })
        
        let emailAction = UIAlertAction(title: "Email", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.ttReqClickListnr?.responds(to: Selector(("onEmailClick:"))) != nil){
//                self.ttReqClickListnr?.onEmailClick(data: self.data)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) -> Void in
        })
        
        
        optionMenu.addAction(editAction)
        optionMenu.addAction(deleteActon)
        optionMenu.addAction(submitAction)
        optionMenu.addAction(viewAction)
        optionMenu.addAction(emailAction)
        optionMenu.addAction(cancelAction)
        
        if ((delegate?.responds(to: Selector(("onClick:")))) != nil){
            delegate?.onClick(optionMenu: optionMenu , sender: sender)
        }
        
        
    }
    
}
