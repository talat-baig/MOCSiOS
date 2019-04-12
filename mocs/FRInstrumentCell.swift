//
//  FRInstrumentCell.swift
//  mocs
//
//  Created by Talat Baig on 4/5/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class FRInstrumentCell: UITableViewCell {

    @IBOutlet weak var lblContractNo: UILabel!
    @IBOutlet weak var lblCommodity: UILabel!
    @IBOutlet weak var lblInstVal: UILabel!
    @IBOutlet weak var lblInstCurr: UILabel!
    @IBOutlet weak var lblAllocNow: UILabel!
    @IBOutlet weak var lblBal: UILabel!
    @IBOutlet weak var lblProd: UILabel!
    @IBOutlet weak var lblVessel: UILabel!
    @IBOutlet weak var lblFinanceApp: UILabel!
    @IBOutlet weak var lblRefId: UILabel!
    
    @IBOutlet weak var outrVw: UIView!
    @IBOutlet weak var headerVw: UIView!
    
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
 
    func setDataToView(data : FRInstrumentData?) {
        
        lblRefId.text =  data?.allInstNo != "" ? data?.allInstNo : "-"
        lblCommodity.text =  data?.commodity != "" ? data?.commodity : "-"
        lblInstCurr.text =  data?.instCur != "" ? data?.instCur : "-"
        lblBal.text =  data?.bal != "" ? data?.bal : "-"
        lblProd.text =  data?.product != "" ? data?.product : "-"
        lblInstVal.text =  data?.instVal != "" ? data?.instVal : "-"
        lblAllocNow.text =  data?.allocNow != "" ? data?.allocNow : "-"
        lblFinanceApp.text =  data?.financeApprvl != "" ? data?.financeApprvl : "-"
        lblContractNo.text = data?.contractNo != "" ? data?.contractNo : "-"
        lblVessel.text = data?.vessel != "" ? data?.vessel : "_"
    }
}
