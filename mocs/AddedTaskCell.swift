//
//  AddedTaskCell.swift
//  mocs
//
//  Created by Talat Baig on 4/16/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class AddedTaskCell: UITableViewCell {

    /// Label New Task
    @IBOutlet weak var lblNewTask: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// Set data to Cell UI elements
    /// - Parameter task: Object of type TaskDetails
    func setDataToViews(task : TaskDetails) {
        lblNewTask.text = Helper.removingRegexMatches(str: task.tName, pattern: "<.*?>")
    }
    
}
