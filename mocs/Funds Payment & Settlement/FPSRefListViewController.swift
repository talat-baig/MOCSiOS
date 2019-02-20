//
//  FPSRefListViewController.swift
//  mocs
//
//  Created by Talat Baig on 1/2/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class FPSRefListViewController: UIViewController, UIGestureRecognizerDelegate {

    var arrayList = [FPSRefData]()
    var newArray = [FPSRefData]()
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var srchBar: UISearchBar!
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "FPSRefListCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(populateList))
        tableView.addSubview(refreshControl)
        
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Funds Payment [Counterparty-wise]"
        vwTopHeader.lblSubTitle.isHidden = true
        
        populateList()
    }
    
    @objc func handleTap() {
        self.srchBar.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view?.isDescendant(of: tableView))! {
            return false
        }
        return true
    }
    
    
    @objc func populateList() {
        
        if internetStatus != .notReachable {

            var newData:[FPSRefData] = []

            self.view.showLoading()
            let url:String = String.init(format: Constant.FPS.FPS_REF_LIST, Session.authKey, Helper.encodeURL(url:  FilterViewController.getFilterString()))

            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result){

                    let jsonResponse = JSON(response.result.value!)
                    let jsonArr = jsonResponse.arrayObject as! [[String:AnyObject]]

                    for i in 0..<jsonArr.count {

                        let fpsRef = FPSRefData()
                 
                        fpsRef.cpName = jsonResponse[i]["CounterParty Name"].stringValue
                        fpsRef.refId = jsonResponse[i]["ReferenceID"].stringValue
//                        fpsRef.balAmt = jsonResponse[i]["Balance Amount"].stringValue
                        
                        if jsonResponse[i]["Balance Amount"].stringValue == "" {
                            fpsRef.balAmt  = "-"
                        } else {
                            fpsRef.balAmt  = jsonResponse[i]["Balance Amount"].stringValue
                        }
                        fpsRef.paidAmt = jsonResponse[i]["Paid Amount"].stringValue
                        fpsRef.reqAmt = jsonResponse[i]["Requested Amount"].stringValue
                        fpsRef.currency = jsonResponse[i]["Currency"].stringValue
                        
                        newData.append(fpsRef)
                    }
                    self.arrayList = newData
                    self.newArray = self.arrayList
                    self.tableView.reloadData()
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
}

// Mark: - UITextFieldDelegate method
extension FPSRefListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTap()
        return false
    }
}



extension FPSRefListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.arrayList = newArray
        } else {
            let filteredArray = newArray.filter {
                $0.refId.localizedCaseInsensitiveContains(searchText) ||  $0.cpName.localizedCaseInsensitiveContains(searchText)
            }
            self.arrayList = filteredArray
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        srchBar.text = ""
        self.srchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.srchBar.endEditing(true)
    }
}


// MARK: - UITableViewDataSource methods
extension FPSRefListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FPSRefListCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.selectionStyle = .none
        let data = self.arrayList[indexPath.row]
        cell.setDataToView(data: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fpsPayment = self.storyboard?.instantiateViewController(withIdentifier: "FPSPaymentListVC") as! FPSPaymentListVC
        fpsPayment.refId = self.arrayList[indexPath.row].refId
        self.navigationController?.pushViewController(fpsPayment, animated: true)
    }
    
}


// MARK: - WC_HeaderViewDelegate methods
extension FPSRefListViewController: WC_HeaderViewDelegate {
    
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





