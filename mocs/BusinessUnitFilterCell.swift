//
//  BusinessUnitFilterCell.swift
//  mocs
//
//  Created by Talat Baig on 4/11/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class BusinessUnitFilterCell: UITableViewCell {
    
    @IBOutlet weak var btnCheck: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    var selectionItemBlock : ((BusinessUnitFilterCell) -> Void)?

    func setupCellViews(title : String){
        lblTitle.text = title
    }
    
//    func selectionButtonTapped(_ sender : AnyObject) -> Void {
//        if let action = selectionItemBlock {
//            action(self)
//        }
//    }
    
}
