//
//  PCViewViewController.swift
//  mocs
//
//  Created by Admin on 2/21/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
class PCViewViewController: ButtonBarPagerTabStripViewController {

    let purpleInspireColor = AppColor.universalHeaderColor
    var response:Data!
    var titleHead:String!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!

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
        
        if titleHead != nil{
            self.title = titleHead
        }
        
        vwTopHeader.delegate = self
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Contract ID"
        vwTopHeader.lblSubTitle.text = titleHead
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var viewArray:[UIViewController] = [];
        let primary = self.storyboard!.instantiateViewController(withIdentifier: "PCPrimaryViewController") as! PCPrimaryViewController
        primary.response = self.response
        
        let payment = self.storyboard!.instantiateViewController(withIdentifier: "PCPaymentViewController") as! PCPaymentViewController
        payment.response = self.response
        
        let product = self.storyboard!.instantiateViewController(withIdentifier: "PCProductViewController") as! PCProductViewController
        product.response = self.response
        
        let shipment = self.storyboard!.instantiateViewController(withIdentifier: "PCShipmentViewController") as! PCShipmentViewController
        shipment.response = self.response
        
        let attachment = self.storyboard!.instantiateViewController(withIdentifier: "PCAttachmentViewController") as! PCAttachmentViewController
        attachment.refId = self.titleHead
        attachment.moduleName = Constant.MODULES.PC
        
        viewArray.append(primary)
        viewArray.append(payment)
        var jsonResponse = JSON(self.response)
        var array = jsonResponse.arrayObject as! [[String:AnyObject]]
        var rawJson = JSON.init(parseJSON: (array[0]["Products"] as! String))
        if (rawJson.null == nil) {
            if (rawJson.arrayObject as! [[String:AnyObject]]).count > 0{
                viewArray.append(product)
            }
        }
        
        viewArray.append(shipment)
        viewArray.append(attachment)
        return viewArray
    }

}

extension PCViewViewController: WC_HeaderViewDelegate {
    
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

