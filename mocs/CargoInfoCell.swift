//
//  CargoInfoCell.swift
//  mocs
//
//  Created by Talat Baig on 7/17/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

protocol onCargoMoreClickListener: NSObjectProtocol {
    func onClick(optionMenu:UIViewController, sender : UIButton ) -> Void
}

protocol onCargoOptionIemClickListener: NSObjectProtocol {
    func onViewClick() -> Void
    func onCancelClick() -> Void
    func onApproveClick() -> Void
}

class CargoInfoCell: UITableViewCell {
    
    @IBOutlet weak var vwOuter: UIView!
    
    @IBOutlet weak var lblWHRNum: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    weak var menuDelegate : onCargoMoreClickListener?
    weak var optionMenuDelegate : onCargoOptionIemClickListener?
    
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vwOuter.layer.shadowOpacity = 0.25
        vwOuter.layer.shadowOffset = CGSize(width: 0, height: 2)
        vwOuter.layer.shadowRadius = 1
        vwOuter.layer.shadowColor = UIColor.black.cgColor
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func moreClick(_ sender: UIButton) {
        
//        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
//
//        let viewAction = UIAlertAction(title: "View", style: .default, handler: { (UIAlertAction) -> Void in
//            if (self.optionMenuDelegate?.responds(to: Selector(("onViewClick"))) != nil){
//                self.optionMenuDelegate?.onViewClick()
//            }
//        })
//
//        optionMenu.addAction(viewAction)
        
        
//        let approveAction = UIAlertAction(title: "Approve", style: .default, handler: { (UIAlertAction) -> Void in
//            if (self.optionMenuDelegate?.responds(to: Selector(("onApproveClick"))) != nil){
//                self.optionMenuDelegate?.onViewClick()
//            }
//        })
        
//        if sender.tag == 1 {
//            optionMenu.addAction(approveAction)
//        }
//
        
//        if ((menuDelegate?.responds(to: Selector(("onClick:")))) != nil ){
//            menuDelegate?.onClick(optionMenu: optionMenu , sender: sender)
//        }
//        
//        
        
        
    }
    
}
