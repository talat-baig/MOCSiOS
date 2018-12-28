//
//  TravelTicketNonEditVC.swift
//  mocs
//
//  Created by Talat Baig on 9/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON

class TravelTicketNonEditVC: UIViewController, IndicatorInfoProvider {

    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY INFORMATION")
    }
    
    weak var ttData : TravelTicketData!

    
    @IBOutlet weak var lblCompnyName: UILabel!
    
    @IBOutlet weak var lblTrvlerName: UILabel!
    
    @IBOutlet weak var lblDept: UILabel!
    
    @IBOutlet weak var lblPurpose: UILabel!
    
    @IBOutlet weak var lblTrvlType: UILabel!
    
    @IBOutlet weak var lblTrvlMode: UILabel!
    
    @IBOutlet weak var lblTrvlClass: UILabel!
    
    @IBOutlet weak var lblDebtAcName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assginDateToFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func assginDateToFields() {
        
        lblCompnyName.text = ttData.tCompName
        lblDept.text = ttData.trvlrDept
        lblTrvlerName.text = ttData.trvlrName
        lblPurpose.text = ttData.trvlrPurpose
        lblTrvlType.text = ttData.trvlrType
        lblTrvlClass.text = ttData.trvlrClass
        lblTrvlMode.text = ttData.trvlrMode
//        lblDebtAcName.text = ttData.debitACName
        if ttData.debitACName == "" {
            lblDebtAcName.text! = "-"
        } else {
            lblDebtAcName.text! = ttData.debitACName
        }
    }
    
}
