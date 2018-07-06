//
//  TradeInvoiceAdapter.swift
//  mocs
//
//  Created by Admin on 3/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class TradeInvoiceAdapter: UITableViewCell {

    /// Label for Reference Id
    @IBOutlet weak var RefId: UILabel!
    
    /// Label for Company Name
    @IBOutlet weak var comapnyName: UILabel!
    
    /// Label for Location
    @IBOutlet weak var location: UILabel!
    
    /// Label for Business
    @IBOutlet weak var business: UILabel!
    
    /// Label for Beneficiary
    @IBOutlet weak var beneficiary: UILabel!
    
    /// Label for Date
    @IBOutlet weak var date: UILabel!
    
    /// Label for Payment
    @IBOutlet weak var payment: UILabel!
    
    /// Label for requested amount
    @IBOutlet weak var requestedAmt: UILabel!
    
    /// Label for Tax
    @IBOutlet weak var tax: UILabel!
    
    /// Label for gross amount
    @IBOutlet weak var grossAmt: UILabel!
    
    /// Label for gross amount
    @IBOutlet weak var grossAmtUSD: UILabel!
    
    /// Label for FxRate
    @IBOutlet weak var fxRate: UILabel!
    
    /// Inner view
    @IBOutlet weak var vwInner: UIView!
    
    /// onButtonClickListener delegate Object
    weak var delegate:onButtonClickListener?
    
    /// TRIData object
    var data:TRIData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.vwInner.layer.borderWidth = 1
        self.vwInner.layer.borderColor = AppColor.universalHeaderColor.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    /// Set data of type TRIData to View
    /// - Parameter data: TRIData object
    func setDataToView(data:TRIData){
        RefId.text! = data.refId
        comapnyName.text! = data.company
        location.text! = data.location
        business.text! = data.businessUnit
        beneficiary.text! = data.beneficiary
        date.text! = data.date
        payment.text! = data.payMode
        requestedAmt.text! = data.requestAmount
        tax.text! = data.tax
        grossAmt.text! = data.requestAmountGross
        grossAmtUSD.text! = data.requestAmountGrossUSD
        fxRate.text! = data.fxRate
        self.data = data
    }
    
    @IBAction func view_click(_ sender: Any) {
        if(self.delegate?.responds(to: Selector(("onViewClick:"))) != nil){
            delegate?.onViewClick(data: data!)
        }
    }
    @IBAction func mail_click(_ sender: Any) {
        if(self.delegate?.responds(to: Selector(("onMailClick:"))) != nil){
            delegate?.onMailClick(data: data!)
        }
    }
    @IBAction func approve_click(_ sender: Any) {
        if(self.delegate?.responds(to: Selector(("onApproveClick:"))) != nil){
            delegate?.onApproveClick(data: data!)
        }
    }
    @IBAction func decline_click(_ sender: Any) {
        if(self.delegate?.responds(to: Selector(("onDeclineClick:"))) != nil){
            delegate?.onDeclineClick(data: data!)
        }
    }
}
