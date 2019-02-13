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

class DeliveryOrderController: UIViewController, UIGestureRecognizerDelegate, customPopUpDelegate, filterViewDelegate {
  
    
    var arrayList:[DeliveryOrderData] = []

    var navTitle = ""
    var searchString = ""

    var declVw = CustomPopUpView()
    var myView = CustomPopUpView()
    @IBOutlet weak var vwHeader: WC_HeaderView!
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var currentPage : Int = 1

    @IBOutlet weak var btnMore: UIButton!
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(refreshList))
        tableView.addSubview(refreshControl)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        srchBar.delegate = self
        FilterViewController.filterDelegate = self
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.isNavigationBarHidden = true
        
        vwHeader.delegate = self
        vwHeader.btnBack.isHidden = false
        vwHeader.btnLeft.isHidden = true
        vwHeader.btnRight.isHidden = false
        vwHeader.lblTitle.text = navTitle
        vwHeader.lblSubTitle.isHidden = true
        
       
        tableView.separatorStyle = .none
        
        btnMore.isHidden = true
        btnMore.layer.cornerRadius = 5.0
        btnMore.layer.shadowRadius = 4.0
        btnMore.layer.shadowOpacity = 0.8
        btnMore.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor

        
        self.refreshList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        var arrData : [DeliveryOrderData] = []

        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.DO.LIST, Session.authKey,
                                  Helper.encodeURL(url: FilterViewController.getFilterString()), self.currentPage,self.searchString)
            self.view.showLoading()

            print("currPAge-%d",currentPage)
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let jsonResponse = JSON(response.result.value!)
                    let arrayJson = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    if arrayJson.count > 0 {

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
                            arrData.append(data)
                        }
                        self.arrayList.append(contentsOf: arrData)
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
    
    func handlePagination() {
        
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
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                self.view.hideLoading()
                if Helper.isPostResponseValid(vc: self, response: response.result) {
                    let alert = UIAlertController(title: "Success", message: "Order Successfully Approved", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
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
    
    func declineContract(data:DeliveryOrderData, comment:String){
     
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.DO.DECLINE, Session.authKey,data.refId,comment)
            self.view.showLoading()
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                self.view.hideLoading()
                if Helper.isPostResponseValid(vc: self, response: response.result) {
                    let alert = UIAlertController(title: "Success", message: "Order Successfully Declined", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (UIAlertAction) -> Void in
                        self.refreshList()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }else{
            Helper.showMessage(message: "No Internet Available, Please Try Again")
        }
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @IBAction func btnMoreTapped(_ sender: Any) {
        self.loadMoreItemsForList()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset.y + scrollView.frame.size.height
        let contentHeight = scrollView.contentSize.height

        if ((contentOffset) >= (contentHeight)) && self.arrayList.count > 0 {
            DispatchQueue.main.async {
                self.btnMore.isHidden = false
            }
        } else {
            DispatchQueue.main.async {
                self.btnMore.isHidden = true
            }
        }
    }
    
    func applyFilter(filterString: String) {
        if !arrayList.isEmpty {
            arrayList.removeAll()
        }
        self.refreshList()
    }
    
    func cancelFilter(filterString: String) {
         self.populateList()
    }
    
    
}
extension DeliveryOrderController: UITableViewDelegate, UITableViewDataSource, onButtonClickListener{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 318
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DeliveryOrderAdapter
        
        if self.arrayList.count > 0 {
            let data = arrayList[indexPath.row]
            cell.setDataToView(data: data)
        }
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
