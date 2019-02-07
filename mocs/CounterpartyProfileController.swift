//
//  CounterpartyProfileController.swift
//  mocs
//
//  Created by Talat Baig on 8/27/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CounterpartyProfileController: UIViewController, UIGestureRecognizerDelegate , onCPApprove  , onCPUpdate {
    
    var navTitle = ""
    var currentPage : Int = 1
    
    @IBOutlet weak var srchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var btnMore: UIButton!
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    //    var myView = CustomPopUpView()
    //    var declView = CustomPopUpView()
    
    var arrayList:[CPListData] = []
    var newArray : [CPListData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        srchBar.delegate = self
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        self.navigationController?.isNavigationBarHidden = true
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(self.refreshList))
        tableView.addSubview(refreshControl)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.lblTitle.text = navTitle
        vwTopHeader.lblSubTitle.isHidden = true
        btnMore.isHidden = true
        btnMore.layer.cornerRadius = 5.0
        
        populateList()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @objc func showFilterMenu(){
        self.sideMenuViewController?.presentRightMenuViewController()
    }
    
    @objc func refreshList() {
        self.arrayList.removeAll()
        self.currentPage = 1
        self.populateList()
    }
    
    func loadMoreItemsForList() {
        self.currentPage += 1
        populateList()
    }
    
    @objc func populateList(){
        var arrData : [CPListData] = []
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.CP.LIST, Session.authKey, self.currentPage)
            
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                
                if Helper.isResponseValid(vc: self, response: response.result, tv: self.tableView){
                    
                    let jsonResponse = JSON(response.result.value!);
                    let jsonArray = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    //                    self.arrayList.removeAll()
                    if jsonArray.count > 0 {
                        
                        for(_,j):(String,JSON) in jsonResponse {
                            let data = CPListData()
                            
                            data.refId = j["Refid"].stringValue
                            data.custId = j["CustomerID"].stringValue
                            data.cpName = j["CPName"].stringValue
                            
                            data.contactType = j["ContactType"].stringValue
                            data.industryType = j["IndustryType"].stringValue
                            data.addedBy = j["Addedby"].stringValue
                            
                            data.addedDate = j["Addedbysysdt"].stringValue
                            data.address = j["Address"].stringValue
                            data.country = j["Country"].stringValue
                            
                            data.zipPostalCode = j["ZipPostalCode"].stringValue
                            data.branchCity = j["BranchCity"].stringValue
                            data.shortName = j["ShortName"].stringValue
                            
                            data.website = j["Website"].stringValue
                            data.faxNo = j["Faxno"].stringValue
                            
                            data.email = j["Email"].stringValue
                            
                            data.phNo1 = j["PhoneNo1"].stringValue
                            data.phNo2 = j["PhoneNo2"].stringValue
                            
                            data.kycRequired = j["KYCRequired"].stringValue
                            data.kycValidDate = j["KYCValidUntilDate"].stringValue
                            data.kycContactType = j["KYCContactType"].stringValue
                            
                            arrData.append(data)
                        }
                        self.arrayList.append(contentsOf: arrData)
                        self.newArray = self.arrayList
                        self.tableView.tableFooterView = nil
                        
                    } else {
                        
                        if self.arrayList.isEmpty {
                            self.btnMore.isHidden = true
                            Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isApprovals, action: nil)
                        } else {
                            self.currentPage -= 1
                            Helper.showMessage(message: "No more data found")
                        }
                    }
                    self.tableView.reloadData()
                } else {
                    if self.arrayList.isEmpty {
                        self.btnMore.isHidden = true
                        Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isApprovals, action: nil)
                    } else {
                        self.currentPage -= 1
                    }
                    print("Invalid Reponse")
                }
            }))
        }else{
           
            self.refreshControl.endRefreshing()
            Helper.showNoInternetMessg()
            
            if self.arrayList.isEmpty {
                btnMore.isHidden = true
                Helper.showNoInternetState(vc: self, tb: tableView, action: #selector(refreshList))
                self.tableView.reloadData()
            } else {
                self.currentPage -= 1
            }
        }
    }
    
    func onOkClick() {
        self.refreshList()
    }
    
    func onOkCPClick() {
        self.refreshList()
    }
    
    func onCPUpdateClick() {
        self.refreshList()
    }
    
    
    @IBAction func btnMoreTapped(_ sender: Any) {
        self.loadMoreItemsForList()
    }
    
    func viewClaim(data:CPListData) {
        
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.CP.VIEW, Session.authKey, data.custId)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let responseJson = JSON(response.result.value!)
                    let arrData = responseJson.arrayObject as! [[String:AnyObject]]
                    
                    if (arrData.count > 0) {
                        
                        self.getBankDetailsAndNavigate(primResponse: response.result.value!, data : data)
                    } else {
                        self.view.makeToast("No Data To Show")
                    }
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    
    func getBankDetailsAndNavigate(primResponse : Data , data : CPListData) {
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.CP.BANK_DETAILS, Session.authKey, data.custId)
            
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ bnkResponse in
                
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: bnkResponse.result) {
                    
                    let responseJson = JSON(bnkResponse.result.value!)
                    self.getRelationShipDetailsAndNavigate(primResponse: primResponse, bnkResponse: bnkResponse.result.value! , data : data)
                }
            }))
        }else{
            Helper.showNoInternetMessg()
        }
        
    }
    
    func getRelationShipDetailsAndNavigate(primResponse : Data , bnkResponse : Data , data : CPListData) {
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.CP.REL_DETAILS, Session.authKey, data.custId)
            
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ relResponse in
                
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: relResponse.result) {
                    
                    let responseJson = JSON(relResponse.result.value!)
                    
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "CPBaseViewController") as! CPBaseViewController
                    vc.bnkCredResponse = bnkResponse
                    vc.cpResponse = primResponse
                    vc.relResponse = relResponse.result.value
                    vc.cpListData = data
                    vc.cpBaseDel = self
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }))
        }else{
            Helper.showNoInternetMessg()
        }
    }
    
    func sendEmail(refId:String){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.CP.CP_MAIL, Session.authKey, refId)
            self.view.showLoading()
            
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                self.view.hideLoading()
                
                if response.result.value == "Success" {
                    let alert = UIAlertController(title: "Success", message: "Mail has been sent Successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) && self.arrayList.count > 0 {
            btnMore.isHidden = false
        } else {
            btnMore.isHidden = true
        }
    }
    
}

extension CounterpartyProfileController: UITableViewDataSource, UITableViewDelegate, onCPListMoreListener, onCPListMoreItemListener {
    
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
        self.handleTap()
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func onViewClick(data: CPListData) {
        self.handleTap()
        viewClaim(data: data)
    }
    
    func onMailClick(data: CPListData) {
        self.handleTap()
        let alert = UIAlertController(title: "Are you sure you want to Email?", message: "This Email will be send to your official Email ID", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "SEND", style: .default, handler: { (UIAlertAction) -> Void in
            self.sendEmail(refId: data.custId)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func onCancelClick() {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arrayList.count > 0{
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        }else{
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cplistcell") as! CPCell
        if self.arrayList.count > 0{
            let data = arrayList[indexPath.row]
            cell.setDataToView(data: data)
        }
        cell.cpMenuDelegate = self
        cell.cpOptionItemDelegate = self
        return cell;
    }
    
    
}

extension CounterpartyProfileController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.arrayList = newArray
        } else {
            let filteredArray =   newArray.filter {
                $0.custId.localizedCaseInsensitiveContains(searchText)
            }
            self.arrayList = filteredArray
        }
        tableView.reloadData()
    }
}



extension CounterpartyProfileController: WC_HeaderViewDelegate {
    
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


