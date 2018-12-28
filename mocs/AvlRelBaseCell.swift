//
//  AvlRelBaseCell.swift
//  mocs
//
//  Created by Talat Baig on 11/15/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class AvlRelBaseCell: UITableViewCell {
    
    @IBOutlet weak var btnAvlRel: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnAvlRel.layer.cornerRadius = btnAvlRel.frame.size.width/2
     
        self.btnAvlRel.layer.masksToBounds = false
        self.btnAvlRel.layer.shadowColor = UIColor.black.cgColor
        self.btnAvlRel.layer.shadowOpacity = 0.25
        self.btnAvlRel.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.btnAvlRel.layer.shadowRadius = 1
    }
    
    
    @IBAction func btnAvlRelTapped(_ sender: Any) {
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
