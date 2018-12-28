//
//  SCPrimaryController.swift
//  mocs
//
//  Created by Admin on 2/27/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import SwiftyJSON
import XLPagerTabStrip
class SCPrimaryController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    var response:Data!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var businessUnit: UILabel!
    @IBOutlet weak var commodity: UILabel!
    @IBOutlet weak var supplier: UILabel!
    @IBOutlet weak var cpid: UILabel!
    @IBOutlet weak var trader: UILabel!
    @IBOutlet weak var transaction: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var term: UILabel!
    @IBOutlet weak var value: UILabel!
    
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
        let jsonResponse = JSON(response)
        for(_,j):(String,JSON) in jsonResponse{
            date.text! = j["Sales Contract Date"].stringValue
            company.text! = j["Company Name"].stringValue
            location.text! = j["Location"].stringValue
            businessUnit.text! = j["Business Vertical"].stringValue
            commodity.text! = j["Commodity"].stringValue
            supplier.text! = j["Supplier"].stringValue
            cpid.text! = j["CP Id"].stringValue
            trader.text! = j["Trader"].stringValue
            transaction.text! = j["Transaction Type"].stringValue
            currency.text! = j["Contract Currency"].stringValue
            term.text! = j["Delivery Terms"].stringValue
            value.text! = j["Total Contract Value"].stringValue
        }
    }
    
}
