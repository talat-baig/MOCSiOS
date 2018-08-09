//
//  ROStorageInfoVC.swift
//  mocs
//
//  Created by Talat Baig on 7/9/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class ROStorageInfoVC: UIViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "STORAGE INFO")
    }
    
    var response:Data?
    
   
    
    @IBOutlet weak var lblStorageLoc: UILabel!
    
    @IBOutlet weak var lblSiteName: UILabel!
    
    @IBOutlet weak var lblReqTo: UILabel!
    
    @IBOutlet weak var lblReleaseTo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         parseAndAssign()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func parseAndAssign(){
        let jsonResponse = JSON(response!)
        for(_,j):(String,JSON) in jsonResponse{
            lblStorageLoc.text! = j["Storage Location"].stringValue
            lblSiteName.text! = j["Site Name"].stringValue
            lblReqTo.text! = j["Request To"].stringValue
            lblReleaseTo.text! = j["Release To"].stringValue
        }
    }
    
    
}
