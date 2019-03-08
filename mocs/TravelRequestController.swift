//
//  TravelRequestController.swift
//  mocs
//
//  Created by Talat Baig on 9/12/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TravelRequestController: UIViewController, UIGestureRecognizerDelegate , onTRFUpdate , onTRFSubmit{

    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!

    @IBOutlet weak var srchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var arrayList:[TravelRequestData] = []
    
    var newArray : [TravelRequestData] = []
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
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
        vwTopHeader.lblTitle.text = "Travel Requests"
        vwTopHeader.lblSubTitle.isHidden = true

        populateList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view?.isDescendant(of: tableView))! {
            return false
        }
        return true
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
        
        var data: [TravelRequestData] = []
        
        if internetStatus != .notReachable {
            
            self.showLoading()
            let url:String = String.init(format: Constant.TRF.TRF_LIST, Session.authKey)
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.hideLoading()
                self.refreshControl.endRefreshing()
                
                if Helper.isResponseValid(vc: self, response: response.result, tv: self.tableView) {
                    
                    let jsonResponse = JSON(response.result.value!)
                    let array = jsonResponse.arrayObject as! [[String:AnyObject]]
                    if array.count > 0 {
                        self.arrayList.removeAll()
                        
                        for(_,json):(String,JSON) in jsonResponse {
                           
                            let trfData = TravelRequestData()
                            
                            trfData.reqNo = json["RequestNo"].stringValue
                            trfData.reqDate = json["RequestDate"].stringValue
                            trfData.empName = json["EmployeeName"].stringValue
                            trfData.empDept = json["Department"].stringValue
                            trfData.empCode = json["EmployeeCode"].stringValue

                            trfData.empDesgntn = json["Designation"].stringValue
                            trfData.counter = json["Counter"].intValue
                            trfData.reason = json["ReasonForTravel"].stringValue
                            trfData.accmpnd = json["Accompanied"].stringValue
                            trfData.requestor = json["Requestor"].stringValue
                            trfData.currency = json["Currency"].stringValue
                            trfData.trvelAdvnce = json["TravelAdvance"].stringValue
                            trfData.status = json["Status1"].stringValue
                            trfData.trfId = json["ID"].intValue
                            trfData.reportMngr = json["ReportingManager"].stringValue
                            trfData.trvArrangmnt = json["TravelArrangement"].stringValue

                            
                            if json["Approver"].stringValue == "" {
                                trfData.approver = ""
                            } else {
                                trfData.approver  = json["Approver"].stringValue
                            }
                            
                            if json["ApproverDate"].stringValue == "" {
                                  trfData.approvdDate = ""
                            } else {
                                  trfData.approvdDate  = json["ApproverDate"].stringValue
                            }
                            data.append(trfData)
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
    
    func onTRFUpdateClick() {
        populateList()
    }
    
    @IBAction func btnAddRequestTapped(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TravelRequestAddEditController") as! TravelRequestAddEditController
        vc.okTRFSubmit = self
        self.navigationController!.pushViewController(vc, animated: true)
        
    }

    func viewRequest(data: TravelRequestData,  isFromView: Bool) {
    
        getItirenaryData(trfData : data, isFromView: isFromView)
    }
    
    func submitRequest(data : TravelRequestData) {
    
        if self.internetStatus != .notReachable{
            showLoading()
            let url = String.init(format: Constant.TRF.TRF_SUBMIT, Session.authKey, data.trfId)
            print("Submit TRF", url)
            
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                self.view.hideLoading()
                
                if Helper.isPostResponseValid(vc: self, response: response.result) {
                    
                    let success = UIAlertController(title: "Success", message: "Request has been Submitted Successfully", preferredStyle: .alert)
                    success.addAction(UIAlertAction(title: "OK", style: .default, handler: {(AlertAction) ->  Void in
                        self.populateList()
                    }))
                    self.present(success, animated: true, completion: nil)
                }
            })
        } else {
            Helper.showNoInternetMessg()
        }
        
    }
    
    
    
    
    func deleteRequest(data : TravelRequestData ) {
        
        if internetStatus != .notReachable {
            showLoading()
            let url = String.init(format: Constant.TRF.TRF_DELETE, Session.authKey, data.trfId)
            print(url)
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                
                self.view.hideLoading()
                if Helper.isPostResponseValid(vc: self, response: response.result) {
                    
                    let alert = UIAlertController(title: "Success", message: "Request Successfully deleted", preferredStyle: .alert)
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
    
    
    func getItirenaryData(trfData :TravelRequestData, isFromView : Bool ) {
        
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.TRF.ITINERARY_LIST, Session.authKey,
                                  trfData.trfId)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
            
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TRBaseViewController") as! TRBaseViewController
                    vc.trfData = trfData
                    vc.isFromView = isFromView
                    vc.trfBaseDelegate = self
                    vc.trfReqNo = trfData.reqNo
                    vc.itinryRespone = response.result.value
                
                    self.navigationController!.pushViewController(vc, animated: true)
            
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }

    func onOkClick() {
        populateList()
    }
    
    
}

extension TravelRequestController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.arrayList = newArray
        } else {
            let filteredArray = newArray.filter {
                $0.reqNo.localizedCaseInsensitiveContains(searchText)
            }
            self.arrayList = filteredArray
        }
        tableView.reloadData()
    }
}


extension TravelRequestController: UITableViewDataSource, UITableViewDelegate, onMoreClickListener, onTReqItemClickListener {
 
   
    func onViewClick(data: TravelRequestData) {
        viewRequest(data: data,  isFromView: true)
    }
    
    func onEditClick(data: TravelRequestData) {
        viewRequest(data: data,  isFromView: false)
    }
    
    func onDeleteClick(data: TravelRequestData) {
        
        let alert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete Travel Request Item? Once you delete this, there is no way to un-delete", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO GO BACK", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) -> Void in
            self.deleteRequest(data : data )
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func onSubmitClick(data: TravelRequestData) {
        
        
        
        let alert = UIAlertController(title: "Submit Request?", message: "Are you sure you want to submit this Request? After submitting you'll not be able to edit the Request", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) -> Void in
            
            self.submitRequest(data:data)
        }))
        self.present(alert, animated: true, completion: nil)
        
      }
    

    
    func onEmailClick(data: TravelRequestData) {
        let alert = UIAlertController(title: "Are you sure you want to Email?", message: "This Email will be send to your official Email ID", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "SEND", style: .default, handler: { (UIAlertAction) -> Void in
            self.sendEmail(data: data)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendEmail(data:TravelRequestData){
        
        showLoading()
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.TRF.TRF_SEND_EMAIL, Session.authKey,data.trfId )
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                self.view.hideLoading()
                let jsonResponse = JSON.init(parseJSON: response.result.value!)
                
                if jsonResponse["ServerMsg"].stringValue == "Success" {
                    
                    let alert = UIAlertController(title: "Success", message: "Request has been Mailed Successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            })
        }else{
            Helper.showNoInternetMessg()
        }
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
        return 230
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        handleTap()
   
        let data = arrayList[indexPath.row]
        
        if (data.status.caseInsensitiveCompare("Saved") == ComparisonResult.orderedSame){
            viewRequest(data: data, isFromView: false)
        } else {
            viewRequest(data: data , isFromView: true)
        }
        
        if (data.status.caseInsensitiveCompare("Sent for Approval") == ComparisonResult.orderedSame) || (data.status.caseInsensitiveCompare("approved") == ComparisonResult.orderedSame) || (data.status.caseInsensitiveCompare("declined")  == ComparisonResult.orderedSame) {
            self.view.makeToast("Request already submitted, cannot be edited")
        }

        if (data.status.caseInsensitiveCompare("deleted") == ComparisonResult.orderedSame){
            self.view.makeToast("Request has been deleted, cannot be edited")
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let data = arrayList[indexPath.row]
        let view = tableView.dequeueReusableCell(withIdentifier: "TravelRequestAdapter") as! TravelRequestAdapter
        view.btnMore.tag = indexPath.row
        view.setDataToView(data: data, isFromApprove : false)
        view.isFromApprov = false
        view.delegate = self
        view.trvlReqItemClickListener = self
        return view
    }
    
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
        
        let section = 0
        let indexPath = IndexPath(row: sender.tag, section: section)
        let cell: TravelRequestAdapter = self.tableView.cellForRow(at: indexPath) as! TravelRequestAdapter
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            if let presentation = optionMenu.popoverPresentationController {
                presentation.sourceView = cell.btnMore
            }
        }
        self.present(optionMenu, animated: true, completion: nil)
    }
    
  
}


extension TravelRequestController: WC_HeaderViewDelegate {
    
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

