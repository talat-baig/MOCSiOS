//
//  BankChargeDetailsVC.swift
//  mocs
//
//  Created by Talat Baig on 3/11/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON


class BankChargeDetailsVC: UIViewController, UIGestureRecognizerDelegate {

    var arrayList = [BCDetailData]()
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "BankChargeDetailCell", bundle: nil), forCellReuseIdentifier: "cell")
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblSubTitle.isHidden = false
//        vwTopHeader.lblTitle.text = self.empName
//        vwTopHeader.lblSubTitle.text =  self.empID
        
        self.tableView.separatorStyle = .none
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.populateList()
    }
    
    
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view?.isDescendant(of: tableView))! {
            return false
        }
        return true
    }
    
    
    @objc func populateList(){
        
//        var newArr : [ECRRefData] = []
//        if internetStatus != .notReachable {
//
//            self.view.showLoading()
//            let url:String = String.init(format: Constant.ECRReport.REF_LIST, Session.authKey, Helper.encodeURL(url : FilterViewController.getFilterString()), Helper.encodeURL(url: self.empName))
//
//            Alamofire.request(url).responseData(completionHandler: ({ response in
//                self.view.hideLoading()
//                if Helper.isResponseValid(vc: self, response: response.result){
//
//                    let jsonResp = JSON(response.result.value!)
//                    let arrayJson = jsonResp.arrayObject as! [[String:AnyObject]]
//
//                    if arrayJson.count > 0 {
//
//                        for(_,j):(String,JSON) in jsonResp {
//
//                            let newObj = ECRRefData()
//
//                            newObj.refNo = j["Reference ID"].stringValue
//                            newObj.amtReq = j["Requested Amount"].stringValue != "" ? j["Requested Amount"].stringValue : "-"
//                            newObj.reqType = j["Request Type"].stringValue != "" ? j["Request Type"].stringValue : "-"
//                            newObj.charge = j["Account Charge Head"].stringValue != "" ? j["Account Charge Head"].stringValue : "-"
//                            newObj.amtPaid = j["Paid Total"].stringValue != "" ? j["Paid Total"].stringValue : "-"
//                            newObj.natureExpense = j["Expense Type"].stringValue != "" ? j["Expense Type"].stringValue : "-"
//                            newObj.curr = j["Local Currency"].stringValue != "" ? j["Local Currency"].stringValue : "-"
//                            newObj.deptApproval = j["Claim Dept. Approval Status"].stringValue != "" ? j["Claim Dept. Approval Status"].stringValue : "-"
//                            newObj.financeApproval = j["Claim Finance Approval Status"].stringValue != "" ? j["Claim Finance Approval Status"].stringValue : "-"
//                            newObj.account = j["Account Number"].stringValue != "" ? j["Account Number"].stringValue : "-"
//                            newObj.bankName = j["Bank"].stringValue != "" ? j["Bank"].stringValue : "-"
//
//                            newObj.remarks = j["Remarks"].stringValue != "" ? j["Remarks"].stringValue : "-"
//
//                            newArr.append(newObj)
//                        }
//                        self.arrayList = newArr
//                    }
//                    self.newArray = self.arrayList
//                    self.tableView.setNeedsLayout()
//                    self.tableView.layoutIfNeeded()
//                    self.tableView.reloadData()
//                }
//            }))
//        } else {
//            Helper.showNoInternetMessg()
//        }
    }
    
}


// MARK: - UITableViewDataSource methods
extension BankChargeDetailsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BankChargeDetailCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.isUserInteractionEnabled = false
        cell.selectionStyle = .none
//        if self.arrayList.count > 0 {
//            cell.setDataToView(data: self.arrayList[indexPath.row])
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}




// MARK: - WC_HeaderViewDelegate methods
extension BankChargeDetailsVC: WC_HeaderViewDelegate {
    
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
