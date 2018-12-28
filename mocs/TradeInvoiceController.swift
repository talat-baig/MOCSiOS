//
//  TradeInvoiceController.swift
//  mocs
//
//  Created by Admin on 3/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class TradeInvoiceController: UIViewController , UIGestureRecognizerDelegate, filterViewDelegate, customPopUpDelegate{
    
    /// Table view
    @IBOutlet weak var tableView: UITableView!
    
    /// Search bar
    @IBOutlet weak var srchBar: UISearchBar!
    
    /// Top Header
    @IBOutlet weak var vwHeader: WC_HeaderView!
    
    /// Custom Pop-up View
    var declVw = CustomPopUpView()
    
    /// Array of TRIData elements
    var arrayList:[TRIData] = []
    
    /// Array of TRIData elements
    var newArray:[TRIData] = []
    
    // Refresh Control
    var refreshControl:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.isNavigationBarHidden = true
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(populateList))
        tableView.addSubview(refreshControl)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        FilterViewController.filterDelegate = self
        
        vwHeader.delegate = self
        vwHeader.btnLeft.isHidden = false
        vwHeader.btnRight.isHidden = false
        vwHeader.lblTitle.text = Constant.PAHeaderTitle.TRI
        vwHeader.lblSubTitle.isHidden = true
        
        srchBar.delegate = self
        populateList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Open Filter screen
    @objc func showFilterMenu(){
        self.sideMenuViewController?.presentRightMenuViewController()
    }
    
    /// Cancel filters selections
    func cancelFilter(filterString: String) {
        self.populateList()
    }
    
    ///  Apply Fitler for the list.
    /// - filterString - Filter selected String
    func applyFilter(filterString: String) {
        
        if !arrayList.isEmpty {
            arrayList.removeAll()
        }
        self.populateList()
    }
    
    /// Fetch the list of TRI data and populate table view according to the list
    @objc func populateList(){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.TRI.LIST, Session.authKey,
                                  Helper.encodeURL(url: FilterViewController.getFilterString()))
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result, tv: self.tableView){
                    let jsonResponse = JSON(response.result.value!);
                    let jsonArray = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    self.arrayList.removeAll()
                    if jsonArray.count > 0{
                        
                        //                        self.arrayList.removeAll()
                        
                        for(_,j):(String,JSON) in jsonResponse{
                            let data = TRIData()
                            data.refId = j["TRI Reference ID"].stringValue
                            data.company = j["Company Name"].stringValue
                            data.location = j["Location"].stringValue
                            data.businessUnit = j["Business Vertical"].stringValue
                            data.beneficiary = j["Beneficiary Name"].stringValue
                            data.date = j["TRI Date"].stringValue
                            data.requestAmount = j["Requested Amount"].stringValue
                            data.payMode = j["Payment Mode"].stringValue
                            data.requestAmountNet = j["Requested Net Amount"].stringValue
                            data.tax = j["Tax"].stringValue
                            data.requestAmountGross = j["Requested Gross Amount"].stringValue
                            data.requestAmountGrossUSD = j["Requested Gross Amount (USD)"].stringValue
                            data.fxRate = j["FX Rate"].stringValue
                            data.allocatedItems = j["Allocated Invoice Items"].stringValue
                            self.arrayList.append(data)
                        }
                        self.newArray = self.arrayList
                        self.tableView.tableFooterView = nil
                        //                        self.tableView.reloadData()
                    }else{
                        self.refreshControl.endRefreshing()
                        Helper.showNoFilterState(vc: self, tb: self.tableView, reports: EmpStateScreen.isApprovals, action: #selector(self.showFilterMenu))
                    }
                    self.tableView.reloadData()
                } else {
                    Helper.showNoFilterState(vc: self, tb: self.tableView, reports: EmpStateScreen.isApprovals, action: #selector(self.showFilterMenu))
                }
            }))
        } else {
            
            Helper.showNoInternetState(vc: self, tb: tableView, action: #selector(populateList))
            refreshControl.endRefreshing()
        }
    }
    
    
    func showEmptyState(){
        Helper.showNoItemState(vc:self ,  tb:tableView)
    }
    
    
    func onRightBtnTap(data: AnyObject, text: String, isApprove: Bool) {
        
        if isApprove {
            
        } else {
            self.declineInvoice(data: data as! TRIData)
            declVw.removeFromSuperviewWithAnimate()
        }
    }
    
    func sendEmail(refId:String){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.API.SEND_EMAIL, Session.authKey,
                                  "TRI",
                                  refId)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let alert = UIAlertController(title: "Success", message: "Mail has been sent Successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }))
        }else{
            Helper.showNoInternetMessg()
        }
    }
    
    func approveInvoice(refId:String){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.TRI.APPROVE, Session.authKey,
                                  refId)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let alert = UIAlertController(title: "Success", message: "Invoice Successfully Approved", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) -> Void in
                        self.populateList()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    func declineInvoice(data:TRIData){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.TRI.DECLINE, Session.authKey,
                                  data.refId)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let alert = UIAlertController(title: "Success", message: "Invoice Successfully Declined", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) -> Void in
                        self.populateList()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }))
        }else{
            Helper.showNoInternetMessg()
        }
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
}

/// Mark: - UITableViewDataSource and UITableViewDelagete, onButtonClickListener methods
extension TradeInvoiceController:UITableViewDataSource, UITableViewDelegate, onButtonClickListener , approveTRIDelegate {
    
    func approve(refId: String) {
        self.approveInvoice(refId: refId)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 352
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TradeInvoiceAdapter
        cell.setDataToView(data: data)
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    
    
    func onViewClick(data: AnyObject) {
        let viewClaim = self.storyboard?.instantiateViewController(withIdentifier: "TRIViewController") as! TRIViewController
        viewClaim.data = data as? TRIData
        viewClaim.title = (data as! TRIData).refId
        self.navigationController?.pushViewController(viewClaim, animated: true)
    }
    
    func onMailClick(data: AnyObject) {
        self.handleTap()
        let alert = UIAlertController(title: "Are you sure you want to Email?", message: "This Email will be send to your official Email ID", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "SEND", style: .default, handler: { (UIAlertAction) -> Void in
            self.sendEmail(refId: (data as! TRIData).refId)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func onApproveClick(data: AnyObject) {
        
        self.handleTap()
        let myView = Bundle.main.loadNibNamed("CustomTRIApproveView", owner: nil, options: nil)![0] as! CustomTRIApproveView
        myView.frame = CGRect.init(x: 0, y: (self.navigationController?.navigationBar.frame.origin.y)!, width: self.view.frame.size.width, height: self.view.frame.size.height)
        myView.passRefNumToView(refStr: (data as! TRIData).refId)
        myView.approveDelegate = self
        DispatchQueue.main.async {
            self.navigationController?.view.addMySubview(myView)
        }
        
    }
    
    func onDeclineClick(data: AnyObject) {
        
        self.handleTap()
        declVw = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        declVw.setDataToCustomView(title: "Decline?", description: "Are you sure you want to decline this Invoice? You can't revert once declined", leftButton: "GO BACK", rightButton: "DECLINE", isTxtVwHidden: true, isApprove: false)
        declVw.data = data
        declVw.cpvDelegate = self
        self.view.addMySubview(declVw)
    }
}

/// Mark: - UISearchBarDelegate methods
extension TradeInvoiceController: UISearchBarDelegate {
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

/// Mark: - WC_HeaderViewDelegate methods
extension TradeInvoiceController: WC_HeaderViewDelegate {
    
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

