//
//  APInvoiceListVC.swift
//  mocs
//
//  Created by Talat Baig on 10/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import NotificationBannerSwift


class APInvoiceListVC: UIViewController {
    
    var apInvoiceData:[APInvoiceData] = []
    
    var jsonResp : Data?
    
    var counterpty = String()
    
    /// emailFromHeaderDelegate  delegate object
    var delegate: emailFromHeaderDelegate?
    
    /// SendEmailHeaderView Object
    var headerVwEmail : SendEmailHeaderView?
    
    /// Array of IndexPaths
    var selectedIndexPath : [IndexPath] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "APInvoiceCell", bundle: nil), forCellReuseIdentifier: "apInvoiceCell")
        
        self.title = "Invoices"
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Invoices"
        vwTopHeader.lblSubTitle.text = counterpty
        
        headerVwEmail = Bundle.main.loadNibNamed("SendEmailHeaderView", owner: nil, options: nil)![0] as? SendEmailHeaderView
        headerVwEmail?.frame = CGRect.init(x: 0, y: 0, width:  self.view.frame.size.width, height: vwTopHeader.frame.size.height)
        headerVwEmail?.backgroundColor = UIColor.black
        headerVwEmail?.sendEmailDelegate = self
        
        parseAndAssign()
        
    }
    
    /// Tap action method that gets called when Send email tapped. Opens Email pop-up.
    @objc func sendEmailTapped(sender:UIButton) {
        let buttonRow = sender.tag
        let invoiceNum =  apInvoiceData[buttonRow].invNo
        self.openCustomSendEmailView(invoiceNum: invoiceNum)
    }
    
    
    func parseAndAssign() {
        
        guard let jsonRes = jsonResp else {
            return
        }
        
        let jsonResponse = JSON(jsonRes)
        
        let jsonArr = jsonResponse.arrayObject as! [[String:AnyObject]]
        
        for i in 0..<jsonArr.count {
            
            let newARObj = APInvoiceData()
            newARObj.location = jsonResponse[i]["Location"].stringValue
            newARObj.company = jsonResponse[i]["Company"].stringValue
            newARObj.bVertical = jsonResponse[i]["Business Vertical"].stringValue
            newARObj.counterpty = jsonResponse[i]["Counterparty"].stringValue
            newARObj.invNo = jsonResponse[i]["Invoice No"].stringValue
            newARObj.currency = jsonResponse[i]["Currency"].stringValue
            newARObj.invtDate = jsonResponse[i]["Invoice Date"].stringValue
            newARObj.dueDate = jsonResponse[i]["Due Date"].stringValue
            newARObj.invVal = jsonResponse[i]["Invoice Amount"].stringValue
            newARObj.invBalPayble = jsonResponse[i]["Balance Payable (USD)"].stringValue
            
            self.apInvoiceData.append(newARObj)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    /// Method to open custom email view by passing data to view and assign delegate
    func openCustomSendEmailView(invoiceNum : String) {
        
        let myView = Bundle.main.loadNibNamed("SendEmailView", owner: nil, options: nil)![0] as! SendEmailView
        myView.frame = CGRect.init(x: 0, y:0, width: self.view.frame.size.width, height: (self.view.frame.size.height) + (self.navigationController?.navigationBar.frame.size.height)!)
        myView.passInvoiceNumToView(invoiceNum: invoiceNum)
        myView.delegate = self
        
        self.view.addSubview(myView)
    }
    
    /// Method that calls API to send Instruments emailon the given email id/ids
    func sendInstrumentsEmail(invIds : String, emailIds : String) {
        
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.AP.SEND_EMAIL, Session.authKey, emailIds, Helper.encodeURL(url: invIds))
            print(url)
            self.view.showLoading()
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                self.view.hideLoading()
                
                guard let resp = response.result.value else {
                    NotificationBanner(title: "Something Went Wrong!", subtitle: "Please Try again later", style:.info).show()
                    return
                }
                let jsonResponse = JSON.init(parseJSON: resp)
                
                if jsonResponse["ServerMsg"].stringValue == "Success" {
                    let alert = UIAlertController(title: "Success", message: "Mail has been sent Successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Oops", message: "Unable to send mail. Please try again later", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension APInvoiceListVC: emailFromHeaderDelegate, sendEmailFromViewDelegate {
    
    func onSendTap(whrNo: String, roId: String, manual: String, emailIds: String) {
        
    }
    
    
    /// sendEmailFromViewDelegate method
    /// - Parameters:
    ///    - invoice: Invoice number and String
    ///    - emailIds: Email Ids as String
    func onSendEmailTap(invoice: String, emailIds: String) {
        self.resetTableViews()
        self.sendInstrumentsEmail(invIds: invoice, emailIds: emailIds)
    }
    
    /// Tap Action method for left arrow cancel button
    func onCancelTap() {
        self.resetTableViews()
    }
    
    /// Reset table view UI back to normal (Un-Selected)
    func resetTableViews(){
        vwTopHeader.isHidden = false
        self.selectedIndexPath.removeAll()
        headerVwEmail?.removeFromSuperviewWithAnimate()
        tableView.reloadData()
    }
    
    /// Delegate method called when Send button from header view is tapped.
    /// - Parameter indexPath: Array of IndexPaths
    func onSendHeaderVwTap(indexPath: [IndexPath]) {
        var invoiceArr = [String]()
        
        for i in self.selectedIndexPath {
            let newInv =  self.apInvoiceData[i.row].invNo
            invoiceArr.append(newInv)
        }
        let newInvoiceNum = invoiceArr.joined(separator: ",")
        self.openCustomSendEmailView(invoiceNum: newInvoiceNum)
    }
    
    /// Delegate method called when Cancel button from header view is tapped.
    func onCanceHeaderVwTap() {
        self.resetTableViews()
    }
    
}

extension APInvoiceListVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apInvoiceData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 308
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "apInvoiceCell") as! APInvoiceCell
        cell.layer.masksToBounds = true
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 5
        cell.btnSendEmail.tag = indexPath.row
        cell.btnSendEmail.addTarget(self, action: #selector(self.sendEmailTapped(sender:)), for: UIControlEvents.touchUpInside)
        //                cell.selectionStyle = .none
        
        if apInvoiceData.count > 0 {
            let isSelected = self.selectedIndexPath.contains(indexPath)
            cell.setDataToView(data: self.apInvoiceData[indexPath.row],isSelected: isSelected)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let index = self.selectedIndexPath.index(where: {$0 == indexPath}) {
            self.selectedIndexPath.remove(at: index)
        } else {
            self.selectedIndexPath.append(indexPath)
        }
        
        tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
        let isSelected = self.selectedIndexPath.contains(indexPath)
        
        if isSelected {
            
            headerVwEmail?.lblTitle.text = String(format : "%d selected",self.selectedIndexPath.count)
            headerVwEmail?.getIndexPath(indexPath: self.selectedIndexPath)
            self.view.addSubview(headerVwEmail!)
            
        } else {
            
            if headerVwEmail != nil {
                
                headerVwEmail?.lblTitle.text = String(format : "%d selected",self.selectedIndexPath.count)
                
                if  self.selectedIndexPath.count == 0 {
                    headerVwEmail?.removeFromSuperviewWithAnimate()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let index = self.selectedIndexPath.index(where: {$0 == indexPath}) {
            self.selectedIndexPath.remove(at: index)
        }
        tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
    }
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

