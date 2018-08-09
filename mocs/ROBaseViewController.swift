//
//  ROBaseViewController.swift
//  mocs
//
//  Created by Talat Baig on 7/6/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ROBaseViewController: ButtonBarPagerTabStripViewController {
    
    var roData = ROData()
    var response:Data!
    var cargoResponse : Data!
    let purpleInspireColor = UIColor(red:0.312, green:0.581, blue:0.901, alpha:1.0)
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
        
        vwTopHeader.delegate = self
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Release Order"
        vwTopHeader.lblSubTitle.text = roData.refId
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var viewArray:[UIViewController] = [];
        
        let primary = self.storyboard!.instantiateViewController(withIdentifier: "ROPrimaryViewController") as! ROPrimaryViewController
        primary.response = response
        primary.roData = roData
        
        let cargoInfo = self.storyboard!.instantiateViewController(withIdentifier: "ROCarfoInfoVC") as! ROCarfoInfoVC
        cargoInfo.cResponse = cargoResponse
        cargoInfo.roData = roData
        
        let storageInfo = self.storyboard!.instantiateViewController(withIdentifier: "ROStorageInfoVC") as! ROStorageInfoVC
        storageInfo.response = response
//        storageInfo.roData = roData
        
        
        viewArray.append(primary)
        viewArray.append(storageInfo)

        viewArray.append(cargoInfo)
        
        return viewArray
    }
    
}

extension ROBaseViewController: WC_HeaderViewDelegate {
    
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
