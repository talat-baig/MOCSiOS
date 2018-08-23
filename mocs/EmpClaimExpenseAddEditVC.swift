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
    
    weak var ecrExpListData : ECRExpenseListData!
    weak var ecrData : EmployeeClaimData!

    
    
    @IBOutlet weak var stckVwCurrency: UIStackView!
    
    
    @IBOutlet weak var btnReason: UIButton!
    @IBOutlet weak var vwInvNo: UIView!
    @IBOutlet weak var vwAccChargeHd: UIView!
    
    @IBOutlet var datePickerTool: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var okPymntDelegate : onECRPaymentAddDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
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
        
        vwPymntReason.layer.borderWidth = 1
        vwPymntReason.layer.borderColor = UIColor.lightGray.cgColor
        vwPymntReason.layer.cornerRadius = 5
        vwPymntReason.layer.masksToBounds = true;
        
        vwVendor.layer.borderWidth = 1
        vwVendor.layer.borderColor = UIColor.lightGray.cgColor
        vwVendor.layer.cornerRadius = 5
        vwVendor.layer.masksToBounds = true;
        
        
        vwInvNo.layer.borderWidth = 1
        vwInvNo.layer.borderColor = UIColor.lightGray.cgColor
        vwInvNo.layer.cornerRadius = 5
        vwInvNo.layer.masksToBounds = true;
        
        btnReason.contentHorizontalAlignment = .left
        
        btnAccChrgHd.contentHorizontalAlignment = .left
        
        btnAccChrgHd.setTitle("Advance", for:.normal)
        vwAccChargeHd.layer.borderWidth = 1
        vwAccChargeHd.layer.borderColor = UIColor.lightGray.cgColor
        vwAccChargeHd.layer.cornerRadius = 5
        vwAccChargeHd.layer.masksToBounds = true;
        
        vwExpenseDetails.layer.borderWidth = 1
        vwExpenseDetails.layer.borderColor = UIColor.lightGray.cgColor
        vwExpenseDetails.layer.cornerRadius = 5
        vwExpenseDetails.layer.masksToBounds = true;
        
        vwComments.layer.borderWidth = 1
        vwComments.layer.borderColor = UIColor.lightGray.cgColor
        vwComments.layer.cornerRadius = 5
        vwComments.layer.masksToBounds = true;
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        if ecrExpListData != nil {
            assignDataToViews()
        } else {
            
        }
        
        
        
        
        
    }
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    func assignDataToViews() {
        
         // * to validate Date */
//        let dateFormatter = DateFormatter()
//        let tempLocale = dateFormatter.locale // save locale temporarily
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
//        let date = dateFormatter.date(from: ecrExpListData.addedDate)!
//        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
//        dateFormatter.locale = tempLocale // reset the locale
//        let dateString = dateFormatter.string(from: date)
//        print("EXACT_DATE : \(dateString)")


//        datePicker.date = date

        btnAccChrgHd.setTitle(ecrExpListData.accntCharge, for: .normal)
        btnReason.setTitle(ecrExpListData.reason, for: .normal)
        txtVendor.text = ecrExpListData.vendor
        txtExpDate.text = ecrExpListData.addedDate
        txtAmtPaid.text = ecrExpListData.expAmount
        txtInvoiceNum.text = ecrExpListData.invoiceNo
        txtComments.text = ecrExpListData.comments

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        guard let itemsCategry = btnAccChrgHd.titleLabel?.text, !itemsCategry.isEmpty else {
            Helper.showMessage(message: "Please enter Account Charge Head")
            return
        }
        
        guard let accntChrg = btnReason.titleLabel?.text, !accntChrg.isEmpty else {
            Helper.showMessage(message: "Please enter Payment Reason")
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
            refId = ecrExpListData.eprRefId
        }
        
        self.addOrEditClaim(ecrRefNo: refId, pymntDate: pymntDate, invoiceNo: invNo, comments: comments, amtPaid: amtPaid, vendor: vendor, accntChrgHead: accntChrg, itemsCategory: itemsCategry, counter: 0)
       
    }
    
    
    func addOrEditClaim( ecrRefNo : String, pymntDate : String, invoiceNo : String, comments : String, amtPaid : String ,vendor : String,  accntChrgHead: String , itemsCategory : String, counter : Int = 0) {
        
        
        if self.internetStatus != .notReachable {
            
            self.view.showLoading()
            var url = String()
            var newRecord = [String : Any]()
            
            
            if ecrExpListData == nil {
                
                url = String.init(format: Constant.API.ECR_ADD_PAYMENT, Session.authKey, ecrRefNo , counter )
                
                newRecord = ["EPRItemsDate": pymntDate , "EPRItemsCategory": "", "EPRItemsAccountChargeHead": accntChrgHead, "EPRItemsVendorName": vendor, "EPRItemsInvoiceNumber": invoiceNo, "EPRItemsAmount": amtPaid, "EPRItemsRemarks": comments , "EPRItemsTaxType": ""] as [String : Any]
                
            } else {
                
                //   url = String.init(format: Constant.API.ECR_UPDATE, Session.authKey, counter , ecrRefNo)
                //   newRecord = ["EPRMainRequestedValueDate": txtFldReqDate.text ?? "" , "EPRMainRequestedCurrency": currency] as [String : Any]
            }
            
            
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
    
    
    /// Invoked before hiding keyboard and used to move view down
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrlVw.isScrollEnabled = true
        let contentInset:UIEdgeInsets = .zero
        self.scrlVw.contentInset = contentInset
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        scrlVw.contentSize.height = 650
    }
    
    
    @IBAction func btnReasonTapped(_ sender: Any) {
        
        let dropDown = DropDown()
        dropDown.anchorView = btnReason
        
        dropDown.dataSource = ["Medical", "Salary", "Official Expenses", "Travel" ]
        
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnReason.setTitle(item, for: .normal)
        }
        dropDown.show()
    }
    
    @IBAction func btnAccntChrgHd(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnAccChrgHd
        
        dropDown.dataSource = ["Advance"]
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
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
