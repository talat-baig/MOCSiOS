//
//  LMSGridTableView.swift
//  mocs
//
//  Created by Talat Baig on 1/25/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class LMSGridTableView: UITableView {
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
