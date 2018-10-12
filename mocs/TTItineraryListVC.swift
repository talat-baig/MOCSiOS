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
import Alamofire
import SwiftyJSON

class TTItineraryListVC: UIViewController, IndicatorInfoProvider, UIGestureRecognizerDelegate , onTTItinryAddDelegate, onTTItineraryOptionClickListener, notifyChilds_UC, onMoreClickListener {
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "ITINERARY DETAILS")
    }
    
    
    weak var ttData : TravelTicketData?
    var arrayList : [TTItineraryListData] = []
    var bookDate = String()
    var expryDate = String()
    
    var itinryResponse : Data?
    var isFromView : Bool = false
//    lazy var refreshControl:UIRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var btnAddItinry: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TTItineraryListCell", bundle: nil), forCellReuseIdentifier: "cell")
//        refreshControl = Helper.attachRefreshControl(vc: self, action: #selector(getItirenaryData))
        
        if isFromView {
            btnAddItinry.isHidden = true
            
        } else {
            btnAddItinry.isHidden = false
//            tableView.addSubview(refreshControl)
        }
        
        guard let respValue = itinryResponse else {
            Helper.showMessage(message: "No Itinerary Data Found.")
            return
        }
        
        populateList(response: respValue)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let ttBaseVC = self.parent as? TTBaseViewController
        ttBaseVC?.saveTTItnryReference(vc: self)
        
        guard let baseBookDte = ttBaseVC?.bookDateStr else {
            return
        }
        guard let baseExpryDte = ttBaseVC?.expiryDateStr else {
            return
        }
        
        self.bookDate = baseBookDte
        self.expryDate = baseExpryDte
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func notifyChild(messg: String, success: Bool) {
        
    }
    
    @IBAction func btnAddItineraryTapped(_ sender: Any) {
        
        let addItrnyVC = self.storyboard?.instantiateViewController(withIdentifier: "TTAddNewItineraryVC") as! TTAddNewItineraryVC
        addItrnyVC.retDate = expryDate
        addItrnyVC.depDate = bookDate
        addItrnyVC.okTTItnryAddDel = self
        self.navigationController?.pushViewController(addItrnyVC, animated: true)
    }
    
    @objc func getItirenaryData() {
        
        if internetStatus != .notReachable {
            
            var url = String()
            
            
            
            if ttData?.trvlrRefNum != nil {
                url = String.init(format: Constant.TT.TT_GET_ITINRY_LIST, Session.authKey,
                                  (ttData?.trvlrRefNum)!)
            } else {
                url = String.init(format: Constant.TT.TT_GET_ITINRY_LIST, Session.authKey,
                                  "")
            }
            
            self.view.showLoading()
            print(url)
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
//                self.refreshControl.endRefreshing()
                
                self.populateList(response : response.result.value!)
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    func onOkClick(itnryObj: TTItineraryListData) {
        
        self.arrayList.append(itnryObj)
        self.tableView.reloadData()
    }
    
    
    func deleteItnry(data : TTItineraryListData) {
        
        if internetStatus != .notReachable {
            self.view.showLoading()
            
            let url = String.init(format: Constant.TT.TT_DELETE_ITINRY, Session.authKey, data.ItinID)
            
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
    
    
    
    func populateList(response : Data) {
        
        var data: [TTItineraryListData] = []
        
        let pJson = JSON(response)
        let arr = pJson.arrayObject as! [[String:AnyObject]]
        
        if arr.count > 0 {
            
            for(_,k):(String,JSON) in pJson {
                let itinryData = TTItineraryListData()
                
                itinryData.ItinID = k["TravelItineraryID"].intValue
                itinryData.arrvlCity = k["TravelItineraryArrivalCity"].stringValue
                itinryData.depTime = k["DepartureTime"].stringValue
                itinryData.depDate = k["TravelItineraryDate"].stringValue
                itinryData.destCity = k["TravelItineraryDepartureCity"].stringValue
                itinryData.flightNo = k["DepartureDate"].stringValue
                itinryData.itatCode = k["ITATcode"].stringValue
                itinryData.trvlStatus = k["TravelItineraryStatus"].stringValue
                itinryData.trvRefNum = k["TravelTravellerReferenceNo"].stringValue
                
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
    
    
    func onCancelClick() {
        
    }
    
    func onDeleteClick(data: TTItineraryListData) {
        
        let alert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete Itinerary Item?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "NO GO BACK", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) -> Void in
            if data.ItinID != 0 {
                self.deleteItnry(data: data)
            } else {
                
                if let index = self.arrayList.index(where: {$0 == data}) {
                    self.arrayList.remove(at: index)
                }
                self.tableView.reloadData()
                
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func onEditClick(data: TTItineraryListData) {
        
        let addItrnyVC = self.storyboard?.instantiateViewController(withIdentifier: "TTAddNewItineraryVC") as! TTAddNewItineraryVC
        addItrnyVC.retDate = expryDate
        addItrnyVC.depDate = bookDate
        addItrnyVC.ttItnry = data
        addItrnyVC.okTTItnryAddDel = self
        self.navigationController?.pushViewController(addItrnyVC, animated: true)
        
    }
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
        
        let section = 0
        let indexPath = IndexPath(row: sender.tag, section: section)
        let cell: TTItineraryListCell = self.tableView.cellForRow(at: indexPath) as! TTItineraryListCell
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            if let presentation = optionMenu.popoverPresentationController {
                presentation.sourceView = cell.btnMenu
                
            }
        }
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
}



extension TTItineraryListVC : UITableViewDelegate, UITableViewDataSource {
    
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
        return 215
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = arrayList[indexPath.row]
        let views = tableView.dequeueReusableCell(withIdentifier: "cell") as! TTItineraryListCell
        views.setdataToView(data : data)
        views.btnMenu.tag = indexPath.row
        views.itnryMenuDelegate = self
        views.itnryItemMenuDelegate = self
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
