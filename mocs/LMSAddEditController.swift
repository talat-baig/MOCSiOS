//
//  LMSAddEditController.swift
//  mocs
//
//  Created by Talat Baig on 1/18/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NotificationCenter
import DropDown
import SwiftyJSON
import Alamofire
import NotificationBannerSwift

class LMSAddEditController: UIViewController,IndicatorInfoProvider, UIGestureRecognizerDelegate {
    
    var isFromView : Bool = false
    
    var arrLeaveTypes : [String] = []
    
    var lmsReqData : LMSReqData?
    var arrLMSAttachmnt : [VoucherData] = []
    var arrayWorkOff : [WorkOffData] = []
    
    //    var selDate : Date?
    //    var lmsAttachmnts : [TTVoucher] = []
    //    var startDate = Date()
    //    var endDate = Date()
    
    weak var currentTxtFld: UITextField? = nil
    weak var okLMSSubmit : onTCRSubmit?
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var vwLeaveType: UIView!
    @IBOutlet weak var vwLeavePeriod: UIView!
    @IBOutlet weak var vwNoOfDays: UIView!
    @IBOutlet weak var vwContact: UIView!
    @IBOutlet weak var vwManager: UIView!
    @IBOutlet weak var vwReason: UIView!
    @IBOutlet weak var vwDelegation: UIView!
    
    @IBOutlet weak var btnLeaveType: UIButton!
    
    
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var mySubVw: UIView!
    
    @IBOutlet weak var txtFldFrom: UITextField!
    @IBOutlet weak var txtFldTo: UITextField!
    
    @IBOutlet weak var txtVwReason: UITextView!
    @IBOutlet weak var txtFldDelegation: UITextField!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var txtFldNoOfDays: UITextField!
    
    @IBOutlet weak var txtFldContact: UITextField!
    
    @IBOutlet weak var txtFldApprovingMngr: UITextField!
    
    @IBOutlet var datePickerTool: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
        
        self.assignDataToViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.handleTap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let lmsBaseVC = self.parent as? LMSBaseViewController
        
        
        guard let lmsDocVC = lmsBaseVC?.attachmntVC else {
            return
        }
        
        let lmsDocArray = lmsDocVC.arrayList
        
        self.arrLMSAttachmnt = lmsDocArray
        //        self.checkForLeaveType()
    }
    
    func assignDataToViews() {
        
        if isFromView {
            self.txtFldDelegation.isUserInteractionEnabled = false
            self.txtVwReason.isUserInteractionEnabled = false
            self.txtFldFrom.isUserInteractionEnabled = false
            self.txtFldContact.isUserInteractionEnabled = false
            self.txtFldTo.isUserInteractionEnabled = false
            self.btnLeaveType.isUserInteractionEnabled = false
            btnSubmit.isHidden = true
            
        } else {
            self.txtFldDelegation.isUserInteractionEnabled = true
            self.txtVwReason.isUserInteractionEnabled = true
            self.txtFldFrom.isUserInteractionEnabled = true
            self.txtFldTo.isUserInteractionEnabled = true
            self.txtFldContact.isUserInteractionEnabled = true
            self.btnLeaveType.isUserInteractionEnabled = true
            btnSubmit.isHidden = false
            
            
            
            self.getLeaveTypes { (res) in
                
                if res {
                    if self.lmsReqData != nil {
                        self.btnLeaveType.setTitle( self.lmsReqData?.leaveType , for: .normal)
                        self.btnSubmit.setTitle("UPDATE", for: .normal)
                    } else {
                        self.btnLeaveType.setTitle( self.arrLeaveTypes[0] , for: .normal)
                        self.btnSubmit.setTitle("APPLY", for: .normal)
                    }
                } else {
                    self.btnLeaveType.setTitle( "" , for: .normal)
                }
            }
            
            self.getWorkPolicy{ (arr, res)  in
                
                if res {
                    
                    if arr.count > 0 {
                        self.arrayWorkOff = arr
                        //                        self.checkWorkOffDays()
                    }
                    
                } else {
                }
            }
            
        }
        
        
        
        
        if lmsReqData != nil {
            
            txtVwReason.text = lmsReqData?.reason
            txtFldDelegation.text = lmsReqData?.delegation
            txtFldContact.text = lmsReqData?.contact.stripped
            txtFldNoOfDays.text = lmsReqData?.noOfDays
            txtFldApprovingMngr.text = Session.reportMngr
            self.btnLeaveType.setTitle( self.lmsReqData?.leaveType , for: .normal)
            //            self.checkForLeaveType() // check leave type for UI elements enable/disable
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let fromDte = lmsReqData?.from, !fromDte.isEmpty {
                let newFrom = Helper.convertToDate(dateString: fromDte)
                let modFrom = dateFormatter.string(from: newFrom)
                txtFldFrom.text = modFrom
            } else {
                txtFldFrom.text = "-"
            }
            
            if let toDte = lmsReqData?.to , !toDte.isEmpty {
                let newTo = Helper.convertToDate(dateString: toDte)
                let modTo = dateFormatter.string(from: newTo)
                txtFldTo.text = modTo
            } else {
                txtFldTo.text = "-"
            }
            
        } else {
            txtFldApprovingMngr.text = Session.reportMngr
        }
        
        //         self.makePrefix()
    }
    
    func getLeaveTypes( comp : @escaping(Bool)-> ()) {
        
        if Session.leaveTypes == "" {
            if internetStatus != .notReachable {
                
                let url = String.init(format: Constant.API.LMS_LEAVE_TYPES, Session.authKey)
                self.view.showLoading()
                
                Alamofire.request(url).responseData(completionHandler: ({ response in
                    self.view.hideLoading()
                    if Helper.isResponseValid(vc: self, response: response.result){
                        let jsonString = JSON(response.result.value!)
                        Session.leaveTypes = jsonString.rawString()!
                        self.arrLeaveTypes = self.parseAndAssignLeaveTypes(leavTypeString : Session.leaveTypes)
                        comp(true)
                    } else {
                        comp(false)
                    }
                }))
            } else {
                Helper.showNoInternetMessg()
                comp(false)
            }
        } else {
            
            self.arrLeaveTypes = parseAndAssignLeaveTypes(leavTypeString: Session.leaveTypes)
            comp(true)
        }
        
    }
    
    func parseAndAssignLeaveTypes(leavTypeString : String)  -> [String] {
        
        //            var leavTyp = [String]()
        var lmsLeavTyp = [LeaveType]()
        
        let jsonObj = JSON.init(parseJSON:leavTypeString)
        
        for(_,j):(String,JSON) in jsonObj{
            
            let newLeaveTyp = LeaveType()
            
            if j["LeaveTypeName"].stringValue == "" {
                newLeaveTyp.leaveTypeName = "-"
            } else {
                newLeaveTyp.leaveTypeName = j["LeaveTypeName"].stringValue
            }
            
            if j["LeaveTypeShortName"].stringValue == "" {
                newLeaveTyp.leaveTypeShortName = "-"
            } else {
                newLeaveTyp.leaveTypeShortName = j["LeaveTypeShortName"].stringValue
            }
            newLeaveTyp.leaveId = j["LeaveTypeID"].stringValue
            newLeaveTyp.leaveTypeRef = j["LeaveTypeReferenceID"].stringValue
            
            lmsLeavTyp.append(newLeaveTyp)
        }
        
        let filteredLeaveType = lmsLeavTyp.map { $0.leaveTypeShortName }
        return filteredLeaveType
    }
    
    
    func initialSetup(){
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.isHidden = true
        
        Helper.addBordersToView(view: vwNoOfDays)
        Helper.addBordersToView(view: vwLeaveType)
        Helper.addBordersToView(view: vwLeavePeriod)
        
        Helper.addBordersToView(view: vwManager)
        Helper.addBordersToView(view: vwContact)
        Helper.addBordersToView(view: vwReason)
        Helper.addBordersToView(view: vwDelegation)
        
        Helper.addBordersToView(view: txtVwReason)
        
        self.txtVwReason.layer.borderColor = UIColor.lightGray.cgColor
        self.txtVwReason.layer.masksToBounds = true;
        self.txtVwReason.layer.borderWidth = 0.6
        
        self.txtFldFrom.inputView = datePickerTool
        self.txtFldTo.inputView = datePickerTool
        
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        btnLeaveType.contentHorizontalAlignment = .left
        
        txtFldContact.setLeftIcon(icon:#imageLiteral(resourceName: "plus"))
        btnSubmit.layer.cornerRadius = 5.0
    }
    
    
    @objc func datePickerValueChanged() {
        
        //        selDate = self.datePicker.date
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            var keyboardHeight : CGFloat
            keyboardHeight = keyboardRectangle.height
            var contentInset:UIEdgeInsets = self.scrlVw.contentInset
            contentInset.bottom = keyboardHeight
            
            self.scrlVw.isScrollEnabled = true
            self.scrlVw.contentInset = contentInset
        }
    }
    
    
    /// Invoked before hiding keyboard and used to move view down
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrlVw.isScrollEnabled = true
        let contentInset:UIEdgeInsets = .zero
        self.scrlVw.contentInset = contentInset
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrlVw.contentSize = CGSize(width: mySubVw.frame.size.width, height: 680.0)
        print(scrlVw.contentSize)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    func getAttachmentsData(voucherArray : [VoucherData]) -> [TTVoucher] {
        
        var newVouchrArry : [TTVoucher] = []
        
        if voucherArray.count > 0 {
            
            for item in self.arrLMSAttachmnt {
                
                var newItem = TTVoucher()
                
                newItem.docRefNum = item.documentID
                let docName = item.documentName
                newItem.docName = Helper.encodeURL(url: docName)
                newItem.docDesc = item.documentDesc
                newItem.docPath = item.documentPath
                newItem.docType = item.documentType
                newItem.docCategry = item.documentCategory
                
                newVouchrArry.append(newItem)
            }
        }
        return newVouchrArry
    }
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        self.handleTap()
        
        let arrAttachments = self.getAttachmentsData(voucherArray: self.arrLMSAttachmnt)
        
        guard let leaveType = self.btnLeaveType.titleLabel?.text , !leaveType.isEmpty else {
            Helper.showMessage(message: "Please enter leave type")
            return
        }
        
        guard let fromDate = self.txtFldFrom?.text, !fromDate.isEmpty else {
            Helper.showMessage(message: "Please select from date")
            return
        }
        
        guard let toDate = self.txtFldTo?.text , !toDate.isEmpty else {
            Helper.showMessage(message: "Please select to Date")
            return
        }
        
        guard let contact = self.txtFldContact?.text , !contact.isEmpty else {
            Helper.showMessage(message: "Please provide proper phone number with country code")
            return
        }
        
        if contact.count < 12 {
            Helper.showMessage(message: "Please provide proper phone number with country code")
            return
        }
        
        let newContact = contact.stripped
        
        guard let reason = self.txtVwReason?.text , !reason.isEmpty else {
            Helper.showMessage(message: "Please enter reason for leave")
            return
        }
        
        let delegation = txtFldDelegation.text
        let noOfDays = txtFldNoOfDays.text
        
        
        let leaveReqObj = AddLeaveData(leavId:  lmsReqData != nil ? lmsReqData?.srNo ?? "" : ""  , shortName: leaveType, fromDate : fromDate , toDate : toDate , noOfDays : noOfDays ?? "" , leaveContact : newContact , remarks : reason ,  supportDoc : arrAttachments , delegation :  delegation ?? "")
        
        var newDict: [String: Any]?
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(leaveReqObj)
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            guard let jsonStr = jsonString else {
                return
            }
            
            print("JSON String : " + jsonStr)
            newDict = Helper.convertToDictionary(text: jsonStr)
        }
        catch {
        }
        
        var messg = ""
        var titleMsg = ""
        
        if lmsReqData != nil {
            titleMsg = "Update?"
            messg = "Are you sure you want to update the leave?"
        } else {
            messg = "Are you sure you want to apply for the leave?"
            titleMsg = "Apply?"
        }
        
        let alert = UIAlertController(title: titleMsg , message: messg , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "GO BACK", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (UIAlertAction) -> Void in
            self.submitLeaveReq(leaveReq: newDict)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func submitLeaveReq( leaveReq : [String: Any]?) {
        
        self.handleTap()
        
        if self.internetStatus != .notReachable {
            
            self.view.showLoading()
            
            let url = String.init(format: Constant.API.LMS_ADD_UPDATE, Session.authKey)
            
            Alamofire.request(url, method: .post, parameters: leaveReq, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                
                self.view.hideLoading()
                debugPrint(response.result.value as Any)
                
                let jsonResponse = JSON.init(parseJSON: response.result.value!)
                
                if jsonResponse["ServerMsg"].stringValue == "Success" {
                    var messg = String()
                    
                    if self.lmsReqData != nil {
                        messg = "Leave Request has been Updated Successfully"
                    } else {
                        messg = "Leave Request has been Submitted Successfully"
                    }
                    
                    let success = UIAlertController(title: "Success", message: messg, preferredStyle: .alert)
                    success.addAction(UIAlertAction(title: "OK", style: .default, handler: {(UIAlertAction) -> Void in
                        
                        if let d = self.okLMSSubmit {
                            d.onOkClick()
                        }
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(success, animated: true, completion: nil)
                }  else {
                    let servrMsg = jsonResponse["ServerMsg"].stringValue
                    
                    if servrMsg == "" {
                        //                        NotificationBanner(title: "Something went wrong", style: .danger).show()
                        NotificationBanner(title: "Oops!",subtitle:"Unexpected error occurred, Please try again later", style: .danger).show()
                        
                    } else {
                        NotificationBanner(title: servrMsg ,style: .danger).show()
                    }
                }
            })
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    
    @IBAction func btnLeaveTypeTapped(_ sender: Any) {
        
        self.handleTap()
        
        let leaveTyp = DropDown()
        leaveTyp.anchorView = btnLeaveType
        leaveTyp.dataSource = self.arrLeaveTypes
        leaveTyp.selectionAction = { [weak self] (index, item) in
            self?.btnLeaveType.setTitle( item , for: .normal)
            self?.checkForLeaveType(leaveType : item)
        }
        leaveTyp.show()
    }
    
    
    func checkForLeaveType(leaveType : String = "") {
        
        if leaveType == "HAPL" {
            txtFldTo.isEnabled = false
            txtFldTo.text = ""
            txtFldFrom.text = ""
            txtFldNoOfDays.text = ""
        } else {
            txtFldTo.isEnabled = true
            
            if lmsReqData != nil {
                txtFldNoOfDays.text = lmsReqData?.noOfDays
            } else {
                //txtFldNoOfDays.text = ""
            }
        }
    }
    
    func getWorkPolicy( comp : @escaping([WorkOffData],Bool)-> ()) {
        
        if internetStatus != .notReachable {
            
            var newData:[WorkOffData] = []
            
            self.view.showLoading()
            let url:String = String.init(format: Constant.API.LMS_LEAVE_POLICY, Session.authKey)
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result) {
                    
                    let jsonResponse = JSON(response.result.value!)
                    let jsonArr = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    if jsonArr.count > 0 {
                        
                        for i in 0..<jsonArr.count {
                            
                            let wrkOff = WorkOffData()
                            wrkOff.woDays  = jsonResponse[i]["WorkOff Day"].stringValue
                            wrkOff.woPolicy  = jsonResponse[i]["WorkOff Policy"].stringValue
                            wrkOff.woDates  = jsonResponse[i]["PHDates"].stringValue
                            newData.append(wrkOff)
                        }
                        
                        comp(newData,true)
                    } else {
                        comp([],false)
                    }
                } else {
                    comp([],false)
                }
            }))
        } else {
            Helper.showNoInternetMessg()
            comp([],false)
        }
        print("work Off Count : %d",self.arrayWorkOff.count)
    }
    
    
    func checkWorkOffDays(startDate : Date , endDate : Date) -> Int {
        
        var workingDays : Int = 0
        
        let workOff = self.arrayWorkOff[0].woDays // {sat,sun}
        let arrWO = workOff.components(separatedBy: ",")
        
        let publicOff = self.arrayWorkOff[0].woDates // {2019-01-04,2019-03-02}
        let arrPO = publicOff.components(separatedBy: ",")
        
        let workPolicy = self.arrayWorkOff[0].woPolicy // {WO,PH}
        let arrPolicy = workPolicy.components(separatedBy: ",")
        
        workingDays =  Helper.getWorkingDays(startDate: startDate, endDate: endDate, publicHolidays: arrPO , workOff:arrWO , workOffPolicy:arrPolicy)
        return workingDays
    }
    
    
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        
        datePickerTool.isHidden = true
        self.view.endEditing(true)
    }
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if currentTxtFld == txtFldFrom {
            
            if txtFldTo.text != "" {
                
                let toDate = dateFormatter.date(from: txtFldTo.text!)!
                let fromDte = datePicker.date
                txtFldFrom.text =  dateFormatter.string(from: fromDte) as String
                
                if fromDte > toDate {
                    
                    txtFldTo.text = ""
                    txtFldNoOfDays.text = ""
                } else {
                    
                    let fromDate = dateFormatter.date(from: txtFldFrom.text!)!
                    let toDate = dateFormatter.date(from: txtFldTo.text!)!
                    
                    let working = self.checkWorkOffDays(startDate: fromDate, endDate: toDate)
                    txtFldNoOfDays.text = String(format: "%d", working)
                }
            } else {
                
                txtFldFrom.text = dateFormatter.string(from: datePicker.date) as String
                
                if txtFldTo.isEnabled == false {
                    txtFldTo.text = txtFldFrom.text
                    txtFldNoOfDays.text = "0.5"
                } else  {
                }
            }
        }
        
        if currentTxtFld == txtFldTo {
            txtFldTo.text = dateFormatter.string(from: datePicker.date) as String
            
            let fromDate = dateFormatter.date(from: txtFldFrom.text!)!
            let toDate = dateFormatter.date(from: txtFldTo.text!)!
            
            let working = self.checkWorkOffDays(startDate: fromDate, endDate: toDate)
            txtFldNoOfDays.text = String(format: "%d", working)
        }
        self.view.endEditing(true)
    }
    
}


extension LMSAddEditController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        datePickerTool.isHidden = true
        self.handleTap()
        
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let protectedRange = NSMakeRange(0, 0)
        let intersection = NSIntersectionRange(protectedRange, range)
        
        if textField == txtFldContact {
            
            if intersection.length > 0 {
                return false
            }
            if range.location == 11 {
                return true
            }
            
            if range.location + range.length > 11 {
                return false
            }
            
        }
        return true
        
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        var val = true
        currentTxtFld = textField
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale =  Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone =  TimeZone(abbreviation: "GMT+0:00")
        
        switch textField {
            
        case txtFldFrom :
            datePickerTool.isHidden = false
            
            datePicker.minimumDate = Date.distantPast
            datePicker.maximumDate =  Date.distantFuture
            
            if txtFldFrom.text == "" {
                datePicker.date = Date()
            } else {
                let currDate: Date = dateFormatter.date(from: txtFldFrom.text!)!
                datePicker.date = currDate
            }
            
        case txtFldTo :
            
            let fromDte = txtFldFrom.text
            
            if fromDte != "" {
                txtFldTo.reloadInputViews()
                datePickerTool.isHidden = false
                
                let newfromDte = dateFormatter.date(from: fromDte!)
                datePicker.minimumDate = newfromDte
                datePicker.maximumDate = Date.distantFuture
                
                if txtFldTo.text == "" {
                    datePicker.date = newfromDte!
                } else {
                    let currDate: Date = dateFormatter.date(from: txtFldTo.text!)!
                    datePicker.date = currDate
                }
                
            } else {
                
                self.view.makeToast("Please Select From Date First")
                datePickerTool.isHidden = true
                val = false
            }
            
        case txtFldDelegation :
            
            let scrollPoint:CGPoint = CGPoint(x:0, y:  vwReason.frame.origin.y  )
            scrlVw!.setContentOffset(scrollPoint, animated: true)
            
        default :
            val = true
            break
        }
        return val
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView ==  txtVwReason {
            let scrollPoint:CGPoint = CGPoint(x:0, y:  vwManager.frame.origin.y)
            scrlVw!.setContentOffset(scrollPoint, animated: true)
        }
    }
    
}



extension LMSAddEditController: WC_HeaderViewDelegate {
    
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

