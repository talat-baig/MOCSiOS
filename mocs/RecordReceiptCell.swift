//
//  RecordReceiptCell.swift
//  mocs
//
//  Created by Talat Baig on 7/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit


protocol onRRcptMoreClickListener: NSObjectProtocol {
    func onClick(optionMenu:UIViewController, sender : UIButton ) -> Void
}

protocol onRRcptItemClickListener: NSObjectProtocol {
    func onCancelClick() -> Void
    func onReceiveClick() -> Void
}


class RecordReceiptCell: UITableViewCell {
    
    @IBOutlet weak var vwOuter: UIView!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var btnMore: UIButton!
    
    weak var rrMenuDelegate : onRRcptMoreClickListener?
    weak var rrOptionClickDelegate : onRRcptItemClickListener?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vwOuter.layer.borderColor = AppColor.universalHeaderColor.cgColor
        vwOuter.layer.borderWidth = 1.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func moreClick(_ sender: UIButton) {
        
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let receiveAction = UIAlertAction(title: "Receive", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.rrOptionClickDelegate?.responds(to: Selector(("onReceiveClick"))) != nil) {
                self.rrOptionClickDelegate?.onReceiveClick()
            }
        })
        
        if sender.tag == 1 {
            optionMenu.addAction(receiveAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) -> Void in
            if (self.rrOptionClickDelegate?.responds(to: Selector(("onCancelClick"))) != nil){
                self.rrOptionClickDelegate?.onCancelClick()
            }
        })

        optionMenu.addAction(cancelAction)

        if ((rrMenuDelegate?.responds(to: Selector(("onClick:")))) != nil ){
            rrMenuDelegate?.onClick(optionMenu: optionMenu , sender: sender)
        }
        
        
    }
    
    
}
