//
//  LMSBaseViewController.swift
//  mocs
//
//  Created by Talat Baig on 1/18/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import  XLPagerTabStrip

protocol onLMSUpdate {
    func onLMSUpdateClick()
}

class LMSBaseViewController: ButtonBarPagerTabStripViewController , UC_NotifyComplete,  onTCRSubmit {
  
    
    let purpleInspireColor = UIColor(red:0.312, green:0.581, blue:0.901, alpha:1.0)
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    var isFromView : Bool = false
    var lmsReqData : LMSReqData?
    var notifyChilds : notifyChilds_UC?
    var attachmntVC : ECRVoucherListVC?
    var lmsUpdateDelgte: onLMSUpdate?

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
        vwTopHeader.lblTitle.text = "LMS-Request"
        vwTopHeader.lblSubTitle.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        var viewArray:[UIViewController] = []
//        var isEdit : Bool = false
        
 
        let lmsAttachmnt = self.storyboard?.instantiateViewController(withIdentifier: "ECRVoucherListVC") as! ECRVoucherListVC
        lmsAttachmnt.isFromView = isFromView
        lmsAttachmnt.lmsData = self.lmsReqData
        lmsAttachmnt.moduleName = Constant.MODULES.LMS
        self.saveVocuherListRef(vc: lmsAttachmnt)
        lmsAttachmnt.vouchResponse = nil
        lmsAttachmnt.ucNotifyDelegate = self
        
        let lmsAddEditVC = self.storyboard?.instantiateViewController(withIdentifier: "LMSAddEditController") as! LMSAddEditController
        lmsAddEditVC.isFromView = isFromView
        lmsAddEditVC.okLMSSubmit = self
        lmsAddEditVC.lmsReqData = self.lmsReqData
        viewArray.append(lmsAddEditVC)
        viewArray.append(lmsAttachmnt)

        return viewArray
    }
    
    func saveVocuherListRef(vc: ECRVoucherListVC){
        self.attachmntVC = vc
    }
    
    func onOkClick() {
        if let d = self.lmsUpdateDelgte {
            d.onLMSUpdateClick()
        }
    }
    
    
    func notifyUCVouchers(messg: String, success: Bool) {

        if let d = notifyChilds {
            d.notifyChild(messg: messg, success : success)
        }
    }
    
}
extension LMSBaseViewController: WC_HeaderViewDelegate {
    
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
