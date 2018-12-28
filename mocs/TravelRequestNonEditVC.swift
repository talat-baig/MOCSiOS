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
    
    @IBOutlet weak var lblReqBy: UILabel!
    @IBOutlet weak var lblApprvdBy: UILabel!
    @IBOutlet weak var lblApprvdByDate: UILabel!
    @IBOutlet weak var lblReqByDate: UILabel!

    
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
       
//        lblEmpName.text! = trfDta.empName
        
        if trfDta.empName == "" {
            lblEmpName.text! = "-"
        } else {
            lblEmpName.text! = trfDta.empName
        }
        
        if trfDta.trvArrangmnt == "" {
           lblTrvlArngmnt.text! = "-"
        } else {
            lblTrvlArngmnt.text! = trfDta.trvArrangmnt
        }
        
        if trfDta.reason == "" {
            lblReason.text! = "-"
        } else {
            lblReason.text! = trfDta.reason
        }
        
        if trfDta.accmpnd == "" {
             lblAccmpnd.text! = "-"
        } else {
            lblAccmpnd.text! = trfDta.accmpnd
        }
        
//        lblEmpCode.text! = Session.empCode
//        lblDept.text! = Session.department
//        lblDesgntn.text! = Session.designation
        
        lblEmpCode.text! = trfDta.empCode
        lblDept.text! = trfDta.empDept
        lblDesgntn.text! = trfDta.empDesgntn
       
        if trfDta.approver == "" {
            lblApprvdBy.text! = "-"
        } else {
            lblApprvdBy.text! = trfDta.approver
        }
        
        if trfDta.requestor == "" {
            lblReqBy.text! = "-"
        } else {
            lblReqBy.text! = trfDta.requestor
        }
        
        if trfDta.reqDate == "" {
            lblReqByDate.text! = "-"
        } else {
            lblReqByDate.text! = trfDta.reqDate
        }
        
        if trfDta.approvdDate == "" {
            lblApprvdByDate.text! = "-"
        } else {
            lblApprvdByDate.text! = trfDta.approvdDate
        }
        
        if trfDta.reportMngr == "" {
            lblReportMngr.text! = "-"
        } else {
            lblReportMngr.text! = trfDta.reportMngr
        }
        
        
    }
    
    
}
