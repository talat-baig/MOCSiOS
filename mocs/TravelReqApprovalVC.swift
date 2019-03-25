//
//  TravelReqApprovalVC.swift
//  mocs
//
//  Created by Talat Baig on 9/21/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NotificationBannerSwift

class TravelReqApprovalVC: UIViewController, UIGestureRecognizerDelegate, customPopUpDelegate {
    
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    var navTitle = ""
    var arrayList:[TravelRequestData] = []
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    var myView = CustomPopUpView()
    var declView = CustomPopUpView()
    @IBOutlet weak var btnMore: UIButton!
    var currentPage : Int = 1
    var searchString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        srchBar.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.isNavigationBarHidden = true
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(refreshList))
        tableView.addSubview(refreshControl)
        
        tableView.separatorStyle = .none
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.lblTitle.text = navTitle
        vwTopHeader.lblSubTitle.isHidden = true
        
        populateList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
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
    
    @objc func populateList() {
        
        var data: [TravelRequestData] = []
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.TRF.TRF_APPROVAL_LIST, Session.authKey,self.currentPage,self.searchString)
            print("TRF URL", url)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                
                if Helper.isResponseValid(vc: self, response: response.result, tv: self.tableView) {
                    
                    let jsonResponse = JSON(response.result.value!)
                    let array = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    if array.count > 0 {
                        
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
                        self.arrayList.append(contentsOf: data)
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
                    
                } else {
                    if self.arrayList.isEmpty {
                        self.btnMore.isHidden = true
                        Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isApprovals, action: nil)
                    } else {
                        self.currentPage -= 1
                    }
                    print("Invalid Reponse")
                }
                self.tableView.reloadData()
            }))
        } else {
            
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
    
    
    
    func getItirenaryData(trfData :TravelRequestData, isFromView : Bool ) {
        
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.TRF.ITINERARY_LIST, Session.authKey,
                                  trfData.trfId)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                
                let vc = UIStoryboard(name: "TravelRequest", bundle: nil).instantiateViewController(withIdentifier: "TRBaseViewController") as! TRBaseViewController
                vc.trfData = trfData
                vc.isFromView = isFromView
                vc.trfReqNo = trfData.reqNo
                vc.itinryRespone = response.result.value
                self.navigationController!.pushViewController(vc, animated: true)
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    
    func onRightBtnTap(data: AnyObject, text: String, isApprove: Bool) {
        
        var commnt = ""
        if text == "" || text == "Enter Comment" || text == "Enter Comment (Optional)" {
            commnt = ""
        } else {
            commnt = text
        }
        
        if isApprove {
            
            self.approveOrDeclineTRF(event: 1, trData: data as! TravelRequestData, comment: commnt)
            myView.removeFromSuperviewWithAnimate()
        } else {
            
            if text == "" || text == "Enter Comment" {
                Helper.showMessage(message: "Please Enter Comment")
                return
            }
            
            self.approveOrDeclineTRF(event: 2, trData: data as! TravelRequestData , comment: commnt)
            declView.removeFromSuperviewWithAnimate()
        }
    }
    
    func approveOrDeclineTRF( event : Int, trData:TravelRequestData, comment:String) {
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.TRF.TRF_APPROVE, Session.authKey, trData.trfId, event, Helper.encodeURL(url: comment))
            self.view.showLoading()
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                self.view.hideLoading()
                if Helper.isPostResponseValid(vc: self, response: response.result) {
                    if event == 1 {
                        self.showSuccessAlert()
                    } else {
                        self.showDeclineAlert()
                    }
                }
            })
        } else {
            
        }
    }
    
    func viewRequest(data: TravelRequestData,  isFromView: Bool) {
        getItirenaryData(trfData : data, isFromView: isFromView)
    }
    
    func showSuccessAlert() {
        
        let alert = UIAlertController(title: "Success", message: "Travel Request Successfully Approved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
            (UIAlertAction) -> Void in
            self.refreshList()
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDeclineAlert() {
        let alert = UIAlertController(title: "Success", message: "Travel Request Successfully Declined", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
            (UIAlertAction) -> Void in
            self.refreshList()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnMoreTapped(_ sender: Any) {
        self.loadMoreItemsForList()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset.y + scrollView.frame.size.height
        let contentHeight = scrollView.contentSize.height
        
        if ((contentOffset) >= (contentHeight)) && self.arrayList.count > 9 {
            DispatchQueue.main.async {
                self.btnMore.isHidden = false
            }
        } else {
            DispatchQueue.main.async {
                self.btnMore.isHidden = true
            }
        }
    }
    
    
}

extension TravelReqApprovalVC : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let view = tableView.dequeueReusableCell(withIdentifier: "cell") as! TravelRequestAdapter
        view.btnMore.tag = indexPath.row
        
        if arrayList.count > 0 {
            let data = arrayList[indexPath.row]
            view.setDataToView(data: data, isFromApprove : true)
        }
   
        view.isFromApprov = true
        view.delegate = self
        view.trfApprvListener = self
        return view
    }
    
}

extension TravelReqApprovalVC : onMoreClickListener , onTRFApprovItemClickListener {
    
    
    func onViewClick(data: TravelRequestData) {
        viewRequest(data: data,  isFromView: true)
    }
    
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func onApproveTRF(data: TravelRequestData) {
        
        self.handleTap()
        self.myView = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        self.myView.setDataToCustomView(title: "Approve?", description: "Are you sure you want to approve this Travel Request? You can't revert once approved", leftButton: "GO BACK", rightButton: "APPROVE",isTxtVwHidden: false, isApprove: true)
        self.myView.data = data
        self.myView.cpvDelegate = self
        self.myView.isApprove = true
        self.view.window?.addSubview(self.myView)
    }
    
    func onDeclineTRF(data: TravelRequestData) {
        
        self.handleTap()
        self.declView = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        declView.setDataToCustomView(title: "Decline?", description: "Are you sure you want to decline this Travel Request? You can't revert once declined", leftButton: "GO BACK", rightButton: "DECLINE", isTxtVwHidden: false, isApprove: false)
        declView.data = data
        declView.isApprove = false
        declView.cpvDelegate = self
        self.view.addMySubview(declView)
    }
    
}

extension TravelReqApprovalVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.searchString = ""
            self.refreshList()
            self.handleTap()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchString = ""
        self.refreshList()
        self.handleTap()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        guard let searchTxt = searchBar.text else {
            return
        }
        
        self.searchString = searchTxt
        self.refreshList()
        self.handleTap()
    }
}


extension TravelReqApprovalVC: WC_HeaderViewDelegate {
    
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

