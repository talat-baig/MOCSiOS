//
//  PurchaseContractListVC.swift
//  mocs
//
//  Created by Talat Baig on 12/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PurchaseContractListVC: UIViewController, UIGestureRecognizerDelegate {
    
    var pcData = [PurchaseSummData]()
    var newArray = [PurchaseSummData]()
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var srchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.register(UINib(nibName: "PurchaseSummCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.separatorStyle = .none
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Purchase Summary[Contract-wise]"
        vwTopHeader.lblSubTitle.isHidden = true
        
        populateList()
    }
    
    @objc func handleTap() {
        self.srchBar.endEditing(true)
    }
    
    @objc func populateList() {
        
        if internetStatus != .notReachable {
            
            self.view.showLoading()
            let url:String = String.init(format: Constant.PurchaseSummary.PC_SALES_LIST, Session.authKey)
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let jsonResponse = JSON(response.result.value!)
                    let jsonArr = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    for i in 0..<jsonArr.count {
                        
                        let pcDataObj = PurchaseSummData()
                        pcDataObj.refNo = jsonResponse[i]["Purchase Contract"].stringValue
                        pcDataObj.fundPaymnt = jsonResponse[i]["Funds Payment Amount"].stringValue
                        pcDataObj.supplierName = jsonResponse[i]["Supplier Name"].stringValue
                        pcDataObj.paymntTerm = jsonResponse[i]["Payment Term"].stringValue
                        pcDataObj.delTerm = jsonResponse[i]["Delivery Term"].stringValue
                        pcDataObj.value = jsonResponse[i]["Value"].stringValue
                        pcDataObj.grQty = jsonResponse[i]["Goods Received Qty"].stringValue
                        
                        if jsonResponse[i]["Shipment Start Date"].stringValue == "" {
                            pcDataObj.shipStrtDte = "-"
                        } else {
                            pcDataObj.shipStrtDte = jsonResponse[i]["Shipment Start Date"].stringValue
                        }
                        if jsonResponse[i]["Shipment End Date"].stringValue == "" {
                            pcDataObj.shipEndDte = "-"
                        } else {
                            pcDataObj.shipEndDte = jsonResponse[i]["Shipment End Date"].stringValue
                        }
                        pcDataObj.rcvdInvQty = jsonResponse[i]["Quantity"].stringValue
                        pcDataObj.contractStatus = jsonResponse[i]["Contract Status"].stringValue
                        
                        if jsonResponse[i]["POL"].stringValue == "" {
                            pcDataObj.pol = "-"
                        } else {
                            pcDataObj.pol = jsonResponse[i]["POL"].stringValue
                        }
                        
                        if jsonResponse[i]["POD"].stringValue == "" {
                            pcDataObj.pod = "-"
                        } else {
                            pcDataObj.pod = jsonResponse[i]["POD"].stringValue
                        }
                        
                        if jsonResponse[i]["Invoice Amount"].stringValue == "" {
                            pcDataObj.rcvdInvAmt = "-"
                        } else {
                            pcDataObj.rcvdInvAmt = jsonResponse[i]["Invoice Amount"].stringValue
                        }
                        
                        
                        //                        pcDataObj. = jsonResponse[i]["Contract Currency"].stringValue
                        //                        pcDataObj.invCurr = jsonResponse[i]["Invoice Currency"].stringValue
                        
                        self.pcData.append(pcDataObj)
                    }
                    self.newArray = self.pcData
                    self.tableView.reloadData()
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view?.isDescendant(of: tableView))! {
            return false
        }
        return true
    }
}


// Mark: - UITextFieldDelegate method
extension PurchaseContractListVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTap()
        return false
    }
}

extension PurchaseContractListVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pcData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PurchaseSummCell
        cell.layer.masksToBounds = true
        cell.setDataTOView(data:  self.pcData[indexPath.row] )
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 5
        return cell
    }
}


// MARK: - UITableViewDelegate methods
extension PurchaseContractListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let purSumm = self.storyboard?.instantiateViewController(withIdentifier: "PurchaseSummProductVC") as! PurchaseSummProductVC
        purSumm.refNo =  self.pcData[indexPath.row].refNo
        self.navigationController?.pushViewController(purSumm, animated: true)
    }
}

extension PurchaseContractListVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //                if  searchText.isEmpty {
        //                    self.pcData = newArray
        //                } else {
        //                    let filteredArray = newArray.filter {
        //                        $0.refNo.localizedCaseInsensitiveContains(searchText)
        //                    }
        //                    self.pcData = filteredArray
        //                }
        //                tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        srchBar.text = ""
        self.srchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.srchBar.endEditing(true)
    }
}


extension PurchaseContractListVC: WC_HeaderViewDelegate {
    
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
