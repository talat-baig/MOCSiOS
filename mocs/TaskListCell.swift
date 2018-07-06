//
//  TaskListCell.swift
//  mocs
//
//  Created by Talat Baig on 4/16/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class TaskListCell: UITableViewCell {

    /// Label Title
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
   
    /// Set data to UI elements
    func setDataToView(data : TaskData) {
        self.lblTitle.text = data.taskName
    }

}
