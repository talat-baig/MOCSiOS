//
//  EmpClaimExpenseAddEditVC.swift
//  mocs
//
//  Created by Talat Baig on 6/13/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import DropDown
import SwiftyJSON
import Alamofire
import NotificationBannerSwift
import DropDown


protocol onECRPaymentAddDelegate: NSObjectProtocol {
    func onOkClick() -> Void
}

class EmpClaimExpenseAddEditVC: UIViewController ,UIGestureRecognizerDelegate{
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var vwPymntReason: UIView!
    
    @IBOutlet weak var vwVendor: UIView!
    
    @IBOutlet weak var vwExpenseDetails: UIView!
    
    @IBOutlet weak var txtInvoiceNum: UITextField!
    
    @IBOutlet weak var btnAccChrgHd: UIButton!
    
    @IBOutlet weak var vwComments: UIView!
    
    @IBOutlet weak var txtComments: UITextView!
    
    @IBOutlet weak var txtAmtPaid: UITextField!
    
    @IBOutlet weak var txtVendor: UITextField!
    
    @IBOutlet weak var txtExpDate: UITextField!
    
    @IBOutlet weak var stckVwCurrency: UIStackView!
    
    @IBOutlet weak var btnReason: UIButton!
    
    @IBOutlet weak var vwInvNo: UIView!
    
    @IBOutlet weak var vwAccChargeHd: UIView!
    
    @IBOutlet var datePickerTool: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var okPymntDelegate : onECRPaymentAddDelegate?
    
    var arrAccChrg = [String]()
    
    var arrReason = [String]()
    
    weak var ecrExpListData : ECRExpenseListData!
    
    weak var ecrData : EmployeeClaimData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initialSetup()
        
        if ecrExpListData != nil {
            // Edit
            assignDataToViews()
        } else {
            // Add
            if arrAccChrg.count > 0 {
                
                btnAccChrgHd.setTitle(arrAccChrg[0], for:.normal)
                self.getPaymentReason(accntChrg: arrAccChrg[0]) { (res) in
                    
                    self.btnReason.setTitle(self.arrReason.first, for: .normal)
                }
            } else {
                btnAccChrgHd.setTitle("", for:.normal)
                btnReason.setTitle("", for:.normal)
            }
        }
        
        checkDatePickerDates()
        
    }
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    
    func checkDatePickerDates() {
        
        if ecrData.claimTypeInInt == 0 {
            let currentDate = Date()
            datePicker.date = currentDate
            datePicker.maximumDate = currentDate
            datePicker.minimumDate = currentDate

            
        } else {
            
            let currentDate = Date()
            datePicker.date = currentDate
            datePicker.maximumDate = currentDate
            datePicker.minimumDate = Date.distantPast

        }
    }
    
    
    func initialSetup() {
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Add New Payment"
        vwTopHeader.lblSubTitle.isHidden = true
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        txtExpDate.inputView = datePickerTool
        
        Helper.addBordersToView(view: vwPymntReason)
        Helper.addBordersToView(view: vwVendor)
        Helper.addBordersToView(view: vwInvNo)
        Helper.addBordersToView(view: vwAccChargeHd)
        Helper.addBordersToView(view: vwExpenseDetails)
        Helper.addBordersToView(view: vwComments)
        
        btnReason.contentHorizontalAlignment = .left
        btnAccChrgHd.contentHorizontalAlignment = .left
        
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    func assignDataToViews() {
        
        let newReqDate = Helper.convertToDate(dateString: ecrExpListData.addedDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let modDate = dateFormatter.string(from: newReqDate)
        
        
        btnAccChrgHd.setTitle(ecrExpListData.accntCharge, for: .normal)
        btnReason.setTitle(self.ecrExpListData.reason, for: .normal)

        
        self.getPaymentReason(accntChrg: ecrExpListData.accntCharge, comp: {(result) in
          
        })
        
//        self.btnReason.setTitle(self.ecrExpListData.reason, for: .normal)
        
        txtVendor.text = ecrExpListData.vendor
        txtExpDate.text = modDate
        txtAmtPaid.text = ecrExpListData.expAmount
        txtInvoiceNum.text = ecrExpListData.invoiceNo
        txtComments.text = ecrExpListData.comments
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
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
    
    func getPaymentReason( accntChrg : String , comp : @escaping(Bool) ->()) {
        
        if internetStatus != .notReachable {
            var newData:[String] = []
            var url = ""
            
//            if ecrData.claimType.caseInsensitiveCompare("Benefits Reimbursement") == ComparisonResult.orderedSame {
//                url = String.init(format: Constant.API.GET_PAYMENT_REASON, Session.authKey , Helper.encodeURL(url: accntChrg), "", self.ecrData.headRef)
//            } else { // Temp Commented For EBR Final Confirmation of Web Module
                url = String.init(format: Constant.API.GET_PAYMENT_REASON, Session.authKey, Helper.encodeURL(url: ecrData.claimType) , Helper.encodeURL(url: accntChrg), self.ecrData.headRef)
//            } // Temp Commented For EBR Final Confirmation of Web Module
            
            
            print("Payment reason:",url)
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let jsonString = JSON(response.result.value!)
                    print(jsonString)
                    for(_,j):(String,JSON) in jsonString {
                        let newCurr = j["AccChargeHead"].stringValue
                        newData.append(newCurr)
                    }
                    self.arrReason = newData
                    comp(true)
                    
                } else {
                    comp(false)
                }
            }))
        } else {
            Helper.showNoInternetMessg()
            comp(false)
        }
    }
    
    func showNoBenefitsPopUp() {
        
        self.handleTap()
        var custPopUpVw = CustomPopUpView()

        custPopUpVw = Bundle.main.loadNibNamed("CustomPopUpView", owner: nil, options: nil)![0] as! CustomPopUpView
        custPopUpVw.setDataToCustomView(title: "", description: "No benefits have been allocated to you, please contact HR" , leftButton: "", rightButton: "OK", isTxtVwHidden: true, isApprove: false, isWithoutData: false, isEBRWarning : true, isOkButton: true, imgName: "warning")
       
        self.view.addMySubview(custPopUpVw)
    }
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        guard let accntChrg = btnAccChrgHd.titleLabel?.text, !accntChrg.isEmpty else {
            Helper.showMessage(message: "Please enter Account Charge Head")
            return
        }
        
      
        
        guard let reason = btnReason.titleLabel?.text, !reason.isEmpty else {
            
//            if self.ecrData.claimTypeInInt == 3 {
//
//                self.showNoBenefitsPopUp()
//           } else { // Temp Commented For EBR Final Confirmation of Web Module
                Helper.showMessage(message: "Please enter Payment Reason")
//            } // Temp Commented For EBR Final Confirmation of Web Module
            return
        }
        
        
       
        guard let pymntDate = txtExpDate.text, !pymntDate.isEmpty else {
            Helper.showMessage(message: "Please enter Payment Date")
            return
        }
        
        guard let amtPaid = txtAmtPaid.text, !amtPaid.isEmpty else {
            Helper.showMessage(message: "Please enter Amount Paid")
            return
        }
        
        guard let vendor = txtVendor.text else {
            return
        }
        
        guard let invNo = txtInvoiceNum.text else {
            return
        }
        
        guard let comments = txtComments.text else {
            return
        }
        
        var refId = String()
        
        if ecrExpListData == nil  {
            refId = ecrData.headRef
        } else {
            refId = ecrExpListData.eprItemsId
        }
        
        self.addOrEditClaim(refId: refId, pymntDate: pymntDate, invoiceNo: invNo, comments: comments, amtPaid: amtPaid, vendor: vendor, accntChrgHead: accntChrg, reason: reason, counter: ecrData.counter)
        
    }
    
    
    func addOrEditClaim( refId : String, pymntDate : String, invoiceNo : String, comments : String, amtPaid : String ,vendor : String,  accntChrgHead: String , reason : String, counter : Int = 0) {
        
        if self.internetStatus != .notReachable {
            
            self.view.showLoading()
            var url = String()
            var newRecord = [String : Any]()
            
            if ecrExpListData == nil {
                
                url = String.init(format: Constant.API.ECR_ADD_PAYMENT, Session.authKey, refId , counter )
                
                newRecord = ["EPRItemsDate": pymntDate , "EPRItemsCategory": accntChrgHead, "EPRItemsAccountChargeHead": reason, "EPRItemsVendorName": vendor, "EPRItemsInvoiceNumber": invoiceNo, "EPRItemsAmount": amtPaid, "EPRItemsRemarks": comments , "EPRItemsTaxType": ""] as [String : Any]
                
            } else {
                
                url = String.init(format: Constant.API.ECR_UPDATE_PAYMENT, Session.authKey,refId )
                newRecord = ["EPRItemsDate": pymntDate , "EPRItemsCategory": accntChrgHead, "EPRItemsAccountChargeHead": reason, "EPRItemsVendorName": vendor, "EPRItemsInvoiceNumber": invoiceNo, "EPRItemsAmount": amtPaid, "EPRItemsRemarks": comments , "EPRItemsTaxType": ""] as [String : Any]
            }
            print("add or edit:", url)
            
            Alamofire.request(url, method: .post, parameters: newRecord, encoding: JSONEncoding.default)
                .responseString(completionHandler: {  response in
                    self.view.hideLoading()
                    debugPrint(response.result.value as Any)
                    
                    let jsonResponse = JSON.init(parseJSON: response.result.value!)
                    
                    if jsonResponse["ServerMsg"].stringValue == "Success" {
                        
                        var messg = String()
                        
                        if self.ecrExpListData != nil {
                            messg = "Payment has been Updated Successfully"
                        } else {
                            messg = "Payment has been Added Successfully"
                        }
                        
                        
                        let success = UIAlertController(title: "Success", message: messg, preferredStyle: .alert)
                        success.addAction(UIAlertAction(title: "OK", style: .default, handler: {(UIAlertAction) -> Void in
                            
                            if let d = self.okPymntDelegate {
                                d.onOkClick()
                            }
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(success, animated: true, completion: nil)
                        
                    }  else {
                        NotificationBanner(title: "Something Went Wrong!", subtitle: "Please Try again later", style:.info).show()
                    }
                })
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        scrlVw.contentSize.height = 650
    }
    
    
    @IBAction func btnReasonTapped(_ sender: Any) {
        
        let dropDown = DropDown()
        dropDown.anchorView = btnReason
        dropDown.dataSource = arrReason
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnReason.setTitle(item, for: .normal)
        }
        dropDown.show()
    }
    
    @IBAction func btnAccntChrgHd(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnAccChrgHd
        dropDown.dataSource = arrAccChrg
        dropDown.selectionAction = { [weak self] (index, item) in
            
            self?.btnAccChrgHd.setTitle(item, for: .normal)
            self?.getPaymentReason(accntChrg: item, comp: {(result) in
                
                if result {
                    self?.btnReason.setTitle(self?.arrReason.first, for: .normal)
                    
                } else {
                    
                }
            })
        }
        dropDown.show()
    }
    
    @IBAction func btnDoneTapped(sender:UIButton){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtExpDate.text = dateFormatter.string(from: datePicker.date) as String
        self.view.endEditing(true)
    }
    
    @IBAction func btnCancelTapped(sender:UIButton){
        datePickerTool.isHidden = true
        self.view.endEditing(true)
    }
    
}
extension EmpClaimExpenseAddEditVC : UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if textView == txtComments {
            let scrollPoint:CGPoint = CGPoint(x:0, y:  vwExpenseDetails.frame.origin.y + 15 )
            scrlVw!.setContentOffset(scrollPoint, animated: true)
        }
        return true
    }
    
    
}

extension EmpClaimExpenseAddEditVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        datePickerTool.isHidden = true
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtExpDate {
            datePickerTool.isHidden = false
        }
        
        if textField == txtInvoiceNum {
            let scrollPoint:CGPoint = CGPoint(x:0, y:  vwVendor.frame.origin.y  )
            scrlVw!.setContentOffset(scrollPoint, animated: true)
        }
        
        return true
    }
    
}


extension EmpClaimExpenseAddEditVC: WC_HeaderViewDelegate {
    
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
