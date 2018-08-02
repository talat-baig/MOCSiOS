//
//  ROListCell.swift
//  mocs
//
//  Created by Talat Baig on 7/6/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit


//protocol onROListMoreListener: NSObjectProtocol {
//    func onClick(optionMenu:UIViewController, sender : UIButton ) -> Void
//}
//
//protocol onROListMoreItemListener: NSObjectProtocol {
//    func onViewClick() -> Void
//    func onMailClick() -> Void
//    func onCancelClick() -> Void
//    func onApproveClick() -> Void
//}

class ROListCell: UITableViewCell {
    
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblBusinessUnit: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCommodity: UILabel!
    @IBOutlet weak var lblReleaseFor: UILabel!
    @IBOutlet weak var lblStorageLoc: UILabel!
    @IBOutlet weak var vwInner: UIView!
    var data:PurchaseContractData?
    weak var delegate:onButtonClickListener?
    
    
//    weak var roMenuDelegate : onROListMoreListener?
//    weak var roOptionItemDelegate : onROListMoreItemListener?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwInner.layer.borderWidth = 1
        self.vwInner.layer.borderColor = AppColor.universalHeaderColor.cgColor
    }
    
    func setDataToView(data:PurchaseContractData?){
   
        self.data = data
    }
    
    
    @IBAction func onMoretapped(_ sender: Any) {
        
//        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
//
//        let viewAction = UIAlertAction(title: "View", style: .default, handler: { (UIAlertAction) -> Void in
//            if (self.roOptionItemDelegate?.responds(to: Selector(("onViewClick"))) != nil){
//                self.roOptionItemDelegate?.onViewClick()
//            }
//        })
//
//        optionMenu.addAction(viewAction)
//
//        let mailAction = UIAlertAction(title: "Mail", style: .default, handler: { (UIAlertAction) -> Void in
//            if (self.roOptionItemDelegate?.responds(to: Selector(("onMailClick"))) != nil){
//                self.roOptionItemDelegate?.onMailClick()
//            }
//        })
//
//
//        optionMenu.addAction(mailAction)
//
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) -> Void in
//            if (self.roOptionItemDelegate?.responds(to: Selector(("onCancelClick"))) != nil){
//                self.roOptionItemDelegate?.onCancelClick()
//            }
//        })
//
//
//        optionMenu.addAction(cancelAction)
//
//        if ((roMenuDelegate?.responds(to: Selector(("onClick:")))) != nil ){
//            roMenuDelegate?.onClick(optionMenu: optionMenu , sender: sender as! UIButton)
//        }
//
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func onViewTap(_ sender: Any) {
        if(self.delegate?.responds(to: #selector(ROListCell.onViewTap(_:))) != nil){
            print("onViewTap")
            delegate?.onViewClick(data: data!)
        }
    }
    
    
    @IBAction func onMailTap(_ sender: Any) {
        if(self.delegate?.responds(to: #selector(ROListCell.onMailTap(_:))) != nil){
            //            delegate?.onMailClick(data: data!)
        }
    }
    
    
    @IBAction func onDeclineTap(_ sender: Any) {
        if(self.delegate?.responds(to: #selector(ROListCell.onDeclineTap(_:))) != nil){
            //            delegate?.onDeclineClick(data: data!)
        }
    }
    
    
    @IBAction func onApproveTap(_ sender: Any) {
        if(self.delegate?.responds(to: #selector(ROListCell.onApproveTap(_:))) != nil){
            //            delegate?.onApproveClick(data: data!)
        }
    }
    
    
}
