//
//  EPRListCell.swift
//  mocs
//
//  Created by Talat Baig on 4/23/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class EPRListCell: UITableViewCell {

    
    @IBOutlet weak var btnCheckUncheck: UIButton!
    @IBOutlet weak var lblRefId: UILabel!
    @IBOutlet weak var LblAmt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupDataToView(tcrEPRData : TCREPRListData,  isSelected:Bool? = false ) {
        lblRefId.text = tcrEPRData.eprRefId
        LblAmt.text = tcrEPRData.eprAmt
        
        if isSelected! {
            btnCheckUncheck.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        } else {
            btnCheckUncheck.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        }
    }
    
    @IBAction func btnCheckTapped(_ sender: Any) {
        
        
    }
    
   
    
}
