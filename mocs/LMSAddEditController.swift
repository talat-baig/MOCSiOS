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

class LMSAddEditController: UIViewController,IndicatorInfoProvider, UIGestureRecognizerDelegate {

    var isFromView : Bool = false

    var arrLeaveTypes : [String] = []
    

    
    var lmsReqData : LMSReqData?

    weak var currentTxtFld: UITextField? = nil

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
    @IBOutlet weak var txtVwDelegation: UITextView!

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
    
    func assignDataToViews() {
        
        self.getLeaveTypes()
        
        if isFromView {
            self.txtVwDelegation.isUserInteractionEnabled = false
            self.txtVwReason.isUserInteractionEnabled = false
            self.txtFldFrom.isUserInteractionEnabled = false
            self.txtFldTo.isUserInteractionEnabled = false
            self.btnLeaveType.isUserInteractionEnabled = false
            btnSubmit.isHidden = true
        } else {
            self.txtVwDelegation.isUserInteractionEnabled = true
            self.txtVwReason.isUserInteractionEnabled = true
            self.txtFldFrom.isUserInteractionEnabled = true
            self.txtFldTo.isUserInteractionEnabled = true
            self.btnLeaveType.isUserInteractionEnabled = true
            btnSubmit.isHidden = false
        }
        
        if lmsReqData != nil {
           
            txtVwReason.text = lmsReqData?.reason
            txtVwDelegation.text = lmsReqData?.delegation
            txtFldContact.text = lmsReqData?.contact
            txtFldNoOfDays.text = lmsReqData?.noOfDays
            txtFldApprovingMngr.text = lmsReqData?.mngrName
            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let newFrom = dateFormatter.string(from: lmsReqData?.from)
//            let newTo = dateFormatter.string(from: lmsReqData?.to)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
//            guard let fromDte = lmsReqData?.from, !fromDte.isEmpty else {
//                return
//            }
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
            
//            guard let toDte = lmsReqData?.to , !toDte.isEmpty else {
//                return
//            }
            
//            let newFrom = Helper.convertToDate(dateString: fromDte)
//            let newTo = Helper.convertToDate(dateString: toDte)
//
//            let modFrom = dateFormatter.string(from: newFrom)
//            let modTo = dateFormatter.string(from: newTo)
//
//
//            txtFldTo.text = modTo
//            txtFldFrom.text = modFrom
            
            
            btnLeaveType.setTitle( lmsReqData?.leaveType , for: .normal)
            
        } else {
            
            btnLeaveType.setTitle( self.arrLeaveTypes[0] , for: .normal)
        }
        
//        self.getLeaveTypes()
    }

    func getLeaveTypes() {
        
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
                        }
                    }))
                } else {
                    Helper.showNoInternetMessg()
                }
            } else {
                self.arrLeaveTypes = parseAndAssignLeaveTypes(leavTypeString: Session.leaveTypes)
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

        self.txtVwDelegation.layer.borderColor = UIColor.lightGray.cgColor
        self.txtVwDelegation.layer.masksToBounds = true;
        self.txtVwDelegation.layer.borderWidth = 0.6
        
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
    
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
    }
    
    
    @IBAction func btnLeaveTypeTapped(_ sender: Any) {
        
        let leaveTyp = DropDown()
        leaveTyp.anchorView = btnLeaveType
        leaveTyp.dataSource = self.arrLeaveTypes
        leaveTyp.selectionAction = { [weak self] (index, item) in
            self?.btnLeaveType.setTitle( item , for: .normal)
        }
        leaveTyp.show()
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
            
            let estDays =  Helper.daysBetweenDates(startDate:fromDate , endDate: toDate)
            txtFldNoOfDays.text = String(format: "%d", estDays)
        }
       
        
        self.view.endEditing(true)
    }
    
}


extension LMSAddEditController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        datePickerTool.isHidden = true
        self.handleTap()
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
          
            
        default :
            val = true
            break
        }
        return val
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
