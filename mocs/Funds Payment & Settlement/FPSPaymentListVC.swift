//
//  FPSPaymentListVC.swift
//  mocs
//
//  Created by Talat Baig on 1/2/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FPSPaymentListVC: UIViewController {

    var refId = ""
    var arrayList = [FPSPaymentData]()
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "FPSPaymentCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.separatorStyle = .none
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(populateList))
        tableView.addSubview(refreshControl)
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Funds Payment [Reference-wise]"
        vwTopHeader.lblSubTitle.text = refId
        
        populateList()
    }
    
    @objc func populateList() {
        
        if internetStatus != .notReachable {
            
            var newData:[FPSPaymentData] = []
            
            self.view.showLoading()
            let url:String = String.init(format: Constant.FPS.FPS_PAYMENTS_LIST, Session.authKey,Helper.encodeURL(url:FilterViewController.getFilterString()),Helper.encodeURL(url:refId))
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let jsonResponse = JSON(response.result.value!)
                    let jsonArr = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    for i in 0..<jsonArr.count {
                        
                        let fpsPymnt = FPSPaymentData()

                        if jsonResponse[i]["Payment Reference ID"].stringValue == "" {
                            fpsPymnt.payId  = "-"
                        } else {
                            fpsPymnt.payId  = jsonResponse[i]["Payment Reference ID"].stringValue
                        }

                        if jsonResponse[i]["Paid Amount"].stringValue == "" {
                            fpsPymnt.paidAmt  = "-"
                        } else {
                             fpsPymnt.paidAmt  = jsonResponse[i]["Paid Amount"].stringValue
                        }
                        
                        if jsonResponse[i]["Payment Reason"].stringValue == "" {
                            fpsPymnt.reason  = "-"
                        } else {
                            fpsPymnt.reason  = jsonResponse[i]["Payment Reason"].stringValue
                        }
                        
                        if jsonResponse[i]["Journal"].stringValue == "" {
                            fpsPymnt.journal  = "-"
                        } else {
                            fpsPymnt.journal  = jsonResponse[i]["Journal"].stringValue
                        }
                        
                        if jsonResponse[i]["Paid Date"].stringValue == "" {
                            fpsPymnt.paidDate  = "-"
                        } else {
                            fpsPymnt.paidDate  = jsonResponse[i]["Paid Date"].stringValue
                        }
                        
                        if jsonResponse[i]["Payment Mode"].stringValue == "" {
                            fpsPymnt.payMode  = "-"
                        } else {
                            fpsPymnt.payMode  = jsonResponse[i]["Payment Mode"].stringValue
                        }
                        
                        if jsonResponse[i]["Remarks"].stringValue == "" {
                            fpsPymnt.remarks  = "-"
                        } else {
                            fpsPymnt.remarks  = jsonResponse[i]["Remarks"].stringValue
                        }
                        
                        if jsonResponse[i]["Currency"].stringValue == "" {
                            fpsPymnt.currency  = "-"
                        } else {
                            fpsPymnt.currency = jsonResponse[i]["Currency"].stringValue
                        }
                        

                        
                        newData.append(fpsPymnt)
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
extension FPSPaymentListVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FPSPaymentCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        let data = self.arrayList[indexPath.row]
        cell.setDataToViews(data: data)
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}


// MARK: - WC_HeaderViewDelegate methods
extension FPSPaymentListVC: WC_HeaderViewDelegate {
    
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
