//
//  DOPrimaryControllerViewController.swift
//  mocs
//
//  Created by Admin on 2/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Alamofire
class DOPrimaryControllerViewController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    var response:Data?
    @IBOutlet weak var delDate: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var business: UILabel!
    @IBOutlet weak var delOrderFor: UILabel!
    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var custCode: UILabel!
    @IBOutlet weak var commodity: UILabel!
    @IBOutlet weak var contractRefId: UILabel!
    @IBOutlet weak var storageSite: UILabel!
    @IBOutlet weak var delPriod: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

        parseAndAssign()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func parseAndAssign(){
        let responseJson = JSON(response!)
        for(_,j):(String,JSON) in responseJson{
            delDate.text! = j["DO Date"].stringValue
            company.text! = j["Company"].stringValue
            location.text! = j["Location"].stringValue
            business.text! = j["Business Vertical"].stringValue
            delOrderFor.text! = j["DO For"].stringValue
            customer.text! = j["Customer Name"].stringValue
            custCode.text! = j["Customer Code"].stringValue
            contractRefId.text! = j["Sales Contract Reference No."].stringValue
            storageSite.text! = j["Storage site"].stringValue
            delPriod.text! = j["Delivery Period"].stringValue
        }
    }
}
