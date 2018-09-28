//
//  TravelTicketNonEditInfoVC.swift
//  mocs
//
//  Created by Talat Baig on 9/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class TravelTicketNonEditInfoVC: UIViewController, IndicatorInfoProvider {

    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "TICKET INFORMATION")
    }
    
    @IBOutlet weak var lblCarrier: UILabel!
    
    @IBOutlet weak var lblTicktNo: UILabel!

    @IBOutlet weak var lblTBookDateDate: UILabel!

    @IBOutlet weak var lblTExpiryDate: UILabel!
    
    @IBOutlet weak var lblTcktPNR: UILabel!
    
    @IBOutlet weak var lblTcktCost: UILabel!
    
    @IBOutlet weak var lblTrvlAgent: UILabel!
    
    @IBOutlet weak var lblTcktStatus: UILabel!
    
    @IBOutlet weak var lblInvoiceNo: UILabel!
    
    @IBOutlet weak var lblAdvance: UILabel!
    
    @IBOutlet weak var lblComments: UILabel!
    
    @IBOutlet weak var lblApprovdBy: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
