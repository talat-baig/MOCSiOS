//
//  FPSListCell.swift
//  mocs
//
//  Created by Talat Baig on 1/3/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class FPSListCell: UITableViewCell {

    
    @IBOutlet weak var vwInner: UIView!
    
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblBU: UILabel!
    @IBOutlet weak var lblLocation: UILabel!

    @IBOutlet weak var lblPaid: UILabel!
    @IBOutlet weak var lblReq: UILabel!
    @IBOutlet weak var lblBal: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataToView(data : SSListData?) {
        lblCompany.text = data?.company
        lblLocation.text = data?.location
        lblBU.text = data?.bVertical
        lblPaid.text = data?.totalPaid
        lblBal.text = data?.totalValUSD
        lblReq.text = data?.totalRequested
    }
    
}
