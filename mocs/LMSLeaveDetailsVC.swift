//
//  LMSLeaveDetailsVC.swift
//  mocs
//
//  Created by Talat Baig on 1/14/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class LMSLeaveDetailsVC: UIViewController , onButtonClickListener , customPopUpDelegate {
    
    var arrayList : [LMSLeaveData] = []
    var empName = ""
    var empId = ""
    var dept = ""
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    var declVw = CustomPopUpView()
    var myView = CustomPopUpView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = self.empName
        vwTopHeader.lblSubTitle.text = empId + "-" + dept
        
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "LMSLeaveDetailsCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        populateList()
    }
    
    
    @objc func populateList() {
        
        if internetStatus != .notReachable {
            
            var newData:[LMSLeaveData] = []
            
            self.view.showLoading()
            let url:String = String.init(format: Constant.LMS.GET_LEAVES_BY_NAME, Session.authKey, Helper.encodeURL(url:empName))
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let jsonResponse = JSON(response.result.value!)
                    let jsonArr = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    if jsonArr.count > 0 {
                        
                        for i in 0..<jsonArr.count {
                            
                            let lmsData = LMSLeaveData()
                            
                            lmsData.reqId  = jsonResponse[i]["LeaveApplicationID"].stringValue
                            
                            if jsonResponse[i]["To Date"].stringValue == "" {
                                lmsData.toDate  = "-"
                            } else {
                                lmsData.toDate = jsonResponse[i]["To Date"].stringValue
                            }
                            
                            if jsonResponse[i]["From Date"].stringValue == "" {
                                lmsData.fromDate  = "-"
                            } else {
                                lmsData.fromDate = jsonResponse[i]["From Date"].stringValue
                            }
                            
                            if jsonResponse[i]["No Of Days"].stringValue == "" {
                                lmsData.noOfDays  = "-"
                            } else {
                                lmsData.noOfDays = jsonResponse[i]["No Of Days"].stringValue
                            }
                            
                            if jsonResponse[i]["Reporting Manager Status"].stringValue == "" {
                                lmsData.status  = "-"
                            } else {
                                lmsData.status = jsonResponse[i]["Reporting Manager Status"].stringValue
                            }
                            
                            if jsonResponse[i]["Requested Date"].stringValue == "" {
                                lmsData.reqDate  = "-"
                            } else {
                                lmsData.reqDate = jsonResponse[i]["Requested Date"].stringValue
                            }
                            
                            
                            
                            if jsonResponse[i]["Type Of Leave"].stringValue == "" {
                                lmsData.type  = "-"
                            } else {
                                lmsData.type = jsonResponse[i]["Type Of Leave"].stringValue
                            }
                            
                            if jsonResponse[i]["Reason"].stringValue == "" {
                                lmsData.reason  = "-"
                            } else {
                                lmsData.reason = jsonResponse[i]["Reason"].stringValue
                            }
                            
                            if jsonResponse[i]["Contact on Leave"].stringValue == "" {
                                lmsData.contact  = "-"
                            } else {
                                lmsData.contact = jsonResponse[i]["Contact on Leave"].stringValue
                            }
                            
                            newData.append(lmsData)
                        }
                        self.arrayList = newData
                    } else {
                        self.showEmptyState()
                    }
                    self.tableView.reloadData()
                    
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    func showEmptyState() {
//        Helper.showNoFilterState(vc: self, tb: tableView, reports: ModName.isLMSApproval)
        Helper.showNoFilterState(vc: self, tb: tableView, reports: ModName.isLMSApprovalDetails, action: #selector(self.populateList) )

    }
    
    func approveOrDeclineLeave( status : String, data:LMSLeaveData, comment:String) {
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.LMS.APPROVE_LEAVES, Session.authKey, data.reqId, status , Helper.encodeURL(url:comment))
            self.view.showLoading()
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                self.view.hideLoading()
                if Helper.isPostResponseValid(vc: self, response: response.result) {
                    if status == "Approved" {
                        self.showSuccessAlert()
                    } else {
                        self.showDeclineAlert()
                    }
                }
            })
        } else {
            
        }
        
    }
    
    func showSuccessAlert() {
        
        let alert = UIAlertController(title: "Success", message: "Leave Request Successfully Approved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
            (UIAlertAction) -> Void in
//            self.populateList()
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDeclineAlert() {
        let alert = UIAlertController(title: "Success", message: "Leave Request Successfully Declined", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
            (UIAlertAction) -> Void in
//            self.populateList()
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func onRightBtnTap(data: AnyObject, text: String, isApprove: Bool) {
        
        var commnt = ""
        if text == "" || text == "Enter Comment" || text == "Enter Comment (Optional)" {
            commnt = ""
        } else {
            commnt = text
        }
        
        if isApprove {
            self.approveOrDeclineLeave(status: "Approved", data: (data as! LMSLeaveData), comment: commnt)
            myView.removeFromSuperviewWithAnimate()
        } else {
            if text == "" || text == "Enter Comment"  {
                Helper.showMessage(message: "Please Enter Comment")
                return
            } else {
                self.approveOrDeclineLeave(status: "Rejected", data: (data as! LMSLeaveData), comment: commnt)
                declVw.removeFromSuperviewWithAnimate()
            }
        }
    }
    
    func onViewClick(data: AnyObject) {
        
    }
    
    func onMailClick(data: AnyObject) {
        
    }
    
    func onApproveClick(data: AnyObject) {
        
        self.handleTap()
        
        myView = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        myView.setDataToCustomView(title: "Approve?", description: "Are you sure you want to approve this Leave? You can't revert once approved", leftButton: "GO BACK", rightButton: "APPROVE",isTxtVwHidden: false, isApprove: true)
        myView.data = data
        myView.isApprove = true
        myView.cpvDelegate = self
        self.view.addMySubview(myView)
    }
    
    func onDeclineClick(data: AnyObject) {
        
        self.handleTap()
        declVw = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        declVw.setDataToCustomView(title: "Decline?", description: "Are you sure you want to decline this Leave? You can't revert once declined", leftButton: "GO BACK", rightButton: "DECLINE", isTxtVwHidden: false, isApprove: false)
        declVw.data = data
        declVw.isApprove = false
        declVw.cpvDelegate = self
        self.view.addMySubview(declVw)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
}


// MARK: - UITableViewDataSource methods
extension LMSLeaveDetailsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 315
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LMSLeaveDetailsCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        let data = self.arrayList[indexPath.row]
        cell.setDataToViews(data: data)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}

// MARK: - WC_HeaderViewDelegate methods
extension LMSLeaveDetailsVC: WC_HeaderViewDelegate {
    
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
