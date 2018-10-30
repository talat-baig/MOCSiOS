//
//  APListCell.swift
//  mocs
//
//  Created by Talat Baig on 10/23/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class APListCell: UITableViewCell {

    @IBOutlet weak var lblCompany: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblBUnit: UILabel!
    
    @IBOutlet weak var vwInner: UIView!
    
    @IBOutlet weak var lblBalPayable: UILabel!
    @IBOutlet weak var lblPaidTillDate: UILabel!
    
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
        // Initialization code
        
        vwInner.layer.shadowOpacity = 0.3
        vwInner.layer.shadowOffset = CGSize(width: 0, height: 3)
        vwInner.layer.shadowRadius = 3.0
        vwInner.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    public func setDataToViews(data : APListData) {
        
        self.lblCompany.text = data.company
        self.lblBUnit.text = data.bVertical
        self.lblLocation.text = data.location
        
        self.lblBalPayable.text = data.balPayable
        self.lblPaidTillDate.text = data.paidTillDate
        
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
        }
        
    }
    
}
