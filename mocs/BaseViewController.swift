//
//  BaseViewController.swift
//  mocs
//
//  Created by Talat Baig on 3/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import  XLPagerTabStrip


protocol onTCRUpdate {
    func onTCRUpdateClick()
}

protocol notifyChilds_UC {
    func notifyChild(messg : String , success : Bool)
}

class BaseViewController: ButtonBarPagerTabStripViewController, onTCRSubmit, UC_NotifyComplete {
   
    
  let purpleInspireColor = UIColor(red:0.312, green:0.581, blue:0.901, alpha:1.0)
  
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    var isFromView : Bool = false
    var response:Data?
    var voucherResponse: Data?

    var tcrData = TravelClaimData()
    var tcrBaseDelegate: onTCRUpdate?
//    var cancelReqDel: cancelRequestDelegate?
    var notifyChilds : notifyChilds_UC?

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
        vwTopHeader.lblTitle.text = "Travel Claim"
        vwTopHeader.lblSubTitle.text = tcrData.headRef
         self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onOkClick() {
        if let d = self.tcrBaseDelegate {
            d.onTCRUpdateClick()
        }
    }
    
    func notifyUCVouchers(messg: String, success: Bool) {

        if let d = notifyChilds {
            d.notifyChild(messg: messg, success : success)
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var viewArray:[UIViewController] = []
        
        if isFromView {
            let tcNonEditVC = self.storyboard?.instantiateViewController(withIdentifier: "TravelClaimNonEditController") as! TravelClaimNonEditController
            tcNonEditVC.response = response
            self.notifyChilds = tcNonEditVC
            viewArray.append(tcNonEditVC)
        } else {
            let tcAddEditVC = self.storyboard?.instantiateViewController(withIdentifier: "TravelClaimEditAddController") as! TravelClaimEditAddController
            tcAddEditVC.response = response
            tcAddEditVC.tcrNo = tcrData.headRef
            tcAddEditVC.okTCRSubmit = self
            self.notifyChilds = tcAddEditVC
            tcAddEditVC.counter = tcrData.counter
            viewArray.append(tcAddEditVC)
        }
        
        
        let tcExpenseVC = self.storyboard?.instantiateViewController(withIdentifier: "ExpenseListViewController") as! ExpenseListViewController
        tcExpenseVC.isFromView = isFromView
        tcExpenseVC.tcrData = tcrData
        self.notifyChilds = tcExpenseVC
        tcExpenseVC.response = response
        
        let tcVouchersVC = self.storyboard?.instantiateViewController(withIdentifier: "VouchersListViewController") as! VouchersListViewController
        tcVouchersVC.tcrData = tcrData
        tcVouchersVC.isFromView = isFromView
        tcVouchersVC.moduleName = Constant.MODULES.TCR
        tcVouchersVC.vouchResponse = voucherResponse
        tcVouchersVC.ucNotifyDelegate = self
        
        viewArray.append(tcExpenseVC)
        viewArray.append(tcVouchersVC)

        return viewArray
    }
    

}


extension BaseViewController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        //        self.navigationController?.popViewController(animated: true)
//        if GlobalVariables.shared.isUploadingSomething {
//            let alert = UIAlertController(title: "Going back would cancel file uploading?", message: "Do you wish to continue", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
//            alert.addAction(UIAlertAction(title: "YES", style: .destructive, handler: { (UIAlertAction) -> Void in
//
//                if let d = self.cancelReqDel {
//                    d.cancelUploadReq()
//                }
//                self.navigationController?.popViewController(animated: true)
//            }))
//            self.present(alert, animated: true, completion: nil)
//        } else {
            self.navigationController?.popViewController(animated: true)
//        }
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
        
    }
    
}

