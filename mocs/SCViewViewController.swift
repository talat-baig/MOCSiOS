//
//  SCViewViewController.swift
//  mocs
//
//  Created by Admin on 2/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
class SCViewViewController: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!

    let purpleInspireColor = AppColor.universalHeaderColor
    var response:Data!
    var refId:String!
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
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        vwTopHeader.delegate = self
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Contract ID"
        vwTopHeader.lblSubTitle.text = self.refId
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var controllers:[UIViewController] = []
        
        let primary = self.storyboard!.instantiateViewController(withIdentifier: "SCPrimaryController") as! SCPrimaryController
        primary.response = response
        
        // Purchase Contract Payment and Sales Contract Payment are same
        // thats why using Purchase Contract Payment Screen
        let payment = UIStoryboard(name: "PurchaseContract", bundle: nil).instantiateViewController(withIdentifier: "PCPaymentViewController") as! PCPaymentViewController
        payment.response = response

        let shipment = UIStoryboard(name: "PurchaseContract", bundle: nil).instantiateViewController(withIdentifier: "PCShipmentViewController") as! PCShipmentViewController
        shipment.response = response
        
        let attachment = UIStoryboard(name: "PurchaseContract", bundle: nil).instantiateViewController(withIdentifier: "PCAttachmentViewController") as! PCAttachmentViewController
        attachment.refId = refId
        attachment.moduleName = Constant.MODULES.SC
        
        let product = UIStoryboard(name: "PurchaseContract", bundle: nil).instantiateViewController(withIdentifier: "PCProductViewController") as! PCProductViewController
        product.response = response
        
        controllers.append(primary)
        controllers.append(payment)
        controllers.append(shipment)
        var jsonResponse = JSON(self.response)
        var array = jsonResponse.arrayObject as! [[String:AnyObject]]
        var rawJson = JSON.init(parseJSON: (array[0]["Products"] as! String))
        if (rawJson.null == nil) {
            if (rawJson.arrayObject as! [[String:AnyObject]]).count > 0{
                controllers.append(product)
            }
        }
        controllers.append(attachment)
        return controllers
    }

}

extension SCViewViewController: WC_HeaderViewDelegate {
    
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
