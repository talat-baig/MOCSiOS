//
//  EPRViewController.swift
//  mocs
//
//  Created by Admin on 3/8/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
class EPRViewController: ButtonBarPagerTabStripViewController {
    var response:Data?
    var regId:String?
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    let purpleInspireColor = UIColor(red:0.312, green:0.581, blue:0.901, alpha:1.0)
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
        
        
        vwTopHeader.delegate = self
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Claim ID"
        vwTopHeader.lblSubTitle.text =  regId
        
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = self?.purpleInspireColor
            newCell?.label.textColor = .black
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var views:[UIViewController] = []
        
        let primary = self.storyboard?.instantiateViewController(withIdentifier: "EPRPrimaryController") as! EPRPrimaryController
        primary.response = response
        
        views.append(primary)
        
        var jsonResponse = JSON(response!)
        var array = jsonResponse.arrayObject as! [[String:AnyObject]]
        
        var rawLog = JSON.init(parseJSON: (array[0]["Payment Request Items"] as? String ?? ""))
        if rawLog.null == nil{
            if (rawLog.arrayObject as! [[String:AnyObject]]).count > 0 {
                let payment = self.storyboard?.instantiateViewController(withIdentifier: "EPRPaymentController") as! EPRPaymentController
                payment.response = rawLog
                views.append(payment)
            }
        }
        
        let voucher = UIStoryboard(name: "PurchaseContract", bundle: nil).instantiateViewController(withIdentifier: "PCAttachmentViewController") as! PCAttachmentViewController
        voucher.refId = regId!
        voucher.moduleName = Constant.MODULES.EPRECR
        
        views.append(voucher)
        return views
    }

}



extension EPRViewController: WC_HeaderViewDelegate {
    
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

