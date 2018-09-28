//
//  TTBaseViewController.swift
//  mocs
//
//  Created by Talat Baig on 9/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import  XLPagerTabStrip

class TTBaseViewController: ButtonBarPagerTabStripViewController {
    
    let purpleInspireColor = UIColor(red:0.312, green:0.581, blue:0.901, alpha:1.0)
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    var isFromView : Bool = false
    var response:Data?
    var deptStr = ""
    
    
    var trvticktAddEditVC : TravelTicketAddEditVC?
    var ttInfo : TravelTicketInformationVC?

    
    
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
            
            self?.buttonBarView.allowsSelection = true

            
            if self?.deptStr == "" {
                
                

            }

        }
        
        
        vwTopHeader.delegate = self
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.lblTitle.text = "Travel Ticket"
        vwTopHeader.lblSubTitle.text = "TT12345678"
        
        if isFromView {
            vwTopHeader.btnRight.isHidden = true
        } else {
            vwTopHeader.btnRight.setTitleColor(UIColor.white, for: .normal)
            vwTopHeader.btnRight.isHidden = false
            vwTopHeader.btnRight.setTitle("SUBMIT", for: .normal)
        }
        
        vwTopHeader.btnRight.setImage(nil, for: .normal)
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    func saveTTAddEditReference(vc:TravelTicketAddEditVC){
        self.trvticktAddEditVC = vc
    }
    
    func saveTTInfoReference(vc:TravelTicketInformationVC){
        self.ttInfo = vc
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var viewArray:[UIViewController] = []
        
        if isFromView {
          
            let ttPrimNonEdit = self.storyboard?.instantiateViewController(withIdentifier: "TravelTicketNonEditVC") as! TravelTicketNonEditVC
            viewArray.append(ttPrimNonEdit)
            
            let ttcktNonEdit = self.storyboard?.instantiateViewController(withIdentifier: "TravelTicketNonEditInfoVC") as! TravelTicketNonEditInfoVC
            viewArray.append(ttcktNonEdit)
            
            let ttItinry = self.storyboard?.instantiateViewController(withIdentifier: "TTItineraryListVC") as! TTItineraryListVC
            ttItinry.isFromView = self.isFromView
            viewArray.append(ttItinry)

             let attachment = UIStoryboard(name: "PurchaseContract", bundle: nil).instantiateViewController(withIdentifier: "PCAttachmentViewController") as! PCAttachmentViewController
            viewArray.append(attachment)

            
        } else {
            let ttAddEditVC = self.storyboard?.instantiateViewController(withIdentifier: "TravelTicketAddEditVC") as! TravelTicketAddEditVC
            viewArray.append(ttAddEditVC)
            
            let ttInfo = self.storyboard?.instantiateViewController(withIdentifier: "TravelTicketInformationVC") as! TravelTicketInformationVC
            viewArray.append(ttInfo)
            
            let ttItinry = self.storyboard?.instantiateViewController(withIdentifier: "TTItineraryListVC") as! TTItineraryListVC
            ttItinry.isFromView = self.isFromView
            viewArray.append(ttItinry)
            
            let ttVoucher = self.storyboard?.instantiateViewController(withIdentifier: "TTVoucherListVC") as! TTVoucherListVC
            viewArray.append(ttVoucher)
        }
        
//        let ttAddEditVC = self.storyboard?.instantiateViewController(withIdentifier: "TravelTicketAddEditVC") as! TravelTicketAddEditVC
//        viewArray.append(ttAddEditVC)
//
//        let ttInfo = self.storyboard?.instantiateViewController(withIdentifier: "TravelTicketInformationVC") as! TravelTicketInformationVC
//        viewArray.append(ttInfo)
//
//        let ttItinry = self.storyboard?.instantiateViewController(withIdentifier: "TTItineraryListVC") as! TTItineraryListVC
//        viewArray.append(ttItinry)
//
//        let ttVoucher = self.storyboard?.instantiateViewController(withIdentifier: "TTVoucherListVC") as! TTVoucherListVC
//        viewArray.append(ttVoucher)
        
        
        return viewArray
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    
    func processInfo() {
   
        
        guard let compny = self.trvticktAddEditVC?.btnCompany.titleLabel?.text else {
            return
        }
        
        if compny == "-" {
            self.moveToViewController(at: 0, animated: true)
            Helper.showMessage(message: "Please enter Company")
            return
        }
        
        guard let trvlrName = self.trvticktAddEditVC?.btnTrvllerName.titleLabel?.text else {
            return
        }
        
        if trvlrName == "-" {
            self.moveToViewController(at: 0, animated: true)
            Helper.showMessage(message: "Please enter Traveller Name")
            return
        }
        
        
        guard let ticktNum = self.trvticktAddEditVC?.txtDept.text, !ticktNum.isEmpty else {
            self.moveToViewController(at: 0, animated: true)
            Helper.showMessage(message: "Please enter Department")
            return
        }
        
        
        guard let carrier = self.ttInfo?.btnCarrier.titleLabel?.text else {
            return
        }
        
        if carrier == "-" {
            self.moveToViewController(at: 1, animated: true)
            Helper.showMessage(message: "Please enter Carrier")
            return
        }
        
       
        //
        //        if ttInfo.btnTrvlAgent.titleLabel?.text == "" {
        //            Helper.showMessage(message: "Please enter Traveller Agent")
        //            return
        //        }
        //
        
        //
        
    }
}


extension TTBaseViewController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {

        self.processInfo()
    }
    
}
