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
       
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BaseViewController") as! BaseViewController
//        vc.response = tcrResponse
//        vc.isFromView = isFromView
//        vc.tcrBaseDelegate = self
//        vc.notifyChilds = self
//        vc.title = tcrData.headRef
//        vc.voucherResponse = response.result.value
//        vc.tcrData = tcrData
//        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func onEditClick(data: TravelRequestData) {
        
        viewRequest(data: data,  isFromView: false)

//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TRBaseViewController") as! TRBaseViewController
//        vc.response = tcrResponse
//        vc.isFromView = isFromView
//        vc.tcrBaseDelegate = self
//        vc.title = tcrData.headRef
//        vc.itnryResponse = response.result.value
//        vc.tcrData = tcrData
//        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func onDeleteClick(data: TravelRequestData) {
        
    }
    
    func onSubmitClick(data: TravelRequestData) {
        
    }
    
    func onEmailClick(data: TravelRequestData) {
        
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
        return 240
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        handleTap()
   
        let data = arrayList[indexPath.row]
 
        viewRequest(data: data , isFromView: false)

        
//        if (data.headStatus.caseInsensitiveCompare("draft") == ComparisonResult.orderedSame){
//            viewClaim(data: data, counter: data.counter , isFromView: false)
//        } else {
//            viewClaim(data: data, counter: data.counter , isFromView: true)
//        }
        
//        if (data.headStatus.caseInsensitiveCompare("submitted") == ComparisonResult.orderedSame) || (data.headStatus.caseInsensitiveCompare("approved by finance") == ComparisonResult.orderedSame) || (data.headStatus.caseInsensitiveCompare("approved By manager")  == ComparisonResult.orderedSame) {
//            self.view.makeToast("Claim already submitted, cannot be edited")
//        }
//
//        if (data.headStatus.caseInsensitiveCompare("deleted") == ComparisonResult.orderedSame){
//            self.view.makeToast("Claim has been deleted, cannot be edited")
//        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let data = arrayList[indexPath.row]
        let view = tableView.dequeueReusableCell(withIdentifier: "TravelRequestAdapter") as! TravelRequestAdapter
        view.btnMore.tag = indexPath.row
        view.setDataToView(data: data)
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
    
    
    func onViewClick(data: TravelClaimData) {
//        viewClaim(data: data ,isFromView: true)
    }
    
//    func viewClaim(data:TravelClaimData, counter: Int = 0, isFromView : Bool){
//        if internetStatus != .notReachable{
//            let url = String.init(format: Constant.TCR.VIEW, Session.authKey,
//                                  data.headRef,data.counter)
//            self.view.showLoading()
//            Alamofire.request(url).responseData(completionHandler: ({ response in
//                self.view.hideLoading()
//                if Helper.isResponseValid(vc: self, response: response.result){
//
//                    self.getVouchersDataAndNavigate(tcrData: data, isFromView: isFromView, tcrResponse: response.result.value)
//                }
//            }))
//        } else {
//            Helper.showNoInternetMessg()
//        }
//    }
//
    
    
//    func onEditClick(data: TravelClaimData) {
//        viewClaim(data: data, counter:data.counter , isFromView: false)
//    }
//
//    func onDeleteClick(data: TravelClaimData) {
//        let alert = UIAlertController(title: "Delete Claim?", message: "Are you sure you want to delete this claim? After deleting you'll not be able to rollback", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
//        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) -> Void in
//            self.deleteClaim(data: data)
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    func onSubmitClick(data: TravelClaimData) {
//
//        let currentDate = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd MMM yyyy"
//        dateFormatter.calendar = Calendar(identifier: .iso8601)
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//        let travelEndDate = dateFormatter.date(from: data.endDate)
//
//        if travelEndDate! > currentDate {
//            Helper.showMessage(message: "Travel end date cannot be greater then current date")
//            return
//
//        } else if data.totalAmount == "0.00" {
//            Helper.showMessage(message: "Please add expense before submitting")
//            return
//
//        } else {
//
//            let alert = UIAlertController(title: "Submit Claim?", message: "Are you sure you want to submit this claim? After submitting you'll not be able to edit the claim", preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
//
//            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) -> Void in
//
//                self.submitInvoice(data:data)
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }
//
//    }
//
//    func onEmailClick(data: TravelClaimData) {
//
//        let alert = UIAlertController(title: "Are you sure you want to Email?", message: "This Email will be send to your official Email ID", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
//        alert.addAction(UIAlertAction(title: "SEND", style: .default, handler: { (UIAlertAction) -> Void in
//            self.sendEmail(data: data)
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
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

