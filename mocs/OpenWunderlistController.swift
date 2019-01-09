//
//  OpenWunderlistController.swift
//  mocs
//
//  Created by Talat Baig on 12/4/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit



class OpenWunderlistController: UIViewController {

    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Task Manager"
        vwTopHeader.lblSubTitle.isHidden = true
        
    }

}



// MARK: - WC_HeaderViewDelegate methods
extension OpenWunderlistController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
    
}
