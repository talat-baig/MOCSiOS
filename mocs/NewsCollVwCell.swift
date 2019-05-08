//
//  NewsCollVwCell.swift
//  mocs
//
//  Created by Talat Baig on 5/7/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class NewsCollVwCell: UICollectionViewCell {

    
    @IBOutlet weak var imgVw: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblSubtitle: UILabel!

    @IBOutlet weak var outrVw: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        outrVw.layer.shadowOpacity = 0.25
        outrVw.layer.cornerRadius = 5
//        outrVw.layer.shadowRadius = 1
//        outrVw.layer.shadowColor = UIColor.gray.cgColor
        
        imgVw.layer.cornerRadius = 5
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 1.0
        
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
    }

    func setDataToView(newsData : NewsData) {
        
        self.lblTitle.text = newsData.title
        self.lblSubtitle.text = newsData.description
//        self.imgVw.image = new

        let url = URL(string: newsData.imgSrc)
        self.imgVw.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "home_placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
    }
}
