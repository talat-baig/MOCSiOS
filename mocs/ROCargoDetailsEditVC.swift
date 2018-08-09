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
    
//    var roGuid : String = ""
    var roId : String = ""
    var whrId : String = ""
    var whrNum : String = ""

    var arrayList: [RRcptData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Record Receipt"
        vwTopHeader.lblSubTitle.text = whrId
        
        populateList()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let lastView : UIView! = mySubVw.subviews.last
        let height = lastView.frame.size.height
        let pos = lastView.frame.origin.y
        let sizeOfContent = height + pos + 100
        
        scrlVw.contentSize.height = sizeOfContent
    }
    
    func showEmptyState(){
        Helper.showNoItemState(vc:self , messg: "No Receipt Found\nTap on + button to add new receipt" , tb:tableView)
    }
    
    func populateList() {
        var data: [RRcptData] = []
        
        if internetStatus != .notReachable {
            let url = String.init(format: Constant.RO.RRCPT_LIST,  "D7BE635C-FACA-44FF-A3F1-E1E0CC8E", roId, whrNum)
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
//                            self.roId = j["ROReferenceID"].stringValue
                            data.append(rrData)
                        }
                        
                        self.arrayList = data
                        self.tableView.tableFooterView = nil
                    } else {
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
        rrAddVC.whrNum = whrNum
        rrAddVC.okSubmitDelegate = self
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

extension ROCargoDetailsEditVC: UITableViewDelegate, UITableViewDataSource, onRRcptMoreClickListener, onRRcptItemClickListener, onRRcptSubmit  {
    
    func onOkClick() {
        self.populateList()
    }
    
    
    func onClick(optionMenu: UIViewController, sender: UIButton) {
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func onCancelClick() {
        
    }
    
    func onReceiveClick() {
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
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

