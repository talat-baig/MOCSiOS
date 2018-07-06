//
//  ECRBaseViewController.swift
//  mocs
//
//  Created by Talat Baig on 6/13/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import  XLPagerTabStrip

class ECRBaseViewController: ButtonBarPagerTabStripViewController {

    let purpleInspireColor = UIColor(red:0.312, green:0.581, blue:0.901, alpha:1.0)
     @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
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
        vwTopHeader.lblSubTitle.text = ""
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
        
//        if isFromView {
//            let tcNonEditVC = self.storyboard?.instantiateViewController(withIdentifier: "EmployeeClaimAddEditVC") as! EmployeeClaimAddEditVC
////            tcNonEditVC.response = response
////            self.notifyChilds = tcNonEditVC
//            viewArray.append(tcNonEditVC)
//        } else {
            let tcAddEditVC = self.storyboard?.instantiateViewController(withIdentifier: "EmployeeClaimAddEditVC") as! EmployeeClaimAddEditVC
            tcAddEditVC.isToUpdate = true
//            tcAddEditVC.response = response
//            tcAddEditVC.tcrNo = tcrData.headRef
//            tcAddEditVC.okTCRSubmit = self
//            self.notifyChilds = tcAddEditVC
//            tcAddEditVC.counter = tcrData.counter
            viewArray.append(tcAddEditVC)
//        }
        
        
        let tcExpenseVC = self.storyboard?.instantiateViewController(withIdentifier: "ECRExpenseListVC") as! ECRExpenseListVC
//        tcExpenseVC.isFromView = isFromView
//        tcExpenseVC.tcrData = tcrData
//        self.notifyChilds = tcExpenseVC
//        tcExpenseVC.response = response
        
        let ecrVoucher = self.storyboard?.instantiateViewController(withIdentifier: "ECRVoucherListVC") as! ECRVoucherListVC
//        tcVouchersVC.tcrData = tcrData
//        ecrVoucher.isFromView = true
//        tcVouchersVC.moduleName = Constant.MODULES.TCR
//        ecrVoucher.vouchResponse = nil
//        tcVouchersVC.ucNotifyDelegate = self
        //        self.notifyChilds = tcVouchersVC
        //        self.cancelReqDel = tcVouchersVC
        
        viewArray.append(tcExpenseVC)
        viewArray.append(ecrVoucher)
        
        return viewArray
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


