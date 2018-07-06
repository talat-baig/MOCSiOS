//
//  TRIAllocationCell.swift
//  mocs
//
//  Created by Admin on 3/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import SwiftyJSON
class TRIAllocationCell: UITableViewCell {
    
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var invoiceNo: UILabel!
    @IBOutlet weak var invoiceType: UILabel!
    @IBOutlet weak var na: UILabel!
    @IBOutlet weak var reason: UILabel!
    @IBOutlet weak var netAmount: UILabel!
    @IBOutlet weak var grossAmount: UILabel!
    @IBOutlet weak var remark: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setDataToView(data:JSON){
        date.text! = data["Invoice Date"].stringValue
        reason.text! = data["Payment Reason"].stringValue
        invoiceNo.text! = data["Invoice No."].stringValue
        invoiceType.text! = data["Invoice Type"].stringValue
        netAmount.text! = data["Net Amount Requested"].stringValue
        na.text! = data["Na"].stringValue
        grossAmount.text! = data["Gross Amount Requested"].stringValue
        remark.text! = data["Remarks"].stringValue
    }
}
