//
//  CredUtilCell.swift
//  mocs
//
//  Created by Talat Baig on 3/25/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class CredUtilCell: UITableViewCell {
    
    @IBOutlet weak var lblCPName: UILabel!
    
    @IBOutlet weak var lblBilled: UILabel!
    @IBOutlet weak var lblUnbilled: UILabel!
    @IBOutlet weak var lblCredLimit: UILabel!
    @IBOutlet weak var lblAvailCredLimit: UILabel!
    @IBOutlet weak var lblPayments: UILabel!
    @IBOutlet weak var lblTotalOutstanding: UILabel!

    @IBOutlet weak var lblHeader: UILabel!
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
    
    func setDataToViews(data : CUListData?) {
        
        lblCPName.text = data?.cpName != "" ? data?.cpName : "-"
        lblBilled.text = data?.billed != "" ? data?.billed : "-"
        lblUnbilled.text = data?.unbilled != "" ? data?.unbilled : "-"
        lblHeader.text = data?.cpID != "" ? data?.cpID : "-"
        lblPayments.text = data?.payments != "" ? data?.payments : "-"
        lblCredLimit.text = data?.credLimit != "" ? data?.credLimit : "-"
        lblAvailCredLimit.text = data?.AvlCreditLimit != "" ? data?.AvlCreditLimit : "-"
    }

}
