//
//  TopHeaderView.swift
//  
//
//  Created by Talat Baig on 3/23/18.
//

import UIKit
import AKSideMenu


protocol topHeaderVwDelegate {
    
    func topMenuLeftBtnTapped(sender: Any)
    func topMenuRightBtnTapped(sender: Any)
}

class TopHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var btnMenu: UIButton!
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    
    @IBOutlet weak var btnFilter: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var delegate: topHeaderVwDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView = loadNib()
        // use bounds not frame or it'll be offset
        contentView.frame = bounds
        // Adding custom subview on top of our view
        addSubview(contentView)
        contentView.frame = self.bounds
    }
    
    @IBAction func presentLeftMenu(_ sender: Any) {
        if let d = delegate {
            d.topMenuLeftBtnTapped(sender: sender)
        }
    }
    
    /// Top view right button tap event action
    @IBAction func presentRightMenu(_ sender: Any) {
        if let d = delegate {
            d.topMenuRightBtnTapped(sender: sender)
        }
    }
}


