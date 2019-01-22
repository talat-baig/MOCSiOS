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

class LMSReqController: UIViewController {
    
    var arrayGridList : [LMSGridData] = []
    var lmsSummry = LMSSummaryData()

    var arrayList : [LMSReqData] = []
    //    @IBOutlet weak var collVw: UICollectionView!
    //    @IBOutlet weak var gridTableVw: UITableView!
    @IBOutlet weak var tableView: UITableView!
    
    //    @IBOutlet weak var btnApplyLeave: UIButton!
    //    @IBOutlet weak var scrlVw: UIScrollView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "LMS Requests"
        vwTopHeader.lblSubTitle.isHidden = true
        
        
        self.tableView.register(UINib(nibName: "LMSReqDataCell", bundle: nil), forCellReuseIdentifier: "datacell")
        
        self.tableView.register(UINib(nibName: "LMSCustomHeader", bundle: nil), forCellReuseIdentifier: "summarycell")
        
        
        
        populateReqList()
    }
    
    func showLoading(){
        self.view.showLoading()
    }
    
    func hideLoading(){
        self.view.hideLoading()
    }
    
    @objc func populateReqList() {
        
        var data: [LMSReqData] = []
        
        if internetStatus != .notReachable {
            
            self.showLoading()
            let url:String = String.init(format: Constant.API.LMS_LIST, Session.authKey)
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.hideLoading()
                //                self.refreshControl.endRefreshing()
                
                if Helper.isResponseValid(vc: self, response: response.result, tv: self.tableView) {
                    
                    let jsonResponse = JSON(response.result.value!)
                    let array = jsonResponse.arrayObject as! [[String:AnyObject]]
                    if array.count > 0 {
                        self.arrayList.removeAll()
                        
                        for(_,json):(String,JSON) in jsonResponse{
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
                            lmsReq.mngrName = json["Reporting Manager"].stringValue
                            data.append(lmsReq)
                        }
                        self.arrayList = data
                        //                        self.newArray = data
                        self.tableView.tableFooterView = nil
                        self.tableView.reloadData()
                        //                        self.tblHeight.constant = self.tableView.contentSize.height
                    } else {
                        // show empty state
                        //                        Helper.showEmptyState(vc: <#UIViewController#>)
                    }
                }
            }))
        } else {
            Helper.showNoInternetMessg()
            Helper.showNoInternetState(vc: self, tb: tableView, action: #selector(populateReqList))
            //            self.refreshControl.endRefreshing()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    
    
    
    
    @objc func btnApplyTapped( sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LMSBaseViewController") as! LMSBaseViewController
        vc.isFromView = false
        vc.lmsReqData = nil
        self.navigationController!.pushViewController(vc, animated: true)
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
            
            return self.arrayList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 360
        } else {
            return 240
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var tableCell: UITableViewCell?
        
        if indexPath.section == 0 {
            let data = self.lmsSummry
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
        
    }
    
    func viewLeave(data:LMSReqData, isFromView : Bool){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LMSBaseViewController") as! LMSBaseViewController
        vc.isFromView = isFromView
        vc.lmsReqData = data
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
