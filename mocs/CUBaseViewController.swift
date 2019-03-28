//
//  CUBaseViewController.swift
//  mocs
//
//  Created by Talat Baig on 3/25/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CUBaseViewController: ButtonBarPagerTabStripViewController {

    let purpleInspireColor = UIColor(red:0.312, green:0.581, blue:0.901, alpha:1.0)
    
    var cuListData : CUListData?
    var response:Data?
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var lblTotalOutStng: UILabel!
    @IBOutlet weak var lblTotalDebit: UILabel!
    @IBOutlet weak var lblTotalCredit: UILabel!

    
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
        vwTopHeader.lblTitle.text = "Statement"
        vwTopHeader.lblSubTitle.text = cuListData?.cpID
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        self.setDatatoView()

    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var views:[UIViewController] = []
        
        let cuCreditVC = self.storyboard?.instantiateViewController(withIdentifier: "CreditStatementController") as! CreditStatementController
        cuCreditVC.response = self.response
        
        let cuDebitVC = self.storyboard?.instantiateViewController(withIdentifier: "DebitStatementController") as! DebitStatementController
        cuDebitVC.response = self.response
        views.append(cuDebitVC)
        views.append(cuCreditVC)
        
        return views
    }
    

    func setDatatoView() {
        
        lblTotalDebit.text = String(format: "Total Debit : \n%@", self.cuListData?.billed ?? "-")
        lblTotalOutStng.text =  String(format: "Total Outstanding : %@",  self.cuListData?.totalOutstanding ??  "-")
        lblTotalCredit.text =  String(format: "Total Credit : \n%@", self.cuListData?.payments ?? "-")
    }
}


extension CUBaseViewController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        
    }
    
}
