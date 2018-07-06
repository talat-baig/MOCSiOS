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
    
    
    func createStackView(lblCurr1 : String, lblAmt1 : String, lblCurr2 : String , lblAmt2: String) {
        
        let lblCurrency1 = UILabel()
        let lblAmount1 = UILabel()
        
        lblCurrency1.text = lblCurr1
        lblAmount1.text = lblAmt1
        
        lblAmount1.textColor = UIColor.white
        lblCurrency1.textColor = UIColor.white
        
        lblCurrency1.font = UIFont.systemFont(ofSize: 13.0)
        lblAmount1.font = UIFont.systemFont(ofSize: 17.0 ,  weight: .semibold)
        
        let s1 = UIStackView()
        s1.axis = .vertical
        s1.distribution = .fillEqually
        s1.alignment = .fill
        s1.spacing = 0
        s1.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        s1.addArrangedSubview(lblCurrency1)
        s1.addArrangedSubview(lblAmount1)
        // -------- //
        let lblCurrency2 = UILabel()
        let lblAmount2 = UILabel()
        
        lblCurrency2.text = lblCurr2
        lblAmount2.text = lblAmt2
        
        lblAmount2.textColor = UIColor.white
        lblCurrency2.textColor = UIColor.white
        
        lblCurrency2.font = UIFont.systemFont(ofSize: 13.0)
        lblAmount2.font = UIFont.systemFont(ofSize: 17.0 ,  weight: .semibold)
        
        let s2 = UIStackView()
        s2.axis = .vertical
        s2.distribution = .fillEqually
        s2.alignment = .fill
        s2.spacing = 0
        s2.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        s2.addArrangedSubview(lblCurrency2)
        s2.addArrangedSubview(lblAmount2)
        
        
        let rect = CGRect(origin: CGPoint(x:0, y:16), size: CGSize(width:self.stackVwAmtRecvd.frame.size.width, height:self.stackVwAmtRecvd.frame.size.height - 16))
        
        let s3 = UIStackView(frame: rect )
        s3.axis = .horizontal
        s3.distribution = .fillEqually
        s3.alignment = .fill
        s3.spacing = 0
        s3.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        s3.addArrangedSubview(s1)
        s3.addArrangedSubview(s2)
        
        stackVwAmtRecvd.addArrangedSubview(s3)
    }
    
}
