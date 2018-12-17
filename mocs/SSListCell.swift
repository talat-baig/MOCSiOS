//
//  SSListCell.swift
//  mocs
//
//  Created by Talat Baig on 12/10/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class SSListCell: UITableViewCell {
    
    @IBOutlet weak var lblCompany: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblBUnit: UILabel!
    
    @IBOutlet weak var vwInner: UIView!
    
    @IBOutlet weak var lblContractVal: UILabel!
    
    @IBOutlet weak var stckVw1: UIStackView!
    @IBOutlet weak var stckVw2: UIStackView!
    @IBOutlet weak var stckVw3: UIStackView!
    @IBOutlet weak var stckVw4: UIStackView!
    @IBOutlet weak var stckVw5: UIStackView!
    @IBOutlet weak var stckVw6: UIStackView!
    
    @IBOutlet weak var lblCurr1: UILabel!
    @IBOutlet weak var lblCurr2: UILabel!
    @IBOutlet weak var lblCurr3: UILabel!
    @IBOutlet weak var lblCurr4: UILabel!
    @IBOutlet weak var lblCurr5: UILabel!
    @IBOutlet weak var lblCurr6: UILabel!
    
    @IBOutlet weak var lblAmt1: UILabel!
    @IBOutlet weak var lblAmt2: UILabel!
    @IBOutlet weak var lblAmt3: UILabel!
    @IBOutlet weak var lblAmt4: UILabel!
    @IBOutlet weak var lblAmt5: UILabel!
    @IBOutlet weak var lblAmt6: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        vwInner.layer.shadowOpacity = 0.3
        vwInner.layer.shadowOffset = CGSize(width: 0, height: 3)
        vwInner.layer.shadowRadius = 3.0
        vwInner.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    public func setDataToViews(data : SSListData) {
        
        self.lblCompany.text = data.company
        self.lblBUnit.text = data.bVertical
        self.lblLocation.text = data.location
        
        self.lblContractVal.text = data.totalValUSD
        
//        if data.totalValue.count > 0 {
//
//            for i in 0..<data.totalValue.count {
//                if i == 0 {
//                    stckVw1.isHidden = false
//                    stckVw2.isHidden = true
//                    stckVw3.isHidden = true
//                    stckVw4.isHidden = true
//                    stckVw5.isHidden = true
//                    stckVw6.isHidden = true
//
//                    lblCurr1.text = data.totalValue[i].currency
//                    lblAmt1.text = data.totalValue[i].amount
//                }
//                if i == 1 {
//                    stckVw2.isHidden = false
//                    stckVw3.isHidden = true
//                    stckVw4.isHidden = true
//                    stckVw5.isHidden = true
//                    stckVw6.isHidden = true
//
//                    lblCurr2.text =  data.totalValue[i].currency
//                    lblAmt2.text =  data.totalValue[i].amount
//                }
//                if i == 2 {
//                    stckVw3.isHidden = false
//                    stckVw4.isHidden = true
//                    stckVw5.isHidden = true
//                    stckVw6.isHidden = true
//
//                    lblCurr3.text =  data.totalValue[i].currency
//                    lblAmt3.text =  data.totalValue[i].amount
//                }
//                if i == 3 {
//                    stckVw4.isHidden = false
//                    stckVw5.isHidden = true
//                    stckVw6.isHidden = true
//
//                    lblCurr4.text =  data.totalValue[i].currency
//                    lblAmt4.text =  data.totalValue[i].amount
//                }
//
//                if i == 4 {
//                    stckVw5.isHidden = false
//                    stckVw6.isHidden = true
//
//                    lblCurr5.text =  data.totalValue[i].currency
//                    lblAmt5.text =  data.totalValue[i].amount
//                }
//                if i == 5 {
//                    stckVw6.isHidden = false
//
//                    lblCurr6.text =  data.totalValue[i].currency
//                    lblAmt6.text =  data.totalValue[i].amount
//                }
//
//
//            }
//        } else {
//            stckVw1.isHidden = true
//            stckVw2.isHidden = true
//            stckVw3.isHidden = true
//            stckVw4.isHidden = true
//            stckVw5.isHidden = true
//            stckVw6.isHidden = true
//
//        }
        
    }
}
