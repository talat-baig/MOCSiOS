//
//  SendEmailHeaderView.swift
//  mocs
//
//  Created by Talat Baig on 4/5/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

protocol emailFromHeaderDelegate {
    func onSendHeaderVwTap(indexPath : [IndexPath]) -> Void
    func onCanceHeaderVwTap() -> Void
}

/// Send Email Header
class SendEmailHeaderView: UIView {

    /// Label for title text
    @IBOutlet weak var lblTitle: UILabel!
    
    /// Button Cancel
    @IBOutlet weak var btnCancel: UIButton!
   
    /// Button Send
    @IBOutlet weak var btnSend: UIButton!
    
    /// Delegate object
    var sendEmailDelegate: emailFromHeaderDelegate?
    
    /// Array of IndexPaths
    var selIndexPath : [IndexPath]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
    }
    
    /// Get array of index path and assign to
    func getIndexPath( indexPath : [IndexPath]){
        self.selIndexPath = indexPath
    }
    
    /// Tap action event for Cancel button
    @IBAction func cancelTapped(_ sender: Any) {
        if let d = sendEmailDelegate {
            d.onCanceHeaderVwTap()
        }
    }
    
    /// Tap action event for Send button
    @IBAction func sendTapped(_ sender: Any) {
      
        if let d = sendEmailDelegate {
            guard let indPath = self.selIndexPath else {
                Helper.showMessage(message: "Something went wrong")
                return
            }
            d.onSendHeaderVwTap(indexPath: indPath)
        }
    }
    
}
