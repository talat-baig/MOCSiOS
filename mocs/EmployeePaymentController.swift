//
//  EmployeePaymentController.swift
//  mocs
//
//  Created by Admin on 3/7/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class EmployeePaymentController: UIViewController, UIGestureRecognizerDelegate, filterViewDelegate, customPopUpDelegate {

    var arrayList:[EPRData] = []
    var newArray:[EPRData] = []
    var navTitle = ""

    var currentPage : Int = 1
    var myView = CustomPopUpView()
    var declView = CustomPopUpView()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var btnMore: UIButton!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var srchBar: UISearchBar!
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(refreshList))
        tableView.addSubview(refreshControl)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        srchBar.delegate = self
        FilterViewController.filterDelegate = self

        self.navigationController?.isNavigationBarHidden = true
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.btnBack.isHidden = false
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
    
    @objc func populateList() {
        
        var newData :[EPRData] = []
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.EPR.LIST, Session.authKey,
                                  Helper.encodeURL(url: FilterViewController.getFilterString(noBU: true)), self.currentPage)
            print(url)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                
                if Helper.isResponseValid(vc: self, response: response.result,tv: self.tableView){
                    let jsornResponse = JSON(response.result.value!)
                    let arrayJson = jsornResponse.arrayObject as! [[String:AnyObject]]
//                    self.arrayList.removeAll()
                    
                    if arrayJson.count > 0 {
                        
                        for(_,j):(String,JSON) in jsornResponse{
                            let data = EPRData()
                            data.refId = j["EPR Reference ID"].stringValue
                            data.company = j["Company Name"].stringValue
                            data.location = j["Location"].stringValue
                            data.businessUnit = j["Business Vertical"].stringValue
                            data.date = j["Raised On"].stringValue
                            data.benifitiaryName = j["Beneficiary Name"].stringValue
                            data.paymentType = j["Payment Type"].stringValue
                            data.requestAmount = j["Requested Amount"].stringValue
                            data.status = j["Status"].stringValue
                            newData.append(data)
                        }
                        self.arrayList.append(contentsOf: newData)
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
//                     self.tableView.reloadData()
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
    
    func onRightBtnTap(data: AnyObject, text: String, isApprove: Bool) {
        if isApprove {
            self.approveClaim(data:data as! EPRData, comment : text)
            myView.removeFromSuperviewWithAnimate()
        } else {
            
            if text == "" || text == "Enter Comment" {
                Helper.showMessage(message: "Please Enter Comment")
                return
            }else{
                self.declineClaim(data: data as! EPRData, comment: text)
                declView.removeFromSuperviewWithAnimate()
            }
        }
    }
    
    func viewClaim(refId:String) {
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.EPR.VIEW, Session.authKey,
                                  refId)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let viewClaim = self.storyboard?.instantiateViewController(withIdentifier: "EPRViewController") as! EPRViewController
                    viewClaim.response = response.result.value
                    viewClaim.regId = refId
                    viewClaim.title = refId
                    self.navigationController?.pushViewController(viewClaim, animated: true)
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    func sendEmail(refID:String) {
        
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.API.SEND_EMAIL, Session.authKey,
                                  Helper.encodeURL(url: "EPRECR"),
                                  refID)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let alert = UIAlertController(title: "Success", message: "Mail has been sent Successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }))
        }else{
           Helper.showNoInternetMessg()
        }
    }

    func approveClaim(data:EPRData, comment:String){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.EPR.APPROVE, Session.authKey,
                                  Helper.encodeURL(url: data.refId),
                                  Helper.encodeURL(url: comment))
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                     let alert = UIAlertController(title: "Success", message: "Claim Successfully Approved", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                        (UIAlertAction) -> Void in
                        self.refreshList()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    func declineClaim(data:EPRData, comment:String){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.EPR.DECLINE, Session.authKey,
                                  Helper.encodeURL(url: data.refId),
                                  Helper.encodeURL(url: comment))
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let alert = UIAlertController(title: "Success", message: "Claim Successfully Declined", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                        (UIAlertAction) -> Void in
                        self.refreshList()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    @objc func showFilterMenu(){
        self.sideMenuViewController?.presentRightMenuViewController()
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @IBAction func btnMoreTapped(_ sender: Any) {
        self.loadMoreItemsForList()
    }
}

extension EmployeePaymentController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.arrayList = newArray
        } else {
            let filteredArray =  newArray.filter {
                $0.refId.localizedCaseInsensitiveContains(searchText)
            }
            self.arrayList = filteredArray
        }
        tableView.reloadData()
    }
}

extension EmployeePaymentController: UITableViewDelegate, UITableViewDataSource, onButtonClickListener{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 295
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EmployeePaymentAdapter
        if arrayList.count > 0 {
            let data = arrayList[indexPath.row]
            viewCell.setViewToData(data)
        }
        viewCell.selectionStyle = .none
        viewCell.delegate = self
        return viewCell
    }
    
    func onViewClick(data: AnyObject) {
        self.viewClaim(refId: (data as! EPRData).refId)
    }
    
    func onMailClick(data: AnyObject) {
        let prompt = UIAlertController(title: "Are you sure you want to Email?", message: "This email will be sent to your official email ID", preferredStyle: .alert)
        
        prompt.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
        prompt.addAction(UIAlertAction(title: "SEND", style: .default, handler: { (UIAlertAction) -> Void in
            self.sendEmail(refID: (data as! EPRData).refId)
        }))
        self.present(prompt, animated: true, completion: nil)
    }
    
    func onApproveClick(data: AnyObject) {
        
        self.handleTap()
        
        myView = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        myView.setDataToCustomView(title: "Approve?", description: "Are you sure you want to approve this Claim? You can't revert once approved", leftButton: "GO BACK", rightButton: "APPROVE",isTxtVwHidden: false, isApprove: true)
        myView.data = data
        myView.cpvDelegate = self
        myView.isApprove = true
        self.view.addMySubview(myView)
    }
    
    func onDeclineClick(data: AnyObject) {
        
        self.handleTap()
        declView = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        declView.setDataToCustomView(title: "Decline?", description: "Are you sure you want to decline this Claim? You can't revert once declined", leftButton: "GO BACK", rightButton: "DECLINE", isTxtVwHidden: false, isApprove:  false)
        declView.data = data
        declView.isApprove = false
        declView.cpvDelegate = self
        self.view.addMySubview(declView)
    }
}


extension EmployeePaymentController: WC_HeaderViewDelegate {
    
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
