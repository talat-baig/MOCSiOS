//
//  PCPaymentViewController.swift
//  mocs
//
//  Created by Admin on 2/21/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
class PCPaymentViewController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PAYMENTS")
    }
    
    var response:Data!
    
    // VARIABLE INIT
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var advance: UILabel!
    @IBOutlet weak var primaryPay: UILabel!
    @IBOutlet weak var secondryPay: UILabel!
    @IBOutlet weak var thirdPay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

        parseAndAssign()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func parseAndAssign(){
        let data = JSON(response)
        for(_,j):(String,JSON) in data{
            value.text = j["Total Contract Value"].stringValue
            advance.text = j["Advance"].stringValue
            primaryPay.text = j["Primary Payment Mode"].stringValue
            secondryPay.text = j["Secondary Payment Mode"].stringValue == "" ? " " : j["Secondary Payment Mode"].stringValue
            thirdPay.text = j["Third Payment Mode"].stringValue == "" ? " " : j["Third Payment Mode"].stringValue
        }
    }

}
