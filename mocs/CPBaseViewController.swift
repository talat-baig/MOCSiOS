//
//  CPBaseViewController.swift
//  mocs
//
//  Created by Talat Baig on 8/27/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip



protocol onCPUpdate {
    func onCPUpdateClick()
}

protocol onProcessItemClickListener: NSObjectProtocol {
    
    func onApprove(data: CPListData) -> Void
    func onDecline(data: CPListData) -> Void
    func onCancelClick() -> Void
}


class CPBaseViewController: ButtonBarPagerTabStripViewController, onCPApprove {
   
   
    let purpleInspireColor = UIColor(red:0.312, green:0.581, blue:0.901, alpha:1.0)
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    var cpResponse : Data?
    var bnkCredResponse : Data?
    var relResponse : Data?
    var cpListData = CPListData()
    
    var processItemDelegte : onProcessItemClickListener?
    var cpBaseDel: onCPUpdate?
    
    override func viewDidLoad() {
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
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
        vwTopHeader.btnRight.isHidden = false
        
        vwTopHeader.btnRight.setImage(nil, for: .normal)
        vwTopHeader.lblTitle.text = "Counterparty Profile"
        vwTopHeader.lblSubTitle.text = cpListData.custId
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var views:[UIViewController] = []
        
        let cpPrimary = self.storyboard?.instantiateViewController(withIdentifier: "CPPrimaryViewController") as! CPPrimaryViewController
        cpPrimary.primResponse = cpResponse
        
        let kycVC = self.storyboard?.instantiateViewController(withIdentifier: "KYCDetailsController") as! KYCDetailsController
        kycVC.cpData = cpListData
        kycVC.kycResp = cpResponse
        kycVC.okCPApprove = self
//        self.processItemDelegte = kycVC
        
        let bnkAccnt = self.storyboard?.instantiateViewController(withIdentifier: "BankAccountsController") as! BankAccountsController
        bnkAccnt.response = bnkCredResponse
        
        
        let relationshp = self.storyboard?.instantiateViewController(withIdentifier: "RelationshipController") as! RelationshipController
        relationshp.response = relResponse
        
        let attachment = UIStoryboard(name: "PurchaseContract", bundle: nil).instantiateViewController(withIdentifier: "PCAttachmentViewController") as! PCAttachmentViewController
        attachment.isFromCP = true
        attachment.refId = cpListData.cpName
        
        views.append(cpPrimary)
        views.append(bnkAccnt)
        views.append(relationshp)
        views.append(kycVC)
        views.append(attachment)
        return views
    }
    
    func onOkCPClick() {
        if let d = self.cpBaseDel {
            d.onCPUpdateClick()
        }
    }
    
    func onOkClick() {
        if let d = self.cpBaseDel {
            d.onCPUpdateClick()
        }
    }
    
}



extension CPBaseViewController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        
    }

}
