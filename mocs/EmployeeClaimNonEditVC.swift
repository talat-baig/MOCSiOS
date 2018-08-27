//
//  EmployeeClaimNonEditVC.swift
//  mocs
//
//  Created by Talat Baig on 8/16/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class EmployeeClaimNonEditVC: UIViewController, IndicatorInfoProvider , notifyChilds_UC {
   
    var ecrData = EmployeeClaimData()
    
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblEmpDept: UILabel!
    @IBOutlet weak var lblBenfName: UILabel!
    @IBOutlet weak var lblClaimType: UILabel!
    @IBOutlet weak var lblReqDate: UILabel!

    @IBOutlet weak var lblReqAmt: UILabel!
    @IBOutlet weak var lblBalToPay: UILabel!
    @IBOutlet weak var lblPaidVal: UILabel!

    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseAndAssign()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseAndAssign() {
        
        lblCompany.text = self.ecrData.companyName
        lblLocation.text = self.ecrData.location
        lblEmpDept.text = self.ecrData.employeeDepartment
        lblBenfName.text = self.ecrData.benefName
        lblClaimType.text = self.ecrData.claimType
        lblReqDate.text = self.ecrData.requestedDate
        lblReqAmt.text = self.ecrData.reqAmount
        lblBalToPay.text = self.ecrData.balance
        lblPaidVal.text = self.ecrData.paidAmount

    }
 
    func notifyChild(messg: String, success: Bool) {
        Helper.showVUMessage(message: messg, success: success)

    }
    
   
}
