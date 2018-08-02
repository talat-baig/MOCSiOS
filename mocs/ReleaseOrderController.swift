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

class ReleaseOrderController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    /// Array of TRIData elements
    var arrayList:[ROData] = []
    
    /// Array of TRIData elements
    var newArray:[ROData] = []
    
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.tableView.register(UINib(nibName: "ROListCell", bundle: nil), forCellReuseIdentifier: "ROListCell")
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
    
    @objc func showFilterMenu(){
        self.sideMenuViewController?.presentRightMenuViewController()
    }
    
    @objc func populateList(){
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.RO.LIST,
                                  Helper.encodeURL(url: "35+Ivory Coast+06,35+Ivory Coast+05"),"D7BE635C-FACA-44FF-A3F1-E1E0CC8E")
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
                            let data = ROData()
                            data.company = j["Company Name"].stringValue
                            data.businessUnit = j["Businessunit"].stringValue
                            data.location = j["Location"].stringValue
                            data.commodity = j["Commodity"].stringValue
                            data.date = j["Date"].stringValue
                            data.refId = j["ReferenceID"].stringValue
                            data.releaseFor = j["Release For"].stringValue
                            self.arrayList.append(data)
                        }
                        self.newArray = self.arrayList
                        self.tableView.tableFooterView = nil
                    }else{
                        self.refreshControl.endRefreshing()
                        Helper.showNoFilterState(vc: self, tb: self.tableView, action: #selector(self.showFilterMenu))
                    }
                    self.tableView.reloadData()
                }
            }))
        }else{
            
            Helper.showNoInternetMessg()
            Helper.showNoInternetState(vc: self, tb: tableView, action: #selector(populateList))
            refreshControl.endRefreshing()
        }
    }
    
    func viewRO() {
        //        if internetStatus != .notReachable{
        //            let url = String.init(format: Constant.PC.VIEW, Session.authKey,data.RefNo)
        //            self.view.showLoading()
        //            Alamofire.request(url).responseData(completionHandler: ({ response in
        //                self.view.hideLoading()
        //                if Helper.isResponseValid(vc: self, response: response.result){
        //                    let responseJson = JSON(response.result.value!)
        //                    let arrData = responseJson.arrayObject as! [[String:AnyObject]]
        //                    if (arrData.count > 0){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ROBaseViewController") as! ROBaseViewController
        
        //                        vc.response = response.result.value
        //                        vc.title = data.RefNo
        //                        vc.titleHead = data.RefNo
        self.navigationController!.pushViewController(vc, animated: true)
        //                    }else{
        //                        self.view.makeToast("No Data To Show")
        //                    }
        //                }
        //            }))
        //        }else{
        //            Helper.showNoInternetMessg()
        //        }
    }
    
}

extension ReleaseOrderController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //        if  searchText.isEmpty {
        //            self.arrayList = newArray
        //        } else {
        //            let filteredArray =   newArray.filter {
        //                $0.RefNo.localizedCaseInsensitiveContains(searchText)
        //            }
        //            self.arrayList = filteredArray
        //        }
        //        tableView.reloadData()
    }
}


extension ReleaseOrderController: UITableViewDataSource, UITableViewDelegate, onButtonClickListener  {
    //    func onApproveClick() {
    //
    //    }
    //
    //
    //    func onClick(optionMenu: UIViewController, sender: UIButton) {
    //          self.present(optionMenu, animated: true, completion: nil)
    //    }
    //
    //    func onViewClick() {
    //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ROBaseViewController") as! ROBaseViewController
    //        self.navigationController!.pushViewController(vc, animated: true)
    //    }
    //
    //    func onCancelClick() {
    //
    //    }
    //
    //    func onMailClick() {
    //
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 294
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
        viewRO()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = arrayList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ROListCell") as! ROListCell
        cell.setDataToView(data: data)
        //        cell.roMenuDelegate = self
        //        cell.roOptionItemDelegate = self
        //        cell.selectionStyle = .none
        cell.delegate = self
        return cell;
    }
    
    func onViewClick(data: AnyObject) {
        
        viewRO()
    }
    
    func onMailClick(data: AnyObject) {
        
        //        self.handleTap()
        //        let alert = UIAlertController(title: "Are you sure you want to Email?", message: "This email will be sent to your official email ID", preferredStyle: .alert)
        //        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: {(UIAlertAction) -> Void in
        //        }))
        //
        //        alert.addAction(UIAlertAction(title: "SEND", style: .default, handler: {(UIAlertAction)-> Void in
        //            self.sendEmail(data: data as! PurchaseContractData)
        //        }))
        //        self.present(alert, animated: true, completion: nil)
    }
    
    
    func onApproveClick(data: AnyObject) {
        
        //        self.handleTap()
        //        myView = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        //        myView.setDataToCustomView(title: "Approve?", description: "Are you sure you want to approve this Contract? You can't revert once approved", leftButton: "GO BACK", rightButton: "APPROVE",isTxtVwHidden: false, isApprove:  true)
        //        myView.data = data
        //        myView.cpvDelegate = self
        //        self.view.addMySubview(myView)
    }
    
    
    func onDeclineClick(data: AnyObject) {
        
        //        self.handleTap()
        //
        //        declView = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        //        declView.setDataToCustomView(title: "Decline?", description: "Are you sure you want to decline this Contract? You can't revert once declined", leftButton: "GO BACK", rightButton: "DECLINE", isTxtVwHidden: false, isApprove: false)
        //        declView.data = data
        //        declView.cpvDelegate = self
        //        self.view.addMySubview(declView)
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



