//
//  PurchaseListAdapter.swift
//  mocs
//
//  Created by Admin on 2/19/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class PurchaseListAdapter: UITableViewCell {

    @IBOutlet weak var lblRefId: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblBusiness: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCommodity: UILabel!
    @IBOutlet weak var lblSupplier: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    weak var delegate:onButtonClickListener?
    var data:PurchaseContractData?
    
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
        if(self.delegate?.responds(to: #selector(PurchaseListAdapter.onViewClick(_:))) != nil){
            delegate?.onViewClick(data: data!)
        }
    }
    @IBAction func onMailClick(_ sender: Any) {
        if(self.delegate?.responds(to: #selector(PurchaseListAdapter.onMailClick(_:))) != nil){
            delegate?.onMailClick(data: data!)
        }
    }
    @IBAction func onApproveClick(_ sender: Any) {
        if(self.delegate?.responds(to: #selector(PurchaseListAdapter.onApproveClick(_:))) != nil){
            delegate?.onApproveClick(data: data!)
        }
    }
    @IBAction func onDeclineClick(_ sender: Any) {
        if(self.delegate?.responds(to: #selector(PurchaseListAdapter.onDeclineClick(_:))) != nil){
            delegate?.onDeclineClick(data: data!)
        }
    }
}
