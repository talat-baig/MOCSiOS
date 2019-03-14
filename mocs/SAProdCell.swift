//
//  SAProdCell.swift
//  mocs
//
//  Created by Talat Baig on 3/12/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class SAProdCell: UITableViewCell {

    @IBOutlet weak var outrVw: UIView!
    @IBOutlet weak var lblProdName: UILabel!
    @IBOutlet weak var lblSKU: UILabel!
    @IBOutlet weak var lblLotNo: UILabel!
    @IBOutlet weak var lblMOT: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        outrVw.layer.borderColor = AppColor.universalHeaderColor.cgColor
        outrVw.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataToView(data:SAProdData){
        lblProdName.text = data.prod != "" ? data.prod : "-"
        lblSKU.text = data.sku != "" ? data.sku : "-" //
        lblLotNo.text = data.lotNo != "" ? data.lotNo : "-"
        lblMOT.text = data.mode != "" ? data.mode : "-"
    }
    
}
