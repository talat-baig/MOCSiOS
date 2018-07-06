//
//  TreeTableViewCell.swift
//  RATreeViewExamples
//
//  Created by Rafal Augustyniak on 22/11/15.
//  Copyright © 2015 com.Augustyniak. All rights reserved.
//

import UIKit

class TreeTableViewCell : UITableViewCell {
    
    @IBOutlet private weak var additionalButton: UIButton!
    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet private weak var customTitleLabel: UILabel!
    
    private var additionalButtonHidden : Bool {
        get {
            return additionalButton.isHidden;
        }
        set {
            additionalButton.isHidden = newValue;
        }
    }
    
    override func awakeFromNib() {
        selectedBackgroundView? = UIView()
        selectedBackgroundView?.backgroundColor = .clear
    }
    
    var additionButtonActionBlock : ((TreeTableViewCell) -> Void)?;
    
    func setup(withTitle title: String, detailsText: String, level : Int, additionalButtonHidden: Bool) {
        customTitleLabel.text = title
        detailsLabel.text = detailsText
        self.additionalButtonHidden = additionalButtonHidden
        
        let backgroundColor: UIColor
        backgroundColor = UIColor(red: 37.0/255.0, green: 108.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        
        self.backgroundColor = backgroundColor
        self.contentView.backgroundColor = backgroundColor
        
        let left = 11.0 + 20.0 * CGFloat(level)
        self.customTitleLabel.frame.origin.x = left
        self.detailsLabel.frame.origin.x = left
    }
    
    func additionButtonTapped(_ sender : AnyObject) -> Void {
        if let action = additionButtonActionBlock {
            action(self)
        }
    }
    
}
