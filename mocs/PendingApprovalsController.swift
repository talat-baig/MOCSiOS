//
//  PendingApprovalsController.swift
//  mocs
//
//  Created by Talat Baig on 1/30/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PendingApprovalsController: UIViewController {

    var arrayList : [PAData] = []

    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = Constant.PAHeaderTitle.ALL
        vwTopHeader.lblSubTitle.isHidden = true
        
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "PendingApprovalCell", bundle: nil), forCellReuseIdentifier: "cell")
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(self.getAllPAData))
        tableView.addSubview(refreshControl)

        getAllPAData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if FilterViewController.selectedDataObj.count > 0 {
            FilterViewController.selectedDataObj.removeAll()
        }
        
        getAllPAData()
    }
    
    @objc func getAllPAData() {
        
        var arrData: [PAData] = []
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.PAData.PA_GET_ALL, Session.authKey, "0")
            print("PA URL", url)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()

                if Helper.isResponseValid(vc: self, response: response.result, tv: self.tableView) {
                    
                    let jsonResponse = JSON(response.result.value!)
                    let array = jsonResponse.arrayObject as! [[String:AnyObject]]
                    self.arrayList.removeAll()
                    
                    if array.count > 0 {
                        self.lblSummary.isHidden = false
                    
                        for(_,json):(String,JSON) in jsonResponse {
                            
                            let paDta = PAData()
                            
                            if json["Module Name"].stringValue == "" {
                                paDta.modName = "-"
                            } else {
                                paDta.modName = json["Module Name"].stringValue
                            }
                           
                            if json["Total Pending"].stringValue == "" {
                                paDta.paCount = "0"
                            } else {
                                paDta.paCount  = json["Total Pending"].stringValue
                            }
                            
                            if json["MenuNames"].stringValue == "" {
                                paDta.menuNames = "-"
                            } else {
                                paDta.menuNames  = json["MenuNames"].stringValue
                            }
                            arrData.append(paDta)
                        }
                        self.arrayList = arrData
                    } else {
                        Helper.showEmptyState(vc: self, messg: "No Summary data found", action: nil)
                        self.lblSummary.isHidden = true
                    }
                    self.tableView.tableFooterView = nil
//                    self.tableView.reloadData()
                } else {
                    Helper.showEmptyState(vc: self, messg: "No Summary data found", action: nil)
                    self.lblSummary.isHidden = true
                }
                self.tableView.reloadData()
            }))
        } else {
            self.arrayList.removeAll()
            Helper.showNoInternetMessg()
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            lblSummary.isHidden = true
            Helper.showNoInternetState(vc: self, tb: tableView, action: #selector(getAllPAData))
        }
    }
    
    func navigateToModulePA(data: PAData) {
        
        switch data.modName.lowercased() {
            
        case "tcr":
            let vc = UIStoryboard(name: "TCR", bundle: nil).instantiateViewController(withIdentifier: "TCRController") as! TCRController
            vc.navTitle = data.menuNames
            self.navigationController!.pushViewController(vc, animated: true)

            break
            
        case "epr":
            let vc = UIStoryboard(name: "EmployeePayment", bundle: nil).instantiateViewController(withIdentifier: "EmployeePaymentController") as! EmployeePaymentController
            vc.navTitle = data.menuNames
            self.navigationController!.pushViewController(vc, animated: true)
            break
            
        case "do":
            let vc = UIStoryboard(name: "DeliveryOrder", bundle: nil).instantiateViewController(withIdentifier: "DeliveryOrderController") as! DeliveryOrderController
            vc.navTitle = data.menuNames
            self.navigationController!.pushViewController(vc, animated: true)
            break
            
        case "counterparty":
            let vc = UIStoryboard(name: "CounterpartyApproval", bundle: nil).instantiateViewController(withIdentifier: "CounterpartyProfileController") as! CounterpartyProfileController
            vc.navTitle = data.menuNames
            self.navigationController!.pushViewController(vc, animated: true)
            break
            
        case "leave management system":
            let vc = UIStoryboard(name: "LMS", bundle: nil).instantiateViewController(withIdentifier: "LeaveManagmentController") as! LeaveManagmentController
            vc.navTitle = data.menuNames
            self.navigationController!.pushViewController(vc, animated: true)
            break
            
        case "purchase contract":
            let vc = UIStoryboard(name: "PurchaseContract", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContractController") as! PurchaseContractController
            vc.navTitle = data.menuNames
            self.navigationController!.pushViewController(vc, animated: true)
            break
            
        case "ro":
            let vc = UIStoryboard(name: "ReleaseOrder", bundle: nil).instantiateViewController(withIdentifier: "ReleaseOrderController") as! ReleaseOrderController
            vc.navTitle = data.menuNames
            self.navigationController!.pushViewController(vc, animated: true)
            break
            
        case "sales contract":
            let vc = UIStoryboard(name: "SalesContract", bundle: nil).instantiateViewController(withIdentifier: "SalesContractController") as! SalesContractController
            vc.navTitle = data.menuNames
            self.navigationController!.pushViewController(vc, animated: true)
            break
            
        case "travel request":
            let vc = UIStoryboard(name: "TravelReqApproval", bundle: nil).instantiateViewController(withIdentifier: "TravelReqApprovalVC") as! TravelReqApprovalVC
            vc.navTitle = data.menuNames
            self.navigationController!.pushViewController(vc, animated: true)
            break
            
        case "tri":
            let vc = UIStoryboard(name: "TradeInvoice", bundle: nil).instantiateViewController(withIdentifier: "TradeInvoiceController") as! TradeInvoiceController
            vc.navTitle = data.menuNames
            self.navigationController!.pushViewController(vc, animated: true)

            break
            
        case "ari":
            let vc = UIStoryboard(name: "AdminReceive", bundle: nil).instantiateViewController(withIdentifier: "AdminReceiveController") as! AdminReceiveController
            vc.navTitle = data.menuNames
            self.navigationController!.pushViewController(vc, animated: true)
            break
            
        default:
            break
        }
    }
}



extension PendingApprovalsController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = arrayList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PendingApprovalCell
        cell.selectionStyle = .none
        cell.setDataToView(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.arrayList[indexPath.row]
        self.navigateToModulePA(data: data)
    }
    
}

extension PendingApprovalsController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
    }
    
}

