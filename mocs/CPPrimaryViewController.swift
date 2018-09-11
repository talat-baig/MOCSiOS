//
//  CPPrimaryViewController.swift
//  mocs
//
//  Created by Talat Baig on 8/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class CPPrimaryViewController: UIViewController, IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var mySubVw: UIView!
    
    @IBOutlet weak var lblCPName: UILabel!
    @IBOutlet weak var lblContctType: UILabel!
    @IBOutlet weak var lblIndustryType: UILabel!
    @IBOutlet weak var lblShortName: UILabel!
    @IBOutlet weak var lblFaxNum: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblWebsite: UILabel!
    @IBOutlet weak var lblPhno1: UILabel!
    @IBOutlet weak var lblPhno2: UILabel!

    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblBranchCity: UILabel!
    @IBOutlet weak var lblZip: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblTaxNo1: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblContactEmail: UILabel!
    @IBOutlet weak var lblMobNum: UILabel!
    @IBOutlet weak var lblPhNum: UILabel!
    
    var primResponse : Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseAndAssign()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func parseAndAssign() {
        
        let jsonResponse = JSON(primResponse!)
        for(_,j):(String,JSON) in jsonResponse{
            
            lblCPName.text! = j["CPName"].stringValue
            lblContctType.text! = j["ContactType"].stringValue
            lblIndustryType.text! = j["IndustryType"].stringValue
            
            if j["Faxno"].stringValue == "" {
                lblFaxNum.text! = "-"
            } else {
                lblFaxNum.text! = j["Faxno"].stringValue
            }
            
            if j["Email"].stringValue == "" {
                lblEmail.text! = "-"
            } else {
                lblEmail.text! = j["Email"].stringValue
            }
            
            if j["Website"].stringValue == "" {
                lblWebsite.text! = "-"
            } else {
                lblWebsite.text! = j["Website"].stringValue
            }
            
            if j["ShortName"].stringValue == "" {
                lblShortName.text! = "-"
            } else {
                lblShortName.text! = j["ShortName"].stringValue
            }

            if j["PhoneNo2"].stringValue == "" {
                lblPhno2.text! = "-"
            } else {
                lblPhno2.text! = j["PhoneNo2"].stringValue
            }
            
            if j["PhoneNo1"].stringValue == "" {
                lblPhno1.text! = "-"
            } else {
                lblPhno1.text! = j["PhoneNo1"].stringValue
            }
            
            if j["Address"].stringValue == "" {
                lblAddress.text! = "-"
            } else {
                lblAddress.text! = j["Address"].stringValue
            }
            
            if j["BranchCity"].stringValue == "" {
                lblBranchCity.text! = "-"
            } else {
                lblBranchCity.text! = j["BranchCity"].stringValue
            }
            
            if j["ZipPostalCode"].stringValue == "" {
                lblZip.text! = "-"
            } else {
                lblZip.text! = j["ZipPostalCode"].stringValue
            }
            
            if j["Country"].stringValue == "" {
                lblCountry.text! = "-"
            } else {
                lblCountry.text! = j["Country"].stringValue
            }
            
            if j["Taxno1"].stringValue == "" {
                lblTaxNo1.text! = "-"
            } else {
                lblTaxNo1.text! = j["Taxno1"].stringValue
            }
            
            if j["Contact_Person_Name"].stringValue == "" {
                lblName.text! = "-"
            } else {
                lblName.text! = j["Contact_Person_Name"].stringValue
            }
            
            if j["JobTitle"].stringValue == "" {
                lblJobTitle.text! = "-"
            } else {
                lblJobTitle.text! = j["JobTitle"].stringValue
            }
            
            if j["Email1"].stringValue == "" {
                lblShortName.text! = "-"
            } else {
                lblShortName.text! = j["Email1"].stringValue
            }
            
            if j["MobileNo"].stringValue == "" {
                lblMobNum.text! = "-"
            } else {
                lblMobNum.text! = j["MobileNo"].stringValue
            }
            
            if j["PhoneNo"].stringValue == "" {
                lblPhNum.text! = "-"
            } else {
                lblPhNum.text! = j["PhoneNo"].stringValue
            }

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
