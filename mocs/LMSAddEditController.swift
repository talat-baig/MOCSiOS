//
//  LMSAddEditController.swift
//  mocs
//
//  Created by Talat Baig on 1/18/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NotificationCenter
import DropDown
import SwiftyJSON
import Alamofire

class LMSAddEditController: UIViewController,IndicatorInfoProvider, UIGestureRecognizerDelegate {

    @IBOutlet weak var vwTopHeader: WC_HeaderView!

    @IBOutlet weak var vwLeaveType: UIView!
    @IBOutlet weak var vwLeavePeriod: UIView!
    @IBOutlet weak var vwNoOfDays: UIView!
    @IBOutlet weak var vwContact: UIView!
    @IBOutlet weak var vwManager: UIView!
    @IBOutlet weak var vwReason: UIView!
    @IBOutlet weak var vwDelegation: UIView!

    @IBOutlet weak var btnLeaveType: UIButton!
    
    
    @IBOutlet weak var txtFldFrom: UITextField!
    @IBOutlet weak var txtFldTo: UITextField!

    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
    

    func initialSetup(){
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.isHidden = true
        
        Helper.addBordersToView(view: vwNoOfDays)
        Helper.addBordersToView(view: vwLeaveType)
        Helper.addBordersToView(view: vwLeavePeriod)

        Helper.addBordersToView(view: vwManager)
        Helper.addBordersToView(view: vwContact)
        Helper.addBordersToView(view: vwReason)
        Helper.addBordersToView(view: vwDelegation)

    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @IBAction func btnLeaveTypeTapped(_ sender: Any) {
    }
}



extension LMSAddEditController: WC_HeaderViewDelegate {
    
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
