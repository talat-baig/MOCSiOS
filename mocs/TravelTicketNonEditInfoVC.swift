//
//  TravelTicketNonEditInfoVC.swift
//  mocs
//
//  Created by Talat Baig on 9/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class TravelTicketNonEditInfoVC: UIViewController, IndicatorInfoProvider , notifyChilds_UC {
  

    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "TICKET INFORMATION")
    }
    
    weak var ttData : TravelTicketData!

    
    @IBOutlet weak var lblCarrier: UILabel!
    
    @IBOutlet weak var lblTicktNo: UILabel!

    @IBOutlet weak var lblTBookDateDate: UILabel!

    @IBOutlet weak var lblTExpiryDate: UILabel!
    
    @IBOutlet weak var lblTcktPNR: UILabel!
    
    @IBOutlet weak var lblTcktCost: UILabel!
    
    @IBOutlet weak var lblTrvlAgent: UILabel!
    
    @IBOutlet weak var lblTcktStatus: UILabel!
    
    @IBOutlet weak var lblInvoiceNo: UILabel!
    
    @IBOutlet weak var lblAdvance: UILabel!
    
    @IBOutlet weak var lblComments: UILabel!
    
    @IBOutlet weak var lblApprovdBy: UILabel!
    
    @IBOutlet weak var lblAdvAmtCurr: UILabel!
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func notifyChild(messg: String, success: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assginDateToFields()
    }
    
    func assginDateToFields() {
        
//        lblCarrier.text = ttData.carrier
        
        if ttData.carrier == "" {
            lblCarrier.text! = "-"
        } else {
            lblCarrier.text! = ttData.carrier
        }
        
//        lblTicktNo.text = ttData.ticktNum

        if ttData.ticktNum == "" {
           lblTicktNo.text! = "-"
        } else {
            lblTicktNo.text! = ttData.ticktNum
        }
        
//        lblTBookDateDate.text = ttData.issueDate
        if ttData.issueDate == "" {
            lblTBookDateDate.text! = "-"
        } else {
            lblTBookDateDate.text! = ttData.issueDate
        }
        
//        lblTExpiryDate.text = ttData.expiryDate

        if ttData.expiryDate == "" {
            lblTExpiryDate.text! = "-"
        } else {
            lblTExpiryDate.text! = ttData.expiryDate
        }
        
//        lblTcktCost.text = ttData.ticktCost

        if ttData.ticktCost == "" {
            lblTcktCost.text! = "-"
        } else {
            lblTcktCost.text! = ttData.ticktCost
        }
        

        if ttData.agent == "" {
            lblTrvlAgent.text! = "-"
        } else {
            lblTrvlAgent.text! = ttData.agent
        }
        
        if ttData.ticktPNRNum == "" {
            lblTcktPNR.text! = "-"
        } else {
            lblTcktPNR.text! = ttData.ticktPNRNum
        }
        
        if ttData.ticktStatus == "" {
            lblTcktStatus.text! = "-"
        } else {
            lblTcktStatus.text! = ttData.ticktStatus
        }
        
        
        if ttData.invoiceNum == "" {
            lblInvoiceNo.text! = "-"
        } else {
            lblInvoiceNo.text! = ttData.invoiceNum
        }
       
        if ttData.trvlAprAmt == "" {
            lblAdvance.text! = "-"
        } else {
            lblAdvance.text! =  ttData.trvlAprAmt != "0" ?  ttData.trvlAprAmt + " " + ttData.trvlAprCurr : "-"
            
        }
        
        if ttData.trvlComments == "" {
            lblComments.text! = "-"
        } else {
            lblComments.text! = ttData.trvlComments
        }
        
        
        if ttData.approvdBy == "" {
            lblApprovdBy.text! = "-"
        } else {
            lblApprovdBy.text! = ttData.approvdBy
        }
    }
    

}
