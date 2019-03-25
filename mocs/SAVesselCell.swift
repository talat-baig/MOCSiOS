//
//  SAVesselCell.swift
//  mocs
//
//  Created by Talat Baig on 3/12/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class SAVesselCell: UITableViewCell {

    @IBOutlet weak var outrVw: UIView!
    
    @IBOutlet weak var headerVw: UIView!
    
    @IBOutlet weak var lblVesslName: UILabel!
    @IBOutlet weak var lblShipQty: UILabel!
    @IBOutlet weak var lblPOL: UILabel!
    @IBOutlet weak var lblPOD: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCurr: UILabel!
    @IBOutlet weak var lblPendingShpmnt: UILabel!
    @IBOutlet weak var lblBuyrName: UILabel!
    @IBOutlet weak var lblUOM: UILabel!
    @IBOutlet weak var lblSC: UILabel!

    @IBOutlet weak var lblhead: UILabel!
    
    
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
    
    func setDataToView(data : SAVesselData?) {
        
        lblVesslName.text = data?.vessel != "" ? data?.vessel : "-"
        lblShipQty.text = data?.shipdQty != "" ? data?.shipdQty : "-"
        lblPOL.text = data?.pol != "" ? data?.pol : "-"
        lblPOD.text = data?.pod != "" ? data?.pod : "-"
        lblPrice.text = data?.price != "" ? data?.price : "-"
        lblPendingShpmnt.text = data?.pendingShipmnt != "" ? data?.pendingShipmnt : "-"
        lblBuyrName.text = data?.buyrName != "" ? data?.buyrName : "-"
        lblUOM.text = data?.uom != "" ? data?.uom : "-"
        lblSC.text = data?.salesContrct != "" ? data?.salesContrct : "-"
        lblhead.text = data?.refID != "" ? data?.refID : "-"
    }
    
}
