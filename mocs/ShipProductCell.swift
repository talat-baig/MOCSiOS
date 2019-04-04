//
//  ShipProductCell.swift
//  mocs
//
//  Created by Talat Baig on 3/27/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class ShipProductCell: UITableViewCell {

    @IBOutlet weak var outrVw: UIView!
    @IBOutlet weak var headerVw: UIView!

    @IBOutlet weak var lblBlNo: UILabel!
    @IBOutlet weak var lblBlDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblSAStatus: UILabel!
    @IBOutlet weak var lblQty: UILabel!

    
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
    
    func setDataToView(data : ShipAppProdData?) {
        
        lblQty.text = data?.qty != "" || data?.qty != nil ? data?.qty : "-"
        lblValue.text = data?.value != "" || data?.value != nil ? data?.value : "-"
        lblPrice.text = data?.price != "" || data?.price != nil ? data?.price : "-"
        lblBlNo.text =  data?.blNo != "" || data?.blNo != nil ? data?.blNo : "-"
        lblBlDate.text = data?.blDate != "" || data?.blDate != nil ? data?.blDate : "-"
        lblSAStatus.text = data?.saStatus != "" || data?.saStatus != nil ? data?.saStatus : "-"
    }
    
}
