//
//  TravelRequestAdapter.swift
//  mocs
//
//  Created by Talat Baig on 9/12/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit


protocol onTReqItemClickListener: NSObjectProtocol {
    func onViewClick(data:TravelRequestData) -> Void
    func onEditClick(data:TravelRequestData) -> Void
    func onDeleteClick(data:TravelRequestData) -> Void
    func onSubmitClick(data:TravelRequestData) -> Void
    func onEmailClick(data:TravelRequestData) -> Void
}


class TravelRequestAdapter: UITableViewCell {


    @IBOutlet weak var lblRefNo: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var outerVw: UIView!
    
    weak var delegate:onMoreClickListener?
    
    weak var data:TravelRequestData!

    weak var trvlReqItemClickListener:onTReqItemClickListener?

    
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
    
    func setDataToView(data: TravelRequestData?) {

        self.data = data
    }
 
    
    @IBAction func moreClick(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.trvlReqItemClickListener?.responds(to: Selector(("onEditClick:"))) != nil){
//                self.trvlReqItemClickListener?.onEditClick(data: self.data)
            }
        })
        
        let deleteActon = UIAlertAction(title: "Delete", style: .default, handler: { (UIAlertAction)-> Void in
            if (self.trvlReqItemClickListener?.responds(to: Selector(("onDeleteClick:"))) != nil){
                self.trvlReqItemClickListener?.onDeleteClick(data: self.data)
            }
        })
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.trvlReqItemClickListener?.responds(to: Selector(("onSubmitClick:"))) != nil){
                self.trvlReqItemClickListener?.onSubmitClick(data: self.data)
            }
        })
        
        let viewAction = UIAlertAction(title: "View", style: .default, handler: { (alert:UIAlertAction!)-> Void in
            if (self.trvlReqItemClickListener?.responds(to: Selector(("onViewClick:"))) != nil){
                self.trvlReqItemClickListener?.onViewClick(data: self.data)
            }
        })
        
        let emailAction = UIAlertAction(title: "Email", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.trvlReqItemClickListener?.responds(to: Selector(("onEmailClick:"))) != nil){
                self.trvlReqItemClickListener?.onEmailClick(data: self.data)
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
