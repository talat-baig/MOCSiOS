//
//  FRAContractListController.swift
//  mocs
//
//  Created by Talat Baig on 12/21/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class FRAContractListController: UIViewController {
    
    var arrayList = [FRAContractData]()
    var refId : String = ""
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "FRAContractCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.separatorStyle = .none
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(populateList))
        tableView.addSubview(refreshControl)
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Funds Receipt [Contract-wise]"
        vwTopHeader.lblSubTitle.isHidden = true
        
        populateList()
    }
    
  
    @objc func populateList() {
        
        if internetStatus != .notReachable {
            
            var newData:[FRAContractData] = []

            
            self.view.showLoading()
            let url:String = String.init(format: Constant.FRA.FRA_CONTRACT_LIST, Session.authKey,Helper.encodeURL(url:refId))
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let jsonResponse = JSON(response.result.value!)
                    let jsonArr = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    for i in 0..<jsonArr.count {
                        
                        let fraContrct = FRAContractData()
                        fraContrct.refNo = jsonResponse[i]["Allocated Contract Number"].stringValue
                        
                        if jsonResponse[i]["Allocated Invoice Number"].stringValue == "" {
                            fraContrct.invNo  = "-"
                        } else {
                            fraContrct.invNo  = jsonResponse[i]["Allocated Invoice Number"].stringValue
                        }
                        
                        if jsonResponse[i]["Invoice Amount"].stringValue == "" {
                            fraContrct.invAmt  = "-"
                        } else {
                            fraContrct.invAmt  = jsonResponse[i]["Invoice Amount"].stringValue
                        }
                        
                        if jsonResponse[i]["USD Equivalent"].stringValue == "" {
                            fraContrct.invVal  = "-"
                        } else {
                            fraContrct.invVal  = jsonResponse[i]["USD Equivalent"].stringValue
                        }
                        
                        if jsonResponse[i]["Invoice CCY"].stringValue == "" {
                            fraContrct.invCurr  = "-"
                        } else {
                            fraContrct.invCurr  = jsonResponse[i]["Invoice CCY"].stringValue
                        }
                        
                        if jsonResponse[i]["Allocated and Unallocated Amount"].stringValue == "" {
                            fraContrct.unallocAmt  = "-"
                        } else {
                            fraContrct.unallocAmt  = jsonResponse[i]["Allocated and Unallocated Amount"].stringValue
                        }
                        
                        if jsonResponse[i]["FX Gain and Loss Amount"].stringValue == "" {
                            fraContrct.gainLossAmt  = "-"
                        } else {
                            fraContrct.gainLossAmt  = jsonResponse[i]["FX Gain and Loss Amount"].stringValue
                        }
                        
                        if jsonResponse[i]["Cancel reason"].stringValue == "" {
                            fraContrct.remarks  = "-"
                        } else {
                            fraContrct.remarks  = jsonResponse[i]["Cancel reason"].stringValue
                        }
                        newData.append(fraContrct)
                    }
                    self.arrayList = newData
                    self.tableView.reloadData()
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
}




// MARK: - UITableViewDataSource methods
extension FRAContractListController: UITableViewDataSource, UITableViewDelegate {
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FRAContractCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        let data = self.arrayList[indexPath.row]
        cell.setDataToView(data: data)
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
    }
    
}


// MARK: - WC_HeaderViewDelegate methods
extension FRAContractListController: WC_HeaderViewDelegate {
    
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
