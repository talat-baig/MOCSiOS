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

class CounterpartyProfileController: UIViewController, UIGestureRecognizerDelegate , customPopUpDelegate {
    
    
    
    @IBOutlet weak var srchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    var myView = CustomPopUpView()
    
    var arrayList:[CPListData] = []
    var newArray : [CPListData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        srchBar.delegate = self
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        self.navigationController?.isNavigationBarHidden = true
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(self.populateList))
        tableView.addSubview(refreshControl)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = Constant.PAHeaderTitle.CP
        vwTopHeader.lblSubTitle.isHidden = true
        
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
    
    
    @objc func populateList(){
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.CP.LIST, Session.authKey)
            
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                
                if Helper.isResponseValid(vc: self, response: response.result, tv: self.tableView){
                    
                    let jsonResponse = JSON(response.result.value!);
                    let jsonArray = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    self.arrayList.removeAll()
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
                            
                            self.arrayList.append(data)
                        }
                        self.newArray = self.arrayList
                        self.tableView.tableFooterView = nil
                        
                    }else{
                        self.refreshControl.endRefreshing()
                        Helper.showNoFilterState(vc: self, tb: self.tableView, action: #selector(self.showFilterMenu))
                    }
                    self.tableView.reloadData()
                }
            }))
        }else{
            
            Helper.showNoInternetMessg()
            Helper.showNoInternetState(vc: self, tb: tableView, action: #selector(populateList))
            refreshControl.endRefreshing()
        }
    }
    
    
    func viewClaim(data:CPListData) {
        //        if internetStatus != .notReachable{
        //            let url = String.init(format: Constant.TCR.VIEW, Session.authKey,
        //                                  data.headRef, data.counter)
        //            self.view.showLoading()
        //            Alamofire.request(url).responseData(completionHandler: ({ response in
        //                self.view.hideLoading()
        //                if Helper.isResponseValid(vc: self, response: response.result){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "CPPrimaryViewController") as! CPPrimaryViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //                }
        //            }))
        //        }else{
        //            Helper.showNoInternetMessg()
        //        }
    }
    
    
    
    func onRightBtnTap(data: AnyObject, text: String, isApprove: Bool) {
        
    }
    
}

extension CounterpartyProfileController: UITableViewDataSource, UITableViewDelegate, onButtonClickListener {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 305
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
        
        let data = arrayList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cplistcell") as! CPCell
        cell.setDataToView(data: data)
        cell.delegate = self
        return cell;
    }
    
    func onViewClick(data: AnyObject) {
        //         viewClaim(data: data as! CPListData)
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "CPBaseViewController") as! CPBaseViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onMailClick(data: AnyObject) {
        
    }
    
    func onApproveClick(data: AnyObject) {
        
        self.handleTap()
        
        let myView = Bundle.main.loadNibNamed("EnterKYCDetailsView", owner: nil, options: nil)![0] as! EnterKYCDetailsView
        //        myView.setDataToCustomView(title: "Approve?", description: "Are you sure you want to approve this Claim? You can't revert once approved", leftButton: "GO BACK", rightButton: "APPROVE",isTxtVwHidden: false, isApprove: true)
        //        myView.data = data
        //        myView.cpvDelegate = self
        //        myView.isApprove = true
        self.view.addMySubview(myView)
        
        
        
    }
    
    func onDeclineClick(data: AnyObject) {
        
    }
    
    
    
}

extension CounterpartyProfileController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.arrayList = newArray
        } else {
            let filteredArray =   newArray.filter {
                $0.refId.localizedCaseInsensitiveContains(searchText)
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


