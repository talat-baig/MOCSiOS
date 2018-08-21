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
import DropDown

class EmpClaimExpenseAddEditVC: UIViewController ,UIGestureRecognizerDelegate{
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var vwPymntReason: UIView!
    
    @IBOutlet weak var vwVendor: UIView!
    
    @IBOutlet weak var vwExpenseDetails: UIView!
    
    //    @IBOutlet weak var vwCurrType: UIView!
    
    //    @IBOutlet weak var vwPymntType: UIView!
    
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
        vwTopHeader.lblTitle.text = "Add New Expense"
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
    }
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
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
            //            let scrollPoint:CGPoint = CGPoint(x:0, y: stckVwCurrency.frame.origin.y)
            //            scrlVw!.setContentOffset(scrollPoint, animated: true)
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
        
        if textField == txtComments {
            //
            //            let scrollPoint:CGPoint = CGPoint(x:0, y: stckVwCurrency.frame.origin.y)
            //            scrlVw!.setContentOffset(scrollPoint, animated: true)
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
