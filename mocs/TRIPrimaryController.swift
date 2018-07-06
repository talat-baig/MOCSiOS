//
//  TRIPrimaryController.swift
//  mocs
//
//  Created by Admin on 3/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class TRIPrimaryController: UIViewController, IndicatorInfoProvider {
   
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var businessUnit: UILabel!
    @IBOutlet weak var beneficary: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var paymentMode: UILabel!
    @IBOutlet weak var requestedNetAmount: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var grossAmount: UILabel!
    @IBOutlet weak var grossAmountUSD: UILabel!
    @IBOutlet weak var fxRate: UILabel!
    
    var data:TRIData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

        setDataToView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setDataToView(){
        if let tri = data{
            company.text! = tri.company
            location.text! = tri.location
            businessUnit.text! = tri.businessUnit
            beneficary.text! = tri.beneficiary
            date.text! = tri.date
            paymentMode.text! = tri.payMode
            requestedNetAmount.text! = tri.requestAmountNet
            tax.text! = tri.tax
            grossAmount.text! = tri.requestAmountGross
            grossAmountUSD.text! = tri.requestAmountGrossUSD
            fxRate.text! = tri.fxRate
        }
    }
}
