//
//  ProductListViewController.swift
//  mocs
//
//  Created by Talat Baig on 11/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Alamofire

class ProductListViewController: UIViewController {
    
    var arrVessel : [String] = []
    var arrayList : [AvlRelProductData] = []
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwSummary: UIView!
    @IBOutlet weak var lblTotalQty: UILabel!
    @IBOutlet weak var vwHeaderAndQty: UIView!
    
    let arrProduct = ["Brazilian Parboiled Rice","Brown Sugar","Lentils","abcd"]
    
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "AvlRelListCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(getVesselAndProductData))
        tableView.addSubview(refreshControl)
        
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        
        vwTopHeader.lblTitle.text = "Report [Product-wise]"
        vwTopHeader.lblSubTitle.isHidden = true
        
        tableView.estimatedRowHeight = 55.0
        tableView.rowHeight = UITableView.automaticDimension
        
        self.vwSummary.layer.borderWidth = 1
        self.vwSummary.layer.borderColor = AppColor.universalHeaderColor.cgColor
        self.vwSummary.layer.cornerRadius = 5
        
        getVesselAndProductData()
        
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
    
    
    func parseAndAssignProductData(response : Data?) {
        
        var arrProd: [AvlRelProductData] = []
        let responseJson = JSON(response!)
        
        for(_,j):(String,JSON) in responseJson {
            let newProd = AvlRelProductData()
            
            if j["Product"].stringValue == "" {
                newProd.prodName = "-"
            } else {
                newProd.prodName = j["Product"].stringValue
            }
            newProd.prodQty = j["Release Available for Sale (mt)"].stringValue
            newProd.totalQty = j["Total Release Available for Sale (mt)"].stringValue
            
            arrProd.append(newProd)
        }
        self.arrayList = arrProd
        
        DispatchQueue.main.async {
            self.lblTotalQty.text =  "Total Qty(MT) : " +  self.arrayList[0].totalQty
            self.tableView.reloadData()
        }
    }
    
    @objc func getVesselAndProductData() {
        
        if internetStatus != .notReachable {
            
            let url1 = String.init(format: Constant.AvlRel.VESSEL_LIST, Session.authKey,  Helper.encodeURL(url : FilterViewController.getFilterString()))
            let url2 = String.init(format: Constant.AvlRel.PRODUCT_LIST, Session.authKey,  Helper.encodeURL(url : FilterViewController.getFilterString()))
            
            self.view.showLoading()
            Alamofire.request(url1).responseData(completionHandler: ({ vesselResp in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()
                
                if Helper.isResponseValid(vc: self, response: vesselResp.result) {
                    
                    let responseJson = JSON(vesselResp.result.value!)
                    let arrVessl = responseJson.arrayObject as! [[String:AnyObject]]
                    
                    if (arrVessl.count > 0) {
                        // call Product List API
                        Alamofire.request(url2).responseData(completionHandler: ({ prodResponse in
                            self.view.hideLoading()
                            self.refreshControl.endRefreshing()
                            
                            if Helper.isResponseValid(vc: self, response: prodResponse.result) {
                                
                                let responseJson = JSON(prodResponse.result.value!)
                                let arrProd = responseJson.arrayObject as! [[String:AnyObject]]
                                
                                if (arrProd.count > 0) {
                                    self.tableView.tableFooterView = nil
                                    self.vwHeaderAndQty.isHidden = false
                                    self.parseAndAssignVesselData(response:vesselResp.result.value)
                                    self.parseAndAssignProductData(response:prodResponse.result.value )
                                } else {
                                    // No Product data found
                                    self.lblTotalQty.text =  " "
                                    self.vwHeaderAndQty.isHidden = true
                                    self.showEmptyState()
                                }
                            } else {
                                
                            }
                        }))
                    } else {
                        // No Vessel data Found
                        self.lblTotalQty.text =  " "
                        self.vwHeaderAndQty.isHidden = true
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



extension ProductListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AvlRelListCell
        cell.layer.masksToBounds = true
        cell.setProductDataToView(data: arrayList[indexPath.row] )
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 5
        return cell
    }
}

// MARK: - UITableViewDelegate methods
extension ProductListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "DetailsListViewController") as! DetailsListViewController
        detail.isFromProduct = true
        detail.arrVesselList = self.arrVessel
        detail.titleStr = arrayList[indexPath.row].prodName
        self.navigationController?.pushViewController(detail, animated: true)
    }
}


extension ProductListViewController: WC_HeaderViewDelegate {
    
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

