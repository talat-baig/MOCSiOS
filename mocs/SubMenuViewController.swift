//
//  SubMenuViewController.swift
//  mocs
//
//  Created by Talat Baig on 5/9/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class SubMenuViewController: UIViewController, filterViewDelegate {
    
    var navHeader = ""
    var isFilter = true
    var arrMenuTitles : [String] = []
    @IBOutlet weak var collVw: UICollectionView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    
    func initialSetup() {
        
        vwTopHeader.delegate = self
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnLeft.isHidden = true
        
        vwTopHeader.btnRight.isHidden = self.isFilter ? false : true
        
        vwTopHeader.lblTitle.text = navHeader
        vwTopHeader.lblSubTitle.isHidden = true
        
        self.title = "OCS-Home"
        FilterViewController.filterDelegate = self
        
        collVw.register(UINib.init(nibName: "HomeMenuCell", bundle: nil), forCellWithReuseIdentifier: "submenucell")
        
        let flowLayoutMenu = UICollectionViewFlowLayout()
        flowLayoutMenu.scrollDirection = UICollectionView.ScrollDirection.vertical
        collVw.collectionViewLayout = flowLayoutMenu
        collVw.showsVerticalScrollIndicator = false
        collVw.reloadData()
    }
    
    func navigateToSelectedVC( module : String = "", index : Int) {
        
        var selVC = UIViewController()
        
        switch module {
            
        case "Administrative":
            
            if index == 0 {
                
                selVC = UIStoryboard(name: "TravelClaim", bundle: nil).instantiateViewController(withIdentifier: "TravelClaimController") as! TravelClaimController
                
            } else if index == 1 {
                selVC = UIStoryboard(name: "EmployeeClaim", bundle: nil).instantiateViewController(withIdentifier: "EmployeeClaimController") as! EmployeeClaimController
                
            } else if index == 2 {
                selVC = UIStoryboard(name: "TravelRequest", bundle: nil).instantiateViewController(withIdentifier: "TravelRequestController") as! TravelRequestController
                
            } else if index == 3 {
                selVC = UIStoryboard(name: "TravelTicket", bundle: nil).instantiateViewController(withIdentifier: "TravelTicketController") as! TravelTicketController
                
            } else {
                selVC = UIStoryboard(name: "LMSReq", bundle: nil).instantiateViewController(withIdentifier: "LMSReqController") as! LMSReqController
            }
            break
            
        case "Business":
            
            if index == 0 {
                
                selVC = UIStoryboard(name: "ARReport", bundle: nil).instantiateViewController(withIdentifier: "ARReportController") as! ARReportController
                
            } else if index == 1 {
                selVC = UIStoryboard(name: "AccountsPayable", bundle: nil).instantiateViewController(withIdentifier: "APReportController") as! APReportController
                
            } else if index == 2 {
                selVC = UIStoryboard(name: "AvblReleases", bundle: nil).instantiateViewController(withIdentifier: "AvlRelBaseViewController") as! AvlRelBaseViewController
                
            } else if index == 3 {
                selVC = UIStoryboard(name: "SalesSummary", bundle: nil).instantiateViewController(withIdentifier: "SalesSummaryReportController") as! SalesSummaryReportController
                
            } else if index == 4 {
                selVC = UIStoryboard(name: "PurchaseSummry", bundle: nil).instantiateViewController(withIdentifier: "PurchaseSummRptController") as! PurchaseSummRptController
                
            } else if index == 5 {
                selVC = UIStoryboard(name: "FundsRecptAllocation", bundle: nil).instantiateViewController(withIdentifier: "FundsRcptController") as! FundsRcptController
                
            } else if index == 6 {
                selVC = UIStoryboard(name: "FundsPayment", bundle: nil).instantiateViewController(withIdentifier: "FundsPaymentController") as! FundsPaymentController
                
            } else if index == 7 {
                selVC = UIStoryboard(name: "ECRReport", bundle: nil).instantiateViewController(withIdentifier: "ECREmployeeListController") as! ECREmployeeListController
                
            } else if index == 8 {
                selVC = UIStoryboard(name: "CashAndBalance", bundle: nil).instantiateViewController(withIdentifier: "CashBankBalController") as! CashBankBalController
                
            } else if index == 9 {
                selVC = UIStoryboard(name: "CustomerLedger", bundle: nil).instantiateViewController(withIdentifier: "CLListController") as! CLListController
                
            }  else if index == 10 {
                selVC = UIStoryboard(name: "PaymentLedger", bundle: nil).instantiateViewController(withIdentifier: "PaymentLedgerController") as! PaymentLedgerController
            } else if index == 11 {
                selVC = UIStoryboard(name: "BankCharges", bundle: nil).instantiateViewController(withIdentifier: "BankChargesController") as! BankChargesController
            } else if index == 12 {
                selVC = UIStoryboard(name: "ShipmentAdvice", bundle: nil).instantiateViewController(withIdentifier: "SARefListController") as! SARefListController
            } else if index == 13 {
                selVC = UIStoryboard(name: "CreditUtilization", bundle: nil).instantiateViewController(withIdentifier: "CreditUtilListController") as! CreditUtilListController
            } else if index == 14 {
                selVC = UIStoryboard(name: "ShipmentAppropriation", bundle: nil).instantiateViewController(withIdentifier: "ShipmentAppListVC") as! ShipmentAppListVC
            } else if index == 15 {
                selVC = UIStoryboard(name: "FundsRemittance", bundle: nil).instantiateViewController(withIdentifier: "FundsRemittancListVC") as! FundsRemittancListVC
            } else if index == 16 {
                selVC = UIStoryboard(name: "ExportPresentation", bundle: nil).instantiateViewController(withIdentifier: "ExportPresentationListVC") as! ExportPresentationListVC
            } else  {
                selVC = UIStoryboard(name: "LMSReport", bundle: nil).instantiateViewController(withIdentifier: "LMSReportListVC") as! LMSReportListVC
            }
            break
            
        default:
            break
            
        }
        self.navigationController?.pushViewController(selVC, animated: true)
    }
    
    
    func applyFilter(filterString: String) {
        
    }
    
    func cancelFilter(filterString: String) {
        
    }
    
    
}


extension SubMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMenuTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "submenucell", for: indexPath as IndexPath) as! HomeMenuCell
        cell.imgVw.image = UIImage(named: "briefcase")
        cell.lblTitle.text = arrMenuTitles[indexPath.row]
        cell.lblDesc.isHidden = true

        return cell
    }
    
    func collectionView(_ collectionView : UICollectionView,layout  collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.size.width/2.09, height: 190)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.navigateToSelectedVC(module : navHeader, index : indexPath.row)
    }
}


extension SubMenuViewController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
    
}

