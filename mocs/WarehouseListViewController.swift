//
//  WarehouseListViewController.swift
//  mocs
//
//  Created by Talat Baig on 11/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Alamofire

class WarehouseListViewController: UIViewController {
    
    var arrVessel : [String] = []
    var arrayList : [WarehouseData] = []
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwSummary: UIView!
    @IBOutlet weak var lblTotalQty: UILabel!
    @IBOutlet weak var vwHeaderAndQty: UIView!
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "AvlRelListCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Report [Warehouse-wise]"
        vwTopHeader.lblSubTitle.isHidden = true
        
        tableView.estimatedRowHeight = 55.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(getVesselAndWarehouseData))
        tableView.addSubview(refreshControl)
        
        self.vwSummary.layer.borderWidth = 1
        self.vwSummary.layer.borderColor = AppColor.universalHeaderColor.cgColor
        self.vwSummary.layer.cornerRadius = 5
        
        getVesselAndWarehouseData()
    }
    
    
    func showEmptyState(){
        Helper.showNoFilterStateResized(vc: self, messg: "No Available Release Data for the current. Try by changing filter.", tb: tableView)
    }
    
    func parseAndAssignVesselData(response : Data?) {
        
        var arrVessl: [String] = []
        let responseJson = JSON(response!)
        
        for(_,j):(String,JSON) in responseJson {
            var newCurr : String = ""
            
            if j["Vessel Name"].stringValue == "" {
                newCurr = "-"
            } else {
                newCurr = j["Vessel Name"].stringValue
            }
            arrVessl.append(newCurr)
        }
        self.arrVessel = arrVessl
    }
    
    
    func parseAndAssignWarehouseData(response : Data?) {
        
        var arrWare: [WarehouseData] = []
        let responseJson = JSON(response!)
        
        for(_,j):(String,JSON) in responseJson {
            let newWare = WarehouseData()
            
            if j["Warehouse Name"].stringValue == "" {
                newWare.wareName = "-"
            } else {
                newWare.wareName = j["Warehouse Name"].stringValue
            }
            newWare.wareQty = j["Release Available for Sale (mt)"].stringValue
            newWare.totalQty = j["Total Release Available for Sale (mt)"].stringValue
            
            arrWare.append(newWare)
        }
        self.arrayList = arrWare
        
        DispatchQueue.main.async {
            self.lblTotalQty.text =  "Total Qty(MT) : " +  self.arrayList[0].totalQty
            self.tableView.reloadData()
        }
    }
    
    @objc func getVesselAndWarehouseData() {
        
        if internetStatus != .notReachable {
            
            let url1 = String.init(format: Constant.AvlRel.VESSEL_LIST, Session.authKey,  Helper.encodeURL(url : FilterViewController.getFilterString()))
            let url2 = String.init(format: Constant.AvlRel.WAREHOUSE_LIST, Session.authKey,  Helper.encodeURL(url : FilterViewController.getFilterString()))
            
            self.view.showLoading()
            Alamofire.request(url1).responseData(completionHandler: ({ vesselResp in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                
                if Helper.isResponseValid(vc: self, response: vesselResp.result) {
                    
                    let responseJson = JSON(vesselResp.result.value!)
                    let arrVessl = responseJson.arrayObject as! [[String:AnyObject]]
                    
                    if (arrVessl.count > 0) {
                        // call Product List API
                        Alamofire.request(url2).responseData(completionHandler: ({ wareResponse in
                            self.view.hideLoading()
                            self.refreshControl.endRefreshing()
                            
                            if Helper.isResponseValid(vc: self, response: wareResponse.result) {
                                
                                let responseJson = JSON(wareResponse.result.value!)
                                let arrWare = responseJson.arrayObject as! [[String:AnyObject]]
                                
                                if (arrWare.count > 0) {
                                    self.tableView.tableFooterView = nil
                                    self.vwHeaderAndQty.isHidden = false
                                    self.parseAndAssignVesselData(response:vesselResp.result.value)
                                    self.parseAndAssignWarehouseData(response:wareResponse.result.value )
                                    
                                    
                                } else {
                                    // No warehouse data found
                                    self.lblTotalQty.text = " "
                                    self.vwHeaderAndQty.isHidden = true
                                    self.showEmptyState()
                                }
                            } else {
                                
                            }
                        }))
                    } else {
                        // No Vessel data Found
                        self.lblTotalQty.text = " "
                        self.vwHeaderAndQty.isHidden = true
                        self.lblTotalQty.text = " "
                        self.showEmptyState()
                    }
                }
            }))
        } else {
            self.vwHeaderAndQty.isHidden = true
            self.lblTotalQty.text = " "
            Helper.showNoInternetMessg()
        }
    }
    
}


extension WarehouseListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AvlRelListCell
        cell.layer.masksToBounds = true
        cell.setWarehouseDataToView(data: arrayList[indexPath.row])
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 5
        return cell
    }
}

// MARK: - UITableViewDelegate methods
extension WarehouseListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "DetailsListViewController") as! DetailsListViewController
        detail.isFromWarehouse = true
        detail.arrVesselList = self.arrVessel
        detail.titleStr = arrayList[indexPath.row].wareName
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
}


extension WarehouseListViewController: WC_HeaderViewDelegate {
    
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

