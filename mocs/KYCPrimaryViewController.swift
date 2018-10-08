//
//  KYCPrimaryViewController.swift
//  mocs
//
//  Created by Talat Baig on 8/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class KYCPrimaryViewController: UIViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY INFORMATION")
    }
    
    var response : Data?
    
    @IBOutlet weak var lblCompName: UILabel!
    @IBOutlet weak var lblIncorpDate: UILabel!
    @IBOutlet weak var lblCountryOfReg: UILabel!
    @IBOutlet weak var lblCompProf: UILabel!
    @IBOutlet weak var lblGrpCompName: UILabel!
    @IBOutlet weak var lblCountryOfRes: UILabel!
    @IBOutlet weak var lblUBO: UILabel!
    @IBOutlet weak var lblKnwnCust: UILabel!
    @IBOutlet weak var lblPublicInfo: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseAndAssign()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseAndAssign() {
        
        let jsonResponse = JSON(response!)
        for(_,j):(String,JSON) in jsonResponse{

            
            if j["CPCompanyName"].stringValue == "" {
                lblCompName.text! = "-"
            } else {
                lblCompName.text! = j["CPCompanyName"].stringValue
            }
            
            if j["CPCountryRegistration"].stringValue == "" {
                lblCountryOfReg.text! = "-"
            } else {
                lblCountryOfReg.text! = j["CPCountryRegistration"].stringValue
            }
            
            
            if j["CPIncorporationDate"].stringValue == "" {
                lblIncorpDate.text! = "-"
            } else {
                lblIncorpDate.text! = j["CPIncorporationDate"].stringValue
            }
            
            
            if j["CPCountryResidenceGroup"].stringValue == "" {
                lblCountryOfRes.text! = "-"
            } else {
                lblCountryOfRes.text! = j["CPCountryResidenceGroup"].stringValue
            }
            
            
            
            if j["CPGroupCompanies"].stringValue == "" {
                lblGrpCompName.text! = "-"
            } else {
                lblGrpCompName.text! = j["CPGroupCompanies"].stringValue
            }
            
            if j["CPCompanyProfile"].stringValue == "" {
                lblCompProf.text! = "-"
            } else {
                lblCompProf.text! = j["CPCompanyProfile"].stringValue
            }
            
            if j["CPUobGroup"].stringValue == "" {
                lblUBO.text! = "-"
            } else {
                lblUBO.text! = j["CPUobGroup"].stringValue
            }
            
            
            if j["CPKnownCustomers"].stringValue == "" {
                lblKnwnCust.text! = "-"
            } else {
                lblKnwnCust.text! = j["CPKnownCustomers"].stringValue
            }
            
            
            if j["CPPublicInformation"].stringValue == "" {
                lblPublicInfo.text! = "-"
            } else {
                lblPublicInfo.text! = j["CPPublicInformation"].stringValue
            }
                        
        }
    }
    
    
}
