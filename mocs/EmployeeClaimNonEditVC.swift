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

class EmployeeClaimNonEditVC: UIViewController, IndicatorInfoProvider {

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

        
        
//        let jsonResponse = JSON(response!)
//        for(_,j):(String,JSON) in jsonResponse{
//            lblCompany.text! = j["Company Name"].stringValue
//            lblDepartment.text! = j["Employee Department"].stringValue
//            lblToDate.text! = j["Travel End Date"].stringValue
//            lblFromDate.text! = j["Travel Start Date"].stringValue
//            lblTravelType.text! = j["Type of Travel"].stringValue
//            lblTravelPurpose.text! = j["Purpose of Travel"].stringValue
//            lblPlaces.text! = j["Places Visited"].stringValue
//            lblTotalAmt.text! = j["Total Amount"].stringValue
//            lblTotalDays.text! = j["Total days"].stringValue
//            lblClaimRaised.text! = j["Claim Raised On"].stringValue
//        }
    }
 

}
