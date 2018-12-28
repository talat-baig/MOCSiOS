//
//  RODetailsViewController.swift
//  mocs
//
//  Created by Talat Baig on 11/19/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NotificationBannerSwift

class RODetailsViewController: UIViewController {
    
    var roNum = ""
    var prodStr = ""
    var vesselStr = ""
    
    var isFromVessel = false
    var isFromProduct = false
    var isFromWarehouse = false
    
    var arrayList : [ROWHRData] = []
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "RODetailsCell", bundle: nil), forCellReuseIdentifier: "rocell")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        
        if isFromVessel {
            vwTopHeader.lblTitle.text = "Report [Vessel-wise]"
        } else if isFromProduct {
            vwTopHeader.lblTitle.text = "Report [Product-wise]"
        } else {
            vwTopHeader.lblTitle.text = "Report [Warehouse-wise]"
        }
        
        vwTopHeader.lblSubTitle.text = roNum
        
        populateList()
    }
    
    func showEmptyState(){
        Helper.showNoItemState(vc:self , messg: "No Data Found" , tb:tableView)
    }
    
    func populateList() {
        
        var data: [ROWHRData] = []
        
        if internetStatus != .notReachable {
            
            self.view.showLoading()
            let url:String = String.init(format: Constant.AvlRel.AVL_WHR_FOR_RO, Session.authKey, Helper.encodeURL(url : prodStr ),Helper.encodeURL(url:vesselStr),Helper.encodeURL(url: roNum))
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let jsonResponse = JSON(response.result.value!)
                    let jsonArr = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    self.arrayList.removeAll()
                    
                    if jsonArr.count > 0 {
                        
                        for(_, j):(String,JSON) in jsonResponse {
                            
                            let roWHRData = ROWHRData()
                            
                            roWHRData.vessel = j["Vessel Name"].stringValue
                            roWHRData.wareHouse = j["Warehouse Name"].stringValue
                            roWHRData.brand = j["Brand Name"].stringValue
                            roWHRData.whrNum = j["WHR No"].stringValue
                            roWHRData.roId = j["Ro Reference ID"].stringValue
                            
                            roWHRData.bagSize = j["Bag Size"].stringValue
                            roWHRData.product = j["Product Name"].stringValue
                            roWHRData.quality = j["Quality"].stringValue
                            roWHRData.whrManual = j["WHR Manual No"].stringValue
                            roWHRData.relForSale = j["Release Available for Sale (mt)"].stringValue
                            roWHRData.relPending = j["Release Pending for Approval (mt)"].stringValue
                            roWHRData.rcvdQty = j["Received Qty"].stringValue
                            roWHRData.reqQty = j["Requested Qty"].stringValue
                            
                            data.append(roWHRData)
                        }
                        self.arrayList = data
                        self.tableView.tableFooterView = nil
                    } else {
                        self.showEmptyState()
                    }
                    self.tableView.reloadData()
                }
            }))
        }  else {
            Helper.showNoInternetMessg()
        }
    }
    
    
    @objc func sendEmailTapped(sender:UIButton) {
        let buttonRow = sender.tag
        let whrNum =  arrayList[buttonRow].whrNum
        let roId =  arrayList[buttonRow].roId
        let manualNo =  arrayList[buttonRow].whrManual
        
        self.openCustomSendEmailView(whrNum: whrNum, roId : roId, manualNo : manualNo)
    }
    
    func openCustomSendEmailView(whrNum : String, roId : String, manualNo : String) {
        
        let myView = Bundle.main.loadNibNamed("SendEmailView", owner: nil, options: nil)![0] as! SendEmailView
        myView.frame = CGRect.init(x: 0, y:0, width: self.view.frame.size.width, height: (self.view.frame.size.height) + (self.navigationController?.navigationBar.frame.size.height)!)
        myView.passWHRdetails(whrNum: whrNum, roId: roId, manualNo: manualNo)
        myView.delegate = self
        myView.isFromAvlRel = true
        self.view.addSubview(myView)
    }
    
    func sendWHREmail(whrNo : String, roId : String, manualNo : String, emailIds : String) {
        
        if internetStatus != .notReachable{
            let url = String.init(format: Constant.AvlRel.SEND_EMAIL, Session.authKey, emailIds, Helper.encodeURL(url: roId),Helper.encodeURL(url: whrNo),Helper.encodeURL(url: manualNo))
            print(url)
            self.view.showLoading()
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                self.view.hideLoading()
                
                guard let resp = response.result.value else {
                    NotificationBanner(title: "Something Went Wrong!", subtitle: "Please Try again later", style:.info).show()
                    return
                }
                let jsonResponse = JSON.init(parseJSON:resp)
                let jsonArray = jsonResponse.arrayObject as! [[String:String]]
             
                let newObj = jsonArray.first ?? [:]
                if newObj["ServerMsg"] == "Success" {
                    let alert = UIAlertController(title: "Success", message: "Mail has been sent Successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Oops", message: "Unable to send mail. Please try again later", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        } else {
            Helper.showNoInternetMessg()
        }
    }
}



extension RODetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 345
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rocell") as! RODetailsCell
        cell.layer.masksToBounds = true
        cell.btnSendMail.tag = indexPath.row
        cell.btnSendMail.addTarget(self, action: #selector(self.sendEmailTapped(sender:)) , for: UIControlEvents.touchUpInside)
        cell.setDataTOView(data: self.arrayList[indexPath.row])
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 5
        return cell
    }
}

// MARK: - UITableViewDelegate methods
extension RODetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension RODetailsViewController: sendEmailFromViewDelegate {
    
    func onSendTap(whrNo: String, roId: String, manual: String, emailIds: String) {
        self.sendWHREmail(whrNo: whrNo, roId: roId, manualNo: manual, emailIds : emailIds)
    }
    
    func onSendEmailTap(invoice: String, emailIds: String) {
        
    }
    
    func onCancelTap() {
        
    }
    
}

extension RODetailsViewController: WC_HeaderViewDelegate {
    
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

