//
//  SalesContractController.swift
//  mocs
//
//  Created by Admin on 2/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Toast_Swift

class SalesContractController: UIViewController , UIGestureRecognizerDelegate , customPopUpDelegate, filterViewDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var srchBar: UISearchBar!
    var navTitle = ""
    var declVw = CustomPopUpView()
    var myView = CustomPopUpView()
    
    @IBOutlet weak var vwHeader: WC_HeaderView!
    var arrayList:[PurchaseContractData] = []
    var newArray:[PurchaseContractData] = []
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(populateList))
        tableView.addSubview(refreshControl)
        tableView.register(UINib(nibName: "ContractCell", bundle: nil), forCellReuseIdentifier: "cell")
        srchBar.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        FilterViewController.filterDelegate = self
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        vwHeader.delegate = self
        vwHeader.btnLeft.isHidden = true
        vwHeader.btnBack.isHidden = false
        vwHeader.btnRight.isHidden = false
        vwHeader.lblTitle.text = navTitle
        vwHeader.lblSubTitle.isHidden = true
        
        populateList()
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func populateList(){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.SC.LIST, Session.authKey,
                                  Helper.encodeURL(url: FilterViewController.getFilterString()))
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result){
                    var jsonResponse = JSON(response.result.value!)
                    let array = jsonResponse.arrayObject as! [[String:AnyObject]]
                    self.arrayList.removeAll()
                    
                    if array.count > 0{
                        
                        for(_,j):(String,JSON) in jsonResponse{
                            let sc = PurchaseContractData()
                            sc.RefNo = j["Sales Contract Reference No."].stringValue
                            sc.company = j["Company Name"].stringValue
                            sc.location = j["Location"].stringValue
                            sc.businessVertical = j["Business Vertical"].stringValue
                            sc.date = j["Sales Contract Date"].stringValue
                            sc.commodity = j["Commodity"].stringValue
                            sc.supplier = j["Supplier"].stringValue
                            sc.contractValue = j["Contract Value"].stringValue
                            self.arrayList.append(sc)
                        }
                        self.newArray = self.arrayList
                        self.tableView.tableFooterView = nil
                    } else {
                        Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isApprovals, action: #selector(self.showFilterMenu))
                    }
                    self.tableView.reloadData()
                } else {
                    Helper.showNoFilterState(vc: self, tb: self.tableView, reports: ModName.isApprovals, action: #selector(self.showFilterMenu))
                }
            }))
        }else{
            Helper.showNoInternetMessg()
            Helper.showNoInternetState(vc: self, tb: tableView, action: #selector(populateList))
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func showFilterMenu(){
        self.sideMenuViewController?.presentRightMenuViewController()
    }
    
    func viewContract(data:PurchaseContractData){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.SC.VIEW, Session.authKey,
                                  data.RefNo)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let view = self.storyboard!.instantiateViewController(withIdentifier: "SCViewViewController") as! SCViewViewController
                    view.response = response.result.value
                    view.refId = data.RefNo
                    self.navigationController!.pushViewController(view, animated: true)
                }
            }))
        }else{
            Helper.showNoInternetMessg()
        }
    }
    
    func sendMail(refId:String){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.API.SEND_EMAIL, Session.authKey,
                                  Helper.encodeURL(url: Constant.MODULES.SC),
                                  Helper.encodeURL(url: refId))
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let alert = UIAlertController(title: "Success", message: "Contract Successfully Mailed", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }))
        }else{
            Helper.showNoInternetMessg()
        }
    }
    
    func approveContract(data: PurchaseContractData){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.SC.APPROVE, Session.authKey,
                                  data.RefNo)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let alert = UIAlertController(title: "Success", message: "Contract Successfully Approved", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
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
    
    func declineContract(data: PurchaseContractData, comment:String){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.SC.DECLINE, Session.authKey,
                                  data.RefNo,
                                  Helper.encodeURL(url: comment))
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let alert = UIAlertController(title: "Success", message: "Contract Successfully Declined", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
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
    
    func onRightBtnTap(data: AnyObject, text: String, isApprove: Bool) {
        if isApprove {
            self.approveContract(data: data as! PurchaseContractData)
            myView.removeFromSuperviewWithAnimate()
        } else {
            if text == "" || text == "Enter Comment"  {
                Helper.showMessage(message: "Please Enter Comment")
                return
            } else {
                self.declineContract(data: data as! PurchaseContractData, comment: text)
                declVw.removeFromSuperviewWithAnimate()
            }
        }
    }
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
}

extension SalesContractController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.arrayList = newArray
        } else {
            let filteredArray =   newArray.filter {
                $0.RefNo.localizedCaseInsensitiveContains(searchText)
            }
            self.arrayList = filteredArray
        }
        tableView.reloadData()
    }
}

extension SalesContractController: UITableViewDataSource, UITableViewDelegate, onButtonClickListener{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 342
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ContractCell
        cell.setDataToView(data: data)
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    func onViewClick(data: AnyObject) {
        viewContract(data: data as! PurchaseContractData)
    }
    
    func onMailClick(data: AnyObject) {
        
        self.handleTap()
        let alert = UIAlertController(title: "Are you sure you want to Email?", message: "This email will be sent to your official email ID", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "SEND", style: .default, handler: { (UIAlertAction) -> Void in
            self.sendMail(refId: (data as! PurchaseContractData).RefNo)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func onApproveClick(data: AnyObject) {
        
        self.handleTap()
        
        myView = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        myView.setDataToCustomView(title: "Approve?", description: "Are you sure you want to approve this Contract? You can't revert once approved", leftButton: "GO BACK", rightButton: "APPROVE", isTxtVwHidden: true, isApprove: true)
        myView.data = data
        myView.cpvDelegate = self
        self.view.addMySubview(myView)
        
    }
    
    func onDeclineClick(data: AnyObject) {
        
        self.handleTap()
        declVw = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        declVw.setDataToCustomView(title: "Decline?", description: "Are you sure you want to decline this Contract? You can't revert once declined", leftButton: "GO BACK", rightButton: "DECLINE", isTxtVwHidden: false, isApprove: false)
        declVw.data = data
        declVw.cpvDelegate = self
        self.view.addMySubview(declVw)
    }
    
}

extension SalesContractController: WC_HeaderViewDelegate {
    
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
