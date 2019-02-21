//
//  ECREmpListCell.swift
//  mocs
//
//  Created by Talat Baig on 2/19/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class ECREmpListCell: UITableViewCell {

    
    @IBOutlet weak var outerVw: UIView!
    @IBOutlet weak var headerVw: UIView!

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmpId: UILabel!
    @IBOutlet weak var lblReq: UILabel!
    @IBOutlet weak var lblPaid: UILabel!
    @IBOutlet weak var lblCurr: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        outerVw.layer.shadowOpacity = 0.25
        outerVw.layer.shadowOffset = CGSize(width: 0, height: 2)
        outerVw.layer.shadowRadius = 1
        outerVw.layer.shadowColor = UIColor.black.cgColor
        
        headerVw.layer.shadowOpacity = 0.25
        headerVw.layer.shadowOffset = CGSize(width: 1, height: 2)
        headerVw.layer.shadowRadius = 1
        headerVw.layer.shadowColor = UIColor.black.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataToView(data:ECREmpData){
        
        lblName.text! = data.empName
        lblEmpId.text! = data.empId
        lblReq.text! = data.totalReq
        lblPaid.text! = data.totalPaid
//        lblCurr.text! = data.curr
    }
    
}
