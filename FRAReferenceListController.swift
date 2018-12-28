//
//  FRAReferenceListController.swift
//  mocs
//
//  Created by Talat Baig on 12/21/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FRAReferenceListController: UIViewController , UIGestureRecognizerDelegate{
    
    var arrayList = [FRARefData]()
    var newArray = [FRARefData]()
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var srchBar: UISearchBar!
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "FRARefCell", bundle: nil), forCellReuseIdentifier: "cell")
        
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
        vwTopHeader.lblTitle.text = "Funds Receipt [Counterparty-wise]"
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
            
            var newData:[FRARefData] = []
            
            self.view.showLoading()
            let url:String = String.init(format: Constant.FRA.FRA_REF_LIST, Session.authKey)
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let jsonResponse = JSON(response.result.value!)
                    let jsonArr = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    for i in 0..<jsonArr.count {
                        
                        let fraRef = FRARefData()
                        
                        fraRef.counterparty = jsonResponse[i]["CounterParty Name"].stringValue
                        
                        fraRef.totalAmt = jsonResponse[i]["Total Charge Amount"].stringValue
                        fraRef.accNum = jsonResponse[i]["Bank Account Number"].stringValue
                        fraRef.refNo = jsonResponse[i]["Reference Number"].stringValue
                        fraRef.bnkName = jsonResponse[i]["Bank Name"].stringValue
                        
                        if jsonResponse[i]["Bank Account Number"].stringValue == "" {
                            fraRef.accNum = "-"
                        } else {
                            fraRef.accNum = jsonResponse[i]["Bank Account Number"].stringValue
                        }
                        
                        if jsonResponse[i]["Gross Amount"].stringValue == "" {
                            fraRef.grossAmt = "-"
                        } else {
                            fraRef.grossAmt = jsonResponse[i]["Gross Amount"].stringValue
                        }
                        
                        if jsonResponse[i]["Net Amount"].stringValue == "" {
                            fraRef.netAmt = "-"
                        } else {
                            fraRef.netAmt = jsonResponse[i]["Net Amount"].stringValue
                        }
                        
                        if jsonResponse[i]["FR Currency"].stringValue == "" {
                            fraRef.frCCY = "-"
                        } else {
                            fraRef.frCCY = jsonResponse[i]["FR Currency"].stringValue
                        }
                        
                        if jsonResponse[i]["Remarks"].stringValue == "" {
                            fraRef.remarks = "-"
                        } else {
                            fraRef.remarks = jsonResponse[i]["Remarks"].stringValue
                        }
                        newData.append(fraRef)
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
extension FRAReferenceListController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTap()
        return false
    }
}



extension FRAReferenceListController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchText.isEmpty {
            self.arrayList = newArray
        } else {
            let filteredArray = newArray.filter {
                $0.refNo.localizedCaseInsensitiveContains(searchText) ||  $0.counterparty.localizedCaseInsensitiveContains(searchText)
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
extension FRAReferenceListController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FRARefCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.selectionStyle = .none
        let data = self.arrayList[indexPath.row]
        cell.setDataToView(data: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fraContractVC = self.storyboard?.instantiateViewController(withIdentifier: "FRAContractListController") as! FRAContractListController
        fraContractVC.refId = self.arrayList[indexPath.row].refNo
        self.navigationController?.pushViewController(fraContractVC, animated: true)
    }
    
}


// MARK: - WC_HeaderViewDelegate methods
extension FRAReferenceListController: WC_HeaderViewDelegate {
    
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




