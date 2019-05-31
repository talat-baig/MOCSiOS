//
//  EnterKYCDetailsView.swift
//  mocs
//
//  Created by Talat Baig on 8/29/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import DropDown


class EnterKYCDetailsView: UIView {

    @IBOutlet weak var btnKYCContctType: UIButton!
    @IBOutlet weak var btnKYCRequired: UIButton!

    let arrKYCReq = ["Yes", "No"]
    let arrKYCContctType = ["Trade", "Admin", "Trade & Admin"]

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnKYCContctType.layer.cornerRadius = 5
        btnKYCContctType.layer.borderWidth = 1
        btnKYCContctType.layer.borderColor = UIColor.lightGray.cgColor
        
        
        btnKYCRequired.layer.cornerRadius = 5
        btnKYCRequired.layer.borderWidth = 1
        btnKYCRequired.layer.borderColor = UIColor.lightGray.cgColor
        
        
        btnKYCContctType.setTitle("Tap to Select", for: .normal)
        btnKYCRequired.setTitle("Tap to Select", for: .normal)
        self.backgroundColor = AppColor.univPopUpBckgColor

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
//        debugPrint("Remove NotificationCenter Deinit")
    }
    
    
    @IBAction func btnKYCContctTypeTapped(_ sender: Any) {
        
        let dropDown = DropDown()
        dropDown.anchorView = btnKYCContctType
        dropDown.dataSource = arrKYCContctType
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnKYCContctType.setTitle(item, for: .normal)
        }
        dropDown.show()
    }
    
    
    @IBAction func btnKYCReqTapped(_ sender: Any) {
        
        let dropDown = DropDown()
        dropDown.anchorView = btnKYCRequired
        dropDown.dataSource = arrKYCReq
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnKYCRequired.setTitle(item, for: .normal)
        }
        dropDown.show()
    }
    
    
    @IBAction func btnCancelTapped(_ sender: Any) {
         self.removeFromSuperviewWithAnimate()
    }
    
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        
    }
    
    
    
    
}
