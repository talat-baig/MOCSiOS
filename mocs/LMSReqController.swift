//
//  LMSReqController.swift
//  mocs
//
//  Created by Talat Baig on 1/18/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LMSReqController: UIViewController , onLMSUpdate {
    
    
    var arrayGridList : [LMSGridData] = []
    //    var lmsSummry = LMSSummaryData()
    
    var arrayList : [LMSReqData] = []
    //    @IBOutlet weak var collVw: UICollectionView!
    //    @IBOutlet weak var gridTableVw: UITableView!
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    //    @IBOutlet weak var btnApplyLeave: UIButton!
    //    @IBOutlet weak var scrlVw: UIScrollView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var lblNoHistory: UILabel!
    @IBOutlet weak var vwLvHistory: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Leave Request"
        vwTopHeader.lblSubTitle.isHidden = true
        
        
        self.tableView.register(UINib(nibName: "LMSReqDataCell", bundle: nil), forCellReuseIdentifier: "datacell")
        
        self.tableView.register(UINib(nibName: "LMSCustomHeader", bundle: nil), forCellReuseIdentifier: "summarycell")
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 88.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(populateLMSData))
        tableView.addSubview(refreshControl)
        
        populateLMSData()
    }
    
    func showLoading(){
        self.view.showLoading()
    }
    
    func hideLoading(){
        self.view.hideLoading()
    }
    
    
    
    @objc func populateLMSData() {
        
        
        if internetStatus != .notReachable {
            
            let url1 = String.init(format: Constant.API.LMS_SUMMARY, Session.authKey)
            let url2 = String.init(format: Constant.API.LMS_LIST, Session.authKey)
            
            self.view.showLoading()
            
            let group = DispatchGroup()
            self.view.showLoading()
            group.enter()
            
            Alamofire.request(url1).responseData(completionHandler: ({ summResposne in
//                self.view.hideLoading()
//                self.refreshControl.endRefreshing()
                 group.leave()
                
                if Helper.isResponseValid(vc: self, response: summResposne.result) {
                    
                    let responseJson = JSON(summResposne.result.value!)
                    let arrSumm = responseJson.arrayObject as! [[String:AnyObject]]
                    
                    if (arrSumm.count > 0) {
                        self.parseAndAssignSummary(response:summResposne.result.value)
                        self.tableView.reloadData()
                    } else {
                        
                    }
                }
            }))
            
            
            group.enter()
            Alamofire.request(url2).responseData(completionHandler: ({ historyResp in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                 group.leave()
                
                if Helper.isResponseValid(vc: self, response: historyResp.result) {
                    
                    let responseJson = JSON(historyResp.result.value!)
                    let arrHistory = responseJson.arrayObject as! [[String:AnyObject]]
                    
                    if (arrHistory.count > 0) {
                        self.tableView.tableFooterView = nil
                        self.parseAndAssignHistory(response:historyResp.result.value )
                        self.tableView.reloadData()
                    } else {

                        self.showLeaveHistoryEmptyState()

                    }
                } else {
                     self.showLeaveHistoryEmptyState()
                }
            }))
            
            group.notify(queue: .main) {
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                
               
            }
            
        }
    }
    
    
    func parseAndAssignHistory(response : Data?) {
        
        var data: [LMSReqData] = []
        let jsonResponse = JSON(response!)
        
        for(_,json):(String,JSON) in jsonResponse {
            
            let lmsReq = LMSReqData()
            
            lmsReq.srNo = json["SNO"].stringValue
            
            lmsReq.leaveType = json["Leave Type"].stringValue
            
            lmsReq.from = json["From Date"].stringValue
            
            lmsReq.to = json["To Date"].stringValue
            
            lmsReq.noOfDays = json["Leave Days"].stringValue
            
            lmsReq.appliedDate = json["Added Date"].stringValue
            
            lmsReq.contact = json["Contact While On Leave"].stringValue
            
            lmsReq.empCode = json["Employee Code"].stringValue
            
            lmsReq.empName = json["Employee Name"].stringValue
            
            lmsReq.dept = json["Department"].stringValue
            
            lmsReq.reason = json["Reason"].stringValue
            
            lmsReq.leaveReason = json["Leave Reason"].stringValue
            
            lmsReq.appStatus = json["Leave Application Status"].stringValue
            
            lmsReq.delegation = json["Delegation Work"].stringValue
            
            if json["Manager Name"].stringValue == "" {
                lmsReq.mngrName  = "-"
            } else {
                lmsReq.mngrName = json["Manager Name"].stringValue
            }
            
            data.append(lmsReq)
        }
        self.arrayList = data
        
        DispatchQueue.main.async {
//            self.tableView.reloadData()
        }
    }
    
    func parseAndAssignSummary(response : Data?) {
        
        
        var data: [LMSGridData] = []
        let jsonResponse = JSON(response!)
        
        for(_,json):(String,JSON) in jsonResponse {
            
            let lmsGrid = LMSGridData()
            
            lmsGrid.leaveBalId = json["LeaveBalanceID"].stringValue
            
            if json["Leave Type"].stringValue == "" {
                lmsGrid.typeOfLeave  = "-"
            } else {
                lmsGrid.typeOfLeave = json["Leave Type"].stringValue
            }
            
            if json["Utilized"].stringValue == "" {
                lmsGrid.utilized   = "-"
            } else {
                lmsGrid.utilized  = json["Utilized"].stringValue
            }
            
            if json["Available Leave"].stringValue == "" {
                lmsGrid.available   = "-"
            } else {
                lmsGrid.available  = json["Available Leave"].stringValue
            }
            
            if json["Total Leave"].stringValue == "" {
                lmsGrid.total  = "-"
            } else {
                lmsGrid.total = json["Total Leave"].stringValue
            }
            
            lmsGrid.lapseStatus = json["LeaveBalanceLapseStatus"].stringValue
            
            
            lmsGrid.isActive = json["IsActive"].stringValue
            
            
            
            data.append(lmsGrid)
        }
        self.arrayGridList = data
        
        
    }
    
    
    
//    @objc func populateReqList() {
//
//        var data: [LMSReqData] = []
//
//        if internetStatus != .notReachable {
//
//            self.showLoading()
//            let url:String = String.init(format: Constant.API.LMS_LIST, Session.authKey)
//
//            Alamofire.request(url).responseData(completionHandler: ({ response in
//                self.hideLoading()
//                self.refreshControl.endRefreshing()
//
//                if Helper.isResponseValid(vc: self, response: response.result, tv: self.tableView) {
//
//                    let jsonResponse = JSON(response.result.value!)
//                    let array = jsonResponse.arrayObject as! [[String:AnyObject]]
//                    if array.count > 0 {
//                        self.arrayList.removeAll()
//
//                        for(_,json):(String,JSON) in jsonResponse {
//
//                            let lmsReq = LMSReqData()
//
//                            lmsReq.srNo = json["SNO"].stringValue
//
//                            lmsReq.leaveType = json["Leave Type"].stringValue
//
//                            lmsReq.from = json["From Date"].stringValue
//
//                            lmsReq.to = json["To Date"].stringValue
//
//                            lmsReq.noOfDays = json["Leave Days"].stringValue
//
//                            lmsReq.appliedDate = json["Added Date"].stringValue
//
//                            lmsReq.contact = json["Contact While On Leave"].stringValue
//
//                            lmsReq.empCode = json["Employee Code"].stringValue
//
//                            lmsReq.empName = json["Employee Name"].stringValue
//
//                            lmsReq.dept = json["Department"].stringValue
//
//                            lmsReq.reason = json["Reason"].stringValue
//
//                            lmsReq.leaveReason = json["Leave Reason"].stringValue
//
//                            lmsReq.appStatus = json["Leave Application Status"].stringValue
//
//                            lmsReq.delegation = json["Delegation Work"].stringValue
//
//                            if json["Manager Name"].stringValue == "" {
//                                lmsReq.mngrName  = "-"
//                            } else {
//                                lmsReq.mngrName = json["Manager Name"].stringValue
//                            }
//
//                            data.append(lmsReq)
//                        }
//                        self.arrayList = data
//                        self.tableView.tableFooterView = nil
//                        self.tableView.reloadData()
//                    } else {
//                        self.showLeaveHistoryEmptyState()
//                    }
//                } else {
//                    self.showLeaveHistoryEmptyState()
//                }
//            }))
//        } else {
//            Helper.showNoInternetMessg()
//            Helper.showNoInternetState(vc: self, tb: tableView, action: #selector(populateReqList))
//        }
//
//    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    func onLMSUpdateClick() {
        
        self.populateLMSData()
    }
    
    
    @objc func btnApplyTapped( sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LMSBaseViewController") as! LMSBaseViewController
        vc.isFromView = false
        vc.lmsReqData = nil
        vc.lmsUpdateDelgte = self
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func showLeaveHistoryEmptyState() {
        
        if self.arrayList.count > 0 {
            self.vwLvHistory.isHidden = true
        } else {
            self.vwLvHistory.isHidden = false
        }
    }
}



extension LMSReqController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            
            if self.arrayList.count > 0 {
                return self.arrayList.count
            } else {
            }
            return self.arrayList.count
        }

        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        } else {
            return 210
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var tableCell: UITableViewCell?
        
        if indexPath.section == 0 {
            let data = self.arrayGridList
            let cell = tableView.dequeueReusableCell(withIdentifier: "summarycell") as! LMSCustomHeader
            cell.setDataToViews(data: data )
            cell.btnApply.addTarget(self, action: #selector(self.btnApplyTapped(sender:)), for: UIControlEvents.touchUpInside)
            cell.selectionStyle =  .none
            tableCell = cell
        } else {
            
            let data = self.arrayList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "datacell") as! LMSReqDataCell
            cell.btnMenu.tag = indexPath.row
            cell.optionClickListener = self
            cell.delegate = self
            cell.setDataToViews(data:data )
            cell.selectionStyle =  .none
            tableCell = cell
        }
        
        return tableCell!
    }
    
    
    func deleteLeave(data:LMSReqData) {
        
        if internetStatus != .notReachable {
            self.view.showLoading()
            
            let url = String.init(format: Constant.API.LMS_CANCEL_LEAVE, Session.authKey, data.srNo)
            
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                
                self.view.hideLoading()
                if Helper.isPostResponseValid(vc: self, response: response.result) {
                    
                    let alert = UIAlertController(title: "Success", message: "Request successfully cancelled", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(AlertAction) ->  Void in
                        if let index = self.arrayList.index(where: {$0 === data}) {
                            self.arrayList.remove(at: index)
                        }
                        self.tableView.reloadData()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    func viewLeave(data:LMSReqData, isFromView : Bool){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LMSBaseViewController") as! LMSBaseViewController
        vc.isFromView = isFromView
        vc.lmsReqData = data
        vc.lmsUpdateDelgte = self
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    
}

extension LMSReqController: onLMSOptionClickListener, onMoreClickListener {
    
    func onViewClick(data: LMSReqData) {
        self.viewLeave(data: data, isFromView: true)
    }
    
    func onEditClick(data: LMSReqData) {
        self.viewLeave(data: data, isFromView: false)
    }
    
    func onDeleteClick(data: LMSReqData) {
        let alert = UIAlertController(title: "Delete Leave?", message: "Are you sure you want to delete this claim? After deleting you'll not be able to rollback", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) -> Void in
            self.deleteLeave(data: data)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    
}

extension LMSReqController: WC_HeaderViewDelegate {
    
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
