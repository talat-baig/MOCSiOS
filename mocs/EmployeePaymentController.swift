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

    var myView = CustomPopUpView()
    var declView = CustomPopUpView()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var srchBar: UISearchBar!
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(populateList))
        tableView.addSubview(refreshControl)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        srchBar.delegate = self
        FilterViewController.filterDelegate = self

        self.navigationController?.isNavigationBarHidden = true
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = Constant.PAHeaderTitle.ECR
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
    
    @objc func populateList() {
        var newData :[EPRData] = []
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.EPR.LIST, Session.authKey,
                                  Helper.encodeURL(url: FilterViewController.getFilterString(noBU: true)))
            
            print(url)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result,tv: self.tableView){
                    let jsornResponse = JSON(response.result.value!)
                    let arrayJson = jsornResponse.arrayObject as! [[String:AnyObject]]
                    self.arrayList.removeAll()
                    
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
                        self.newArray = newData
                        self.arrayList = newData
                        self.tableView.tableFooterView = nil

                    }else{
                        Helper.showNoFilterState(vc: self, tb: self.tableView, action: #selector(self.showFilterMenu))
                    }
                     self.tableView.reloadData()
                } else {
                    Helper.showNoFilterState(vc: self, tb: self.tableView, action: #selector(self.showFilterMenu))
                }
            }))
        }else{
            Helper.showNoInternetMessg()
            Helper.showNoInternetState(vc: self, tb: tableView, action: #selector(populateList))
            self.refreshControl.endRefreshing()
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
    
    func viewClaim(refId:String){
        if internetStatus != .notReachable{
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
        }else{
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
                        self.populateList()
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
                        self.populateList()
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
        return 330
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = arrayList[indexPath.row]
        let viewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EmployeePaymentAdapter
        viewCell.setViewToData(data)
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
