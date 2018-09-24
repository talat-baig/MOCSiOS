//
//  ItineraryListController.swift
//  mocs
//
//  Created by Talat Baig on 9/12/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Alamofire
import DropDown

class ItineraryListController: UIViewController, IndicatorInfoProvider, onItinryAddDelegate, onItineraryOptionClickListener, onMoreClickListener {


    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "ITINERARY DETAILS")
    }
    
    @IBOutlet weak var tableView: UITableView!
    var itinryRes : Data?
    var isFromView : Bool = false
    var arrayList:[ItineraryListData] = []
    var trfData = TravelRequestData()
    lazy var refreshControl:UIRefreshControl = UIRefreshControl()

    @IBOutlet weak var btnAddItinry: UIButton!
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
        
        guard let respValue = itinryRes else {
            Helper.showMessage(message: "Something went wrong!, Please try refreshing")
            return
        }
        
        populateList(response: respValue)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @objc func getItirenaryData() {
        
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.TRF.ITINERARY_LIST, Session.authKey,
                                  trfData.trfId)
            self.view.showLoading()
            print(url)
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                self.refreshControl.endRefreshing()

                self.populateList(response : response.result.value!)
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    func populateList(response : Data) {
        
        var data: [ItineraryListData] = []
        
        let pJson = JSON(response)
        let arr = pJson.arrayObject as! [[String:AnyObject]]
        
        if arr.count > 0 {
            
            for(_,k):(String,JSON) in pJson {
                let itinryData = ItineraryListData()
     
                itinryData.ItinID = k["ItinID"].stringValue
                itinryData.itID = k["ID"].stringValue
                itinryData.bID = k["BID"].stringValue
                itinryData.reqNo = k["RequestNo"].stringValue
                itinryData.dest = k["Destination"].stringValue
                itinryData.depDate = k["DepartureDate"].stringValue
                itinryData.retDate = k["ReturnDate"].stringValue
                itinryData.estDays = k["EstimatedDays"].stringValue
                itinryData.createdDate = k["CreatedDate"].stringValue

                data.append(itinryData)
            }
            
            self.arrayList = data
            self.tableView.reloadData()
        } else {
            
            if isFromView {
                Helper.showNoItemState(vc:self , messg: "No Itinerary Item found" , tb:tableView)
            } else {
                debugPrint("No Itinerary Item found")
                self.tableView.reloadData()

            }
        }
    }
    
    func onOkClick() {
        self.getItirenaryData()
    }
    
    func deleteItinry(data : ItineraryListData) {
        
        if internetStatus != .notReachable {
            self.view.showLoading()
            
            let url = String.init(format: Constant.TRF.ITINERARY_DELETE, Session.authKey, data.ItinID)
            
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                
                self.view.hideLoading()
                if Helper.isPostResponseValid(vc: self, response: response.result) {
                    
                    let alert = UIAlertController(title: "Success", message: "Itinerary Successfully deleted", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(AlertAction) ->  Void in
                        if let index = self.arrayList.index(where: {$0 === data}) {
                            self.arrayList.remove(at: index)
                        }
                        self.tableView.reloadData()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    
    @IBAction func btnAddItineraryTapped(_ sender: Any) {
        
        let addItrnyVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewItineraryVC") as! AddNewItineraryVC
        addItrnyVC.trfData = self.trfData
        addItrnyVC.okItinryAddDelegate = self
        self.navigationController?.pushViewController(addItrnyVC, animated: true)
    }
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
        
        let section = 0
        let indexPath = IndexPath(row: sender.tag, section: section)
        let cell: ItineraryListCell = self.tableView.cellForRow(at: indexPath) as! ItineraryListCell
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            if let presentation = optionMenu.popoverPresentationController {
                presentation.sourceView = cell.btnMenu
                
            }
        }
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func onCancelClick() {
        
    }
    
    func onDeleteClick(data: ItineraryListData) {
        let alert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete Itinerary Item?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "NO GO BACK", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) -> Void in
            self.deleteItinry(data: data)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func onEditClick(data: ItineraryListData) {
        
        let itinryAddEditVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewItineraryVC") as! AddNewItineraryVC
        itinryAddEditVC.itnryListData = data
        itinryAddEditVC.okItinryAddDelegate = self
        self.navigationController?.pushViewController(itinryAddEditVC, animated: true)
    }
    
}


extension ItineraryListController : UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if arrayList.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        }else{
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        return arrayList.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = arrayList[indexPath.row]
        let views = tableView.dequeueReusableCell(withIdentifier: "cell") as! ItineraryListCell
        views.setdataToView(data : data)
        views.btnMenu.tag = indexPath.row
        views.itnryMenuDelegate = self
        views.itnryItemMenuDelegate = self
        views.selectionStyle = .none
        
        if isFromView {
            views.btnMenu.isHidden = true
        } else {
            views.btnMenu.isHidden = false
        }
        
        return views
    }
    
    
    
    
    
}




