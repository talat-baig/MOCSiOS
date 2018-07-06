//
//  AttachmentCell.swift
//  mocs
//
//  Created by Admin on 2/23/18.
//  Copyright © 2018 Rv. All rights reserved.
//
import Foundation
import UIKit

class AttachmentCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var fileDesc: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var vwOuter: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        progressBar.layer.cornerRadius = 3
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 3
        progressBar.subviews[1].clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func downloadButton(_ sender: UIButton) {
    }
    
    func updateProgressAtindexpath(indexPath: IndexPath, progress: Float) {
        self.progressBar.setProgress(progress, animated: true)
    }
    
}

