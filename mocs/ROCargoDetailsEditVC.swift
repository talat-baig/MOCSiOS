//
//  ROCargoDetailsEditVC.swift
//  mocs
//
//  Created by Talat Baig on 7/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ROCargoDetailsEditVC: UIViewController {
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var scrlVw: UIScrollView!
    @IBOutlet weak var mySubVw: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblRecvdQtyTillDteTxt: UILabel!
    @IBOutlet weak var outerVw: UIView!
    //    var roGuid : String = ""
    var roId : String = ""
    var cargoResponse : Data?
    //    var whrId : String = ""
    //    var whrNum : String = ""
    //    var whrDate : String = ""
    
    var whrData = WHRListData()
    var arrayList: [RRcptData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Record Receipt"
        vwTopHeader.lblSubTitle.text = whrData.whrId
        
        outerVw.layer.borderWidth = 1
        outerVw.layer.borderColor = UIColor.lightGray.cgColor
        outerVw.layer.masksToBounds = true;
        
        
        tableView.separatorStyle = .none
        
        populateList()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func showEmptyState(){
        Helper.showNoItemState(vc:self , messg: "No Receipt Found\nTap Receive Release button to add new receipt" , tb:tableView)
    }
    

    
    
    
//    func getCargoDetails(refId : String) {
//
//        var data: [WHRListData] = []
//
//        if internetStatus != .notReachable {
//
//            let url = String.init(format: Constant.RO.CARGO_DETAILS, refId , Session.authKey)
//
//            self.view.showLoading()
//
//            Alamofire.request(url).responseData(completionHandler: ({ cargoResponse in
//
//                self.view.hideLoading()
//                if Helper.isResponseValid(vc: self, response: cargoResponse.result) {
//
//                    let responseJson = JSON(cargoResponse.result.value!)
//
//                    for(_,j):(String,JSON) in responseJson {
//
//                        let arr = responseJson.arrayObject as! [[String:AnyObject]]
//
//                        if arr.count > 0 {
//
//                            for(_,k):(String,JSON) in responseJson {
//                                let whrList = WHRListData()
//                                whrList.vesselName = k["ROVesselName"].stringValue
//                                whrList.uom = k["ROUom"].stringValue
//                                whrList.product = k["ROProduct"].stringValue
//                                whrList.brand = k["ROBrand"].stringValue
//                                whrList.bagSize = k["ROBagSize"].stringValue
//                                whrList.quality = k["ROQuality"].stringValue
//                                whrList.wtTerms = k["ROWeightTerms"].stringValue
//                                whrList.qtyRcvd = k["ROQuantityReceivedinmt"].stringValue
//                                whrList.whrDate = k["ROWhrDateORGrnDate"].stringValue
//                                whrList.whrId = k["RUID"].stringValue
//                                whrList.whrNum = k["ROWhrNoORGrnNo"].stringValue
//                                whrList.roID = k["ROReferenceID"].stringValue
//                                whrList.reqQty = k["RORequestedQtyinmt"].stringValue
//                                whrList.balQty = k["ROBalanceQtyinmt"].stringValue
//                                whrList.manualNo = k["WHR_Manual_No"].stringValue
//
//
//                                if k["ROReceiptQtyinmt"].stringValue == "" {
//                                    whrList.rcptQty = "0"
//                                } else {
//                                    whrList.rcptQty = k["ROReceiptQtyinmt"].stringValue
//                                }
//                                //                    whrList.rcptQty = k["ROReceiptQtyinmt"].stringValue
//
//                                //                    whrList.roGuid = k["ROGUID"].stringValue
//
//                                data.append(whrList)
//                            }
//
//                            self.whrData = data
//                            self.tableView.reloadData()
//                        } else {
//
//
//                        }
//                    }
//
//
//
//                }
//            }))
//        } else {
//            Helper.showNoInternetMessg()
//        }
//
//    }
    
    func populateList() {
        var data: [RRcptData] = []
        
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.RO.RRCPT_LIST,  Session.authKey, roId, whrData.whrNum)
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let responseJson = JSON(response.result.value!)
                    let arr = responseJson.arrayObject as! [[String:AnyObject]]
                    self.arrayList.removeAll()
                    
                    if arr.count > 0 {
                        
                        for(_,j):(String,JSON) in responseJson {
                            let rrData = RRcptData()
                            rrData.rcptDate = j["ROReceiveReceiptDate"].stringValue
                            rrData.rcvdQty = j["ROReceiveQuantityReceived"].stringValue
                            rrData.uom = j["ROReceiveUOM"].stringValue
                            rrData.desc = j["ROReceiveDescription"].stringValue
                            rrData.releaseOrderNum = j["ROReceiveReleaseOrderNo"].stringValue
                            rrData.roRefId = j["ROReferenceID"].stringValue

                            data.append(rrData)
                        }
                        
                        self.arrayList = data
                        self.tableView.tableFooterView = nil
                    } else {
                        self.lblRecvdQtyTillDteTxt.isHidden = true
                        self.showEmptyState()
                    }
                    self.tableView.reloadData()
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
        
    }
    
    
    @IBAction func addNewRRTapped(_ sender: Any) {
        
        let rrAddVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewRecordRcptVC") as! AddNewRecordRcptVC
        rrAddVC.roRefId = roId
        rrAddVC.whrData = whrData
//        rrAddVC.okSubmitDelegate = self
        self.navigationController?.pushViewController(rrAddVC, animated: true)
    }
    
}

// MARK: - WC_HeaderViewDelegate methods
extension ROCargoDetailsEditVC: WC_HeaderViewDelegate {
    
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

extension ROCargoDetailsEditVC: UITableViewDelegate, UITableViewDataSource, onRRcptMoreClickListener, onRRcptItemClickListener  {
    
//    func onOkClick() {
//        self.populateList()
////        self.getCargoDetails(refId: whrData.roID)
//    }
    
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func onCancelClick() {
        
    }
    
    func onReceiveClick() {
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arrayList.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = arrayList[indexPath.row]
        let recRcptCell = tableView.dequeueReusableCell(withIdentifier: "rrcell") as! RecordReceiptCell
        recRcptCell.rrMenuDelegate = self
        recRcptCell.rrOptionClickDelegate = self
        recRcptCell.selectionStyle = .none
        recRcptCell.btnMore.tag = indexPath.row
        recRcptCell.setDataToView(data: data)
        return recRcptCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    
}

