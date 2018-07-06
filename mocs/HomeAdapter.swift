//
//  HomeAdapter.swift
//  mocs
//
//  Created by Admin on 30/03/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Kingfisher
class HomeAdapter: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var btnMore: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataToView(data:NewsData){
        let url = URL(string: data.imgSrc)
        posterImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "home_placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
        lblTitle.text = data.title
        let newStr = data.description.replacingOccurrences(of: "<br>", with: "\n")
        lblDescription.text = Helper.removingRegexMatches(str: newStr, pattern: "<.*?>")
    }
    
    @IBAction func more_click(_ sender: Any) {
        
    }
    
}
