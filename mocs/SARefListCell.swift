//
//  SARefListCell.swift
//  mocs
//
//  Created by Talat Baig on 3/12/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class SARefListCell: UITableViewCell {

    @IBOutlet weak var headerVw: UIView!
    @IBOutlet weak var lblRefId: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPCNo: UILabel!
    @IBOutlet weak var lblSuppName: UILabel!

    @IBOutlet weak var outerVw: UIView!
    
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
    
    func setDataToView(data:SARefData){
        
        lblRefId.text = data.refID != "" ? data.refID : "-" //
        lblDate.text = data.addDate != "" ? data.addDate : "-" //
        lblPCNo.text = data.purContract != "" ? data.purContract : "-"
        lblSuppName.text = data.suppName  != "" ? data.suppName : "-"
    }
    
}
