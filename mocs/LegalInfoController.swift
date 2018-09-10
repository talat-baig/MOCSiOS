//
//  LegalInfoController.swift
//  mocs
//
//  Created by Talat Baig on 8/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class LegalInfoController: UIViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "LEGAL INFORMATION")
    }
    
    var response : Data?
    
    @IBOutlet weak var lblInfoShareholders: UILabel!
    
    @IBOutlet weak var lblDirectorsNames: UILabel!
    @IBOutlet weak var lblNumOfEmp: UILabel!
    
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
            
            
            if j["CPShareholdersInformation"].stringValue == "" {
                lblInfoShareholders.text! = "-"
            } else {
                lblInfoShareholders.text! = j["CPShareholdersInformation"].stringValue
            }
            
            if j["CPCompanyDirectorsName"].stringValue == "" {
                lblDirectorsNames.text! = "-"
            } else {
                lblDirectorsNames.text! = j["CPCompanyDirectorsName"].stringValue
            }
            
            
            if j["CPEmployeesContractingCompany"].stringValue == "" {
                lblNumOfEmp.text! = "-"
            } else {
                lblNumOfEmp.text! = j["CPEmployeesContractingCompany"].stringValue
            }
            
            
        }
    }

  
}
