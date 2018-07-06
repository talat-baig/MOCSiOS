//
//  LevelTwoCell.swift
//  mocs
//
//  Created by Talat Baig on 6/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class LevelTwoCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var imgIcon: UIImageView!
    
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
