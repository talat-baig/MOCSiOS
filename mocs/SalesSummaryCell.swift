//
//  SalesSummaryCell.swift
//  mocs
//
//  Created by Talat Baig on 12/10/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class SalesSummaryCell: UITableViewCell {

    var data : SalesSummData?
    
    @IBOutlet weak var lblRefNum: UILabel!
    @IBOutlet weak var headerVw: UIView!
    @IBOutlet weak var cpName: UILabel!
    @IBOutlet weak var contrctVal: UILabel!
    @IBOutlet weak var paymntTerm: UILabel!
    @IBOutlet weak var pol: UILabel!
    @IBOutlet weak var pod: UILabel!
    @IBOutlet weak var startDte: UILabel!
    @IBOutlet weak var endDte: UILabel!
    @IBOutlet weak var invAmt: UILabel!
    @IBOutlet weak var doQty: UILabel!
    @IBOutlet weak var contrctStatus: UILabel!
    @IBOutlet weak var outerVw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        outerVw.layer.shadowOpacity = 0.25
        outerVw.layer.shadowOffset = CGSize(width: 0, height: 2)
        outerVw.layer.shadowRadius = 1
        outerVw.layer.shadowColor = UIColor.black.cgColor
        
//        let shadowSize : CGFloat = 5.0
//        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
//                                                   y: -shadowSize / 2,
//                                                   width: self.outerVw.frame.size.width + shadowSize,
//                                                   height: self.outerVw.frame.size.height + shadowSize))
//        self.outerVw.layer.masksToBounds = false
//        self.headerVw.layer.shadowColor = UIColor.black.cgColor
//        self.headerVw.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        self.headerVw.layer.shadowOpacity = 0.5
//        self.headerVw.layer.shadowPath = shadowPath.cgPath
        
        headerVw.layer.shadowOpacity = 0.25
        headerVw.layer.shadowOffset = CGSize(width: 1, height: 2)
        headerVw.layer.shadowRadius = 1
        headerVw.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataTOView(data : SalesSummData?) {
        self.data = data
        lblRefNum.text = data?.refNo
        cpName.text = data?.cpName
        contrctVal.text = data?.value
        pol.text = data?.pol
        pod.text = data?.pod
        paymntTerm.text = data?.paymntTerm
        startDte.text = data?.shipStrtDate
        endDte.text = data?.shipEndDate
        invAmt.text = data?.invAmt
        doQty.text = data?.doQty
        contrctStatus.text = data?.contrctStatus
    }
    
    
}
