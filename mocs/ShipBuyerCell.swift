//
//  ShipBuyerCell.swift
//  mocs
//
//  Created by Talat Baig on 3/27/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class ShipBuyerCell: UITableViewCell {

    @IBOutlet weak var outrVw: UIView!
    @IBOutlet weak var headerVw: UIView!

    @IBOutlet weak var lblRefId: UILabel!
    @IBOutlet weak var lblProdName: UILabel!
    @IBOutlet weak var lblQlty: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblBrand: UILabel!

    
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
    
    func setDataToViews(data: SABuyerData){
        
        lblRefId.text = data.refID != "" ? data.refID : "-"
        lblQlty.text = data.quality != "" ? data.quality : "-"
        lblSize.text = data.size != "" ? data.size : "-"
        lblBrand.text = data.brand != "" ? data.brand : "-"
        lblProdName.text = data.product != "" ? data.product : "-"
    }
}
