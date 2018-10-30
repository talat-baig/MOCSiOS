//
//  APCounterpartyCell.swift
//  mocs
//
//  Created by Talat Baig on 10/23/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class APCounterpartyCell: UITableViewCell {

    
    /// Label CounterParty Name
    @IBOutlet weak var lblbalPayable: UILabel!
    
    /// LAbel Invoice Quantity
    @IBOutlet weak var lblPaidTillDate: UILabel!
    
    @IBOutlet weak var lblCPName: UILabel!
    
    /// View Inner
    @IBOutlet weak var vwInner: UIView!
    
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
        vwInner.layer.shadowOpacity = 0.25
        vwInner.layer.shadowOffset = CGSize(width: 0, height: 2)
        vwInner.layer.shadowRadius = 1
        vwInner.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setDataToView(data: APCounterPartyData){
        
        self.lblbalPayable.text = data.balPayable
        self.lblPaidTillDate.text = data.paidTillDate
     
        let dataCount = data.totalInvValue.count
        
        if dataCount > 0 {
            switch dataCount {
                
            case 1:
                stckVw1.isHidden = false
                stckVw2.isHidden = true
                stckVw3.isHidden = true
                stckVw4.isHidden = true
                
                for i in 0..<dataCount {
                    lblCurr1.text = data.totalInvValue[i].currency
                    lblAmt1.text = data.totalInvValue[i].amount
                }
                break
                
            case 2:
                stckVw1.isHidden = false
                stckVw2.isHidden = false
                stckVw3.isHidden = true
                stckVw4.isHidden = true
                for i in 0..<dataCount {
                    if i == 0 {
                        lblCurr1.text = data.totalInvValue[i].currency
                        lblAmt1.text = data.totalInvValue[i].amount
                    }
                    if i == 1 {
                        lblCurr2.text =  data.totalInvValue[i].currency
                        lblAmt2.text =  data.totalInvValue[i].amount
                    }
                }
                
                break
                
            case 3:
                stckVw1.isHidden = false
                stckVw2.isHidden = false
                stckVw3.isHidden = false
                stckVw4.isHidden = true
                
                for i in 0..<dataCount {
                    if i == 0 {
                        lblCurr1.text = data.totalInvValue[i].currency
                        lblAmt1.text = data.totalInvValue[i].amount
                    }
                    if i == 1 {
                        lblCurr2.text =  data.totalInvValue[i].currency
                        lblAmt2.text =  data.totalInvValue[i].amount
                    }
                    if i == 3 {
                        lblCurr3.text =  data.totalInvValue[i].currency
                        lblAmt3.text =  data.totalInvValue[i].amount
                    }
                }
                
                break
                
            case 4:
                stckVw1.isHidden = false
                stckVw2.isHidden = false
                stckVw3.isHidden = false
                stckVw4.isHidden = false
                
                for i in 0..<dataCount {
                    if i == 0 {
                        lblCurr1.text = data.totalInvValue[i].currency
                        lblAmt1.text = data.totalInvValue[i].amount
                    }
                    if i == 1 {
                        lblCurr2.text =  data.totalInvValue[i].currency
                        lblAmt2.text =  data.totalInvValue[i].amount
                    }
                    if i == 3 {
                        lblCurr3.text =  data.totalInvValue[i].currency
                        lblAmt3.text =  data.totalInvValue[i].amount
                    }
                    if i == 4 {
                        lblCurr4.text =  data.totalInvValue[i].currency
                        lblAmt4.text =  data.totalInvValue[i].amount
                    }
                }
                break
            default:
                break
            }
        } else {
            stckVw1.isHidden = true
            stckVw2.isHidden = true
            stckVw3.isHidden = true
            stckVw4.isHidden = true
        }
    }
    
}
