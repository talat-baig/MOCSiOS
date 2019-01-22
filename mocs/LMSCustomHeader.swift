//
//  LMSCustomHeader.swift
//  mocs
//
//  Created by Talat Baig on 1/21/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class LMSCustomHeader: UITableViewCell {

    
    @IBOutlet weak var empName: UILabel!
    @IBOutlet weak var dept: UILabel!
    @IBOutlet weak var repMngr: UILabel!
    @IBOutlet weak var empCode: UILabel!

    @IBOutlet weak var btnApply: UIButton!
    
    @IBOutlet weak var tblVwSummary: UITableView!
    
    func setDataToViews(data : LMSSummaryData) {
        
        empName.text = Session.user
        dept.text = Session.department
        empCode.text = Session.empCode
        repMngr.text = Session.reportMngr
//        lblReason.text = data.reason
//        lblStatus.text = data.appStatus
//        lblNoOfDays.text = data.noOdDays
//        lblDateApplied.text = data.appliedDate
//
//        self.data = data
    }
    
    
    
    
}
