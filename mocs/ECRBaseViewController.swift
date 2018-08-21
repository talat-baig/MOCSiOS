//
//  ECRBaseViewController.swift
//  mocs
//
//  Created by Talat Baig on 6/13/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import  XLPagerTabStrip


protocol onECRUpdate {
    func onECRUpdateClick()
}

class ECRBaseViewController: ButtonBarPagerTabStripViewController, onECRSubmit, UC_NotifyComplete {
    
    
    
    let purpleInspireColor = UIColor(red:0.312, green:0.581, blue:0.901, alpha:1.0)
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    var isFromView : Bool = false
    var response:Data?
    var voucherResponse: Data?
    var ecrBaseDelegate: onECRUpdate?
    var notifyChilds : notifyChilds_UC?
    var ecrData = EmployeeClaimData()
    var paymntRes:Data?
    
    override func viewDidLoad() {
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = AppColor.universalHeaderColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor.darkGray
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarMinimumInteritemSpacing = 0
        // Do any additional setup after loading the view.
        
        super.viewDidLoad()
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = self?.purpleInspireColor
        }
        
        vwTopHeader.delegate = self
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Employee Claim"
        vwTopHeader.lblSubTitle.text = ecrData.headRef
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        var viewArray:[UIViewController] = []
        
        if isFromView {
            
            let ecNonEditVC = self.storyboard?.instantiateViewController(withIdentifier: "EmployeeClaimNonEditVC") as! EmployeeClaimNonEditVC
            ecNonEditVC.ecrData = self.ecrData
            viewArray.append(ecNonEditVC)
        } else {
            
            let ecAddEditVC = self.storyboard?.instantiateViewController(withIdentifier: "EmployeeClaimAddEditVC") as! EmployeeClaimAddEditVC
            self.notifyChilds = ecAddEditVC
            ecAddEditVC.ecrNo = ecrData.headRef
            ecAddEditVC.okECRSubmit = self
            ecAddEditVC.ecrDta = self.ecrData
            viewArray.append(ecAddEditVC)
        }
        
        let ecrExpenseVC = self.storyboard?.instantiateViewController(withIdentifier: "ECRExpenseListVC") as! ECRExpenseListVC
        ecrExpenseVC.isFromView = isFromView
        ecrExpenseVC.paymntRes = paymntRes
        ecrExpenseVC.ecrData = self.ecrData
        
        
        let ecrVoucher = self.storyboard?.instantiateViewController(withIdentifier: "ECRVoucherListVC") as! ECRVoucherListVC
        ecrVoucher.isFromView = isFromView
        
        
        viewArray.append(ecrExpenseVC)
        viewArray.append(ecrVoucher)
        return viewArray
    }
    
    
    
    
    func notifyUCVouchers(messg: String, success: Bool) {
        //         Helper.showMessage(message: messg, style: .success)
        if let d = notifyChilds {
            d.notifyChild(messg: messg, success : success)
        }
    }
    
    
    func onOkClick() {
        if let d = self.ecrBaseDelegate {
            d.onECRUpdateClick()
        }
    }
    
    
}

extension ECRBaseViewController: WC_HeaderViewDelegate {
    
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


