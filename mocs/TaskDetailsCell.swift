//
//  TaskDetailsCell.swift
//  mocs
//
//  Created by Talat Baig on 4/16/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class TaskDetailsCell: UITableViewCell {
    
    /// Label Date
    @IBOutlet weak var lblDate: UILabel!
    
    /// Label Task Title
    @IBOutlet weak var lblTaskTitle: UILabel!
    
    /// Button complete
    @IBOutlet weak var btnComplete: UIButton!
    
    /// Button Star Note
    @IBOutlet weak var btnStarNote: UIButton!
    
    /// Button Add Note
    @IBOutlet weak var btnAddNote: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    /// Set data to Cell view UI elements
    /// - Parameter task: Task Details object
    func setDataToViews(task : TaskDetails) {
        lblDate.text = task.dueDate
        lblTaskTitle.text = task.tName
        
        if task.starTask {
            btnStarNote.setImage(#imageLiteral(resourceName: "mark_star"), for: .normal)
        } else {
            btnStarNote.setImage(#imageLiteral(resourceName: "mark_unstar"), for: .normal)
        }
    }
    
    @IBAction func btnCompleteNoteTapped(_ sender: Any) {
    }
    
    @IBAction func btnAddNoteTapped(_ sender: Any) {
    }
    
    @IBAction func btnStarNoteTapped(_ sender: Any) {
    }
    
    
}
