//
//  PendingApprovalCell.swift
//  mocs
//
//  Created by Talat Baig on 1/30/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class PendingApprovalCell: UITableViewCell {
    
    
    @IBOutlet weak var outrVw: UIView!
    
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblModName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        outrVw.layer.shadowOpacity = 0.25
        outrVw.layer.shadowOffset = CGSize(width: 0, height: 2)
        outrVw.layer.shadowRadius = 1.5
        outrVw.layer.shadowColor = UIColor.gray.cgColor
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataToView(data : PAData){
        
    }
    
    func setDataToView(title : String, count : String){
        lblCount.text = count
        lblModName.text = title
        
    }
    
}
