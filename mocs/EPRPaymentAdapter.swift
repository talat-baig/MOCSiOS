//
//  EPRPaymentAdapter.swift
//  mocs
//
//  Created by Admin on 3/8/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class EPRPaymentAdapter: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var paymentReason: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var invoiceNo: UILabel!
    @IBOutlet weak var remark: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataToView(data:EPRPaymentData){
        date.text! = data.itemDate
        paymentReason.text! = data.reason
        amount.text! = data.amount
        invoiceNo.text! = data.invoice
        remark.text! = data.remark
    }

}
