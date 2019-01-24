//
//  LMSCustomHeader.swift
//  mocs
//
//  Created by Talat Baig on 1/21/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class LMSCustomHeader: UITableViewCell {

    @IBOutlet weak var vwOuter: UIView!
    
    @IBOutlet weak var empName: UILabel!
    @IBOutlet weak var dept: UILabel!
    @IBOutlet weak var repMngr: UILabel!
    @IBOutlet weak var empCode: UILabel!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var tblVwSummary: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vwOuter.layer.cornerRadius = 5.0

        vwOuter.layer.shadowOpacity = 0.20
        vwOuter.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        vwOuter.layer.shadowRadius = 2.0
        vwOuter.layer.shadowColor = UIColor.black.cgColor
        vwOuter.layer.masksToBounds = false

        btnApply.layer.cornerRadius = 5
        btnApply.layer.shadowRadius = 1.0
        btnApply.layer.shadowOpacity = 0.20
        btnApply.layer.masksToBounds = false
        btnApply.layer.shadowOffset =  CGSize.init(width: 0, height: 2)

    }
    
    func setDataToViews(data : LMSSummaryData) {
        empName.text = Session.user
        dept.text = Session.department
        empCode.text = Session.empCode
        repMngr.text = Session.reportMngr
    }
    
    
    
    
}
