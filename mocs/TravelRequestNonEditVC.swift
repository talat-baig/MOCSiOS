//
//  TravelRequestNonEditVC.swift
//  mocs
//
//  Created by Talat Baig on 9/20/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class TravelRequestNonEditVC: UIViewController, IndicatorInfoProvider {
    
    var trfData: TravelRequestData?
    
    
    @IBOutlet weak var lblEmpName: UILabel!
    @IBOutlet weak var lblEmpCode: UILabel!
    @IBOutlet weak var lblDept: UILabel!
    @IBOutlet weak var lblDesgntn: UILabel!
    @IBOutlet weak var lblReportMngr: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblTrvlArngmnt: UILabel!
    
    @IBOutlet weak var lblAccmpnd: UILabel!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "TRAVEL DETAILS")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func assignData(){
        
        guard let trfDta = trfData else {
            return
        }
        
        lblEmpName.text = trfDta.empName
        lblEmpCode.text! = trfDta.empCode
        lblDept.text! = trfDta.empDept
        lblDesgntn.text! = trfDta.empDesgntn
        lblTrvlArngmnt.text! = trfDta.trvArrangmnt
        lblReason.text! = trfDta.reason
        lblAccmpnd.text! = trfDta.accmpnd
        
    }
    
    
}
