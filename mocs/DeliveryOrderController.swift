//
//  DeliveryOrderController.swift
//  mocs
//
//  Created by Admin on 2/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DeliveryOrderController: UIViewController, UIGestureRecognizerDelegate,filterViewDelegate, customPopUpDelegate {
    
    var arrayList:[DeliveryOrderData] = []
    var newArray:[DeliveryOrderData] = []
    
    var declVw = CustomPopUpView()
    var myView = CustomPopUpView()
    @IBOutlet weak var vwHeader: WC_HeaderView!
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(populateList))
        tableView.addSubview(refreshControl)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        srchBar.delegate = self
        FilterViewController.filterDelegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        self.navigationController?.isNavigationBarHidden = true
        vwHeader.delegate = self
        vwHeader.btnLeft.isHidden = false
        vwHeader.btnRight.isHidden = false
        vwHeader.lblTitle.text = Constant.PAHeaderTitle.DO
        vwHeader.lblSubTitle.isHidden = true
        
        self.populateList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FilterViewController.getFilterString() == "" {
            self.populateList()
        }
        
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
    
    func onRightBtnTap(data: AnyObject, text: String, isApprove: Bool) {
        if isApprove {
            self.approveContract(data: (data as! DeliveryOrderData), comment: text)
            myView.removeFromSuperviewWithAnimate()
        } else {
            if text == "" || text == "Enter Comment"  {
                Helper.showMessage(message: "Please Enter Comment")
                return
            } else {
                self.declineContract(data: (data as! DeliveryOrderData), comment: text)
                declVw.removeFromSuperviewWithAnimate()
            }
        }
    }
    
    @objc func populateList(){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.DO.LIST, Session.authKey,
                                  Helper.encodeURL(url: FilterViewController.getFilterString()))
            self.view.showLoading()
            print(FilterViewController.getFilterString())
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let jsonResponse = JSON(response.result.value!)
                    let arrayJson = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    self.arrayList.removeAll()
                    
                    if arrayJson.count > 0 {
//                        self.arrayList.removeAll()
                        
                        for(_,j):(String,JSON) in jsonResponse{
                            let data = DeliveryOrderData()
                            data.refId = j["DO Reference Id"].stringValue
                            data.company = j["Company"].stringValue
                            data.location = j["Location"].stringValue
                            data.businessUnit = j["Business Vertical"].stringValue
                            data.date = j["DO Date"].stringValue
                            data.customer = j["Customer"].stringValue
                            data.value = j["DOValue"].stringValue
                            data.creditLimit = j["DOCreditLimit"].stringValue
                            data.products = j["Products"].stringValue
                            self.arrayList.append(data)
                        }
                        self.newArray = self.arrayList
                        self.tableView.tableFooterView = nil
                    } else {
                        Helper.showNoFilterState(vc: self, tb: self.tableView, action: #selector(self.showFilterMenu))
                    }
                    self.tableView.reloadData()
                    
                }
            }))
        }else{
            Helper.showNoInternetMessg()
            Helper.showNoInternetState(vc: self, tb: self.tableView, action: #selector(self.populateList))
            
            self.refreshControl.endRefreshing()
        }
    }
    
    func viewContract(refId: String){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.DO.VIEW, Session.authKey,
                                  refId)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let viewController = self.storyboard!.instantiateViewController(withIdentifier: "DOViewViewController") as! DOViewViewController
                    viewController.response = response.result.value
                    viewController.title = refId
                    viewController.refId = refId
                    self.navigationController!.pushViewController(viewController, animated: true)
                }
            }))
        }else{
           Helper.showNoInternetMessg()
        }
    }
    
    @objc func showFilterMenu(){
        self.sideMenuViewController?.presentRightMenuViewController()
    }
    
    
    func mailContract(redId:String){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.API.SEND_EMAIL, Session.authKey,
                                  "DO",
                                  redId)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ resonse in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: resonse.result){
                    let alert = UIAlertController(title: "Success", message: "Delivery Order successfully Mailed", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }))
        }else{
            Helper.showNoInternetMessg()
        }
    }
    
    func approveContract(data: DeliveryOrderData, comment:String){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.DO.APPROVE, Session.authKey,
                                  Helper.encodeURL(url: data.refId),
                                  Helper.encodeURL(url: comment))
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let alert = UIAlertController(title: "Success", message: "Order Successfully Approved", preferredStyle: .alert)
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
    
    func declineContract(data:DeliveryOrderData, comment:String){
     
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.DO.DECLINE, Session.authKey,data.refId,comment)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let alert = UIAlertController(title: "Success", message: "Order Successfully Declined", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (UIAlertAction) -> Void in
                        self.populateList()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }))
        }else{
            Helper.showMessage(message: "No Internet Available, Please Try Again")
        }
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
}
extension DeliveryOrderController:UITableViewDelegate, UITableViewDataSource, onButtonClickListener{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 311
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayList.count > 0{
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DeliveryOrderAdapter
        cell.setDataToView(data: data)
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    func onViewClick(data: AnyObject) {
        viewContract(refId: (data as! DeliveryOrderData).refId)
    }
    
    func onMailClick(data: AnyObject) {
        
        self.handleTap()
        let alert = UIAlertController(title: "Are you sure you want to Email?", message: "This email will be sent to your official email ID", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "SEND", style: .default, handler: { (UIAlertAction) -> Void in
            self.mailContract(redId: (data as! DeliveryOrderData).refId)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func onApproveClick(data: AnyObject) {
        
        self.handleTap()
        myView = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        myView.setDataToCustomView(title: "Approve?", description: "Are you sure to approve this Order? You can't revert once approved" , leftButton: "GO BACK", rightButton: "APPROVE", isTxtVwHidden: false, isApprove: true)
        myView.data = data
        myView.cpvDelegate = self
        self.view.addMySubview(myView)
    }
    
    func onDeclineClick(data: AnyObject) {
        
        self.handleTap()
        declVw = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        declVw.setDataToCustomView(title: "Decline?", description: "Are you sure you want to decline this Order? You can't revert once declined", leftButton: "GO BACK", rightButton: "DECLINE", isTxtVwHidden: false, isApprove:  false)
        declVw.data = data
        declVw.cpvDelegate = self
        self.view.addMySubview(declVw)
        
        
    }
    
}

extension DeliveryOrderController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.arrayList = newArray
        } else {
            let filteredArray = newArray.filter {
                $0.refId.localizedCaseInsensitiveContains(searchText)
            }
            self.arrayList = filteredArray
        }
        tableView.reloadData()
    }
}


extension DeliveryOrderController: WC_HeaderViewDelegate {
    
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