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
    var refId = ""
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
        vwTopHeader.lblTitle.text = "Bank Charges Detail"
        vwTopHeader.lblSubTitle.text =  self.refId
        
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
    
    
    @objc func populateList() {
        
        var newArr : [BCDetailData] = []
        if internetStatus != .notReachable {

            self.view.showLoading()
            let url:String = String.init(format: Constant.BankCharges.BCS_DETAILS, Session.authKey, Helper.encodeURL(url : FilterViewController.getFilterString()), Helper.encodeURL(url: self.refId))

            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){

                    let jsonResp = JSON(response.result.value!)
                    let arrayJson = jsonResp.arrayObject as! [[String:AnyObject]]

                    if arrayJson.count > 0 {

                        do {
                            // 1
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            // 2
                            newArr = try decoder.decode([BCDetailData].self, from: response.result.value!)
                        } catch let error { // 3
                            print("Error creating current newDataObj from JSON because: \(error)")
                        }
                        self.arrayList = newArr
                    }
                    self.tableView.setNeedsLayout()
                    self.tableView.layoutIfNeeded()
                    self.tableView.reloadData()
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
}


// MARK: - UITableViewDataSource methods
extension BankChargeDetailsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayList.count
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
        if self.arrayList.count > 0 {
            cell.setDataToView(data: self.arrayList[indexPath.row])
        }
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
