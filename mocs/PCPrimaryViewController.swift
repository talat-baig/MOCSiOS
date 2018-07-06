//
//  PCPrimaryViewController.swift
//  mocs
//
//  Created by Admin on 2/21/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
class PCPrimaryViewController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    var response:Data!
    
    // Mark -> INIT VERIABLES
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblBusiness: UILabel!
    @IBOutlet weak var lblCommodity: UILabel!
    @IBOutlet weak var lblSupplier: UILabel!
    @IBOutlet weak var lblCpID: UILabel!
    @IBOutlet weak var lblTrader: UILabel!
    @IBOutlet weak var lblTransaction: UILabel!
    @IBOutlet weak var lblContractCurr: UILabel!
    @IBOutlet weak var lblTerm: UILabel!
    
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
            self.lblDate.text = j["Purchase Contract Date"].stringValue
            self.lblCompany.text = j["Company Name"].stringValue
            self.lblLocation.text = j["Location"].stringValue
            self.lblBusiness.text = j["Business Vertical"].stringValue
            self.lblCommodity.text = j["Commodity"].stringValue
            self.lblSupplier.text = j["Supplier"].stringValue
            self.lblCpID.text = j["CP Id"].stringValue
            self.lblTrader.text = j["Trader"].stringValue
            self.lblTransaction.text = j["Transaction Type"].stringValue
            self.lblContractCurr.text = j["Contract Currency"].stringValue
            self.lblTerm.text = j["Delivery Terms"].stringValue
        }
    }

}
