//
//  APOverallCell.swift
//  mocs
//
//  Created by Talat Baig on 10/23/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class APOverallCell: UITableViewCell {

    @IBOutlet weak var lblBalPayble: UILabel!
    @IBOutlet weak var lblInvoiceAmt: UILabel!
    @IBOutlet weak var lblPaidDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataToView() {
        
       

    }
    
}
