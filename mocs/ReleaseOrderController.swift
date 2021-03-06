//
//  ReleaseOrderController.swift
//  mocs
//
//  Created by Talat Baig on 7/6/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ReleaseOrderController: UIViewController, UIGestureRecognizerDelegate, filterViewDelegate ,onRRcptSubmit {
    
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    /// Array of TRIData elements
    var arrayList:[ROData] = []
//    var newArray : [ROData] = []
    var currentPage : Int = 1
    var searchString = ""

    var navTitle = ""
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var btnMore: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        srchBar.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshList),
                                               name: .relOrderNotify,
                                               object: nil) 
    
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        FilterViewController.filterDelegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.isNavigationBarHidden = true
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(self.refreshList))
        tableView.addSubview(refreshControl)
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = navTitle
        vwTopHeader.lblSubTitle.isHidden = true
        
        btnMore.isHidden = true
        btnMore.layer.cornerRadius = 5.0
        btnMore.layer.shadowRadius = 4.0
        btnMore.layer.shadowOpacity = 0.8
        btnMore.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        
        populateList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
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
        self.refreshList()
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
    

    
    @objc func showFilterMenu(){
        self.sideMenuViewController?.presentRightMenuViewController()
    }
    
    func onOkClick() {
        self.populateList()
    }
    
    func showEmptyState(){
        Helper.showNoItemState(vc:self ,  tb:tableView)
    }
    
    @objc func populateList(){
        
        var arrData : [ROData] = []
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.RO.LIST, Helper.encodeURL(url:  FilterViewController.getFilterString()), Session.authKey,self.currentPage, self.searchString)
            print("RO URL", url)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                debugPrint(response.result)
                if Helper.isResponseValid(vc: self, response: response.result, tv: self.tableView){
                    
                    let jsonResponse = JSON(response.result.value!);
                    let jsonArray = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    if jsonArray.count > 0 {
                        
                        for(_,j):(String,JSON) in jsonResponse {
                            let data = ROData()
                            data.company = j["ROCompanyName"].stringValue
                            data.businessUnit = j["Businessunit"].stringValue
                            data.location = j["Location"].stringValue
                            data.commodity = j["Commodity"].stringValue
                            data.reqDate = j["Date"].stringValue
                            data.refId = j["ReferenceID"].stringValue
                            data.roStatus = j["BalanceToPay"].stringValue
                            data.reqQty = j["RORequestedQtyinmt"].stringValue
                            data.rcvdQty = j["ROReceiveQuantityReceivedinmt"].stringValue
                            data.balQty = j["ROBalanceQtyinmt"].stringValue
                            
                            data.uom = j["RoUom"].stringValue
                            data.wghtTrms = j["ROWeightTerms"].stringValue
                            
                            if j["ROReceiveReleaseOrderNo"].stringValue == "" {
                                data.relOrderNum = "-"
                            } else {
                                data.relOrderNum = j["ROReceiveReleaseOrderNo"].stringValue
                            }
                            
                            if j["ROReceiveReceiptDate"].stringValue == "" {
                                data.rcptDate = "-"
                            } else {
                                data.rcptDate = j["ROReceiveReceiptDate"].stringValue
                            }
                            
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
    
    func viewRO(data : ROData) {
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.RO.VIEW, Session.authKey, data.refId)
            
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    let responseJson = JSON(response.result.value!)
                    let arrData = responseJson.arrayObject as! [[String:AnyObject]]
                    if (arrData.count > 0) {
                        
                        self.getCargoDetailsAndNavigate(response: response.result.value!, data : data)
                    } else {
                        self.view.makeToast("No Data To Show")
                    }
                }
            }))
        }else{
            Helper.showNoInternetMessg()
        }
        
    }
    
    func sendEmail(refId:String){
        
        if internetStatus != .notReachable{
            
            let url = String.init(format: Constant.RO.EMAIL_RO, Session.authKey, Session.email, refId)
            
            self.view.showLoading()
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                
                self.view.hideLoading()
                //                debugPrint(response.result.value)
                if response.result.value == "Success" {
                    let alert = UIAlertController(title: "Success", message: "Mail has been sent Successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }else{
            Helper.showNoInternetMessg()
        }
    }
    
    func getCargoDetailsAndNavigate(response : Data , data : ROData) {
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.RO.CARGO_DETAILS, data.refId , Session.authKey)
            
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ cargoResponse in
                
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: cargoResponse.result){
                    let responseJson = JSON(cargoResponse.result.value!)
                    let arrData = responseJson.arrayObject as! [[String:AnyObject]]
                    //     if (arrData.count > 0) {
                    
                    let roVC = self.storyboard?.instantiateViewController(withIdentifier: "ROBaseViewController") as! ROBaseViewController
                    roVC.cargoResponse = cargoResponse.result.value
                    roVC.response = response
                    roVC.roData = data
                    
                    self.navigationController!.pushViewController(roVC, animated: true)
                }
            }))
        }else{
            Helper.showNoInternetMessg()
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) && self.arrayList.count > 9 {
            btnMore.isHidden = false
        } else {
            btnMore.isHidden = true
        }
    }
}


extension ReleaseOrderController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.searchString = ""
            self.refreshList()
            self.handleTap()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchString = ""
        self.refreshList()
        self.handleTap()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        guard let searchTxt = searchBar.text else {
            return
        }
        self.searchString = searchTxt
        self.refreshList()
        self.handleTap()
    }
}


extension ReleaseOrderController: UITableViewDataSource, UITableViewDelegate, onROListMoreListener, onROListMoreItemListener  {
    
    func onCancelClick() {
        
    }
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func onViewClick(data:ROData) {
        viewRO(data: data)
    }
    
    func onMailClick(data: ROData) {
        self.handleTap()
        let alert = UIAlertController(title: "Are you sure you want to Email?", message: "This Email will be send to your official Email ID", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "SEND", style: .default, handler: { (UIAlertAction) -> Void in
            self.sendEmail(refId: data.refId)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ROListCell") as! ROListCell
        if arrayList.count > 0 {
            let data = arrayList[indexPath.row]
            cell.setDataToView(data: data)
        }
        cell.roMenuDelegate = self
        cell.roOptionItemDelegate = self
        cell.btnMore.tag = indexPath.row
        
        return cell
    }
    
}

extension ReleaseOrderController: WC_HeaderViewDelegate {
    
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



