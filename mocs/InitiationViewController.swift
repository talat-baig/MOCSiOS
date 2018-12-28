//
//  InitiationViewController.swift
//  mocs
//
//  Created by Talat Baig on 8/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class InitiationViewController: UIViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "INITIATION")
    }
    
    var response : Data?
    
    @IBOutlet weak var lblTraderOp: UILabel!
    
    
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
            
            if j["CPTraderOperations"].stringValue == "" {
                lblTraderOp.text! = "-"
            } else {
                lblTraderOp.text! = j["CPTraderOperations"].stringValue
            }
            
        }
    }
    
}
