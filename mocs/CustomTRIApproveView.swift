//
//  CustomTRIApproveView.swift
//  mocs
//
//  Created by Talat Baig on 4/20/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

protocol approveTRIDelegate {
     func approve( refId : String)
}

/// Custom TRI Approval Pop-up
class CustomTRIApproveView: UIView {
    
    /// Button Check
    @IBOutlet weak var btnCheck: UIButton!
    
    /// Button Approve
    @IBOutlet weak var btnApprove: UIButton!
    
    /// Bool Flag
    var isChecked = false
    
    /// Ref Id String
    var refId : String?
    
    /// delegate object
    var approveDelegate: approveTRIDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnApprove.isEnabled = false
        self.backgroundColor = AppColor.univPopUpBckgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
//        debugPrint("Remove NotificationCenter Deinit")
    }
    
    
    func passRefNumToView(refStr : String) {
        self.refId = refStr
    }
    
    @IBAction func btnCheckTapped(_ sender: Any) {
        
        if isChecked {
            isChecked = false
            btnCheck.setImage(#imageLiteral(resourceName: "unchecked_black"), for: .normal)
            btnApprove.isEnabled = false
        } else {
            isChecked = true
            btnCheck.setImage(#imageLiteral(resourceName: "checked_black"), for: .normal)
            btnApprove.isEnabled = true
        }
    }
    
    ///
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.removeFromSuperviewWithAnimate()
    }
    
    /// Action method for Approve button
    @IBAction func btnApproveTapped(_ sender: Any) {
      
        guard let refIdStr = refId else {
            return
        }
        
        if let d = approveDelegate {
            d.approve(refId: refIdStr)
            self.removeFromSuperview()
        }
        
    }
    
}
