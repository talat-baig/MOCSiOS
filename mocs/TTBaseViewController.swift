//
//  TTBaseViewController.swift
//  mocs
//
//  Created by Talat Baig on 9/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import  XLPagerTabStrip

import Alamofire
import SwiftyJSON

class TTBaseViewController: ButtonBarPagerTabStripViewController , getRepMngrDelegate, getDatesDelegate, UCTT_NotifyComplete {
    
    
    
    let purpleInspireColor = UIColor(red:0.312, green:0.581, blue:0.901, alpha:1.0)
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    var empID : String = ""
    var isFromView : Bool = false
    var response:Data?
    
    var repMngr = ""
    
    var compCode = 0
    var compLoc = ""
    var compName = ""
    
    var bookDateStr = ""
    var expiryDateStr = ""
    
    var trvlItinry : [TTItinerary] = []
    var trvlVoucher : [TTVoucher] = []
    
    var notifyChilds : notifyChilds_UC?
    
    weak var trvlTcktData : TravelTicketData!
    
    var companiesResponse : Data?
    var debitAcResponse : Data?
    var trvlModeResposne : Data?
    var carrierResponse : Data?
    var currResponse : Data?
    var trvlAgentResponse : Data?
    var repMngrResponse : Data?
    var itinryResponse : Data?
    
    var voucherResponse: Data?
    
    var trvticktAddEditVC : TravelTicketAddEditVC?
    var ttInfo : TravelTicketInformationVC?
    var ttItinryListVC : TTItineraryListVC?
    
    
    override func viewDidLoad() {
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = AppColor.universalHeaderColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor.darkGray
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarMinimumInteritemSpacing = 0
        
        
        super.viewDidLoad()
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = self?.purpleInspireColor
            
            self?.buttonBarView.allowsSelection = true
        }
        
        
        vwTopHeader.delegate = self
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.lblTitle.text = "Travel Ticket"
        
        
        if isFromView {
            vwTopHeader.btnRight.isHidden = true
            vwTopHeader.lblSubTitle.text = trvlTcktData.trvlrRefNum

        } else {
            vwTopHeader.btnRight.setTitleColor(UIColor.white, for: .normal)
            vwTopHeader.btnRight.isHidden = false
            
            if trvlTcktData != nil {
                /// Edit
                vwTopHeader.lblSubTitle.isHidden = false
                vwTopHeader.lblSubTitle.text = trvlTcktData.trvlrRefNum
                vwTopHeader.btnRight.setTitle("UPDATE", for: .normal)
                
            } else {
                /// Add
                vwTopHeader.lblSubTitle.isHidden = true
                vwTopHeader.btnRight.setTitle("SUBMIT", for: .normal)
            }
        }
        
        vwTopHeader.btnRight.setImage(nil, for: .normal)
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    func saveTTAddEditReference(vc:TravelTicketAddEditVC){
        self.trvticktAddEditVC = vc
    }
    
    func saveTTInfoReference(vc:TravelTicketInformationVC){
        self.ttInfo = vc
    }
    
    func saveTTItnryReference(vc: TTItineraryListVC){
        self.ttItinryListVC = vc
    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var viewArray:[UIViewController] = []
        
        if isFromView {
            
            let ttPrimNonEdit = self.storyboard?.instantiateViewController(withIdentifier: "TravelTicketNonEditVC") as! TravelTicketNonEditVC
            ttPrimNonEdit.ttData = self.trvlTcktData
            viewArray.append(ttPrimNonEdit)
            
            let ttcktNonEdit = self.storyboard?.instantiateViewController(withIdentifier: "TravelTicketNonEditInfoVC") as! TravelTicketNonEditInfoVC
            ttcktNonEdit.ttData = self.trvlTcktData
            self.notifyChilds = ttcktNonEdit
            viewArray.append(ttcktNonEdit)
            
        } else {
            let ttAddEditVC = self.storyboard?.instantiateViewController(withIdentifier: "TravelTicketAddEditVC") as! TravelTicketAddEditVC
            ttAddEditVC.compResponse = self.companiesResponse
            ttAddEditVC.debitAcResponse = self.debitAcResponse
            ttAddEditVC.trvlModeResposne = self.trvlModeResposne
            ttAddEditVC.ttData = self.trvlTcktData
            self.notifyChilds = ttAddEditVC
            ttAddEditVC.repMngrDelegate = self
            viewArray.append(ttAddEditVC)
            
            let ttInfo = self.storyboard?.instantiateViewController(withIdentifier: "TravelTicketInformationVC") as! TravelTicketInformationVC
            ttInfo.carrierResponse = self.carrierResponse
            ttInfo.currResponse = self.currResponse
            ttInfo.trvlAgentResponse = self.trvlAgentResponse
            ttInfo.repMngrResponse = self.repMngrResponse
            ttInfo.trvTcktData = self.trvlTcktData
            ttInfo.ticktsDateDelegate = self
            self.notifyChilds = ttInfo
            viewArray.append(ttInfo)
            
        }
        let ttItinry = self.storyboard?.instantiateViewController(withIdentifier: "TTItineraryListVC") as! TTItineraryListVC
        ttItinry.isFromView = self.isFromView
        self.notifyChilds = ttItinry
        //            ttItinry.ticktsDateDelegate = self
        ttItinry.itinryResponse = self.itinryResponse
        viewArray.append(ttItinry)
        
        let ttVoucher = self.storyboard?.instantiateViewController(withIdentifier: "TTVoucherListVC") as! TTVoucherListVC
        ttVoucher.trvTcktData = self.trvlTcktData
        ttVoucher.isFromView = isFromView
        ttVoucher.vouchResponse = self.voucherResponse
        ttVoucher.moduleName = Constant.MODULES.TT
        ttVoucher.ucTTNotifyDelegte = self
        viewArray.append(ttVoucher)
        
        return viewArray
    }
    
    
    func notifyUCVouchers(messg: String, success: Bool) {
        if let d = notifyChilds {
            d.notifyChild(messg: messg, success : success)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getCompDetailsFromChild(compCode: Int, loc: String, compName: String) {
        self.compCode = compCode
        self.compLoc = loc
        self.compName = compName
    }
    
    
    func getRepMngrFromChild(repMgr: String, empId: String) {
        self.repMngr = repMgr
        self.empID = empId
    }
    
    
    func getDatesFromTicketInfo(bookDate: String, expdate: String) {
        
        self.bookDateStr = bookDate
        self.expiryDateStr = expdate
    }
    
    func submitTicketInfo( trvlTicket : [String: Any]?) {
        
        if self.internetStatus != .notReachable {
            
            self.view.showLoading()
            var url = String()
            //            var newRecord = [String : Any]()
            
            //            if reqNo == ""  {
            //                url = String.init(format: Constant.TRF.TRF_ADD, Session.authKey)
            //            } else {
            url = String.init(format: Constant.TT.TT_ADD_TRAVELTICKET, Session.authKey)
            //            }
            
            Alamofire.request(url, method: .post, parameters: trvlTicket, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                
                self.view.hideLoading()
                debugPrint(response.result.value as Any)
                
                let jsonResponse = JSON.init(parseJSON: response.result.value!)
                
                if jsonResponse["ServerMsg"].stringValue == "Success" {
                    
                    var messg = String()
                    //                        if self.reqNum != "" {
                    //                            messg = "Request has been Updated Successfully"
                    //                        } else {
                    //                            messg = "Request has been Added Successfully"
                    //                        }
                    
                    let success = UIAlertController(title: "Success", message: "", preferredStyle: .alert)
                    success.addAction(UIAlertAction(title: "OK", style: .default, handler: {(UIAlertAction) -> Void in
                        
                        //                            if let d = self.okTRFSubmit {
                        //                                d.onOkClick()
                        //                            }
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(success, animated: true, completion: nil)
                }  else {
                    
                    //                        NotificationBanner(title: "Something Went Wrong!", subtitle: "Please Try again later", style:.info).show()
                }
            })
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    func validateChildVCData() {
        
        guard let compny = self.trvticktAddEditVC?.txtCompny?.text, !compny.isEmpty else {
            self.moveToViewController(at: 0, animated: true)
            Helper.showMessage(message: "Please enter Company")
            return
        }
        
        let compCode = self.trvticktAddEditVC?.arrCompData.filter{ $0.compName == compny }.first?.compCode
        
        let compLoc = self.trvticktAddEditVC?.arrCompData.filter{ $0.compName == compny }.first?.compCity
        
        guard let swtchGuest = self.trvticktAddEditVC?.swtchGuest else {
            return
        }
        
        guard let trvlrName = self.trvticktAddEditVC?.txtFldTrvlName.text, !trvlrName.isEmpty else {
            self.moveToViewController(at: 0, animated: true)
            Helper.showMessage(message: "Please enter Traveller Name")
            return
        }
        
        let trvlrRefId = self.getTrvlerEMPId(item:trvlrName )
        
        guard let dept = self.trvticktAddEditVC?.txtDept.text else {
            return
        }
        
        guard let trvlMode = self.trvticktAddEditVC?.txtTravelMode.text, !trvlMode.isEmpty else {
            self.moveToViewController(at: 0, animated: true)
            Helper.showMessage(message: "Please enter Travel Mode")
            return
        }
        
        guard let trvlType = self.trvticktAddEditVC?.lblTrvType.text, !trvlType.isEmpty else {
            return
        }
        
        guard let trvlPurpose = self.trvticktAddEditVC?.lblPurpse.text, !trvlPurpose.isEmpty else {
            return
        }
        
        guard let trvlClass = self.trvticktAddEditVC?.txtTrvlClass.text, !trvlClass.isEmpty else {
            self.moveToViewController(at: 0, animated: true)
            Helper.showMessage(message: "Please enter Travel Class")
            return
        }
        
        
        guard let debtAc = self.trvticktAddEditVC?.txtDebitAcName.text else {
            return
        }
        
        guard let carrier = self.ttInfo?.txtCarrier.text, !carrier.isEmpty else {
            self.moveToViewController(at: 1, animated: true)
            Helper.showMessage(message: "Please enter Carrier")
            return
        }
        
        guard let ticktNum = self.ttInfo?.txtTicktNo.text, !ticktNum.isEmpty else {
            self.moveToViewController(at: 1, animated: true)
            Helper.showMessage(message: "Please enter Ticket Number")
            return
        }
        
        guard let bookDate = self.ttInfo?.txtBookingDate.text, !bookDate.isEmpty else {
            self.moveToViewController(at: 1, animated: true)
            Helper.showMessage(message: "Please enter Issue/Booking Date")
            return
        }
        
        guard let expDate = self.ttInfo?.txtExpiryDate.text, !expDate.isEmpty else {
            self.moveToViewController(at: 1, animated: true)
            Helper.showMessage(message: "Please enter Expiry Date")
            return
        }
        
        guard let tPNRNo = self.ttInfo?.txtTicktPnrNo.text else {
            return
        }
        
        guard let trvlTcktStatus = self.ttInfo?.txtTrvlStatus.text else {
            return
        }
        
        guard let amt = self.ttInfo?.txtTicktCost.text, !amt.isEmpty else {
            self.moveToViewController(at: 1, animated: true)
            Helper.showMessage(message: "Please enter Ticket Cost")
            return
        }
        
        guard let currncy = self.ttInfo?.txtCurrency.text, !currncy.isEmpty else {
            self.moveToViewController(at: 1, animated: true)
            Helper.showMessage(message: "Please enter Currency")
            return
        }
        
        
        guard let agent = self.ttInfo?.txtTrvlAgent.text, !agent.isEmpty else {
            self.moveToViewController(at: 1, animated: true)
            Helper.showMessage(message: "Please enter Travel Agent Name")
            return
        }
        
        guard let invNum = self.ttInfo?.txtInvoiceNo.text, !invNum.isEmpty else {
            self.moveToViewController(at: 1, animated: true)
            Helper.showMessage(message: "Please enter Invoice Number")
            return
        }
        
        guard let commnts = self.ttInfo?.txtComments.text else {
            return
        }
        
        guard let eprVal = self.ttInfo?.btnAdvances.titleLabel?.text else {
            return
        }
        
        guard let apprvdBy = self.ttInfo?.txtApprvdBy.text, !apprvdBy.isEmpty else {
            self.moveToViewController(at: 1, animated: true)
            Helper.showMessage(message: "Please enter Approved By")
            return
        }
        
        let apprvdByCode =  self.getRepMngrCode(item: apprvdBy)
        
        var isAdvnce = "false"
        
        guard let swtchAdvnce = self.ttInfo?.switchAdvance else {
            return
        }
        
        if swtchAdvnce.isOn {
            isAdvnce = "true"
        } else {
            isAdvnce = "false"
        }
        
        if  self.ttItinryListVC == nil || self.ttItinryListVC?.arrayList.count == 0 {
            self.moveToViewController(at: 2, animated: true)
            Helper.showMessage(message: "Please Add Itinerary")
            return
        }
        
        guard let ttItinryArray = self.ttItinryListVC?.arrayList else {
            return
        }
        
        
        if ttItinryArray.count > 0 {
            
            var newItrnyArry : [TTItinerary] = []
            
            for item in ttItinryArray {
                
                var newItem = TTItinerary()
                
                newItem.itinryId = item.ItinID
                newItem.trvlRefNum = item.trvRefNum
                newItem.depCity = item.destCity
                newItem.arrvlCity = item.arrvlCity
                newItem.depTime = item.depTime
                newItem.itinryDate = item.depDate
                newItem.flightNum = item.flightNo
                newItem.itatCode = item.itatCode
                newItem.tItinryStatus = item.trvlStatus
                newItem.itinryRefundStatus = "Current Satus"
                
                newItrnyArry.append(newItem)
            }
            
            self.trvlItinry = newItrnyArry
        }
        
        
        
        
        let trvlTicktObj = TravelTicket(refId: trvlTcktData != nil ? "": trvlrRefId , trvlrId: trvlTcktData != nil ? trvlTcktData.trvlrId : 0 , compName: compny, compCode: compCode != nil ? compCode!: 0 , compLoc: compLoc != nil ? compLoc!: "" , guest: trvlTcktData != nil ? trvlTcktData.guest :  swtchGuest.isOn ? 0 : 1, trvlrName: trvlrName, trvlrDept: dept, trvlrRefNum: trvlTcktData != nil ? trvlTcktData.trvlrRefNum :  "", trvlPurpose: trvlPurpose, trvlType: trvlType, trvlMode: trvlMode, trvlClass: trvlClass, trvlDebitAc: debtAc, trvlCarrier: carrier, trvlTicktNum: ticktNum, trvlTIssue: bookDate, trvlTExpiry: expDate, trvlPNRNum: tPNRNo , trvlCost: amt, trvlCurrncy: currncy, trvlTicktStatus: trvlTcktStatus, trvlInvoiceNum: invNum, trvlAgent: agent, trvlAdvance: isAdvnce, trvlComments: commnts, trvlEPRNum: eprVal != "Select EPR No." ? eprVal : "" , trvlApprovedBy: apprvdByCode, trvlPostingStatus: "", trvlPostedBy: "", trvlPostindDate: "", trvlVoucherNum: "" , trvlCounter: trvlTcktData != nil ? trvlTcktData.trvlrCounter : "" , trvlItinry: trvlItinry, trvVoucher: trvlVoucher)
        
        
        //        let trvTicktObj = TravelTicket(refId: <#T##String#>, trvlrId: <#T##String#>, compName: <#T##String#>, compCode: <#T##Int#>, compLoc: <#T##String#>, guest: <#T##Int#>, trvlrName: <#T##String#>, trvlrDept: <#T##String#>, trvlrRefNum: <#T##String#>, trvlPurpose: <#T##String#>, trvlType: <#T##String#>, trvlMode: <#T##String#>, trvlClass: <#T##String#>, trvlDebitAc: <#T##String#>, trvlCarrier: <#T##String#>, trvlTicktNum: <#T##String#>, trvlTIssue: <#T##String#>, trvlTExpiry: <#T##String#>, trvlPNRNum: <#T##String#>, trvlCost: <#T##String#>, trvlCurrncy: <#T##String#>, trvlTicktStatus: <#T##String#>, trvlInvoiceNum: <#T##String#>, trvlAgent: <#T##String#>, trvlAdvance: <#T##String#>, trvlComments: <#T##String#>, trvlEPRNum: <#T##String#>, trvlApprovedBy: <#T##String#>, trvlPostingStatus: <#T##String#>, trvlPostedBy: <#T##String#>, trvlPostindDate: <#T##String#>, trvlVoucherNum: <#T##String#>, trvlCounter: <#T##String#>, trvlItinry: <#T##[TTItinerary]#>, trvVoucher: <#T##[TTVoucher]#>)
        
        
        
        
        var newDict: [String: Any]?
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(trvlTicktObj)
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            guard let jsonStr = jsonString else {
                return
            }
            print("JSON String : " + jsonStr)
            
            newDict = Helper.convertToDictionary(text: jsonStr)
            //            print(newDict)
            
        }
        catch {
        }
        
        
        
        
        let alert = UIAlertController(title: "Submit Ticket Info?", message: "Are you sure you want to submit this Ticket?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) -> Void in
            self.submitTicketInfo(trvlTicket: newDict)
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        
        //        let newStr =  {"TravellerACPostingStatus":"","TravellerPurpose":"Personal","TravellerVoucherNo":"","TravellerTravelAgent":"Adisa Travel","TravellerInvoiceNo":"122323","TravellerCounter":"","RefID":"","TravellerRemarks":"Test","TravellerDepartment":"P&S - Business Management","TravellerTicketStatus":"Valid","TravellerTicketCost":"500","TravellerAPRNo":"","TravellerCarrier":"Thai Airways","TravellerType":"Domestic","trvlMode":"Air","TravellerPostingDate":"","TravellerCompanyLocation":"Russia","TravellerName":"Abhay Kumar","TravellerAdvancePaidStatus":"false","TravellerTicketPNRNo":"122323","TravellerTicketIssue":"2018-10-11","TravellerClass":"Business Class","TravelItinery":[{"Addedbysysdt":"","TravelItineraryArrivalCity":"BKK","TravelItineraryDepartureCity":"BBI","Modifiedby":"","TravelTravellerReferenceNo":"","TravelItineraryStatus":"Unused","FlightNumber":"456HTY","DepartureTime":"12:41","TravelItineraryDate":"2018-10-11","ITATcode":"","TravelItineraryID":"","TravelItineraryRefundStatus":"Current Satus","Addedby":"","Modifiedsysdt":"","Cancelledby":"","Cancelledsysdt":"","Status":""}],"TravellerCompanyCode":57,"TravellerApprovedBy":"Keshaw Kumar","TravellerID":"","TravellerPostedBy":"","TravellerTicketExpire":"2018-10-14","Guest":"Employee","TravellerReferenceNo":"","TravellerTicketNo":"12233t","TravellerDebitACName":"","TravellerTicketCurrency":"AED","TravellerCompanyName":"Agrosindikat OOO"}
        
        
        
    }
    
    
    func getTrvlerEMPId(item : String) -> String {
        let trvlrObj = self.trvticktAddEditVC?.arrTravlrData.filter{ $0.fullName == item }.first
        guard let refId = trvlrObj?.refId else {
            return ""
        }
        return refId
    }
    
    func getRepMngrCode(item : String) -> String {
        let repMngObj = self.ttInfo?.arrRepMngr.filter{ $0.repMngrName == item }.first
        guard let repMngCode = repMngObj?.repMngrId else {
            return ""
        }
        return repMngCode
    }
}


extension TTBaseViewController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.validateChildVCData()
    }
    
}
