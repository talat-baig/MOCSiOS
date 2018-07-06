//
//  PCShipmentViewController.swift
//  mocs
//
//  Created by Admin on 2/21/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
class PCShipmentViewController: UIViewController , IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "SHIPMENT")
    }

    var response:Data!
    // VARIABLE INIT
    @IBOutlet weak var shipType: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var pol: UILabel!
    @IBOutlet weak var pod: UILabel!
    @IBOutlet weak var shippingLine: UILabel!
    @IBOutlet weak var vessel: UILabel!
    @IBOutlet weak var container: UILabel!
    @IBOutlet weak var noOfContainer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        parseAndAssign()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func parseAndAssign(){
        let data = JSON(response)
        for(_,j):(String,JSON) in data{
            shipType.text = j["Shipment Type"].stringValue == "" ? " " : j["Shipment Type"].stringValue
            startDate.text = j["Shipment Start Date"].stringValue == "" ? " " : j["Shipment Start Date"].stringValue
            endDate.text = j["Shipment End Date"].stringValue == "" ? " " : j["Shipment End Date"].stringValue
            pol.text = j["POL"].stringValue == "" ? " " : j["POL"].stringValue
            shippingLine.text = j["Shipping Line"].stringValue == "" ? " " : j["Shipping Line"].stringValue
            vessel.text = j["Mother Vessel"].rawString()
            container.text = j["Container Type"].stringValue == "" ? " " : j["Container Type"].stringValue
            pod.text = j["POD"].stringValue == "" ? " " : j["POD"].stringValue
            noOfContainer.text = j["NoOfContainers"].stringValue == "" ? " " : j["NoOfContainers"].stringValue
        }
    }
}
