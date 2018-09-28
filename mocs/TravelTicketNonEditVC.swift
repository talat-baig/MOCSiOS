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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

}
