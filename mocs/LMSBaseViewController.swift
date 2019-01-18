//
//  LMSBaseViewController.swift
//  mocs
//
//  Created by Talat Baig on 1/18/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import  XLPagerTabStrip

class LMSBaseViewController: ButtonBarPagerTabStripViewController {
    
    let purpleInspireColor = UIColor(red:0.312, green:0.581, blue:0.901, alpha:1.0)
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    var isFromView : Bool = false
    
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
        vwTopHeader.lblTitle.text = "Leave Request"
        vwTopHeader.lblSubTitle.text = ""
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        var viewArray:[UIViewController] = []
        
        
        if isFromView {
            //            let tcNonEditVC = self.storyboard?.instantiateViewController(withIdentifier: "TravelClaimNonEditController") as! LMSAddEditController
            //            tcNonEditVC.response = response
            //            self.notifyChilds = tcNonEditVC
            //            viewArray.append(tcNonEditVC)
        } else {
            let lmsAddEditVC = self.storyboard?.instantiateViewController(withIdentifier: "LMSAddEditController") as! LMSAddEditController
            //            tcAddEditVC.response = response
            //            tcAddEditVC.tcrNo = tcrData.headRef
            //            tcAddEditVC.okTCRSubmit = self
            //            self.notifyChilds = tcAddEditVC
            //            tcAddEditVC.counter = tcrData.counter
            viewArray.append(lmsAddEditVC)
        }
        
        
//                let tcVouchersVC = self.storyboard?.instantiateViewController(withIdentifier: "VouchersListViewController") as! VouchersListViewController
        //        tcVouchersVC.tcrData = tcrData
        //        tcVouchersVC.isFromView = isFromView
        //        tcVouchersVC.moduleName = Constant.MODULES.LMS
        //        tcVouchersVC.vouchResponse = voucherResponse
        //        tcVouchersVC.ucNotifyDelegate = self
        
        //        viewArray.append(lmsAddEditVC)
        //        viewArray.append(tcVouchersVC)
        //
                return viewArray
            }
    
    
}
    extension LMSBaseViewController: WC_HeaderViewDelegate {
        
        func backBtnTapped(sender: Any) {
            
        }
        
        func topMenuLeftButtonTapped(sender: Any) {
            self.presentLeftMenuViewController(sender as AnyObject)
        }
        
        func topMenuRightButtonTapped(sender: Any) {
            self.presentRightMenuViewController(sender as AnyObject)
            
        }
        
}


