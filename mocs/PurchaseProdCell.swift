//
//  PurchaseProdCell.swift
//  mocs
//
//  Created by Talat Baig on 12/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class PurchaseProdCell: UITableViewCell {
    
    @IBOutlet weak var lblProdName: UILabel!
    @IBOutlet weak var outerVw: UIView!
    @IBOutlet weak var headerVw: UIView!
    @IBOutlet weak var lblLotNo: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCurr: UILabel!

    @IBOutlet weak var lblSKU: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        headerVw.layer.shadowOpacity = 0.25
        headerVw.layer.shadowOffset = CGSize(width: 1, height: 2)
        headerVw.layer.shadowRadius = 1
        headerVw.layer.shadowColor = UIColor.black.cgColor
        
        outerVw.layer.shadowOpacity = 0.25
        outerVw.layer.shadowOffset = CGSize(width: 0, height: 2)
        outerVw.layer.shadowRadius = 1
        outerVw.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataToView(data : PurchaseSummProdData) {
        
        lblProdName.text = data.prodName
        lblQty.text = data.qty
        lblPrice.text = data.price
        lblSKU.text = data.sku
        lblCurr.text = data.curr
        lblLotNo.text = data.lotNo
    }
}
