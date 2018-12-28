//
//  ARInstrumentControllerViewController.swift
//  mocs
//
//  Created by Talat Baig on 4/5/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

/// AR Instruments List
class ARInstrumentController: UIViewController {
    
    /// ARInstrumentsData object
    var arInstrumentsData:[ARInstrumentsData] = []
    
    /// Company variable as String
    var company = String()
    
    /// Business unit as String
    var bUnit = String()
    
    /// Location as String
    var location = String()
    
    /// CounterParty as String
    var counterpty = String()
    
    /// emailFromHeaderDelegate  delegate object
    var delegate: emailFromHeaderDelegate?
    
    /// SendEmailHeaderView Object
    var headerVwEmail : SendEmailHeaderView?
    
    /// Array of IndexPaths
    var selectedIndexPath : [IndexPath] = []
    
    /// Table View
    @IBOutlet weak var tblVwInstruments: UITableView!
    
    /// Top Header view
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblVwInstruments.register(UINib(nibName: "ARInstrumentsCell", bundle: nil), forCellReuseIdentifier: "arInstrumentCell")
        self.title = "Instruments"
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Instruments"
        vwTopHeader.lblSubTitle.text = counterpty
        
        headerVwEmail = Bundle.main.loadNibNamed("SendEmailHeaderView", owner: nil, options: nil)![0] as? SendEmailHeaderView
        headerVwEmail?.frame = CGRect.init(x: 0, y: 0, width:  self.view.frame.size.width, height: vwTopHeader.frame.size.height)
        headerVwEmail?.backgroundColor = UIColor.black
        headerVwEmail?.sendEmailDelegate = self
        
        populateList()
        
    }
    
    /// Tap action method that gets called when Send email tapped. Opens Email pop-up.
    @objc func sendEmailTapped(sender:UIButton) {
        let buttonRow = sender.tag
        let invoiceNum =  arInstrumentsData[buttonRow].instNo
        self.openCustomSendEmailView(invoiceNum: invoiceNum)
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
            let url = String.init(format: Constant.AR.SEND_EMAIL, Session.authKey,
                                  Helper.encodeURL(url: invIds),
                                  emailIds)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let alert = UIAlertController(title: "Success", message: "Mail has been sent Successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    /// Method to get list of Instruments data from counterparty and Filter string through API call. Also, populates tableview according to response data.
    func populateList() {
        
        if internetStatus != .notReachable {
            
            self.view.showLoading()
            let url:String = String.init(format: Constant.AR.INSTRUMENTS, Session.authKey, Helper.encodeURL(url : FilterViewController.getFilterString()),Helper.encodeURL(url:self.company),Helper.encodeURL(url: self.location),Helper.encodeURL(url:self.bUnit),Helper.encodeURL(url:self.counterpty))
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let jsonResponse = JSON(response.result.value!)
                    
                    let jsonArr = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    for i in 0..<jsonArr.count {
                        
                        let newARObj = ARInstrumentsData()
                        newARObj.location = jsonResponse[i]["Location"].stringValue
                        newARObj.company = jsonResponse[i]["Company"].stringValue
                        newARObj.bVertical = jsonResponse[i]["Business Vertical"].stringValue
                        newARObj.counterpty = jsonResponse[i]["Counterparty"].stringValue
                        newARObj.buyerId = jsonResponse[i]["BuyerID"].stringValue
                        newARObj.arType = jsonResponse[i]["AR Type"].stringValue
                        newARObj.instNo = jsonResponse[i]["Instrument No."].stringValue
                        newARObj.currency = jsonResponse[i]["Currency"].stringValue
                        newARObj.instDate = jsonResponse[i]["Instrument Date"].stringValue
                        newARObj.dueDate = jsonResponse[i]["Due Date"].stringValue
                        newARObj.invQty = jsonResponse[i]["Invoice Quantity"].stringValue
                        newARObj.invVal = jsonResponse[i]["Invoice Value"].stringValue
                        newARObj.invAmtRecvd = jsonResponse[i]["Amount Received"].stringValue
                        newARObj.invAmtRecvble = jsonResponse[i]["Amount Receivable (USD)"].stringValue
                        
                        self.arInstrumentsData.append(newARObj)
                    }
                    DispatchQueue.main.async {
                        self.tblVwInstruments.reloadData()
                    }
                }
            }))
        }else{
            Helper.showNoInternetMessg()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

extension ARInstrumentController: emailFromHeaderDelegate, sendEmailFromViewDelegate {
    
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
        tblVwInstruments.reloadData()
    }
    
    /// Delegate method called when Send button from header view is tapped.
    /// - Parameter indexPath: Array of IndexPaths
    func onSendHeaderVwTap(indexPath: [IndexPath]) {
        var invoiceArr = [String]()
        
        for i in self.selectedIndexPath {
            let newInv =  self.arInstrumentsData[i.row].instNo
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

// MARK: - UITableViewDataSource methods
extension ARInstrumentController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arInstrumentsData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblVwInstruments.dequeueReusableCell(withIdentifier: "arInstrumentCell") as! ARInstrumentsCell
        cell.layer.masksToBounds = true
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 5
        cell.btnSendEmail.tag = indexPath.row
        cell.btnSendEmail.addTarget(self, action: #selector(self.sendEmailTapped(sender:)), for: UIControlEvents.touchUpInside)
//        cell.selectionStyle = .none
        
        if arInstrumentsData.count > 0 {
            let isSelected = self.selectedIndexPath.contains(indexPath)
            cell.setDataToView(data: self.arInstrumentsData[indexPath.row],isSelected: isSelected)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate methods
extension ARInstrumentController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let index = self.selectedIndexPath.index(where: {$0 == indexPath}) {
            self.selectedIndexPath.remove(at: index)
        } else {
            self.selectedIndexPath.append(indexPath)
        }
        
        tblVwInstruments.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
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
        tblVwInstruments.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
    }
}

// MARK: - WC_HeaderViewDelegate Methods
extension ARInstrumentController: WC_HeaderViewDelegate {
    
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


