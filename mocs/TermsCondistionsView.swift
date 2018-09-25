//
//  TermsCondistionsView.swift
//  mocs
//
//  Created by Talat Baig on 9/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class TermsCondistionsView: UIView {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = AppColor.univPopUpBckgColor
    }
    
    @IBAction func btnOKTapped(_ sender: Any) {
      self.removeFromSuperview()
    }
}
