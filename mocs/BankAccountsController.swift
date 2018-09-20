//
//  BankAccountsController.swift
//  mocs
//
//  Created by Talat Baig on 8/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Alamofire

class BankAccountsController: UIViewController, IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "BANK ACCOUNTS & CREDIT LIMIT")
    }
    
    
    var response : Data?
    
    @IBOutlet weak var lblBnkName: UILabel!
    @IBOutlet weak var lblAccName: UILabel!
    @IBOutlet weak var lblAccNum: UILabel!
    @IBOutlet weak var lblCurr: UILabel!
    @IBOutlet weak var lblIfsc: UILabel!
    @IBOutlet weak var lblSwiftCode: UILabel!
    @IBOutlet weak var lblSwift: UILabel!
    @IBOutlet weak var lblBnkAddress: UILabel!
    @IBOutlet weak var lblInterBnkNme: UILabel!
    @IBOutlet weak var lblInterBnkIfsc: UILabel!
    
    @IBOutlet weak var lblConfirmedBy: UILabel!
    @IBOutlet weak var lblComments: UILabel!
    @IBOutlet weak var lblCalledOnNum: UILabel!
    @IBOutlet weak var lblApprovedBy: UILabel!
    @IBOutlet weak var lblApprovedOn: UILabel!

    
    @IBOutlet weak var lblInternalCL: UILabel!
    @IBOutlet weak var lblInsuredCL: UILabel!
    @IBOutlet weak var lblTotalCL: UILabel!
    @IBOutlet weak var lblMaxTenor: UILabel!
    @IBOutlet weak var lblSublimit1: UILabel!
    @IBOutlet weak var lblSublimit2: UILabel!
    @IBOutlet weak var lblInstrument1: UILabel!
    @IBOutlet weak var lblInstrument2: UILabel!
    @IBOutlet weak var lblMaxLimit1: UILabel!
    @IBOutlet weak var lblMaxLimit2: UILabel!
    @IBOutlet weak var lblMaxCredit: UILabel!
    @IBOutlet weak var lblTempCredit: UILabel!
    @IBOutlet weak var lblEnhancementVal: UILabel!
    @IBOutlet weak var lblReqByDate: UILabel!
    @IBOutlet weak var lblApprovedByDate: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseAndAssign()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func parseAndAssign() {
        
        let jsonResponse = JSON(response!)
        for(_,j):(String,JSON) in jsonResponse {
            
            if j["BankName"].stringValue == "" {
                lblBnkName.text! = "-"
            } else {
                lblBnkName.text! = j["BankName"].stringValue
            }
            
            lblAccName.text! = j["AccountName"].stringValue
            lblAccNum.text! = j["AccountNo"].stringValue

            if j["Currency"].stringValue == "" {
                lblCurr.text! = "-"
            } else {
                lblCurr.text! = j["Currency"].stringValue
            }
            
            
            lblIfsc.text! = j["BankIFSCCode"].stringValue
            
            if j["SwiftCodeIBAN"].stringValue == "" {
                lblSwiftCode.text! = "-"
            } else {
                lblSwiftCode.text! = j["SwiftCodeIBAN"].stringValue
            }
            
            
            if j["ISwift"].stringValue == "" {
                lblSwift.text! = "-"
            } else {
                lblSwift.text! = j["ISwift"].stringValue
            }
            
            
            
            if j["BankAddress"].stringValue == "" {
                lblBnkAddress.text! = "-"
            } else {
                lblBnkAddress.text! = j["BankAddress"].stringValue
            }
            
            
            if j["Comments"].stringValue == "" {
                lblComments.text! = "-"
            } else {
                lblComments.text! = j["Comments"].stringValue
            }
            
            if j["IntermediaryBankName"].stringValue == "" {
                lblInterBnkNme.text! = "-"
            } else {
                lblInterBnkNme.text! = j["IntermediaryBankName"].stringValue
            }
            
            if j["IMBankIFSCCode"].stringValue == "" {
                lblInterBnkIfsc.text! = "-"
            } else {
                lblInterBnkIfsc.text! = j["IMBankIFSCCode"].stringValue
            }
            
            if j["Confirmedby"].stringValue == "" {
                lblConfirmedBy.text! = "-"
            } else {
                lblConfirmedBy.text! = j["Confirmedby"].stringValue
            }
            
            if j["Calledonnumber"].stringValue == "" {
                lblCalledOnNum.text! = "-"
            } else {
                lblCalledOnNum.text! = j["Calledonnumber"].stringValue
            }
            
            if j["Approvedby"].stringValue == "" {
                lblApprovedBy.text! = "-"
            } else {
                lblApprovedBy.text! = j["Approvedby"].stringValue
            }
            
            if j["ApprovedDate"].stringValue == "" {
                lblApprovedOn.text! = "-"
            } else {
                lblApprovedOn.text! = j["ApprovedDate"].stringValue
            }
            
            
            
            lblInternalCL.text! = j["InternalCreditLimit"].stringValue
            lblInsuredCL.text! = j["InsuredCreditLimit"].stringValue
            lblTotalCL.text! = j["TotalCreditLimit"].stringValue
            lblMaxTenor.text! = j["MaxTenor"].stringValue
            lblSublimit1.text! = j["Sublimit1"].stringValue
            lblSublimit2.text! = j["Sublimit2"].stringValue
            lblInstrument1.text! = j["Instrument1"].stringValue
            lblInstrument2.text! = j["Instrument2"].stringValue
            lblInstrument2.text! = j["Email"].stringValue
            lblMaxLimit1.text! = j["MaxLimit1"].stringValue
            lblMaxLimit2.text! = j["MaxLimit2"].stringValue
            lblMaxCredit.text! = j["MaxCreditPeriod"].stringValue
            lblTempCredit.text! = j["TemporaryCreditEnhancement"].stringValue
            lblEnhancementVal.text! = j["EnhancementValidityDuration"].stringValue
            
            if j["RequestedBy"].stringValue == "" {
                lblReqByDate.text! = "-"
            } else {
                lblReqByDate.text! = j["RequestedBy"].stringValue
            }
            
            if j["Approveddate1"].stringValue == "" {
                lblApprovedByDate.text! = "-"
            } else {
                lblApprovedByDate.text! = j["Approveddate1"].stringValue
            }
           
        }
    }
    

}
