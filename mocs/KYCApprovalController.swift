//
//  KYCApprovalController.swift
//  mocs
//
//  Created by Talat Baig on 8/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class KYCApprovalController: UIViewController , IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "APPROVAL")
    }
    var response: Data?
    
    @IBOutlet weak var lblFinanceChkd: UILabel!
    @IBOutlet weak var lblSignatory: UILabel!
    @IBOutlet weak var lblOpDirector: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseAndAssign()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func parseAndAssign() {
        
        let jsonResponse = JSON(response!)
        for(_,j):(String,JSON) in jsonResponse{
            
            
            if j["CPFinanceChecked"].stringValue == "" {
                lblFinanceChkd.text! = "-"
            } else {
                lblFinanceChkd.text! = j["CPFinanceChecked"].stringValue
            }
            
            
            if j["CPAuthoritySignatory"].stringValue == "" {
                lblSignatory.text! = "-"
            } else {
                lblSignatory.text! = j["CPAuthoritySignatory"].stringValue
            }
            
            
            if j["CPOperationsDirector"].stringValue == "" {
                lblOpDirector.text! = "-"
            } else {
                lblOpDirector.text! = j["CPOperationsDirector"].stringValue
            }
            
            
        }
    }
    
}
