//
//  CompanyFilterCell.swift
//  mocs
//
//  Created by Talat Baig on 4/11/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class CompanyFilterCell: UITableViewCell {
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCellViews(title : String){
        lblTitle.text = title
    }
    
}
