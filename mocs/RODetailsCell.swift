//
//  RODetailsCell.swift
//  mocs
//
//  Created by Talat Baig on 11/19/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class RODetailsCell: UITableViewCell {

    var data : ROWHRData?
    @IBOutlet weak var lblVessel: UILabel!
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var lblBagSize: UILabel!
    @IBOutlet weak var lblQuality: UILabel!
    @IBOutlet weak var outerVw: UIView!

    @IBOutlet weak var lblWhrNo: UILabel!
    @IBOutlet weak var lblManual: UILabel!
    @IBOutlet weak var lblRelAvlSale: UILabel!
    @IBOutlet weak var lblRelPending: UILabel!

    @IBOutlet weak var btnSendMail: UIButton!
    
    @IBOutlet weak var whrHeaderVw: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outerVw.layer.shadowOpacity = 0.25
        outerVw.layer.shadowOffset = CGSize(width: 2, height: 2)
        outerVw.layer.shadowRadius = 1
        outerVw.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataTOView(data : ROWHRData?) {
        
        self.data = data
        lblVessel.text = data?.vessel
        lblBrand.text = data?.brand
        lblQuality.text = data?.quality
        lblBagSize.text = data?.bagSize
        lblManual.text = data?.whrManual
        lblWhrNo.text = data?.whrNum

        lblRelAvlSale.text = data?.relForSale
        lblRelPending.text = data?.relPending
       
    }
    
    
    @IBAction func btnSendMailTapped(_ sender: Any) {
    }
    
    
}
