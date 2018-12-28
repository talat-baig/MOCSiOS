//
//  FinancialInfoController.swift
//  mocs
//
//  Created by Talat Baig on 8/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class FinancialInfoController: UIViewController , IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "FINANCIAL INFORMATION/OTHER")
    }
    
    
    @IBOutlet weak var lblAnnTurnover: UILabel!
    @IBOutlet weak var lblAssetsInPoss: UILabel!
    
    @IBOutlet weak var lblSecurities: UILabel!
    
    @IBOutlet weak var lblFinancialsAvbl: UILabel!
    
    @IBOutlet weak var lblOwnExp: UILabel!
    
    @IBOutlet weak var lblNegInfo: UILabel!
    
    
    var response : Data?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseAndAssign()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func parseAndAssign() {
        
        
        let jsonResponse = JSON(response!)
        for(_,j):(String,JSON) in jsonResponse{
            
            if j["CPAnnualTurnover"].stringValue == "" {
                lblAnnTurnover.text! = "-"
            } else {
                lblAnnTurnover.text! = j["CPAnnualTurnover"].stringValue
            }
            
            if j["CPAssetsPossession"].stringValue == "" {
                lblAssetsInPoss.text! = "-"
            } else {
                lblAssetsInPoss.text! = j["CPAssetsPossession"].stringValue
            }
            
            if j["CPFinancialsAvailable"].stringValue == "" {
                lblFinancialsAvbl.text! = "-"
            } else {
                lblFinancialsAvbl.text! = j["CPFinancialsAvailable"].stringValue
            }
            
            if j["CPSecurities"].stringValue == "" {
                lblSecurities.text! = "-"
            } else {
                lblSecurities.text! = j["CPSecurities"].stringValue
            }
            
            if j["CPOwnExperinceTrack"].stringValue == "" {
                lblOwnExp.text! = "-"
            } else {
                lblOwnExp.text! = j["CPOwnExperinceTrack"].stringValue
            }
            
            if j["CPNegativeInformation"].stringValue == "" {
                lblNegInfo.text! = "-"
            } else {
                lblNegInfo.text! = j["CPNegativeInformation"].stringValue
            }
            
        }
        
    }
}
