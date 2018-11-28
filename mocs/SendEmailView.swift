//
//  SendEmailView.swift
//  mocs
//
//  Created by Talat Baig on 4/5/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol sendEmailFromViewDelegate {
    func onSendEmailTap(invoice : String , emailIds : String) -> Void
    func onSendTap(whrNo  : String , roId : String, manual : String, emailIds: String) -> Void
    func onCancelTap() -> Void
}

/// Send Email Pop-up
class SendEmailView: UIView, UIGestureRecognizerDelegate {
    
    /// Invoice number as String
    
    var whrNum : String?
    var roId : String?
    var manualNo : String?
    var invoiceNum : String?
    
    var isFromAvlRel = false
    /// sendEmailFromViewDelegate object
    var delegate : sendEmailFromViewDelegate?
    
    /// Scroll view
    @IBOutlet weak var scrlVw: UIScrollView!
    
    /// Text field for Email Ids
    @IBOutlet weak var txtFldEmailIds: UITextField!
    
    /// Button submit
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        txtFldEmailIds.delegate = self
        self.backgroundColor = AppColor.univPopUpBckgColor
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
        self.addGestureRecognizer(gestureRecognizer)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Invoice number assigned
    func passInvoiceNumToView(invoiceNum : String) {
        self.invoiceNum = invoiceNum
    }
    
    func passWHRdetails(whrNum : String, roId : String, manualNo : String) {
        self.whrNum = whrNum
        self.roId = roId
        self.manualNo = manualNo
        
    }
    
    
    /// Validate Email Ids
    func validateEmailIds(emailIDStr : String) -> String {
        
        var strArr = [String]()
        var newEmailId = ""
        
        if emailIDStr.contains(";"){
            
            let newEmailStr = emailIDStr.trimmingCharacters(in: .whitespaces)
            let emailIdArr = newEmailStr.components(separatedBy: ";")
            
            for emailId in emailIdArr {
                if emailId.isValidEmail{
                    strArr.append(emailId)
                } else {
                    newEmailId  = "Please enter valid email Id"
                }
            }
            newEmailId =  strArr.joined(separator: ";")
        } else {
            if emailIDStr.isValidEmail {
                newEmailId = emailIDStr
            } else {
                newEmailId  = "Please enter valid email Id"
            }
        }
        return newEmailId
    }
    
    /// Action method for Send button. Further calls onSubmitTap method that sends email with Invoice number to given emailIds
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        guard let emailIdStr = txtFldEmailIds.text else {
            Helper.showMessage(message: "Please Enter Email Id")
            return
        }
        
        let emailIds = self.validateEmailIds(emailIDStr: emailIdStr)
        
        if emailIds == "" || emailIds == "Please enter valid email Id" {
            Helper.showMessage(message: "Please enter valid email Id")
            return
        }
        
        
        
        if isFromAvlRel {
            if let d = delegate {
                d.onSendTap(whrNo: self.whrNum ?? "" , roId: self.roId ?? "", manual: self.manualNo ?? "" , emailIds: emailIds)
                self.removeFromSuperviewWithAnimate()
            }
        } else {
            
            guard let invoiceNum = self.invoiceNum else {
                return
            }
            
            if let d = delegate {
                d.onSendEmailTap(invoice: invoiceNum , emailIds: emailIds)
                self.removeFromSuperviewWithAnimate()
            }
        }
    }
    
    /// Action method for Cancel Button.
    @IBAction func btnCancelTapped(_ sender: Any) {
        
        if let d = delegate {
            d.onCancelTap()
        }
        self.removeFromSuperviewWithAnimate()
    }
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.endEditing(true)
    }
    
    /// Invoke before displaying keyboard and used to move view up
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            var keyboardHeight : CGFloat
            keyboardHeight = keyboardRectangle.height - 60
            var contentInset:UIEdgeInsets = self.scrlVw.contentInset
            contentInset.bottom = keyboardHeight
            
            self.scrlVw.isScrollEnabled = false
            self.scrlVw.contentInset = contentInset
        }
    }
    
    /// Invoke before Hiding keyboard and used to move view up
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrlVw.isScrollEnabled = false
        let contentInset:UIEdgeInsets = .zero
        self.scrlVw.contentInset = contentInset
    }
}

// MARK: - UITextField delegate methods
extension SendEmailView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtFldEmailIds {
            self.endEditing(true)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let scrollPoint:CGPoint = CGPoint(x:0, y:textField.frame.size.height +  btnSubmit.frame.size.height + 20 )
        scrlVw!.setContentOffset(scrollPoint, animated: true)
        return true
    }
    
}


// MARK: - ScrollView delegate methods
extension SendEmailView: UIScrollViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = false
    }
}
