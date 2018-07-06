//
//  FilterHeaderView.swift
//  mocs
//
//  Created by Talat Baig on 5/13/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

protocol onFilterButtonTap {
    func onDone() -> Void
    func onCancel() -> Void
}


class FilterHeaderView: UIView {

    @IBOutlet weak var lable: UILabel!
    var delegate: onFilterButtonTap?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func onCancelTap(_ sender: Any) {
        if let d = delegate{
            d.onCancel()
        }
    }
    
    @IBAction func onDoneTap(_ sender: Any) {
        if let d = delegate{
            d.onDone()
        }
    }
    
}
