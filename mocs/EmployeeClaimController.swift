
//
//  EmployeeClaimController.swift
//  mocs
//
//  Created by Talat Baig on 6/12/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EmployeeClaimController: UIViewController, onMoreClickListener {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
  
    var arrayList:[EmployeeClaimData] = []
    var newArray : [EmployeeClaimData] = []

    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Employee Claims Reimbursement"
        vwTopHeader.lblSubTitle.isHidden = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.isHidden = true
        
        
        populateList()
//        srchBar.delegate = self
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(self.populateList))
        tableView.addSubview(refreshControl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showLoading(){
        self.view.showLoading()
    }
    
    func hideLoading(){
        self.view.hideLoading()
    }
    
    
    @objc func populateList() {
        var data: [EmployeeClaimData] = []
        
        if internetStatus != .notReachable {
            
            self.showLoading()
            let url:String = String.init(format: Constant.API.ECR_LIST)
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.hideLoading()
                self.refreshControl.endRefreshing()
                
                if Helper.isResponseValid(vc: self, response: response.result, tv: self.tableView) {
                    
                    let jsonResponse = JSON(response.result.value!)
                    let array = jsonResponse.arrayObject as! [[String:AnyObject]]
                    if array.count > 0 {
                        self.arrayList.removeAll()
                        
                        for(_,json):(String,JSON) in jsonResponse{
                            let ecData = EmployeeClaimData()
                            ecData.headRef = json["EPRMainReferenceID"].stringValue
                            ecData.headStatus = json["DepartmentApprovalStatus"].stringValue
                            ecData.companyName = json["EPRMainCompanyName"].stringValue
                            ecData.employeeDepartment = json["EPRMainDepartment"].stringValue
                            ecData.location = json["EPRMainLocation"].stringValue
                            ecData.reqAmount = json["Total Requested value"].stringValue
                            ecData.currency = json["EPRMainRequestedCurrency"].stringValue
                            ecData.paidAmount = json["Total Paid Value"].stringValue
                            ecData.balance = json["Balance To Pay"].stringValue
                            ecData.requestedDate = json["EPRMainRequestedValueDate"].stringValue

                            data.append(ecData)
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
    
    
    
    @IBAction func btnAddNewClaimTapped(_ sender: Any) {
        let ecAddEditVC = self.storyboard?.instantiateViewController(withIdentifier: "EmployeeClaimAddEditVC") as! EmployeeClaimAddEditVC
//        tcAddEditVC.response = nil\
        ecAddEditVC.isToUpdate = false
//        tcAddEditVC.okTCRSubmit = self
        self.navigationController?.pushViewController(ecAddEditVC, animated: true)
        
        
    }
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    
}

extension EmployeeClaimController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arrayList.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        return arrayList.count
//        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        handleTap()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ECRBaseViewController") as! ECRBaseViewController
        
        self.navigationController!.pushViewController(vc, animated: true)
//        let data = arrayList[indexPath.row]
//
//        if (data.headStatus.caseInsensitiveCompare("draft") == ComparisonResult.orderedSame){
//            viewClaim(data: data, counter: data.counter , isFromView: false)
//        } else {
//            viewClaim(data: data, counter: data.counter , isFromView: true)
//        }
//
//        if (data.headStatus.caseInsensitiveCompare("submitted") == ComparisonResult.orderedSame) || (data.headStatus.caseInsensitiveCompare("approved by finance") == ComparisonResult.orderedSame) || (data.headStatus.caseInsensitiveCompare("approved By manager")  == ComparisonResult.orderedSame) {
//            self.view.makeToast("Claim already submitted, cannot be edited")
//        }
//
//        if (data.headStatus.caseInsensitiveCompare("deleted") == ComparisonResult.orderedSame){
//            self.view.makeToast("Claim has been deleted, cannot be edited")
//        }
//
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let data = arrayList[indexPath.row]
        let view = tableView.dequeueReusableCell(withIdentifier: "empClaimAdapter") as! EmployeeClaimAdapter
        view.setDataToView(data: data)
        view.delegate = self
        return view
    }
    
    
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
        
        let section = 0
        let indexPath = IndexPath(row: sender.tag, section: section)
        let cell: EmployeeClaimAdapter = self.tableView.cellForRow(at: indexPath) as! EmployeeClaimAdapter

        if (UIDevice.current.userInterfaceIdiom == .pad) {
            if let presentation = optionMenu.popoverPresentationController {
                presentation.sourceView = cell.btnOptionMenu
            }
        }
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    func onViewClick(data: TravelClaimData) {
//        viewClaim(data: data ,isFromView: true)
    }
    
    func viewClaim(data:TravelClaimData, counter: Int = 0, isFromView : Bool){
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
    }
    
    
    
//    func onEditClick(data: TravelClaimData) {
////        viewClaim(data: data, counter:data.counter , isFromView: false)
//    }
//
//    func onDeleteClick(data: TravelClaimData) {
//        let alert = UIAlertController(title: "Delete Claim?", message: "Are you sure you want to delete this claim? After deleting you'll not be able to rollback", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
//        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) -> Void in
////            self.deleteClaim(data: data)
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
////                self.submitInvoice(data:data)
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
////            self.sendEmail(data: data)
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
}

extension EmployeeClaimController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
        
    }
    
}


