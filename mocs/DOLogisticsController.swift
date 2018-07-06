//
//  DOLogisticsController.swift
//  mocs
//
//  Created by Admin on 3/1/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
class DOLogisticsController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "LOGISTICS")
    }
    
    var response:JSON?
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var truckNo: UILabel!
    @IBOutlet weak var licenseNo: UILabel!
    @IBOutlet weak var documents: UILabel!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var uom: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseAndAssign()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func parseAndAssign(){
        for(_,j):(String,JSON) in response!{
            driverName.text! = j["Driver Name"].stringValue
            truckNo.text! = j["Truck No."].stringValue
            licenseNo.text! = j["License No."].stringValue
            documents.text! = j["Comments"].stringValue
            qty.text! = j["Quantity"].stringValue
            uom.text! = j["UOM"].stringValue
        }
    }


}
