//
//  TransactionDetailsController.swift
//  mocs
//
//  Created by Talat Baig on 8/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class TransactionDetailsController: UIViewController, IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "TRANSACTION DETAILS")
    }
    
    
    @IBOutlet weak var lblTradingLimit: UILabel!
    
    @IBOutlet weak var lblReqPymnt: UILabel!
    
    @IBOutlet weak var lblBusinessDesc: UILabel!
    
    var response : Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parseAndAssign()
    }

    
    func parseAndAssign() {
        
        let jsonResponse = JSON(response!)
        for(_,j):(String,JSON) in jsonResponse{
            
            
            if j["CPTradingLimitRequested"].stringValue == "" {
                lblTradingLimit.text! = "-"
            } else {
                lblTradingLimit.text! = j["CPTradingLimitRequested"].stringValue
            }
            
            
            if j["CPRequestedPaymentTerms"].stringValue == "" {
                lblReqPymnt.text! = "-"
            } else {
                lblReqPymnt.text! = j["CPRequestedPaymentTerms"].stringValue
            }
            
            if j["CPExpectedBusinessDescription"].stringValue == "" {
                lblBusinessDesc.text! = "-"
            } else {
                lblBusinessDesc.text! = j["CPExpectedBusinessDescription"].stringValue
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
