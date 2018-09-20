//
//  TRBaseViewController.swift
//  mocs
//
//  Created by Talat Baig on 9/12/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip


protocol onTRFUpdate {
    func onTRFUpdateClick()
}


class TRBaseViewController: ButtonBarPagerTabStripViewController, onTRFSubmit {
    
    let purpleInspireColor = UIColor(red:0.312, green:0.581, blue:0.901, alpha:1.0)
    
    var trfData = TravelRequestData()
    var itinryRespone : Data?
    var trfReqNo : String = ""
    var trfBaseDelegate: onTRFUpdate?
    var isFromView : Bool = false
    var response:Data?
    
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
        vwTopHeader.lblTitle.text = "Travel Request"
        vwTopHeader.lblSubTitle.text = trfReqNo
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onOkClick() {
        if let d = self.trfBaseDelegate {
            d.onTRFUpdateClick()
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var viewArray:[UIViewController] = []
        
        
        
        if isFromView {
            let tcNonEditVC = self.storyboard?.instantiateViewController(withIdentifier: "TravelRequestNonEditVC") as! TravelRequestNonEditVC
            tcNonEditVC.trfData = trfData
            viewArray.append(tcNonEditVC)
        } else {
            let trAddEditVC = self.storyboard?.instantiateViewController(withIdentifier: "TravelRequestAddEditController") as! TravelRequestAddEditController
            trAddEditVC.response = response
            trAddEditVC.trvReqData = trfData
            trAddEditVC.reqNum = trfData.reqNo
            trAddEditVC.okTRFSubmit = self
            viewArray.append(trAddEditVC)
        }
        
        
        let iternryVC = self.storyboard?.instantiateViewController(withIdentifier: "ItineraryListController") as! ItineraryListController
        iternryVC.trfData = self.trfData
        iternryVC.itinryRes = self.itinryRespone
        iternryVC.isFromView = isFromView
        viewArray.append(iternryVC)
        
        
        return viewArray
    }
    
}


extension TRBaseViewController: WC_HeaderViewDelegate {
    
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

