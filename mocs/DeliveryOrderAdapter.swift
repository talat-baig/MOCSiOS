//
//  DeliveryOrderAdapter.swift
//  mocs
//
//  Created by Admin on 2/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class DeliveryOrderAdapter: UITableViewCell {

    @IBOutlet weak var refNo: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var business: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var contractValue: UILabel!
    @IBOutlet weak var creditlimit: UILabel!
    
    @IBOutlet weak var vwInner: UIView!
    weak var delegate:onButtonClickListener?
    var data:DeliveryOrderData?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwInner.layer.borderWidth = 1
        self.vwInner.layer.borderColor = AppColor.universalHeaderColor.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setDataToView(data:DeliveryOrderData){
        refNo.text! = data.refId
        company.text! = data.company
        location.text! = data.location
        business.text! = data.businessUnit
        date.text! = data.date
        customer.text! = data.customer
        contractValue.text! = data.value
        creditlimit.text! = data.creditLimit
        self.data = data
    }
    
    
    @IBAction func viewClick(_ sender: Any) {
        if(self.delegate?.responds(to: Selector(("onViewClick:"))) != nil){
            delegate?.onViewClick(data: data!)
        }
    }
    
    @IBAction func mailClick(_ sender: Any) {
        if(self.delegate?.responds(to: Selector(("onMailClick:"))) != nil){
            delegate?.onMailClick(data: data!)
        }
    }
    
    @IBAction func approveClick(_ sender: Any) {
        if(self.delegate?.responds(to: Selector(("onApproveClick:"))) != nil){
            delegate?.onApproveClick(data: data!)
        }
    }
    
    @IBAction func declineClick(_ sender: Any) {
        if(self.delegate?.responds(to: Selector(("onDeclineClick:"))) != nil){
            delegate?.onDeclineClick(data: data!)
        }
    }
}
