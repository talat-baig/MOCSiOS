
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

class EmployeeClaimController: UIViewController, onMoreClickListener, onECRUpdate, onECRSubmit, notifyChilds_UC {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var srchBar: UISearchBar!
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()

    var arrayList:[EmployeeClaimData] = []
    
    var newArray : [EmployeeClaimData] = []
    
    
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
        
        srchBar.delegate = self
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(self.populateList))
        tableView.addSubview(refreshControl)

        populateList()
        
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
    
    func onECRUpdateClick() {
        self.populateList()
    }
    
    func notifyChild(messg: String, success: Bool) {
        Helper.showVUMessage(message: messg, success: success)
    }
    
    @objc func populateList() {
        var data: [EmployeeClaimData] = []
        
        if internetStatus != .notReachable {
            
            self.showLoading()
            let url:String = String.init(format: Constant.API.ECR_LIST, Session.authKey)
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.hideLoading()
                self.refreshControl.endRefreshing()
                
                if Helper.isResponseValid(vc: self, response: response.result, tv: self.tableView) {
                    
                    let jsonResponse = JSON(response.result.value!)
                    let array = jsonResponse.arrayObject as! [[String:AnyObject]]
                    if array.count > 0 {
                        self.arrayList.removeAll()
                        
                        for(_,json):(String,JSON) in jsonResponse {
                            
                            let ecData = EmployeeClaimData()
                            ecData.headRef = json["EPRMainReferenceID"].stringValue
                            ecData.headStatus = json["Status"].stringValue
                            ecData.companyName = json["EPRMainCompanyName"].stringValue
                            ecData.employeeDepartment = json["EPRMainDepartment"].stringValue
                            ecData.location = json["EPRMainLocation"].stringValue
                            ecData.reqAmount = json["Total Requested value"].stringValue
                            ecData.currency = json["EPRMainRequestedCurrency"].stringValue
//                            ecData.paidAmount = json["Total Paid Value"].stringValue
//                            ecData.balance = json["Balance To Pay"].stringValue
                          
                            ecData.paidAmount = json["Total Paid Value"].stringValue != "" ? json["Total Paid Value"].stringValue : "-"

                            ecData.balance = json["Balance To Pay"].stringValue != "" ? json["Balance To Pay"].stringValue : "-"

                            
                            ecData.requestedDate = json["EPRMainRequestedValueDate"].stringValue
                            ecData.benefName = json["EPRMainBeneficiaryName"].stringValue
                            ecData.paymntMethd = json["EPRMainRequestedPaymentMode"].stringValue

                            ecData.counter = json["EprRefIDCounter"].intValue
                            
                            ecData.eprMainId = json["EmployeePaymentRequestMainID"].stringValue

                            
                            ecData.claimType = json["EPRMainPaymentRequestType"].stringValue

                            
                            if json["EPRMainPaymentRequestType"].stringValue == "Advance" {
                                
                                ecData.claimTypeInInt = 1
                                
                            } else if json["EPRMainPaymentRequestType"].stringValue == "Claim Reimbursement" {
                                
                                ecData.claimTypeInInt = 2
                            } else {
                                ecData.claimTypeInInt = 3
                            }
                            
                            
                            
                            if json["EPRMainOpenAdvanceValue"].stringValue == "" {
                                ecData.eprValue = ""
                            } else {
                                ecData.eprValue = json["EPRMainOpenAdvanceValue"].stringValue
                            }
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
        ecAddEditVC.empCurrencyRes = Session.currency
        ecAddEditVC.okECRSubmit = self
        self.navigationController?.pushViewController(ecAddEditVC, animated: true)
    }
    
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    func onOkClick() {
        self.populateList()
    }
    
    
}

extension EmployeeClaimController: UISearchBarDelegate {
    
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


extension EmployeeClaimController: UITableViewDataSource, UITableViewDelegate, onOptionECRTapDelegate {
    
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
        return 275
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
        let view = tableView.dequeueReusableCell(withIdentifier: "empClaimAdapter") as! EmployeeClaimAdapter
        view.btnOptionMenu.tag = indexPath.row
        view.optionECRTapDelegate = self
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
    
    
    func onViewClick(data: EmployeeClaimData) {
        viewClaim(data: data ,isFromView: true)
    }
    
    func onEditClick(data: EmployeeClaimData) {
        viewClaim(data: data, counter:data.counter , isFromView: false)
    }
    
    func onDeleteClick(data: EmployeeClaimData) {
        
        let alert = UIAlertController(title: "Delete Claim?", message: "Are you sure you want to delete this claim? After deleting you'll not be able to rollback", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) -> Void in
            self.deleteClaim(data: data)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func onSubmitClick(data: EmployeeClaimData) {
        
        if data.reqAmount == "0" {
            Helper.showMessage(message: "Please add payment before submitting")
            return
            
        }
        
        let alert = UIAlertController(title: "Submit Claim?", message: "Are you sure you want to submit this claim? After submitting you'll not be able to edit the claim", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) -> Void in
            
            self.submitInvoice(data:data)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func onEmailClick(data: EmployeeClaimData) {
        
        
        let alert = UIAlertController(title: "Are you sure you want to Email?", message: "This Email will be send to your official Email ID", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "SEND", style: .default, handler: { (UIAlertAction) -> Void in
            self.sendEmail(data: data)
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    
    func viewClaim(data:EmployeeClaimData, counter: Int = 0, isFromView : Bool) {
        
        self.getPaymentAndVouchersData(ecrData: data, isFromView: isFromView)
    }
    
    func sendEmail(data:EmployeeClaimData) {
        
        showLoading()
        
        if internetStatus != .notReachable {
         
            let url = String.init(format: Constant.API.ECR_SEND_EMAIL, Session.authKey,Session.email,data.eprMainId,data.headRef, data.counter)
            print("Email url",url)
          
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                self.view.hideLoading()
                
                if response.result.value == "Success" {

                    let alert = UIAlertController(title: "Success", message: "Claim has been Mailed Successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            })
        }else{
            Helper.showNoInternetMessg()
        }
    }
    
    func submitInvoice(data: EmployeeClaimData){
        if self.internetStatus != .notReachable{
            showLoading()
            let url = String.init(format: Constant.API.ECR_SUBMIT, Session.authKey, data.headRef, data.claimTypeInInt, data.eprMainId, data.counter)
            print("Submit EPR/ECR", url)
            
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                self.view.hideLoading()
                
                if Helper.isPostResponseValid(vc: self, response: response.result) {
                    
                    let success = UIAlertController(title: "Success", message: "Claim has been Submitted Successfully", preferredStyle: .alert)
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
    
    func deleteClaim(data:EmployeeClaimData) {
    
        if internetStatus != .notReachable {
            showLoading()
            print(data.headRef)
            let url = String.init(format: Constant.API.ECR_DELETE, Session.authKey, data.eprMainId)
            print(url)
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in

                self.view.hideLoading()
                if Helper.isPostResponseValid(vc: self, response: response.result) {
                    
                    let alert = UIAlertController(title: "Success", message: "Claim Successfully deleted", preferredStyle: .alert)
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
    
    func getPaymentAndVouchersData(ecrData :EmployeeClaimData, isFromView : Bool ) {
        
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.API.ECR_PAYMENT_LIST, Session.authKey,
                                  ecrData.headRef, ecrData.counter)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
              
                if Helper.isResponseValid(vc: self, response: response.result,tv: self.tableView){
                    
                    self.getVouchersDataAndNavigate(ecrData: ecrData, isFromView: isFromView, ecrPaymentRes: response.result.value)
                    
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    
    func getVouchersDataAndNavigate(ecrData :EmployeeClaimData, isFromView : Bool , ecrPaymentRes : Data?) {
        
        let docRefId = String(format: "%@D%d", ecrData.headRef , ecrData.counter)
        if internetStatus != .notReachable {
            
            var url = String()
            
            if(ecrData.headStatus.caseInsensitiveCompare("draft") == ComparisonResult.orderedSame) {
                url =  String.init(format: Constant.DROPBOX.LIST,
                                   Session.authKey,
                                   Helper.encodeURL(url: Constant.MODULES.EPRECR),
                                   Helper.encodeURL(url: docRefId))
            } else {
                url =  String.init(format: Constant.DROPBOX.LIST,
                                   Session.authKey,
                                   Helper.encodeURL(url: Constant.MODULES.EPRECR),
                                   Helper.encodeURL(url: ecrData.headRef))
            }
            
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ECRBaseViewController") as! ECRBaseViewController
                    vc.isFromView = isFromView
                    vc.ecrBaseDelegate = self
                    vc.notifyChilds = self
                    vc.title = ecrData.headRef
                    vc.voucherResponse = response.result.value
                    vc.ecrData = ecrData
                    vc.paymntRes = ecrPaymentRes
                    self.navigationController!.pushViewController(vc, animated: true)
                    
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }

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


