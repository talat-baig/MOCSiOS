//
//  TravelClaimNonEditController.swift
//  Pods
//
//  Created by Talat Baig on 3/26/18.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class TravelClaimNonEditController: UIViewController, IndicatorInfoProvider, notifyChilds_UC {
   
    
    var response:Data?
    
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblDepartment: UILabel!
    @IBOutlet weak var lblToDate: UILabel!
    @IBOutlet weak var lblFromDate: UILabel!
    @IBOutlet weak var lblTravelType: UILabel!
    @IBOutlet weak var lblTravelPurpose: UILabel!
    @IBOutlet weak var lblClaimRaised: UILabel!
    @IBOutlet weak var lblTotalAmt: UILabel!
    @IBOutlet weak var lblPlaces: UILabel!
    @IBOutlet weak var lblTotalDays: UILabel!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseAndAssign()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func notifyChild(messg: String ,success: Bool) {
          Helper.showVUMessage(message: messg, success: success)
    }
    
    func parseAndAssign(){
        let jsonResponse = JSON(response!)
        for(_,j):(String,JSON) in jsonResponse{
            lblCompany.text! = j["Company Name"].stringValue
            lblDepartment.text! = j["Employee Department"].stringValue
            lblToDate.text! = j["Travel End Date"].stringValue
            lblFromDate.text! = j["Travel Start Date"].stringValue
            lblTravelType.text! = j["Type of Travel"].stringValue
            lblTravelPurpose.text! = j["Purpose of Travel"].stringValue
            lblPlaces.text! = j["Places Visited"].stringValue
            lblTotalAmt.text! = j["Total Amount"].stringValue
            lblTotalDays.text! = j["Total days"].stringValue
            lblClaimRaised.text! = j["Claim Raised On"].stringValue
        }
    }
    
    
    
}
