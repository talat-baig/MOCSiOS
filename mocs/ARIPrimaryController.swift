//
//  ARIPrimaryController.swift
//  mocs
//
//  Created by Admin on 3/12/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class ARIPrimaryController: UIViewController, IndicatorInfoProvider {
   
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    var data:ARIData?
    
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var businessUnit: UILabel!
    @IBOutlet weak var beneficiary: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var amountUSD: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        populateView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func populateView(){
        if let ariData = data{
            company.text! = ariData.company
            location.text! = ariData.location
            businessUnit.text! = ariData.businessUnit
            beneficiary.text! = ariData.beneficiaryName
            date.text! = ariData.date
            amount.text! = ariData.requestAmt
            amountUSD.text! = ariData.requestAmtUSD
        }
    }
}
