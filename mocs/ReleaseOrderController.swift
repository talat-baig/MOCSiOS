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
    
    var newArray : [ROData] = []
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        srchBar.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        FilterViewController.filterDelegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.isNavigationBarHidden = true
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(self.populateList))
        tableView.addSubview(refreshControl)
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = Constant.PAHeaderTitle.RO
        vwTopHeader.lblSubTitle.isHidden = true
        
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
        self.populateList()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.populateList()
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
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.RO.LIST, Helper.encodeURL(url:  FilterViewController.getFilterString()), Session.authKey)
            print("RO URL", url)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                debugPrint(response.result)
                if Helper.isResponseValid(vc: self, response: response.result, tv: self.tableView){
                    
                    let jsonResponse = JSON(response.result.value!);
                    let jsonArray = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    self.arrayList.removeAll()
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
                            
                            self.arrayList.append(data)
                        }
                        self.newArray = self.arrayList
                        self.tableView.tableFooterView = nil
                        
                    }else{
                        self.refreshControl.endRefreshing()
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
            refreshControl.endRefreshing()
        }
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
                    //                    if (arrData.count > 0) {
                    
                    let roVC = self.storyboard?.instantiateViewController(withIdentifier: "ROBaseViewController") as! ROBaseViewController
                    roVC.cargoResponse = cargoResponse.result.value
                    roVC.response = response
                    roVC.roData = data
                    
                    self.navigationController!.pushViewController(roVC, animated: true)
                    //                    } else {
                    //                        self.view.makeToast("No Data To Show")
                    //                    }
                }
            }))
        }else{
            Helper.showNoInternetMessg()
        }
        
    }
}


extension ReleaseOrderController: UISearchBarDelegate {
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
        
        if arrayList.count > 0{
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        }else{
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = arrayList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ROListCell") as! ROListCell
        cell.setDataToView(data: data)
        cell.roMenuDelegate = self
        cell.roOptionItemDelegate = self
        cell.btnMore.tag = indexPath.row
        
        return cell;
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



