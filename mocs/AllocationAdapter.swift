//
//  AllocationAdapter.swift
//  mocs
//
//  Created by Admin on 3/12/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import SwiftyJSON

class AllocationAdapter: UITableViewCell {

    /// Label Date
    @IBOutlet weak var lblDate: UILabel!
    
    /// Label Invoice
    @IBOutlet weak var lblinvoice: UILabel!
    
    /// Label Reason
    @IBOutlet weak var lblReason: UILabel!
    
    /// Label Amount
    @IBOutlet weak var lblAmount: UILabel!
    
    /// Label Remark
    @IBOutlet weak var lblRemark: UILabel!

    /// Label Partaining month
    @IBOutlet weak var lblPartainingMonth: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setDataToView(data:JSON){
        lblDate.text! = data["APR Allocation Date"].stringValue
        lblReason.text! = data["A/C Charge Head"].stringValue
        lblinvoice.text! = data["Invoice No."].stringValue
        lblAmount.text! = data["Amount Requested"].stringValue
        lblRemark.text! = data["Remarks"].stringValue
        lblPartainingMonth.text! = data["Pertaining Month"].stringValue
    }

}
