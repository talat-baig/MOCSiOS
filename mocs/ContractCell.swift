//
//  ContractCell.swift
//  mocs
//
//  Created by Admin on 2/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class ContractCell: UITableViewCell {

    @IBOutlet weak var lblRefId: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblBusiness: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCommodity: UILabel!
    @IBOutlet weak var lblSupplier: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    @IBOutlet weak var vwInner: UIView!
    weak var delegate:onButtonClickListener?
    var data:PurchaseContractData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwInner.layer.borderWidth = 1
        self.vwInner.layer.borderColor = AppColor.universalHeaderColor.cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataToView(data:PurchaseContractData){
        lblRefId.text = data.RefNo
        lblCompany.text = data.company
        lblLocation.text = data.location
        lblBusiness.text = data.businessVertical
        lblDate.text = data.date
        lblCommodity.text = data.commodity
        lblSupplier.text = data.supplier
        lblValue.text = data.contractValue
        self.data = data
    }
    
    @IBAction func onViewClick(_ sender: Any) {
        if(self.delegate?.responds(to: Selector(("onViewClick:"))) != nil){
            delegate?.onViewClick(data: data!)
        }
    }
    @IBAction func onMailClick(_ sender: Any) {
        if(self.delegate?.responds(to: Selector(("onMailClick:"))) != nil){
            delegate?.onMailClick(data: data!)
        }
    }
    @IBAction func onApproveClick(_ sender: Any) {
        if(self.delegate?.responds(to: Selector(("onApproveClick:"))) != nil){
            delegate?.onApproveClick(data: data!)
        }
    }
    @IBAction func onDeclineClick(_ sender: Any) {
        if(self.delegate?.responds(to: Selector(("onDeclineClick:"))) != nil){
            delegate?.onDeclineClick(data: data!)
        }
    }

}
