//
//  APOverallCell.swift
//  mocs
//
//  Created by Talat Baig on 10/23/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class APOverallCell: UITableViewCell {


    @IBOutlet weak var lblBalPayble: UILabel!
    @IBOutlet weak var lblInvoiceAmt: UILabel!
    @IBOutlet weak var lblPaidDate: UILabel!

    
    @IBOutlet weak var stackVwAmtRecvd: UIStackView!
    
    @IBOutlet weak var stckVw1: UIStackView!
    @IBOutlet weak var stckVw2: UIStackView!
    @IBOutlet weak var stckVw3: UIStackView!
    @IBOutlet weak var stckVw4: UIStackView!
    
    
    @IBOutlet weak var lblCurr1: UILabel!
    @IBOutlet weak var lblCurr2: UILabel!
    @IBOutlet weak var lblCurr3: UILabel!
    @IBOutlet weak var lblCurr4: UILabel!
    
    @IBOutlet weak var lblAmt1: UILabel!
    @IBOutlet weak var lblAmt2: UILabel!
    @IBOutlet weak var lblAmt3: UILabel!
    @IBOutlet weak var lblAmt4: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    public func setDataToViews(data : APListData) {
        
        self.lblBalPayble.text = data.balPayable
        self.lblPaidDate.text = data.paidTillDate
        
        if data.totalInvoice.count > 0 {
            
            for i in 0..<data.totalInvoice.count {
                if i == 0 {
                    stckVw1.isHidden = false
                    stckVw2.isHidden = true
                    stckVw3.isHidden = true
                    stckVw4.isHidden = true
                    lblCurr1.text = data.totalInvoice[i].currency
                    lblAmt1.text = data.totalInvoice[i].amount
                }
                if i == 1 {
                    stckVw2.isHidden = false
                    stckVw3.isHidden = true
                    stckVw4.isHidden = true
                    
                    lblCurr2.text =  data.totalInvoice[i].currency
                    lblAmt2.text =  data.totalInvoice[i].amount
                }
                if i == 2 {
                    stckVw3.isHidden = false
                    stckVw4.isHidden = true
                    
                    lblCurr3.text =  data.totalInvoice[i].currency
                    lblAmt3.text =  data.totalInvoice[i].amount
                }
                if i == 3 {
                    stckVw4.isHidden = false
                    lblCurr4.text =  data.totalInvoice[i].currency
                    lblAmt4.text =  data.totalInvoice[i].amount
                }
            }
        } else {
            stckVw1.isHidden = true
            stckVw2.isHidden = true
            stckVw3.isHidden = true
            stckVw4.isHidden = true
        }
    }
    

}


