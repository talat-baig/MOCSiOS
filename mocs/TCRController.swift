//
//  TCRController.swift
//  mocs
//
//  Created by Admin on 3/5/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class TCRController: UIViewController, UIGestureRecognizerDelegate , filterViewDelegate, customPopUpDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayList:[TravelClaimData] = []
    var newArray : [TravelClaimData] = []
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var srchBar: UISearchBar!
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    var declVw = CustomPopUpView()
    var myView = CustomPopUpView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(self.populateList))
        
        srchBar.delegate = self
        tableView.addSubview(refreshControl)
        FilterViewController.filterDelegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.isHidden = true
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = Constant.PAHeaderTitle.TCR
        vwTopHeader.lblSubTitle.isHidden = true
        
        self.populateList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func cancelFilter(filterString: String) {
        self.populateList()
    }
    
    
    func applyFilter(filterString: String) {
        if !arrayList.isEmpty {
            arrayList.removeAll()
        }
        self.populateList()
    }
    
//    func clearAllTapped() {
//        self.populateList()
//    }
    
    func onRightBtnTap(data: AnyObject, text: String, isApprove: Bool) {
        
        if isApprove {
            self.approveClaim(data: (data as! TravelClaimData), comment: text)
            myView.removeFromSuperviewWithAnimate()
        } else {
            
            if text == "" || text == "Enter Comment"  {
                Helper.showMessage(message: "Please Enter Comment")
                return
            } else {
                self.declineClaim(data: data as! TravelClaimData, comment: text)
                declVw.removeFromSuperviewWithAnimate()
            }
        }
    }
    
    @objc func populateList(){
        var newData: [TravelClaimData] = []
        
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.TCR.LIST, Session.authKey,
                                  Helper.encodeURL(url: FilterViewController.getFilterString()))
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result){
                    var responseJson = JSON(response.result.value!)
                    let arrayJson = responseJson.arrayObject as! [[String:AnyObject]]
                    
                    self.arrayList.removeAll()
                    if arrayJson.count > 0 {
                        
                        for(_,j):(String,JSON) in responseJson{
                            let data = TravelClaimData()
                            data.headRef = j["TCR Reference ID"].stringValue
                            data.companyName = j["Company Name"].stringValue
                            data.location = j["Location"].stringValue
                            data.businessVertical = j["Business Vertical"].stringValue
                            data.employeeName = j["Employee Name"].stringValue
                            data.employeeDepartment = j["Employee Department"].stringValue
                            data.purposeOfTravel = j["Purpose of Travel"].stringValue
                            data.periodOfTravel = j["Period of Travel"].stringValue
                            data.claimRaisedOn = j["Claim Raised On"].stringValue
                            data.counter = j["Counter"].intValue
                            newData.append(data)
                        }
                        self.arrayList = newData
                        self.newArray = newData
                       self.tableView.tableFooterView = nil
                    }else{
                        Helper.showNoFilterState(vc: self, tb: self.tableView, action: #selector(self.showFilterMenu))
                    }
                 self.tableView.reloadData()
                }
            }))
        }else{
            Helper.showNoInternetMessg()
            Helper.showNoInternetState(vc: self, tb: tableView, action: #selector(populateList))
            self.refreshControl.endRefreshing()
        }
    }
    
    func viewClaim(data:TravelClaimData){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.TCR.VIEW, Session.authKey,
                                  data.headRef, data.counter)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "TCRViewController") as! TCRViewController
                    vc.response = response.result.value
                    vc.regId = data.headRef
                    vc.title = data.headRef
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }))
        }else{
            Helper.showNoInternetMessg()
        }
    }
    
    func sendMail(data:TravelClaimData){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.API.SEND_EMAIL, Session.authKey,
                                  "TCR",
                                  data.headRef, data.counter)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let alert = UIAlertController(title: "Success", message: "Claim has been Mailed Successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }))
        }else{
            Helper.showNoInternetMessg()
        }
    }
    
    func approveClaim(data:TravelClaimData, comment:String){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.TCR.APPROVE, Session.authKey,
                                  data.headRef,
                                  Helper.encodeURL(url: comment))
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let alert = UIAlertController(title: "Success", message: "Claim Successfully Approved", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                        (UIAlertAction) -> Void in
                        self.populateList()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }))
        }else{
            Helper.showNoInternetMessg()
        }
    }
    
    func declineClaim(data: TravelClaimData, comment:String){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.TCR.DECLINE, Session.authKey,
                                  data.headRef,
                                  Helper.encodeURL(url: comment))
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let alert = UIAlertController(title: "Success", message: "Claim Successfully Declined", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                        (UIAlertAction) -> Void in
                        self.populateList()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }))
        }else{
            Helper.showNoInternetMessg()
        }
    }
    
    
    @objc func showFilterMenu(){
        self.sideMenuViewController?.presentRightMenuViewController()
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
}

extension TCRController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.arrayList = newArray
        } else {
            let filteredArray =   newArray.filter {
                $0.headRef.localizedCaseInsensitiveContains(searchText)
            }
            self.arrayList = filteredArray
        }
        tableView.reloadData()
    }
}

extension TCRController:UITableViewDelegate, UITableViewDataSource,onButtonClickListener{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 410
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayList.count > 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }else{
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
        }
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = arrayList[indexPath.row]
        let view = tableView.dequeueReusableCell(withIdentifier: "cell") as! TCRAdapter
        view.setDataToView(data)
        view.selectionStyle = .none
        view.delegate = self
        return view
    }
    
    func onViewClick(data: AnyObject) {
        viewClaim(data: data as! TravelClaimData)
    }
    
    func onMailClick(data: AnyObject) {
        let prompt = UIAlertController(title: "Are you sure you want to Email?", message: "This email will be sent to your official email ID", preferredStyle: .alert)
        
        prompt.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
        prompt.addAction(UIAlertAction(title: "SEND", style: .default, handler: { (UIAlertAction) -> Void in
            self.sendMail(data: data as! TravelClaimData)
        }))
        self.present(prompt, animated: true, completion: nil)
    }
    
    func onApproveClick(data: AnyObject) {
        
        self.handleTap()
        
        myView = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        myView.setDataToCustomView(title: "Approve?", description: "Are you sure you want to approve this Claim? You can't revert once approved", leftButton: "GO BACK", rightButton: "APPROVE",isTxtVwHidden: false, isApprove: true)
        myView.data = data
        myView.isApprove = true
        myView.cpvDelegate = self
        self.view.addMySubview(myView)
        
    }
    
    func onDeclineClick(data: AnyObject) {
        
        self.handleTap()
        declVw = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        declVw.setDataToCustomView(title: "Decline?", description: "Are you sure you want to decline this Claim? You can't revert once declined", leftButton: "GO BACK", rightButton: "DECLINE", isTxtVwHidden: false, isApprove: false)
        declVw.data = data
        declVw.isApprove = false
        declVw.cpvDelegate = self
        self.view.addMySubview(declVw)
        
    }
    
}

extension TCRController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
        
    }
    
}