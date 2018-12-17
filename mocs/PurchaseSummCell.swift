//
//  PurchaseSummCell.swift
//  mocs
//
//  Created by Talat Baig on 12/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class PurchaseSummCell: UITableViewCell {
    
    var data : PurchaseSummData?
    
    @IBOutlet weak var lblRefNum: UILabel!
    @IBOutlet weak var headerVw: UIView!
    @IBOutlet weak var cpName: UILabel!
    @IBOutlet weak var contrctVal: UILabel!
    @IBOutlet weak var paymntTerm: UILabel!
    @IBOutlet weak var pol: UILabel!
    @IBOutlet weak var pod: UILabel!
    @IBOutlet weak var startDte: UILabel!
    @IBOutlet weak var endDte: UILabel!
    @IBOutlet weak var delivryTrm: UILabel!
    @IBOutlet weak var grQty: UILabel!
    @IBOutlet weak var rcvdInvQty: UILabel!
    @IBOutlet weak var invAmt: UILabel!
    @IBOutlet weak var contrctStatus: UILabel!
    
    @IBOutlet weak var fundsPymnt: UILabel!
    @IBOutlet weak var outerVw: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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
    
    func setDataTOView(data : PurchaseSummData?) {
        self.data = data
        lblRefNum.text = data?.refNo
        cpName.text = data?.supplierName
        
        let val = data?.value ?? "-"
//        let valCurr = data?.valCurr ?? ""
        
//        if valCurr == "" {
            contrctVal.text = val
//        } else {
//            contrctVal.text = val + "(" + valCurr + ")"
//        }
        
        pol.text = data?.pol
        pod.text = data?.pod
        paymntTerm.text = data?.paymntTerm
        startDte.text = data?.shipStrtDte
        endDte.text = data?.shipEndDte
        fundsPymnt.text = data?.fundPaymnt
        grQty.text = data?.grQty
        delivryTrm.text = data?.delTerm
        rcvdInvQty.text = data?.rcvdInvQty
        
        let amt = data?.invAmt ?? "-"
//        let curr = data?.invCurr ?? ""
        
//        if curr == "" {
            invAmt.text = amt
//        } else {
//            invAmt.text =  amt + "(" + curr + ")"
//        }
        
        grQty.text = data?.grQty
        contrctStatus.text = data?.contractStatus
    }
    
}
