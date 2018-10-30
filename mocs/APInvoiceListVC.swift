//
//  APInvoiceListVC.swift
//  mocs
//
//  Created by Talat Baig on 10/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class APInvoiceListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "APInvoiceCell", bundle: nil), forCellReuseIdentifier: "apInvoiceCell")
      
        self.title = "Instruments"
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Invoices"
//        vwTopHeader.lblSubTitle.text = counterpty

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
}

extension APInvoiceListVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "apInvoiceCell") as! APInvoiceCell
        cell.layer.masksToBounds = true
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 5
//        cell.btnSendEmail.tag = indexPath.row
//        cell.btnSendEmail.addTarget(self, action: #selector(self.sendEmailTapped(sender:)), for: UIControlEvents.touchUpInside)
        //        cell.selectionStyle = .none
        
//        if arInstrumentsData.count > 0 {
//            let isSelected = self.selectedIndexPath.contains(indexPath)
//            cell.setDataToView(data: self.arInstrumentsData[indexPath.row],isSelected: isSelected)
//        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
//        if let index = self.selectedIndexPath.index(where: {$0 == indexPath}) {
//            self.selectedIndexPath.remove(at: index)
//        } else {
//            self.selectedIndexPath.append(indexPath)
//        }
//
//        tblVwInstruments.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
//        let isSelected = self.selectedIndexPath.contains(indexPath)
//
//        if isSelected {
//
//            headerVwEmail?.lblTitle.text = String(format : "%d selected",self.selectedIndexPath.count)
//            headerVwEmail?.getIndexPath(indexPath: self.selectedIndexPath)
//            self.view.addSubview(headerVwEmail!)
//
//        } else {
//
//            if headerVwEmail != nil {
//
//                headerVwEmail?.lblTitle.text = String(format : "%d selected",self.selectedIndexPath.count)
//
//                if  self.selectedIndexPath.count == 0 {
//                    headerVwEmail?.removeFromSuperviewWithAnimate()
//                }
//            }
//        }
//    }
    
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//
//        if let index = self.selectedIndexPath.index(where: {$0 == indexPath}) {
//            self.selectedIndexPath.remove(at: index)
//        }
//        tblVwInstruments.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
//    }
}

// MARK: - WC_HeaderViewDelegate Methods
extension APInvoiceListVC: WC_HeaderViewDelegate {
    
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

