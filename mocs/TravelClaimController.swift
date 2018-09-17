//
//  TravelClaimController.swift
//  mocs
//
//  Created by Rv on 25/01/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TravelClaimController: UIViewController, UIGestureRecognizerDelegate, onTCRSubmit, notifyChilds_UC, onTCRUpdate {
   
   
    var arrayList: [TravelClaimData] = []
    var newArray : [TravelClaimData] = []
    
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
        
        populateList()
        //        self.title = "Travel Claims"
        srchBar.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.isHidden = true
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Travel Claims"
        vwTopHeader.lblSubTitle.isHidden = true
        
    }
    
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // populateList()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func btnAddNewClaim(_ sender: Any) {
        
        let tcAddEditVC = self.storyboard?.instantiateViewController(withIdentifier: "TravelClaimEditAddController") as! TravelClaimEditAddController
        tcAddEditVC.response = nil
        tcAddEditVC.okTCRSubmit = self
        self.navigationController?.pushViewController(tcAddEditVC, animated: true)
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view?.isDescendant(of: tableView))! {
            return false
        }
        return true
    }
    
    func getVouchersDataAndNavigate(tcrData :TravelClaimData, isFromView : Bool , tcrResponse : Data?) {
        
        let docRefId = String(format: "%@D%d", tcrData.headRef , tcrData.counter)
        
        if internetStatus != .notReachable {
            
            var url = String()
            
            if(tcrData.headStatus.caseInsensitiveCompare("draft") == ComparisonResult.orderedSame) {
                url =  String.init(format: Constant.DROPBOX.LIST,
                                   Session.authKey,
                                   Helper.encodeURL(url: Constant.MODULES.TCR),
                                   Helper.encodeURL(url: docRefId))
            } else {
                url =  String.init(format: Constant.DROPBOX.LIST,
                                   Session.authKey,
                                   Helper.encodeURL(url: Constant.MODULES.TCR),
                                   Helper.encodeURL(url: tcrData.headRef))
                
            }
            
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "BaseViewController") as! BaseViewController
                    vc.response = tcrResponse
                    vc.isFromView = isFromView
                    vc.tcrBaseDelegate = self
                    vc.notifyChilds = self
                    vc.title = tcrData.headRef
                    vc.voucherResponse = response.result.value
                    vc.tcrData = tcrData
                    self.navigationController!.pushViewController(vc, animated: true)
                    
                }
            }))
        } else {
           Helper.showNoInternetMessg()
        }
    }
    
    func notifyChild(messg: String, success : Bool) {
        Helper.showVUMessage(message: messg, success: success)
    }
    
    func onOkClick() {
        self.populateList()
    }
    
    func onTCRUpdateClick() {
        self.populateList()
    }
    
    @objc func populateList() {
        var data: [TravelClaimData] = []
        
        if internetStatus != .notReachable {
            
            self.showLoading()
            let url:String = String.init(format: Constant.API.TCR_LIST, Session.authKey)
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.hideLoading()
                self.refreshControl.endRefreshing()
                
                if Helper.isResponseValid(vc: self, response: response.result, tv: self.tableView) {
                    
                    let jsonResponse = JSON(response.result.value!)
                    let array = jsonResponse.arrayObject as! [[String:AnyObject]]
                    if array.count > 0 {
                        self.arrayList.removeAll()
                        
                        for(_,json):(String,JSON) in jsonResponse{
                            let travel = TravelClaimData()
                            travel.employeeName = json["Employee Name"].stringValue
                            travel.headRef = json["TCR Reference ID"].stringValue
                            travel.headStatus = json["Status"].stringValue
                            travel.companyName = json["Company Name"].stringValue
                            travel.employeeDepartment = json["Business Vertical"].stringValue
                            travel.location = json["Location"].stringValue
                            travel.purposeOfTravel = json["Purpose of Travel"].stringValue
                            travel.periodOfTravel = json["Period of Travel"].stringValue
                            travel.claimRaisedOn = json["Claim Raised On"].stringValue
                            travel.totalAmount = json["Total Amount (Local Currency)"].stringValue
                            travel.counter = json["counter"].intValue
                            travel.endDate = json["EndDate"].stringValue
                            data.append(travel)
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
    
    func showLoading(){
        self.view.showLoading()
    }
    
    func hideLoading(){
        self.view.hideLoading()
    }
    
    
    func sendEmail(data:TravelClaimData){
        showLoading()
        
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.API.SEND_EMAIL_TCR, Session.authKey,"TCR", data.headRef, data.counter)
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let alert = UIAlertController(title: "Success", message: "Claim has been Mailed Successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }))
        }else{
            Helper.showNoInternetMessg()
        }
    }
    
    func submitInvoice(data: TravelClaimData){
        if self.internetStatus != .notReachable{
            showLoading()
            let url = String.init(format: Constant.API.TCR_SUBMIT, Session.authKey, data.headRef, data.counter)
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let success = UIAlertController(title: "Success", message: "Claim has been Submitted Successfully", preferredStyle: .alert)
                    success.addAction(UIAlertAction(title: "OK", style: .default, handler: {(AlertAction) ->  Void in
                        self.populateList()
                    }))
                    self.present(success, animated: true, completion: nil)
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    func deleteClaim(data:TravelClaimData) {
        
        if internetStatus != .notReachable {
            showLoading()
            print(data.headRef)
            let url = String.init(format: Constant.API.TCR_DELETE, Session.authKey, data.headRef, data.counter)
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let alert = UIAlertController(title: "Success", message: "Claim Successfully deleted", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(AlertAction) ->  Void in
                        self.populateList()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
}

extension TravelClaimController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.arrayList = newArray
        } else {
            let filteredArray = newArray.filter {
                $0.headRef.localizedCaseInsensitiveContains(searchText)
            }
            self.arrayList = filteredArray
        }
        tableView.reloadData()
    }
}

extension TravelClaimController: UITableViewDataSource, UITableViewDelegate, onMoreClickListener, onOptionIemClickListener {
    
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
        return 305
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        handleTap()
        let data = arrayList[indexPath.row]
        
        if (data.headStatus.caseInsensitiveCompare("draft") == ComparisonResult.orderedSame){
            viewClaim(data: data, counter: data.counter , isFromView: false)
        } else {
            viewClaim(data: data, counter: data.counter , isFromView: true)
        }
        
        if (data.headStatus.caseInsensitiveCompare("submitted") == ComparisonResult.orderedSame) || (data.headStatus.caseInsensitiveCompare("approved by finance") == ComparisonResult.orderedSame) || (data.headStatus.caseInsensitiveCompare("approved By manager")  == ComparisonResult.orderedSame) {
            self.view.makeToast("Claim already submitted, cannot be edited")
        }
        
        if (data.headStatus.caseInsensitiveCompare("deleted") == ComparisonResult.orderedSame){
            self.view.makeToast("Claim has been deleted, cannot be edited")
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = arrayList[indexPath.row]
        let view = tableView.dequeueReusableCell(withIdentifier: "TravelClaimAdapter") as! TravelClaimAdapter
        view.btnMenu.tag = indexPath.row
        view.setDataToView(data: data)
        view.delegate = self
        view.optionClickListener = self
        return view
    }
    
   
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
        
        let section = 0
        let indexPath = IndexPath(row: sender.tag, section: section)
        let cell: TravelClaimAdapter = self.tableView.cellForRow(at: indexPath) as! TravelClaimAdapter
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            if let presentation = optionMenu.popoverPresentationController {
                presentation.sourceView = cell.btnMenu
            }
        }
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    func onViewClick(data: TravelClaimData) {
        viewClaim(data: data ,isFromView: true)
    }
    
    func viewClaim(data:TravelClaimData, counter: Int = 0, isFromView : Bool){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.TCR.VIEW, Session.authKey,
                                  data.headRef,data.counter)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    self.getVouchersDataAndNavigate(tcrData: data, isFromView: isFromView, tcrResponse: response.result.value)
                }
            }))
        } else {
           Helper.showNoInternetMessg()
        }
    }
    
    
    
    func onEditClick(data: TravelClaimData) {
        viewClaim(data: data, counter:data.counter , isFromView: false)
    }
    
    func onDeleteClick(data: TravelClaimData) {
        let alert = UIAlertController(title: "Delete Claim?", message: "Are you sure you want to delete this claim? After deleting you'll not be able to rollback", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) -> Void in
            self.deleteClaim(data: data)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func onSubmitClick(data: TravelClaimData) {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let travelEndDate = dateFormatter.date(from: data.endDate)
        
        if travelEndDate! > currentDate {
            Helper.showMessage(message: "Travel end date cannot be greater then current date")
            return
            
        } else if data.totalAmount == "0.00" {
            Helper.showMessage(message: "Please add expense before submitting")
            return
            
        } else {
            
            let alert = UIAlertController(title: "Submit Claim?", message: "Are you sure you want to submit this claim? After submitting you'll not be able to edit the claim", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
            
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) -> Void in
               
                self.submitInvoice(data:data)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func onEmailClick(data: TravelClaimData) {
        
        let alert = UIAlertController(title: "Are you sure you want to Email?", message: "This Email will be send to your official Email ID", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "SEND", style: .default, handler: { (UIAlertAction) -> Void in
            self.sendEmail(data: data)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension TravelClaimController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
        
    }
    
}


