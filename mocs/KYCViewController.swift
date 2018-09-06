//
//  KYCViewController.swift
//  mocs
//
//  Created by Talat Baig on 8/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class KYCViewController: ButtonBarPagerTabStripViewController, IndicatorInfoProvider {

    let purpleInspireColor = UIColor(red:0.312, green:0.581, blue:0.901, alpha:1.0)

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "KYC DETAILS")
    }
    
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!

    override func viewDidLoad() {
        
        settings.style.buttonBarBackgroundColor = AppColor.lightestBlue
        settings.style.buttonBarItemBackgroundColor = AppColor.lightestBlue
        settings.style.selectedBarBackgroundColor = .black
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = purpleInspireColor
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        super.viewDidLoad()
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = self?.purpleInspireColor
            newCell?.label.textColor = .black
        }
        
        vwTopHeader.delegate = self
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "KYC DETAILS"
        vwTopHeader.lblSubTitle.text = "CP-001678"
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        var views:[UIViewController] = []
        
        let kycPrimary = self.storyboard?.instantiateViewController(withIdentifier: "KYCPrimaryViewController") as! KYCPrimaryViewController
      
        let transDetails = self.storyboard?.instantiateViewController(withIdentifier: "TransactionDetailsController") as! TransactionDetailsController
        
        let legal = self.storyboard?.instantiateViewController(withIdentifier: "LegalInfoController") as! LegalInfoController
        
        let financial = self.storyboard?.instantiateViewController(withIdentifier: "FinancialInfoController") as! FinancialInfoController
        
        let initiation = self.storyboard?.instantiateViewController(withIdentifier: "InitiationViewController") as! InitiationViewController

        let kycApprovl = self.storyboard?.instantiateViewController(withIdentifier: "KYCApprovalController") as! KYCApprovalController

        let kycAttachmnt = self.storyboard?.instantiateViewController(withIdentifier: "KYCAttachmentController") as! KYCAttachmentController

        
        views.append(kycPrimary)
        views.append(transDetails)
        views.append(legal)
        views.append(financial)
        views.append(initiation)
        views.append(kycApprovl)
        views.append(kycAttachmnt)

        return views
    }


}



extension KYCViewController: WC_HeaderViewDelegate {
    
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
