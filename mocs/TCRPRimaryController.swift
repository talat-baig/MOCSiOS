//
//  TCRPRimaryController.swift
//  mocs
//
//  Created by Admin on 3/5/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
class TCRPRimaryController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    var response:Data?
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var businessVerticle: UILabel!
    @IBOutlet weak var department: UILabel!
    @IBOutlet weak var fromPeriod: UILabel!
    @IBOutlet weak var toPeriod: UILabel!
    @IBOutlet weak var tavelType: UILabel!
    @IBOutlet weak var travelPurpose: UILabel!
    @IBOutlet weak var claimRaiseOm: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var placeVisited: UILabel!
    @IBOutlet weak var totalDays: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parseAndAssign()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseAndAssign(){
        let jsonResponse = JSON(response!)
        for(_,j):(String,JSON) in jsonResponse{
            company.text! = j["Company Name"].stringValue
            businessVerticle.text! = j["Business Vertical"].stringValue
            department.text! = j["Employee Department"].stringValue
            claimRaiseOm.text! = j["Claim Raised On"].stringValue
            tavelType.text! = j["Type of Travel"].stringValue
            travelPurpose.text! = j["Purpose of Travel"].stringValue
            placeVisited.text! = j["Places Visited"].stringValue
            fromPeriod.text! = j["Travel Start Date"].stringValue
            toPeriod.text! = j["Travel End Date"].stringValue
            totalAmount.text! = j["Total Amount"].stringValue
            totalDays.text! = j["Total days"].stringValue
        }
    }



}
