//
//  ARCounterPartyCell.swift
//  mocs
//
//  Created by Talat Baig on 4/4/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class ARCounterPartyCell: UITableViewCell {
    
    /// Label CounterParty Name
    @IBOutlet weak var lblCPName: UILabel!
    
    /// LAbel Invoice Quantity
    @IBOutlet weak var lblInvQnty: UILabel!
    
    /// Label Invoice Value
    @IBOutlet weak var lblInvValue: UILabel!
    
    /// Label Amount Recievable
    @IBOutlet weak var lblAmtRecievable: UILabel!
    
    /// View Inner
    @IBOutlet weak var vwInner: UIView!
    
    /// Stack View 1
    @IBOutlet weak var stckVw1: UIStackView!
    
    /// Stack View 2
    @IBOutlet weak var stckVw2: UIStackView!
    
    /// Stack View 3
    @IBOutlet weak var stckVw3: UIStackView!
    
    /// Stack View 4
    @IBOutlet weak var stckVw4: UIStackView!
    
    /// Label Currency 1
    @IBOutlet weak var lblCurr1: UILabel!
    
    /// Label Currency 2
    @IBOutlet weak var lblCurr2: UILabel!
    
    /// Label Currency 3
    @IBOutlet weak var lblCurr3: UILabel!
    
    /// Label Currency 4
    @IBOutlet weak var lblCurr4: UILabel!
    
    /// Label Amount 1
    @IBOutlet weak var lblAmt1: UILabel!
    
    /// Label Amount 2
    @IBOutlet weak var lblAmt2: UILabel!
    
    /// Label Amount 3
    @IBOutlet weak var lblAmt3: UILabel!
    
    /// Label Amount 4
    @IBOutlet weak var lblAmt4: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vwInner.layer.shadowOpacity = 0.25
        vwInner.layer.shadowOffset = CGSize(width: 0, height: 2)
        vwInner.layer.shadowRadius = 1
        vwInner.layer.shadowColor = UIColor.black.cgColor
    }
    

    /// Set data to UI elements. Also, shows/hides stack views according to data
    /// - Parameter data: data of type ARCounterPartyData
    public func setDataToView(data: ARCounterPartyData){
        
        self.lblCPName.text = data.cpName
        self.lblInvQnty.text = data.totalInvQnty
        self.lblAmtRecievable.text = data.amtRecievable
        
        if data.totalInvValue.count > 0 {
            self.lblInvValue.text = "(" + data.totalInvValue[0].currency.trimmingCharacters(in: .whitespaces) + ") " + data.totalInvValue[0].amount
            self.lblInvValue.isHidden = false
        } else {
            self.lblInvValue.isHidden = true
        }
        
        
        let dataCount = data.totalAmtRecieved.count
        
        if dataCount > 0 {
            switch dataCount {
                
            case 1:
                stckVw1.isHidden = false
                stckVw2.isHidden = true
                stckVw3.isHidden = true
                stckVw4.isHidden = true

                for i in 0..<dataCount {
                    lblCurr1.text = data.totalAmtRecieved[i].currency
                    lblAmt1.text = data.totalAmtRecieved[i].amount
                }
                break
                
            case 2:
                stckVw1.isHidden = false
                stckVw2.isHidden = false
                stckVw3.isHidden = true
                stckVw4.isHidden = true
                for i in 0..<dataCount {
                    if i == 0 {
                        lblCurr1.text = data.totalAmtRecieved[i].currency
                        lblAmt1.text = data.totalAmtRecieved[i].amount
                    }
                    if i == 1 {
                        lblCurr2.text =  data.totalAmtRecieved[i].currency
                        lblAmt2.text =  data.totalAmtRecieved[i].amount
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
                        lblCurr1.text = data.totalAmtRecieved[i].currency
                        lblAmt1.text = data.totalAmtRecieved[i].amount
                    }
                    if i == 1 {
                        lblCurr2.text =  data.totalAmtRecieved[i].currency
                        lblAmt2.text =  data.totalAmtRecieved[i].amount
                    }
                    if i == 3 {
                        lblCurr3.text =  data.totalAmtRecieved[i].currency
                        lblAmt3.text =  data.totalAmtRecieved[i].amount
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
                        lblCurr1.text = data.totalAmtRecieved[i].currency
                        lblAmt1.text = data.totalAmtRecieved[i].amount
                    }
                    if i == 1 {
                        lblCurr2.text =  data.totalAmtRecieved[i].currency
                        lblAmt2.text =  data.totalAmtRecieved[i].amount
                    }
                    if i == 3 {
                        lblCurr3.text =  data.totalAmtRecieved[i].currency
                        lblAmt3.text =  data.totalAmtRecieved[i].amount
                    }
                    if i == 4 {
                        lblCurr4.text =  data.totalAmtRecieved[i].currency
                        lblAmt4.text =  data.totalAmtRecieved[i].amount
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

