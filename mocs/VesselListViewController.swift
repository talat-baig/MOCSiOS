//
//  VesselListViewController.swift
//  mocs
//
//  Created by Talat Baig on 11/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import SwiftyJSON
import  Alamofire

class VesselListViewController: UIViewController {
    
    var response : Data?
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var vwSummary: UIView!
    
    @IBOutlet weak var vwHeaderAndQty: UIView!

    @IBOutlet weak var lblTotalQty: UILabel!

    var arrayList : [VesselList] = []
    var arrVessetList : [String] = []

    lazy var refreshControl:UIRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.register(UINib(nibName: "AvlRelListCell", bundle: nil), forCellReuseIdentifier: "cell")

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Report [Vessel-wise]"
        vwTopHeader.lblSubTitle.isHidden = true
        
        tableView.estimatedRowHeight = 55.0
        tableView.rowHeight = UITableView.automaticDimension
        
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(getVesselData))
        tableView.addSubview(refreshControl)

        
        self.vwSummary.layer.borderWidth = 1
        self.vwSummary.layer.borderColor = AppColor.universalHeaderColor.cgColor
        self.vwSummary.layer.cornerRadius = 5

        getVesselData()
    }
    
    @objc func getVesselData() {
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.AvlRel.VESSEL_LIST, Session.authKey,  Helper.encodeURL(url : FilterViewController.getFilterString()))
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()

                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let responseJson = JSON(response.result.value!)
                    let arrData = responseJson.arrayObject as! [[String:AnyObject]]
                    
                    if (arrData.count > 0) {
                      
                        self.tableView.tableFooterView = nil
                        self.vwHeaderAndQty.isHidden = false
                        self.parseAndAssignVesselData(response : response.result.value! )
                        self.parseAndAssignVesselList(response : response.result.value! )
                    } else {
                        self.lblTotalQty.text =  " "
                        self.vwHeaderAndQty.isHidden = true
                        self.showEmptyState()
                    }
                } else {
                    self.lblTotalQty.text =  " "
                    self.vwHeaderAndQty.isHidden = true
                    self.showEmptyState()
                }
            }))
        } else {
            self.vwHeaderAndQty.isHidden = true
            self.lblTotalQty.text = " "
            Helper.showNoInternetMessg()
        }
    }
    
    func showEmptyState(){
        Helper.showNoFilterStateResized(vc: self, messg: "No Available Release Data for the current. Try by changing filter.", tb: tableView)
    }
    
    func parseAndAssignVesselList(response : Data?) {

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
        self.arrVessetList = arrVessl
    }
    
    
    func parseAndAssignVesselData(response : Data?) {
        
        var arrVessl: [VesselList] = []
        let responseJson = JSON(response!)

        for(_,j):(String,JSON) in responseJson {
            let newVessl = VesselList()
            
            if j["Vessel Name"].stringValue == "" {
                newVessl.vesselName = "-"
            } else {
               newVessl.vesselName = j["Vessel Name"].stringValue
            }
            newVessl.relAvlSale = j["Realease Available for Sale (mt)"].stringValue
            newVessl.totalQty = j["Total Realease Available for Sale (mt)"].stringValue
            arrVessl.append(newVessl)
        }
        self.arrayList = arrVessl
        
        DispatchQueue.main.async {
            self.lblTotalQty.text =  "Total Qty(MT) : " +  self.arrayList[0].totalQty
            self.tableView.reloadData()
        }
    }
}



extension VesselListViewController: UITableViewDataSource {
    
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
        cell.setVesselDataToView(data:arrayList[indexPath.row])
        cell.selectionStyle = .none
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        return cell
    }
}

// MARK: - UITableViewDelegate methods
extension VesselListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "DetailsListViewController") as! DetailsListViewController
        detail.isFromVessel = true
        detail.arrVesselList = self.arrVessetList
        detail.titleStr = arrayList[indexPath.row].vesselName
        self.navigationController?.pushViewController(detail, animated: true)
    }
}


extension VesselListViewController: WC_HeaderViewDelegate {
    
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

