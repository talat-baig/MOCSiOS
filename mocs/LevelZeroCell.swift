//
//  LevelZeroCell.swift
//  mocs
//
//  Created by Talat Baig on 6/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class LevelZeroCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var imgArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCellViews(title : String, image : UIImage){
        lblTitle.text = title
        imgIcon.image = image
    }
}
