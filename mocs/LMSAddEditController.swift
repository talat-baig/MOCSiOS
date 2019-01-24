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
    //    var lmsAttachmnts : [TTVoucher] = []
    
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
            
            self.makePrefix()
            
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
        }
        
        
        
        
        if lmsReqData != nil {
            
            txtVwReason.text = lmsReqData?.reason
            txtFldDelegation.text = lmsReqData?.delegation
            txtFldContact.text = lmsReqData?.contact
            txtFldNoOfDays.text = lmsReqData?.noOfDays
            txtFldApprovingMngr.text = lmsReqData?.mngrName
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
        
        btnLeaveType.contentHorizontalAlignment = .left
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
        scrlVw.contentSize = CGSize(width: mySubVw.frame.size.width, height: 700)
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
                newItem.docName = item.documentName
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
        
        let arrAttachments = self.getAttachmentsData(voucherArray: self.arrLMSAttachmnt)
        
        guard let leaveType = self.btnLeaveType.titleLabel?.text , !leaveType.isEmpty else {
            Helper.showMessage(message: "Please enter Leave Type")
            return
        }
        
        guard let fromDate = self.txtFldFrom?.text, !fromDate.isEmpty else {
            Helper.showMessage(message: "Please enter From Date")
            return
        }
        
        guard let toDate = self.txtFldTo?.text , !toDate.isEmpty else {
            Helper.showMessage(message: "Please enter To Date")
            return
        }
        
        guard let contact = self.txtFldContact?.text , !contact.isEmpty else {
            Helper.showMessage(message: "Please enter Contact Number")
            return
        }
        
        let newContact = contact.stripped
        
        guard let reason = self.txtVwReason?.text , !reason.isEmpty else {
            Helper.showMessage(message: "Please enter Reason for leave")
            return
        }
        
        let delegation = txtFldDelegation.text
        let noOfDays = txtFldNoOfDays.text
        
        
        let leaveReqObj = AddLeaveData(leavId:  lmsReqData != nil ? lmsReqData?.srNo ?? "" : ""  , shortName: leaveType, fromDate : fromDate , toDate : toDate , noOfDays : noOfDays ?? "" , leaveContact : newContact , remarks : Helper.encodeURL(url: reason) ,  supportDoc : arrAttachments , delegation : Helper.encodeURL(url: delegation ?? ""))
        
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
            titleMsg = "Update Leave Request?"
            messg = "Are you sure you want to Update this Request?"
        } else {
            messg = "Are you sure you want to Submit this Request?"
            titleMsg = "Apply For Leave?"
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
            var url = String()
            
            url = String.init(format: Constant.API.LMS_ADD_UPDATE, Session.authKey)
            
            Alamofire.request(url, method: .post, parameters: leaveReq, encoding: JSONEncoding.default).responseString(completionHandler: {  response in
                
                self.view.hideLoading()
                debugPrint(response.result.value as Any)
                
                let jsonResponse = JSON.init(parseJSON: response.result.value!)
                
                if jsonResponse["ServerMsg"].stringValue == "Success" {
                    
                    var messg = String()
                    
                    if self.lmsReqData != nil {
                        messg = "Leave Request has been Updated Successfully"
                    } else {
                        messg = "Leave Request  has been Submitted Successfully"
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
                    NotificationBanner(title: "Something Went Wrong!", subtitle: "Please Try again later", style:.info).show()
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
            txtFldTo.text = "-"
            txtFldNoOfDays.text = "0.5"
        } else {
            txtFldTo.isEnabled = true
            
            if lmsReqData != nil {
                txtFldNoOfDays.text = lmsReqData?.noOfDays
            } else {
                txtFldNoOfDays.text = ""
            }
        }
        
    }
    
    func makePrefix() {
        let attributedString = NSMutableAttributedString(string: "+")
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSMakeRange(0,1))
        txtFldContact.attributedText = attributedString
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
                
                if fromDte > toDate {
                    Helper.showMessage(message: "From date can't be greater than To date")
                } else {
                    txtFldFrom.text =  dateFormatter.string(from: fromDte) as String
                }
            } else {
                txtFldFrom.text = dateFormatter.string(from: datePicker.date) as String
            }
        }
        
        if currentTxtFld == txtFldTo {
            txtFldTo.text = dateFormatter.string(from: datePicker.date) as String
            let fromDate = dateFormatter.date(from: txtFldFrom.text!)!
            
            let toDate = dateFormatter.date(from: txtFldTo.text!)!
            
            let estDays =  Helper.daysBetweenDays2(startDate:fromDate , endDate: toDate)
            txtFldNoOfDays.text = String(format: "%d", estDays)
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
        
        let protectedRange = NSMakeRange(0, 1)
        let intersection = NSIntersectionRange(protectedRange, range)
        
        if textField == txtFldContact {
            
            if intersection.length > 0 {
                return false
            }
            if range.location == 12 {
                return true
            }
            
            if range.location + range.length > 12 {
                return false
            }
            
        }
        return true
        
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        var val = true
        currentTxtFld = textField
        
        switch textField {
            
        case txtFldFrom :
            datePickerTool.isHidden = false
            datePicker.maximumDate = Date.distantFuture
            datePicker.minimumDate = Date.distantPast
            
        case txtFldTo :
            
            let fromDte = txtFldFrom.text
            
            if fromDte != "" {
                txtFldTo.reloadInputViews()
                datePickerTool.isHidden = false
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let newfromDte = dateFormatter.date(from: fromDte!)
                datePicker.minimumDate = newfromDte
                datePicker.maximumDate = Date.distantFuture
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