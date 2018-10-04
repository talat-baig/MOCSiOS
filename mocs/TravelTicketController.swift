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


class TravelTicketController: UIViewController , UIGestureRecognizerDelegate {
    
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
        
        
        //        self.title = "Travel Claims"
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

                            ttData.trvlrId = json["TravellerID"].stringValue
                            
                            ttData.tCompName = json["TravellerCompanyName"].stringValue
                            
                            ttData.tCompCode = json["TravellerCompanyCode"].stringValue
                            
                            ttData.tCompLoc = json["TravellerCompanyLocation"].stringValue
                            
                            ttData.guest = json["Guest1"].stringValue
                            
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
                            
//                            if json["ApproverDate"].boolValue == "" {
//                                ttData.trvlAdvance = ""
//                            } else {
//                                ttData.trvlAdvance  = json["ApproverDate"].stringValue
//                            }
                            
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
                            
                            if json["TravellerApprovedBy"].stringValue == "" {
                                ttData.approvdBy = ""
                            } else {
                                ttData.approvdBy  = json["TravellerApprovedBy"].stringValue
                            }
                         
                            
//                            if json["ApproverDate"].stringValue == "" {
//                                ttData.voucherNum = ""
//                            } else {
//                                ttData.voucherNum  = json["ApproverDate"].stringValue
//                            }
//
                            
//                            if json["ApproverDate"].stringValue == "" {
//                                ttData.trvlrCounter = ""
//                            } else {
//                                ttData.trvlrCounter  = json["ApproverDate"].stringValue
//                            }
//
                           
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
    
    
    func getCompanyListAndNavigate(refId : String) {
        
//        if Session.companies == "" {
        
            if internetStatus != .notReachable {
                
                let url = String.init(format: Constant.TT.TT_GET_COMPANY_LIST, Session.authKey,refId)
                self.view.showLoading()
                Alamofire.request(url).responseData(completionHandler: ({ response in
                    self.view.hideLoading()
                    if Helper.isResponseValid(vc: self, response: response.result) {
                        
                        let ttBaseVC = self.storyboard?.instantiateViewController(withIdentifier: "TTBaseViewController") as! TTBaseViewController
                        ttBaseVC.companiesResponse = response.result.value
                        self.navigationController?.pushViewController(ttBaseVC, animated: true)
                        
                    }
                }))
            } else {

//                let ttBaseVC = self.storyboard?.instantiateViewController(withIdentifier: "TTBaseViewController") as! TTBaseViewController
//                ttBaseVC.companiesResponse = Session.companies
//                self.navigationController?.pushViewController(ttBaseVC, animated: true)
                
        }
    }
                
    
   
    
    @IBAction func btnAddNewTicketTapped(_ sender: Any) {
        
        getCompanyListAndNavigate(refId: "" )
       
    }
    
}


extension TravelTicketController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //        if  searchText.isEmpty {
        //            self.arrayList = newArray
        //        } else {
        //            let filteredArray = newArray.filter {
        //                $0.headRef.localizedCaseInsensitiveContains(searchText)
        //            }
        //            self.arrayList = filteredArray
        //        }
        //        tableView.reloadData()
    }
}

extension TravelTicketController: UITableViewDataSource, UITableViewDelegate , onMoreClickListener, onTTItemClickListener {
    
    func onViewClick() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TTBaseViewController") as! TTBaseViewController
        vc.isFromView = true
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func onEditClick(data : TravelTicketData) {
        
        getCompanyListAndNavigate(refId : data.trvlrRefNum)
    }
    
    func onDeleteClick(data: TravelTicketData) {
        
    }
    
    func onSubmitClick(data: TravelTicketData) {
        
    }
    
    func onEmailClick(data: TravelTicketData) {
        
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
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TTBaseViewController") as! TTBaseViewController
//        vc.isFromView = false
//        getCompanyListAndNavigate(data :  arrayList[indexPath.row].trvlrRefNum)
//        self.navigationController!.pushViewController(vc, animated: true)
        
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
