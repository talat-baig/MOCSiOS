//
//  TravelTicketController.swift
//  mocs
//
//  Created by Talat Baig on 9/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class TravelTicketController: UIViewController , UIGestureRecognizerDelegate, onTTSubmit {
    
    var arrayList: [TravelTicketData] = []
    
    var newArray : [TravelTicketData] = []
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(populateList))
        tableView.addSubview(refreshControl)
        
        srchBar.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.isHidden = true
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Travel Tickets"
        vwTopHeader.lblSubTitle.isHidden = true
        
        populateList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    func showLoading(){
        self.view.showLoading()
    }
    
    func hideLoading(){
        self.view.hideLoading()
    }
    
    
    @objc func populateList() {
        
        var data: [TravelTicketData] = []
        
        if internetStatus != .notReachable {
            
            self.showLoading()
            let url:String = String.init(format: Constant.TT.TT_GET_LIST, Session.authKey)
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.hideLoading()
                self.refreshControl.endRefreshing()
                
                if Helper.isResponseValid(vc: self, response: response.result, tv: self.tableView) {
                    
                    let jsonResponse = JSON(response.result.value!)
                    let array = jsonResponse.arrayObject as! [[String:AnyObject]]
                    if array.count > 0 {
                        self.arrayList.removeAll()
                        
                        for(_,json):(String,JSON) in jsonResponse {
                            
                            let ttData = TravelTicketData()
                            
                            ttData.trvlrId = json["TravellerID"].intValue
                            
                            ttData.tCompName = json["TravellerCompanyName"].stringValue
                            
                            ttData.tCompCode = json["TravellerCompanyCode"].stringValue
                            
                            ttData.tCompLoc = json["TravellerCompanyLocation"].stringValue
                            
                            //                            ttData.guest = json["Guest1"].stringValue
                            
                            if json["Guest1"].stringValue == "Guest" {
                                
                                ttData.guest = 0
                            } else {
                                
                                ttData.guest = 1
                            }
                            
                            ttData.trvlrName = json["TravellerName"].stringValue
                            
                            ttData.trvlrDept = json["TravellerDepartment"].stringValue
                            
                            ttData.trvlrRefNum = json["TravellerReferenceNo"].stringValue
                            
                            
                            if json["TravellerPurpose"].stringValue == "" {
                                ttData.trvlrPurpose = ""
                            } else {
                                ttData.trvlrPurpose  = json["TravellerPurpose"].stringValue
                            }
                            
                            if json["TravellerType"].stringValue == "" {
                                ttData.trvlrType = ""
                            } else {
                                ttData.trvlrType  = json["TravellerType"].stringValue
                            }
                            
                            
                            if json["TravellerMode"].stringValue == "" {
                                ttData.trvlrMode = ""
                            } else {
                                ttData.trvlrMode  = json["TravellerMode"].stringValue
                            }
                            
                            
                            if json["TravellerClass"].stringValue == "" {
                                ttData.trvlrClass = ""
                            } else {
                                ttData.trvlrClass  = json["TravellerClass"].stringValue
                            }
                            
                            if json["TravellerDebitACName"].stringValue == "" {
                                ttData.debitACName = ""
                            } else {
                                ttData.debitACName  = json["TravellerDebitACName"].stringValue
                            }
                            
                            if json["TravellerCarrier"].stringValue == "" {
                                ttData.carrier = ""
                            } else {
                                ttData.carrier  = json["TravellerCarrier"].stringValue
                            }
                            
                            if json["TravellerTicketNo"].stringValue == "" {
                                ttData.ticktNum = ""
                            } else {
                                ttData.ticktNum  = json["TravellerTicketNo"].stringValue
                            }
                            
                            ttData.issueDate = json["TravellerTicketIssue"].stringValue
                            ttData.expiryDate = json["TravellerTicketExpire"].stringValue
                            
                            
                            if json["TravellerTicketPNRNo"].stringValue == "" {
                                ttData.ticktPNRNum = ""
                            } else {
                                ttData.ticktPNRNum  = json["TravellerTicketPNRNo"].stringValue
                            }
                            
                            
                            if json["TravellerTicketCost"].stringValue == "" {
                                ttData.ticktCost = ""
                            } else {
                                ttData.ticktCost  = json["TravellerTicketCost"].stringValue
                            }
                            
                            if json["TravellerTicketCurrency"].stringValue == "" {
                                ttData.tCurrency = ""
                            } else {
                                ttData.tCurrency  = json["TravellerTicketCurrency"].stringValue
                            }
                            
                            if json["TravellerTicketStatus"].stringValue == "" {
                                ttData.ticktStatus = ""
                            } else {
                                ttData.ticktStatus  = json["TravellerTicketStatus"].stringValue
                            }
                            
                            if json["TravellerTravelAgent"].stringValue == "" {
                                ttData.agent = ""
                            } else {
                                ttData.agent  = json["TravellerTravelAgent"].stringValue
                            }
                            
                            if json["TravellerInvoiceNo"].stringValue == "" {
                                ttData.invoiceNum = ""
                            } else {
                                ttData.invoiceNum  = json["TravellerInvoiceNo"].stringValue
                            }
                            
                            if json["TravellerRemarks"].stringValue == "" {
                                ttData.trvlComments = ""
                            } else {
                                ttData.trvlComments  = json["TravellerRemarks"].stringValue
                            }
                            
                            if json["TravellerAPRNo"].stringValue == "" {
                                ttData.trvlAprNum = ""
                            } else {
                                ttData.trvlAprNum  = json["TravellerAPRNo"].stringValue
                            }
                            
                            if json["APR"].stringValue == "" {
                                ttData.trvlAprAmt = ""
                            } else {
                                ttData.trvlAprAmt  = json["APR"].stringValue
                            }
                            
                            if json["Currency"].stringValue == "" {
                                ttData.trvlAprCurr = ""
                            } else {
                                ttData.trvlAprCurr  = json["Currency"].stringValue
                            }
                            
                            if json["Manager"].stringValue == "" {
                                ttData.approvdBy = ""
                            } else {
                                ttData.approvdBy  = json["Manager"].stringValue
                            }
                            
                            if json["Addedby"].stringValue == "" {
                                ttData.tAddedBy = ""
                            } else {
                                ttData.tAddedBy  = json["Addedby"].stringValue
                            }
                            
                            if json["Addedbysysdt"].stringValue == "" {
                                ttData.tAddedDate = ""
                            } else {
                                ttData.tAddedDate  = json["Addedbysysdt"].stringValue
                            }
                            
                            if json["Status"].stringValue == "" {
                                ttData.status = ""
                            } else {
                                ttData.status  = json["Status"].stringValue
                            }
                            
                            if json["TravellerAdvancePaidStatus"].stringValue.caseInsensitiveCompare("True") == ComparisonResult.orderedSame {
                                
                                ttData.trvlAdvance = true
                            } else {
                                ttData.trvlAdvance = false
                            }
                            
                            data.append(ttData)
                        }
                        self.arrayList = data
                        self.newArray = data
                        self.tableView.tableFooterView = nil
                        self.tableView.reloadData()
                    }
                }
            }))
        } else {
            Helper.showNoInternetMessg()
            Helper.showNoInternetState(vc: self, tb: tableView, action: #selector(populateList))
            self.refreshControl.endRefreshing()
        }
    }
    
    
    func onTTSubmitClick() {
        
        self.populateList()
    }
    
    
    func getTTDataAndNavigate(data : TravelTicketData, isFromView : Bool) {
        
        var companiesResponse : Data?
        var debitAcResponse : Data?
        var trvlModeResponse : Data?
        var carrierResponse : Data?
        var currResponse : Data?
        var trvlAgentResponse : Data?
        var repMngrResponse : Data?
        var itinryResponse : Data?
        var voucherResponse : Data?
        
        if internetStatus != .notReachable {
            
            let group = DispatchGroup()
            self.view.showLoading()
            group.enter()
            
            let url1 = String.init(format: Constant.TT.TT_GET_COMPANY_LIST, Session.authKey,data.trvlrRefNum)
            self.view.showLoading()
            Alamofire.request(url1).responseData(completionHandler: ({ response in
                group.leave()
                if Helper.isResponseValid(vc: self, response: response.result) {
                    companiesResponse = response.result.value
                }
            }))
            
            group.enter()
            let url2 = String.init(format: Constant.TT.TT_GET_DEBIT_AC, Session.authKey)
            
            Alamofire.request(url2).responseData(completionHandler: ({ response in
                group.leave()
                if Helper.isResponseValid(vc: self, response: response.result){
                    debitAcResponse = response.result.value
                }
            }))
            
            group.enter()
            let url3 = String.init(format: Constant.TT.TT_GET_TRAVEL_MODES, Session.authKey)
            
            Alamofire.request(url3).responseData(completionHandler: ({ response in
                group.leave()
                if Helper.isResponseValid(vc: self, response: response.result){
                    trvlModeResponse = response.result.value
                }
            }))
            
            group.enter()
            let url4 = String.init(format: Constant.TT.TT_GET_CARRIER_LIST, Session.authKey)
            
            Alamofire.request(url4).responseData(completionHandler: ({ response in
                group.leave()
                if Helper.isResponseValid(vc: self, response: response.result){
                    carrierResponse = response.result.value
                }
            }))
            
            group.enter()
            let url5 = String.init(format: Constant.TT.TT_GET_CURRENCY_LIST, Session.authKey)
            
            Alamofire.request(url5).responseData(completionHandler: ({ response in
                group.leave()
                if Helper.isResponseValid(vc: self, response: response.result){
                    currResponse = response.result.value
                }
            }))
            
            group.enter()
            let url6 = String.init(format: Constant.TT.TT_GET_TRAVEL_AGENT, Session.authKey)
            
            Alamofire.request(url6).responseData(completionHandler: ({ response in
                group.leave()
                if Helper.isResponseValid(vc: self, response: response.result){
                    trvlAgentResponse = response.result.value
                }
            }))
            
            group.enter()
            let url7 = String.init(format: Constant.TT.TT_GET_REP_MNGR_LIST, Session.authKey)
            
            Alamofire.request(url7).responseData(completionHandler: ({ response in
                group.leave()
                if Helper.isResponseValid(vc: self, response: response.result){
                    repMngrResponse = response.result.value
                }
            }))
            
            group.enter()
            let url8 = String.init(format: Constant.TT.TT_GET_ITINRY_LIST, Session.authKey,data.trvlrRefNum)
            
            Alamofire.request(url8).responseData(completionHandler: ({ response in
                group.leave()
                if Helper.isResponseValid(vc: self, response: response.result){
                    itinryResponse = response.result.value
                }
            }))
            
            
            group.enter()
            
            let url9 = String.init(format: Constant.DROPBOX.LIST,Session.authKey, Helper.encodeURL(url: Constant.MODULES.TCR), Helper.encodeURL(url: data.trvlrRefNum))
            
            Alamofire.request(url9).responseData(completionHandler: ({ response in
                group.leave()
                if Helper.isResponseValid(vc: self, response: response.result){
                    voucherResponse = response.result.value
                }
            }))
            
            group.notify(queue: .main) {
                self.view.hideLoading()
                
                let ttBaseVC = self.storyboard?.instantiateViewController(withIdentifier: "TTBaseViewController") as! TTBaseViewController
                ttBaseVC.companiesResponse = companiesResponse
                ttBaseVC.debitAcResponse = debitAcResponse
                ttBaseVC.trvlModeResposne = trvlModeResponse
                ttBaseVC.carrierResponse = carrierResponse
                ttBaseVC.currResponse = currResponse
                ttBaseVC.trvlAgentResponse = trvlAgentResponse
                ttBaseVC.repMngrResponse = repMngrResponse
                ttBaseVC.itinryResponse = itinryResponse
                ttBaseVC.voucherResponse = voucherResponse
                ttBaseVC.isFromView = isFromView
                ttBaseVC.ttSubmitDelgte = self
                ttBaseVC.trvlTcktData = data
                
                self.navigationController?.pushViewController(ttBaseVC, animated: true)
            }
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    
    @IBAction func btnAddNewTicketTapped(_ sender: Any) {
        
        let myData = TravelTicketData()
        getTTDataAndNavigate(data: myData, isFromView: false )
    }
    
    
    func sendEmail(data:TravelTicketData){
        
        showLoading()
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.TT.TT_MAIL_TRAVELTICKET, Session.authKey,data.trvlrRefNum, data.trvlrId )
            
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                self.view.hideLoading()
                
                let jsonResponse = JSON.init(parseJSON: response.result.value!)
                
                if jsonResponse["ServerMsg"].stringValue == "Success" {
                    
                    let alert = UIAlertController(title: "Success", message: "Ticket has been Mailed Successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }else{
            Helper.showNoInternetMessg()
        }
    }
    
    
    func deleteTicket(data : TravelTicketData) {
        
        if internetStatus != .notReachable {
            showLoading()
            let url = String.init(format: Constant.TT.TT_DELETE_TRAVELTICKET, Session.authKey, data.trvlrId)
            print(url)
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                
                self.view.hideLoading()
                if Helper.isPostResponseValid(vc: self, response: response.result) {
                    
                    let alert = UIAlertController(title: "Success", message: "Ticket successfully deleted", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(AlertAction) ->  Void in
                        self.populateList()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            })
            
        } else {
            Helper.showNoInternetMessg()
        }
        
    }
    
}


extension TravelTicketController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.arrayList = newArray
        } else {
            let filteredArray = newArray.filter {
                $0.trvlrRefNum.localizedCaseInsensitiveContains(searchText)
            }
            self.arrayList = filteredArray
        }
        tableView.reloadData()
    }
}

extension TravelTicketController: UITableViewDataSource, UITableViewDelegate , onMoreClickListener, onTTItemClickListener {
    
    func onViewClick(data : TravelTicketData) {
        
        getTTDataAndNavigate(data : data , isFromView : true)
        
    }
    
    func onEditClick(data : TravelTicketData) {
        
        getTTDataAndNavigate(data : data , isFromView : false)
    }
    
    func onDeleteClick(data: TravelTicketData) {
        
        let alert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete Travel Ticket? Once you delete this, there is no way to un-delete", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO GO BACK", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) -> Void in
            self.deleteTicket(data : data )
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func onEmailClick(data: TravelTicketData) {
        
        let alert = UIAlertController(title: "Are you sure you want to Email?", message: "This Email will be send to your official Email ID", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "SEND", style: .default, handler: { (UIAlertAction) -> Void in
            self.sendEmail(data: data)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arrayList.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 286
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        handleTap()
        let data = arrayList[indexPath.row]
        
        if (data.status.caseInsensitiveCompare("Cancelled") == ComparisonResult.orderedSame){
            getTTDataAndNavigate(data : data , isFromView : true)
            self.view.makeToast("Ticket is cancelled, cannot be edited")

        } else {
            getTTDataAndNavigate(data : data , isFromView : false)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = arrayList[indexPath.row]
        let view = tableView.dequeueReusableCell(withIdentifier: "cell") as! TravelTicketCell
        view.btnMore.tag = indexPath.row
        view.setDataToView(data: data)
        view.delegate = self
        view.ttReqClickListnr = self
        return view
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view?.isDescendant(of: tableView))! {
            return false
        }
        return true
    }
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
        
        let section = 0
        let indexPath = IndexPath(row: sender.tag, section: section)
        let cell: TravelTicketCell = self.tableView.cellForRow(at: indexPath) as! TravelTicketCell
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            if let presentation = optionMenu.popoverPresentationController {
                presentation.sourceView = cell.btnMore
            }
        }
        self.present(optionMenu, animated: true, completion: nil)
    }
    
}

extension TravelTicketController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
        
    }
    
}
