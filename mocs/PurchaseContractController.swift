//
//  PurchaseContractController.swift
//  mocs
//
//  Created by Admin on 2/19/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Toast_Swift
import Alamofire
import SwiftyJSON

class PurchaseContractController: UIViewController, UIGestureRecognizerDelegate, filterViewDelegate, customPopUpDelegate {
    
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    var declView = CustomPopUpView()
    var myView = CustomPopUpView()
    var newArray : [PurchaseContractData] = []
    var arrayList:[PurchaseContractData] = []
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    
    func cancelFilter(filterString: String) {
        self.populateList()
    }
    
    func applyFilter(filterString: String) {
        if !arrayList.isEmpty  {
            arrayList.removeAll()
        }
        self.populateList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(populateList))
        
        self.tableView.register(UINib(nibName: "ContractCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.addSubview(self.refreshControl)
     
        srchBar.delegate = self
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = Constant.PAHeaderTitle.PC
        vwTopHeader.lblSubTitle.isHidden = true
        
        FilterViewController.filterDelegate = self
        
        populateList()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl){
        populateList()
    }
    
    
    @objc func populateList(){
        
        var newData: [PurchaseContractData] = []
        
        if(internetStatus != .notReachable){
            self.view.showLoading()
            let url = String.init(format: Constant.PC.LIST, Session.authKey,Helper.encodeURL(url: FilterViewController.getFilterString()))
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let jsonResponse = JSON(response.value!)
                    let data = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    self.arrayList.removeAll()
                    
                    if data.count > 0 {
                        
                        for(_,j):(String,JSON) in jsonResponse{
                            let pc = PurchaseContractData()
                            pc.RefNo = j["Purchase Contract Reference No."].stringValue
                            pc.company = j["Company Name"].stringValue
                            pc.location = j["Location"].stringValue
                            pc.businessVertical = j["Business Vertical"].stringValue
                            pc.date = j["Purchase Contract Date"].stringValue
                            pc.commodity = j["Commodity"].stringValue
                            pc.supplier = j["Supplier"].stringValue
                            pc.contractValue = j["Contract Value"].stringValue
                            newData.append(pc)
                        }
                        
                        self.arrayList = newData
                        self.newArray = newData
                        
                        /// Modified
                        self.tableView.tableFooterView = nil
                    } else {
                        Helper.showNoFilterState(vc: self, tb: self.tableView, reports: EmpStateScreen.isApprovals, action: #selector(self.showFilterMenu))
                    }
                    
                    self.tableView.reloadData()
                } else {
                    Helper.showNoFilterState(vc: self, tb: self.tableView, reports: EmpStateScreen.isApprovals, action: #selector(self.showFilterMenu))

                }
            }))
        }else{
            Helper.showNoInternetMessg()
            Helper.showNoInternetState(vc: self, tb: self.tableView, action: #selector(self.populateList))
        }
    }
    
    func view(data:PurchaseContractData){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.PC.VIEW, Session.authKey,data.RefNo)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let responseJson = JSON(response.result.value!)
                    let arrData = responseJson.arrayObject as! [[String:AnyObject]]
                    if (arrData.count > 0){
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PCViewViewController") as! PCViewViewController
                        vc.response = response.result.value
                        vc.title = data.RefNo
                        vc.titleHead = data.RefNo
                        self.navigationController!.pushViewController(vc, animated: true)
                    }else{
                        self.view.makeToast("No Data To Show")
                    }
                }
            }))
        }else{
            Helper.showNoInternetMessg()
        }
    }
    
    func sendEmail(data:PurchaseContractData){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.API.SEND_EMAIL, Session.authKey,
                                  Helper.encodeURL(url: Constant.MODULES.PC),
                                  Helper.encodeURL(url: data.RefNo))
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
            Helper.showMessage(message: "No Internet Available, Please Try Aagain")
        }
        
    }
    
    func onRightBtnTap(data: AnyObject, text: String, isApprove: Bool) {
        
        if isApprove {
            self.approveContract(data: data as! PurchaseContractData, remark: text)
            myView.removeFromSuperviewWithAnimate()
        } else {
            if text == "" || text == "Enter Comment" {
                Helper.showMessage(message: "Please Enter Comment")
                return
            } else {
                self.declineContract(data: data as! PurchaseContractData, comment: text)
                declView.removeFromSuperviewWithAnimate()
            }
        }
    }
    
    func approveContract(data:PurchaseContractData, remark:String){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.PC.APPROVE, Session.authKey,
                                  data.RefNo,
                                  Helper.encodeURL(url: remark))
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
    
    func declineContract(data:PurchaseContractData, comment:String){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.PC.DECLINE,Session.authKey,
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
    
    @objc func showFilterMenu(){
        self.sideMenuViewController?.presentRightMenuViewController()
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
}

extension PurchaseContractController: UISearchBarDelegate {
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


extension PurchaseContractController: UITableViewDataSource, UITableViewDelegate, onButtonClickListener{
    
    
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
        return cell;
    }
    
    func onViewClick(data: AnyObject) {
        let data = data as! PurchaseContractData
        view(data: data)
    }
    
    func onMailClick(data: AnyObject) {
        
        self.handleTap()
        let alert = UIAlertController(title: "Are you sure you want to Email?", message: "This email will be sent to your official email ID", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: {(UIAlertAction) -> Void in
        }))
        
        alert.addAction(UIAlertAction(title: "SEND", style: .default, handler: {(UIAlertAction)-> Void in
            self.sendEmail(data: data as! PurchaseContractData)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func onApproveClick(data: AnyObject) {
        
        self.handleTap()
        myView = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        myView.setDataToCustomView(title: "Approve?", description: "Are you sure you want to approve this Contract? You can't revert once approved", leftButton: "GO BACK", rightButton: "APPROVE",isTxtVwHidden: false, isApprove:  true)
        myView.data = data
        myView.cpvDelegate = self
        self.view.addMySubview(myView)
    }
    
    
    func onDeclineClick(data: AnyObject) {
        
        self.handleTap()
        
        declView = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        declView.setDataToCustomView(title: "Decline?", description: "Are you sure you want to decline this Contract? You can't revert once declined", leftButton: "GO BACK", rightButton: "DECLINE", isTxtVwHidden: false, isApprove: false)
        declView.data = data
        declView.cpvDelegate = self
        self.view.addMySubview(declView)
    }
    
}

extension PurchaseContractController: WC_HeaderViewDelegate {
    
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


