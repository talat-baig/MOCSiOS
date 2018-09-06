//
//  CPCell.swift
//  mocs
//
//  Created by Talat Baig on 8/27/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class CPCell: UITableViewCell {
    
    @IBOutlet weak var vwInner: UIView!
    
    @IBOutlet weak var lblCPName: UILabel!
    
    @IBOutlet weak var lblContactType: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblBranchCity: UILabel!
    @IBOutlet weak var lblPostalCode: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    
    @IBOutlet weak var lblCustomerId: UILabel!
    
    
    
    
    
    
    weak var delegate:onButtonClickListener?
    
    var data:CPListData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwInner.layer.borderWidth = 1
        self.vwInner.layer.borderColor = AppColor.universalHeaderColor.cgColor
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setDataToView(data:CPListData){
        
        lblCustomerId.text! = data.custId
        
        lblCPName.text! = data.cpName
        
        if data.email == "" {
            lblEmail.text! = "-"
        } else {
            lblEmail.text! = data.email
        }
        
        
        lblContactType.text! = data.contactType
        lblBranchCity.text! = data.branchCity
        lblPostalCode.text! = data.zipPostalCode
        lblCountry.text! = data.country
        self.data = data
    }
    
    @IBAction func onViewClick(_ sender: Any) {
        if(self.delegate?.responds(to: #selector(CPCell.onViewClick(_:))) != nil){
            delegate?.onViewClick(data: data!)
        }
    }
    
    @IBAction func onMailClick(_ sender: Any) {
        
        if(self.delegate?.responds(to: #selector(CPCell.onMailClick(_:))) != nil){
            delegate?.onMailClick(data: data!)
        }
    }
    
    @IBAction func onApproveClick(_ sender: Any) {
      
        if(self.delegate?.responds(to: #selector(CPCell.onApproveClick(_:))) != nil){
            delegate?.onApproveClick(data: data!)
        }
    }
    
    @IBAction func onDeclineClick(_ sender: Any) {
      
        if(self.delegate?.responds(to: #selector(CPCell.onDeclineClick(_:))) != nil){
            delegate?.onViewClick(data: data!)
        }
    }
    
    
}
