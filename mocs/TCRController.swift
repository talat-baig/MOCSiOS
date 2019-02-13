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

    var navTitle = ""
    var currentPage : Int = 1
    var searchString = ""

    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var btnMore: UIButton!

    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    var declVw = CustomPopUpView()
    var myView = CustomPopUpView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(refreshList))
        srchBar.delegate = self
        tableView.addSubview(refreshControl)
        
        FilterViewController.filterDelegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.isHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = navTitle
        vwTopHeader.lblSubTitle.isHidden = true
        
        btnMore.isHidden = true
        btnMore.layer.cornerRadius = 5.0
        btnMore.layer.shadowRadius = 4.0
        btnMore.layer.shadowOpacity = 0.8
        btnMore.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        
        self.populateList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func cancelFilter(filterString: String) {
        self.populateList()
    }
    
    
    func applyFilter(filterString: String) {
        if !arrayList.isEmpty {
            arrayList.removeAll()
        }
        self.refreshList()
    }
    
    
    
    func onRightBtnTap(data: AnyObject, text: String, isApprove: Bool) {
        
        if text == "" || text == "Enter Comment"  {
            Helper.showMessage(message: "Please Enter Comment")
            return
        }
        
        if isApprove {
            self.approveClaim(data: (data as! TravelClaimData), comment: text)
            myView.removeFromSuperviewWithAnimate()
        } else {
            self.declineClaim(data: data as! TravelClaimData, comment: text)
            declVw.removeFromSuperviewWithAnimate()
        }
    }
    
    @objc func populateList(){
        var newData: [TravelClaimData] = []
        
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.TCR.LIST, Session.authKey,
                                  Helper.encodeURL(url: FilterViewController.getFilterString()), self.currentPage, self.searchString)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result){
                    var responseJson = JSON(response.result.value!)
                    let arrayJson = responseJson.arrayObject as! [[String:AnyObject]]
                    
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
                        self.arrayList.append(contentsOf: newData)
                        self.tableView.tableFooterView = nil
                    }else{
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
    
    @IBAction func btnMoreTapped(_ sender: Any) {
        self.loadMoreItemsForList()
    }
    
    func viewClaim(data:TravelClaimData) {
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
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                self.view.hideLoading()
                if Helper.isPostResponseValid(vc: self, response: response.result) {
                    let alert = UIAlertController(title: "Success", message: "Claim Successfully Approved", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                        (UIAlertAction) -> Void in
                        self.refreshList()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            })
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
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                self.view.hideLoading()
                if Helper.isPostResponseValid(vc: self, response: response.result) {
                    let alert = UIAlertController(title: "Success", message: "Claim Successfully Declined", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                        (UIAlertAction) -> Void in
                        self.refreshList()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            })
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) && self.arrayList.count > 0 {
            btnMore.isHidden = false
        } else {
            btnMore.isHidden = true
        }
    }
}

extension TCRController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.searchString = ""
            self.refreshList()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchString = ""
        self.refreshList()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        guard let searchTxt = searchBar.text else {
            return
        }
        
        self.searchString = searchTxt
        
        self.refreshList()
    }
}

extension TCRController:UITableViewDelegate, UITableViewDataSource,onButtonClickListener{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 425
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
        
        let view = tableView.dequeueReusableCell(withIdentifier: "cell") as! TCRAdapter
        if arrayList.count > 0 {
            let data = arrayList[indexPath.row]
            view.setDataToView(data)
        }
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
        self.navigationController?.popViewController(animated: true)
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
        
    }
    
}
