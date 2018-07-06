//
//  EPRPrimaryController.swift
//  mocs
//
//  Created by Admin on 3/8/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
class EPRPrimaryController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    var response:Data?
    
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var beneficiary: UILabel!
    @IBOutlet weak var raisedOn: UILabel!
    @IBOutlet weak var paymentType: UILabel!
    @IBOutlet weak var requestedAmount: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var department: UILabel!
    @IBOutlet weak var fxRate: UILabel!
    @IBOutlet weak var paymentMode: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parseAndAssign()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseAndAssign(){
        let jsonResponse = JSON(response!)
        for(_,j):(String,JSON) in jsonResponse{
            company.text! = j["Company Name"].stringValue
            location.text! = j["Location"].stringValue
            beneficiary.text! = j["Beneficiary Name"].stringValue
            department.text! = j["Department"].stringValue
            raisedOn.text! = j["Raised On"].stringValue
            paymentType.text! = j["Payment Type"].stringValue
            requestedAmount.text! = j["Requested Amount"].stringValue
            fxRate.text! = j["FX $ Rate"].stringValue
            paymentMode.text! = j["Payment Mode"].stringValue
            status.text! = j["Status"].stringValue
        }
    }


}
