//
//  TTItineraryListVC.swift
//  mocs
//
//  Created by Talat Baig on 9/27/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NotificationCenter
import DropDown

class TTItineraryListVC: UIViewController, IndicatorInfoProvider, UIGestureRecognizerDelegate {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "ITINERARY DETAILS")
    }
    
    
    var itinryRes : Data?
    var isFromView : Bool = false
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var btnAddItinry: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ItineraryListCell", bundle: nil), forCellReuseIdentifier: "cell")
        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(getItirenaryData))
        
        if isFromView {
            btnAddItinry.isHidden = true
            
        } else {
            btnAddItinry.isHidden = false
            tableView.addSubview(refreshControl)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @objc func getItirenaryData() {
        
        //        if internetStatus != .notReachable {
        //            let url = String.init(format: Constant.TRF.ITINERARY_LIST, Session.authKey,
        //                                  trfData.trfId)
        //            self.view.showLoading()
        //            print(url)
        //            Alamofire.request(url).responseData(completionHandler: ({ response in
        //                self.view.hideLoading()
        //                self.refreshControl.endRefreshing()
        //
        //                self.populateList(response : response.result.value!)
        //            }))
        //        } else {
        //            Helper.showNoInternetMessg()
        //        }
    }
    
    func populateList(response : Data) {
        
        //        var data: [ItineraryListData] = []
        //
        //        let pJson = JSON(response)
        //        let arr = pJson.arrayObject as! [[String:AnyObject]]
        //
        //        if arr.count > 0 {
        //
        //            for(_,k):(String,JSON) in pJson {
        //                let itinryData = ItineraryListData()
        //
        //                itinryData.ItinID = k["ItinID"].stringValue
        //                itinryData.itID = k["ID"].stringValue
        //                itinryData.bID = k["BID"].stringValue
        //                itinryData.reqNo = k["RequestNo"].stringValue
        //                itinryData.dest = k["Destination"].stringValue
        //                itinryData.depDate = k["DepartureDate"].stringValue
        //                itinryData.retDate = k["ReturnDate"].stringValue
        //                itinryData.estDays = k["EstimatedDays"].stringValue
        //                itinryData.createdDate = k["CreatedDate"].stringValue
        //
        //                data.append(itinryData)
        //            }
        //
        //            self.arrayList = data
        //            self.tableView.reloadData()
        //        } else {
        //
        //            if isFromView {
        //                Helper.showNoItemState(vc:self , messg: "No Itinerary Item found" , tb:tableView)
        //            } else {
        //                debugPrint("No Itinerary Item found")
        //                self.tableView.reloadData()
        //
        //            }
        //        }
    }
    
}



extension TTItineraryListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        if arrayList.count > 0 {
        //            tableView.backgroundView?.isHidden = true
        //            tableView.separatorStyle = .singleLine
        //        }else{
        //            tableView.backgroundView?.isHidden = false
        //            tableView.separatorStyle = .none
        //        }
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        let data = arrayList[indexPath.row]
        let views = tableView.dequeueReusableCell(withIdentifier: "cell") as! ItineraryListCell
        //        views.setdataToView(data : data)
        views.btnMenu.tag = indexPath.row
        //        views.itnryMenuDelegate = self
        //        views.itnryItemMenuDelegate = self
        views.selectionStyle = .none
        //
        if isFromView {
            views.btnMenu.isHidden = true
        } else {
            views.btnMenu.isHidden = false
        }
        //
        return views
    }
    
    
    
    
    
}
