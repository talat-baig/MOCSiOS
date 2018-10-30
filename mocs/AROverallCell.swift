//
//  AROverallCell.swift
//  mocs
//
//  Created by Admin on 3/20/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class AROverallCell: UITableViewCell {
    
    @IBOutlet weak var lblInvQnty: UILabel!
    
    @IBOutlet weak var lblInvValue: UILabel!
    
    @IBOutlet weak var lblAmtRecievable: UILabel!
    
    @IBOutlet weak var stckVwTotalInvVal: UIStackView!
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
    
    
    public func setDataToViews(data : AROverallData) {
        
        self.lblInvQnty.text = data.totalInvQnty
        
        if data.totalInvValue.count > 0 {
            self.lblInvValue.text = "(" + data.totalInvValue[0].currency.trimmingCharacters(in: .whitespaces) + ") " + data.totalInvValue[0].amount
             lblInvValue.isHidden = false
        } else {
             lblInvValue.isHidden = true
        }
        
        self.lblAmtRecievable.text = data.amtRecievable
        
        if data.totalAmtRecieved.count > 0 {
            
            for i in 0..<data.totalAmtRecieved.count {
                if i == 0 {
                    stckVw1.isHidden = false
                    stckVw2.isHidden = true
                     stckVw3.isHidden = true
                     stckVw4.isHidden = true
                    lblCurr1.text = data.totalAmtRecieved[i].currency
                    lblAmt1.text = data.totalAmtRecieved[i].amount
                }
                if i == 1 {
                    stckVw2.isHidden = false
                    stckVw3.isHidden = true
                    stckVw4.isHidden = true
                    
                    lblCurr2.text =  data.totalAmtRecieved[i].currency
                    lblAmt2.text =  data.totalAmtRecieved[i].amount
                }
                if i == 2 {
                    stckVw3.isHidden = false
                    stckVw4.isHidden = true
                    
                    lblCurr3.text =  data.totalAmtRecieved[i].currency
                    lblAmt3.text =  data.totalAmtRecieved[i].amount
                }
                if i == 3 {
                    stckVw4.isHidden = false
                    lblCurr4.text =  data.totalAmtRecieved[i].currency
                    lblAmt4.text =  data.totalAmtRecieved[i].amount
                }
            }
        }
    }
    
    
    
}
