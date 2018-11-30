//
//  AdminReceiveController.swift
//  mocs
//
//  Created by Admin on 3/12/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class AdminReceiveController: UIViewController , UIGestureRecognizerDelegate, filterViewDelegate, customPopUpDelegate {

    /// Table view
    @IBOutlet weak var tableView: UITableView!
    
    /// Array List of type ARIData elements
    var arrayList:[ARIData] = []
    
    /// Array List of type ARIData elements
    var newArray:[ARIData] = []
    
    var myView = CustomPopUpView()
    
    /// CustonPopUpView for decline pop-up
    var declView = CustomPopUpView()
    
    /// Search bar
    @IBOutlet weak var srchBar: UISearchBar!
    
    /// Top Header
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    /// Refresh Control
    var refreshControl:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(populateList))
        tableView.addSubview(refreshControl)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        FilterViewController.filterDelegate = self

        self.navigationController?.isNavigationBarHidden = true
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = Constant.PAHeaderTitle.ARI
        vwTopHeader.lblSubTitle.isHidden = true
        
        self.view.addGestureRecognizer(gestureRecognizer)
        srchBar.delegate = self
        populateList()
    }

    /// filterViewDelegate delegate method to cancel filter
    /// - Parameter filterString: Filter String
    func cancelFilter(filterString: String) {
        self.populateList()
    }
    
    /// filterViewDelegate delegate method to apply filter
    /// - Parameter filterString: Filter String
    func applyFilter(filterString: String) {
        if !arrayList.isEmpty {
            arrayList.removeAll()
        }
        self.populateList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// Method to fetch list of ARI through API call and populate table view with the fetched response
    @objc func populateList() {
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.ARI.LIST, Session.authKey,
                                  Helper.encodeURL(url:FilterViewController.getFilterString()))
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result, tv: self.tableView){
                    var jsonResponse = JSON(response.result.value!);
                    let arrayJson = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    self.arrayList.removeAll()
                    if arrayJson.count > 0{
                        
//                        self.arrayList.removeAll()
                        
                        for(_,j):(String,JSON) in jsonResponse{
                            let data = ARIData()
                            data.refId = j["ARI Reference ID"].stringValue
                            data.company = j["Company Name"].stringValue
                            data.location = j["Location"].stringValue
                            data.businessUnit = j["Business Vertical"].stringValue
                            data.beneficiaryName = j["Beneficiary Name"].stringValue
                            data.date = j["ARI Date"].stringValue
                            data.requestAmt = j["Requested Amount"].stringValue
                            data.requestAmtUSD = j["Requested Amount (USD)"].stringValue
                            data.fxRate = j["FX Rate,"].stringValue
                            data.allocationItem = j["Allocation Items"].stringValue
                            self.arrayList.append(data)
                        }
                        self.newArray = self.arrayList
                        self.tableView.tableFooterView = nil
//                        self.tableView.reloadData()
                    }else{
                        Helper.showNoFilterState(vc: self, tb: self.tableView, action: #selector(self.showFilterMenu))
                    }
                     self.tableView.reloadData()
                } else {
                    Helper.showNoFilterState(vc: self, tb: self.tableView, action: #selector(self.showFilterMenu))
                }
            }))
        } else {
            Helper.showNoInternetMessg()
            Helper.showNoInternetState(vc: self, tb: tableView, action: #selector(populateList))
            self.refreshControl.endRefreshing()
        }
    }
   
    /// Method to Show filter menu
    @objc func showFilterMenu(){
        self.sideMenuViewController?.presentRightMenuViewController()
    }
    
    /// Method that calls API to send email for ARI with ref Id
    /// - Parameter refId: Reference Id as String
    func sendMail(refId:String){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.API.SEND_EMAIL, Session.authKey,
                                  "ARI",
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
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    func onRightBtnTap(data: AnyObject, text: String, isApprove: Bool) {
        if isApprove {
            self.approveContract(data: data as! ARIData, comment: text)
        } else {
            if text == "" || text == "Enter Comment" {
                Helper.showMessage(message: "Please Enter Comment")
                return
            }else{
               self.declineContract(data: data as! ARIData, comment: text)
                declView.removeFromSuperviewWithAnimate()
            }
            
        }
    }
    
    
    func approveContract(data: ARIData, comment:String){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.ARI.APPROVE, Session.authKey,
                                  data.refId,
                                  comment)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let alert = UIAlertController(title: "Success", message: "Invoice Successfully Approved", preferredStyle: .alert)
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

    func declineContract(data:ARIData, comment:String){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.ARI.DECLINE, Session.authKey,
                                  data.refId,
                                  Helper.encodeURL(url: comment))
            self.view.hideLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.showLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let alert = UIAlertController(title: "Success", message: "Invoice Successfully Declined", preferredStyle: .alert)
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
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
}


extension AdminReceiveController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.arrayList = newArray
        } else {
            let filteredArray =   newArray.filter {
                $0.refId.localizedCaseInsensitiveContains(searchText)
            }
            self.arrayList = filteredArray
        }
        tableView.reloadData()
    }
}

extension AdminReceiveController:UITableViewDelegate, UITableViewDataSource, onButtonClickListener{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 305
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
        let data = arrayList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AdminReceiveAdapter
        cell.setDataToView(data: data)
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    func onViewClick(data: AnyObject) {
        
        let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "ARIViewController") as! ARIViewController
        viewController.data = (data as! ARIData)
        viewController.title = (data as! ARIData).refId
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func onMailClick(data: AnyObject) {
        
        self.handleTap()
        let prompt = UIAlertController(title: "Are you sure you want to Email?", message: "This email will be sent to your official email ID", preferredStyle: .alert)
        
        prompt.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
        prompt.addAction(UIAlertAction(title: "SEND", style: .default, handler: { (UIAlertAction) -> Void in
            self.sendMail(refId: (data as! ARIData).refId)
        }))
        self.present(prompt, animated: true, completion: nil)
    }
    
    func onApproveClick(data: AnyObject) {
        
        self.handleTap()
        
        myView = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        myView.setDataToCustomView(title: "Approve?", description:"Are you sure you want to approve this Invoice? You can't revert once approved", leftButton: "GO BACK", rightButton: "APPROVE",isTxtVwHidden: false, isApprove:  true)
        myView.data = data
        myView.cpvDelegate = self
        self.view.addMySubview(myView)

    }
    
    func onDeclineClick(data: AnyObject) {
      
        self.handleTap()
        declView = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        declView.setDataToCustomView(title: "Decline?", description: "Are you sure you want to decline this Invoice? You can't revert once declined", leftButton: "GO BACK", rightButton: "DECLINE", isTxtVwHidden: false, isApprove:  false)
        declView.data = data
        declView.cpvDelegate = self
        self.view.addMySubview(declView)
  
    }
    
    
}

extension AdminReceiveController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
        
    }
    
}

