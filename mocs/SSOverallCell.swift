//
//  SSOverallCell.swift
//  mocs
//
//  Created by Talat Baig on 12/10/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class SSOverallCell: UITableViewCell {
    
    @IBOutlet weak var totalContractVal: UILabel!
    
    @IBOutlet weak var stckVw1: UIStackView!
    @IBOutlet weak var stckVw2: UIStackView!
    @IBOutlet weak var stckVw3: UIStackView!
    @IBOutlet weak var stckVw4: UIStackView!
    @IBOutlet weak var stckVw5: UIStackView!
    @IBOutlet weak var stckVw6: UIStackView!
    
    @IBOutlet weak var lblCurr1: UILabel!
    @IBOutlet weak var lblCurr2: UILabel!
    @IBOutlet weak var lblCurr3: UILabel!
    @IBOutlet weak var lblCurr4: UILabel!
    @IBOutlet weak var lblCurr5: UILabel!
    @IBOutlet weak var lblCurr6: UILabel!

    @IBOutlet weak var lblAmt1: UILabel!
    @IBOutlet weak var lblAmt2: UILabel!
    @IBOutlet weak var lblAmt3: UILabel!
    @IBOutlet weak var lblAmt4: UILabel!
    @IBOutlet weak var lblAmt5: UILabel!
    @IBOutlet weak var lblAmt6: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setDataToViews(data : SSListData) {
        
        self.totalContractVal.text = data.totalValUSD
      
    }
}
