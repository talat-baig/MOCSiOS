//
//  AvlRelListCell.swift
//  mocs
//
//  Created by Talat Baig on 11/15/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class AvlRelListCell: UITableViewCell {
    
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var innerVw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        innerVw.layer.shadowOpacity = 0.25
        innerVw.layer.shadowOffset = CGSize(width: -2, height: 1)
        innerVw.layer.shadowRadius = 1
        innerVw.layer.shadowColor = UIColor.black.cgColor
    }

    func setVesselDataToView(data: VesselList) {
        lblName.text = data.vesselName
        lblQty.text = data.relAvlSale
        lblText.text = "Vessel Name"
    }
    
    func setProductDataToView(data: AvlRelProductData) {
        lblName.text = data.prodName
        lblQty.text = data.prodQty
        lblText.text = "Product Name"
    }
    
    func setWarehouseDataToView(data: WarehouseData) {
        lblName.text = data.wareName
        lblQty.text = data.wareQty
        lblText.text = "Warehouse Name"
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
