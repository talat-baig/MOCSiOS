//
//  LMSEmpDataCell.swift
//  mocs
//
//  Created by Talat Baig on 1/14/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class LMSEmpDataCell: UITableViewCell {

    @IBOutlet weak var lblDept: UILabel!
    @IBOutlet weak var lblLeaves: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblEmpId: UILabel!
    @IBOutlet weak var btnView: UIButton!
    
    @IBOutlet weak var headerVw: UIView!
    @IBOutlet weak var outrVw: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outrVw.layer.shadowOpacity = 0.25
        outrVw.layer.shadowOffset = CGSize(width: 0, height: 2)
        outrVw.layer.shadowRadius = 1
        outrVw.layer.shadowColor = UIColor.black.cgColor
        
        headerVw.layer.shadowOpacity = 0.25
        headerVw.layer.shadowOffset = CGSize(width: 1, height: 2)
        headerVw.layer.shadowRadius = 1
        headerVw.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataToViews(data : LMSEmpData?) {
        
        lblDept.text = data?.dept
        
        let empName = data?.empName ?? ""
        let empId = data?.empId ?? ""
        
        lblEmpId.text  = empName + "-" + empId 
        lblReason.text = data?.reason
        lblLeaves.text = data?.noOfLeaves
        lblStatus.text = data?.status

    }
    
   
    
}
