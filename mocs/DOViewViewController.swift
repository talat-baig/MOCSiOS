//
//  DOViewViewController.swift
//  mocs
//
//  Created by Admin on 2/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON
class DOViewViewController: ButtonBarPagerTabStripViewController {

    var response:Data?
    var refId:String?
    
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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

        vwTopHeader.delegate = self
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Contract ID"
        vwTopHeader.lblSubTitle.text = refId
        
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
        var viewArray:[UIViewController] = []
        
        let primary = self.storyboard!.instantiateViewController(withIdentifier: "DOPrimaryControllerViewController") as! DOPrimaryControllerViewController
        primary.response = response
        
        let product = self.storyboard!.instantiateViewController(withIdentifier: "DOProductController") as! DOProductController
        
        let logistics = self.storyboard!.instantiateViewController(withIdentifier: "DOLogisticsController") as! DOLogisticsController
        
        let attachment = UIStoryboard(name: "PurchaseContract", bundle: nil).instantiateViewController(withIdentifier: "PCAttachmentViewController") as! PCAttachmentViewController
        attachment.refId = refId!
        attachment.moduleName = "DO"
        
        viewArray.append(primary)
        var jsonResponse = JSON(self.response!)
        var array = jsonResponse.arrayObject as! [[String:AnyObject]]

        var rawPro = JSON.init(parseJSON: (array[0]["Release Order Details"]  as? String ?? ""))
        if (rawPro.null == nil) {
            if (rawPro.arrayObject as! [[String:AnyObject]]).count > 0{
                product.response = rawPro
                viewArray.append(product)
            }
        }

        var rawLog = JSON.init(parseJSON: (array[0]["Do Logistics"]  as? String ?? ""))
        if rawLog.null == nil{
            if (rawLog.arrayObject as! [[String:AnyObject]]).count > 0 {
                logistics.response = rawLog
                viewArray.append(logistics)
            }
        }
        
        viewArray.append(attachment)
        
        return viewArray
    }

}


extension DOViewViewController: WC_HeaderViewDelegate {
    
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

