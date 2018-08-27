//
//  ExpenseAddEditViewController.swift
//  mocs
//
//  Created by Talat Baig on 3/28/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import DropDown
import SwiftyJSON
import Alamofire

protocol onSubmitOkDelegate: NSObjectProtocol {
    func onOkClick() -> Void
}

class ExpenseAddEditViewController: UIViewController , UIGestureRecognizerDelegate{
    
    var eplData : ExpenseListData?
    var expCatResponse = String()
    var currResponse = String()
    var arrCurrency = [String]()
    var expCategories = [ExpenseType]()
    var tcrRefNo = String()
    var startDate = String()
    var endDate = String()
    var tcrCounter = Int()

    weak var okSubmitDelegate : onSubmitOkDelegate?

    let chooseCategory = DropDown()
    let chooseSubCategory = DropDown()
    let arrPaymentType = ["Cash","Card","Net Banking"]
    
    @IBOutlet weak var stckPot: UIStackView!
    @IBOutlet weak var scrlVw: UIScrollView!

    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var btnSubCategory: UIButton!
    @IBOutlet weak var txtFldVendor: UITextField!
    @IBOutlet weak var txtFldDate: UITextField!
    @IBOutlet weak var txtFldAmount: UITextField!
    @IBOutlet weak var btnCurrency: UIButton!
    @IBOutlet weak var btnPaymentType: UIButton!
    @IBOutlet weak var txtFldComments: UITextView!
    @IBOutlet var datePickerTool: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var mySubVw: UIView!
    
    @IBOutlet weak var vwCategory: UIView!
    
    @IBOutlet weak var vwSubCategory: UIView!
    
    @IBOutlet weak var vwVendor: UIView!
    
    @IBOutlet weak var vwPot: UIView!
    
    @IBOutlet weak var vwCurrType: UIView!
    
    @IBOutlet weak var vwPaymentType: UIView!
    
    @IBOutlet weak var vwComments: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = tcrRefNo

        initialSetup()
        
        arrCurrency = parseAndAssignCurrency()
        expCategories = parseAndAssignCategory()
       
        self.chooseSubCategory.dataSource = (self.expCategories[0].subCategory)
        
        if eplData != nil {
            /// Edit
            assignData()
        } else {
            /// Add
           setupDefaultValues()
        }
        
    }
    
    func initialSetup() {
        
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
        
        txtFldDate.inputView = datePickerTool
        
        btnCategory.contentHorizontalAlignment = .left
        btnSubCategory.contentHorizontalAlignment = .left
        btnCurrency.contentHorizontalAlignment = .left
        btnPaymentType.contentHorizontalAlignment = .left
        
        Helper.addBordersToView(view: vwCategory)
        Helper.addBordersToView(view: vwSubCategory)
        Helper.addBordersToView(view: vwVendor)
        Helper.addBordersToView(view: vwPot)
        Helper.addBordersToView(view: vwCurrType)
        Helper.addBordersToView(view: vwPaymentType)
        Helper.addBordersToView(view: vwComments)

        self.navigationController?.isNavigationBarHidden = true

    }
        
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let lastView : UIView! = mySubVw.subviews.last
        let height = lastView.frame.size.height
        let pos = lastView.frame.origin.y
        let sizeOfContent = height + pos + 30
        
        scrlVw.contentSize.height = sizeOfContent
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
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    func assignData() {
        
        btnCategory.setTitle(eplData?.expCategory, for: .normal)
        btnSubCategory.setTitle(eplData?.expSubCategory, for: .normal)
        btnCurrency.setTitle(eplData?.expCurrency, for: .normal)
        btnPaymentType.setTitle(eplData?.expPaymentType, for: .normal)
        
        txtFldDate.text = eplData?.expDate
        txtFldAmount.text = eplData?.expAmount
        txtFldVendor.text = eplData?.expVendor
        txtFldComments.text = eplData?.expComments

        datePicker.maximumDate = Helper.convertToDate(dateString: endDate)
        datePicker.minimumDate = Helper.convertToDate(dateString: startDate)
       
    }
    
    func setupDefaultValues() {
        
        btnCategory.setTitle(expCategories[0].category, for: .normal)
        btnSubCategory.setTitle(expCategories[0].subCategory[0], for: .normal)
        btnCurrency.setTitle(arrCurrency[0], for: .normal)
        btnPaymentType.setTitle(arrPaymentType[0], for: .normal)
        
        datePicker.maximumDate = Helper.convertToDate(dateString: endDate)
        datePicker.minimumDate = Helper.convertToDate(dateString: startDate)
    }
    
    
    func parseAndAssignCurrency() -> [String] {
        
        let jsonObj = JSON.init(parseJSON:currResponse)
        var currArr = [String]()
        
        for(_,j):(String,JSON) in jsonObj{
            let newCurr = j["Currency"].stringValue
            currArr.append(newCurr)
        }
        return currArr
    }
    
    func parseAndAssignCategory() -> [ExpenseType] {
        var expCategory = [ExpenseType]()
        
        let jsonObj = JSON.init(parseJSON:expCatResponse)
        
        for(_,j):(String,JSON) in jsonObj{
            let expType = ExpenseType()
            expType.category = j["Expense Category"].stringValue
            
            let jsonSubCategoryStr = j["Expense Sub Category"].stringValue
            let jsonSC = JSON.init(parseJSON:jsonSubCategoryStr)
            
            for(_,k):(String,JSON) in jsonSC {
                let newSub = k["Expense Sub Category"].stringValue
                expType.subCategory.append(newSub)
            }
            expCategory.append(expType)
        }
        return expCategory
    }
    
    @IBAction func btnCurrencyTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnCurrency
        dropDown.dataSource = arrCurrency
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnCurrency.setTitle(item, for: .normal)
        }
        dropDown.show()
    }
    
    @IBAction func btnExpSubCategoryTapped(_ sender: Any) {
        
        chooseSubCategory.anchorView = btnSubCategory
        chooseSubCategory.selectionAction = { [weak self] (index, item) in
            self?.btnSubCategory.setTitle(item, for: .normal)
        }
        chooseSubCategory.show()
    }
    
    @IBAction func btnExpCategoryTapped(_ sender: Any) {
        
        let catArr = expCategories.map({ (expType: ExpenseType) -> String in
            expType.category
        })
        
        chooseCategory.anchorView = btnCategory
        chooseCategory.dataSource = catArr
        chooseCategory.selectionAction = { [weak self] (index, item) in
            self?.btnCategory.setTitle(item, for: .normal)
            self?.chooseSubCategory.dataSource = (self?.expCategories[index].subCategory)!
            self?.btnSubCategory.setTitle(self?.expCategories[index].subCategory.first, for: .normal)
        }
        chooseCategory.show()
    }
    
    
    @IBAction func btnPaymentTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnPaymentType // UIView or UIBarButtonItem
        dropDown.dataSource = arrPaymentType
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnPaymentType.setTitle(item, for: .normal)
        }
        dropDown.show()
    }
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        guard let vendor = txtFldVendor.text, !vendor.isEmpty else {
            Helper.showMessage(message: "Please enter Vendor")
            return
        }
        
        guard let amt = txtFldAmount.text, !amt.isEmpty else {
            Helper.showMessage(message: "Please enter Amount")
            return
        }
        
        guard let date = txtFldDate.text, !date.isEmpty else {
            Helper.showMessage(message: "Please enter Date")
            return
        }
        
        guard let comm = txtFldComments.text, !comm.isEmpty else {
            Helper.showMessage(message: "Please enter Comment")
            return
        }
    
        if btnCurrency.titleLabel?.text == "-" {
            Helper.showMessage(message: "Please enter Currency")
            return
        }
        
        let category = btnCategory.titleLabel?.text
        let subCat = btnSubCategory.titleLabel?.text
        let currency = btnCurrency.titleLabel?.text
        let payment = btnPaymentType.titleLabel?.text
        
        self.addOrEditExpense(tcrRefNo: tcrRefNo, expDate: date, expCat: category!, expSubCat: subCat!, expVendor: vendor, expPayment: payment!, expCurr: currency!, expAmt: amt, expComments: comm, tcrCounter: self.tcrCounter)
        
    }
    
    
    
    func addOrEditExpense(tcrRefNo:String , expDate:String, expCat : String, expSubCat : String, expVendor : String ,expPayment : String, expCurr : String, expAmt : String ,expComments : String, tcrCounter : Int) {
        
        if self.internetStatus != .notReachable {
            
            self.view.showLoading()
            var url = String()
            
            if eplData == nil  {
                url = String.init(format: Constant.API.EXPENSE_ADD, Session.authKey, Helper.encodeURL(url: tcrRefNo), Helper.encodeURL(url:expDate),
                                  Helper.encodeURL(url:expCat),
                                  Helper.encodeURL(url:expSubCat.trimmingCharacters(in: .whitespacesAndNewlines)),
                                  Helper.encodeURL(url:expVendor),
                                  Helper.encodeURL(url:expPayment),
                                  Helper.encodeURL(url:expCurr),
                                  Helper.encodeURL(url:expAmt),
                                  Helper.encodeURL(url:expComments),
                                  tcrCounter)
            } else {
                url = String.init(format: Constant.API.EXPENSE_EDIT, Session.authKey,
                                  Helper.encodeURL(url: tcrRefNo),
                                  Helper.encodeURL(url:(eplData?.expId)!),
                                  Helper.encodeURL(url:expDate),
                                  Helper.encodeURL(url:expCat),
                                  Helper.encodeURL(url:expSubCat),
                                  Helper.encodeURL(url:expVendor),
                                  Helper.encodeURL(url:expPayment),
                                  Helper.encodeURL(url:expCurr),
                                  Helper.encodeURL(url:expAmt),
                                  Helper.encodeURL(url:expComments), tcrCounter )
            }
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                
                if Helper.isResponseValid(vc: self, response: response.result){
                    var messg = String()
                    
                    if (self.eplData != nil) {
                        messg = "Expense has been Updated Successfully"
                    } else {
                        messg = "Expense has been Added Successfully"
                    }
                    
                    let success = UIAlertController(title: "Success", message: messg, preferredStyle: .alert)
                    success.addAction(UIAlertAction(title: "OK", style: .default, handler: {(UIAlertAction) -> Void in
                       
                        if let d = self.okSubmitDelegate {
                            d.onOkClick()
                        }
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(success, animated: true, completion: nil)
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    @IBAction func btnDoneTapped(sender:UIButton){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtFldDate.text = dateFormatter.string(from: datePicker.date) as String
        self.view.endEditing(true)
    }
    
    @IBAction func btnCancelTapped(sender:UIButton){
        datePickerTool.isHidden = true
        self.view.endEditing(true)
    }
    
}

extension ExpenseAddEditViewController: UITextFieldDelegate , UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        datePickerTool.isHidden = true
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtFldDate {
            datePickerTool.isHidden = false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == txtFldComments {
            let scrollPoint:CGPoint = CGPoint(x:0, y:  vwPot.frame.origin.y + 10 )
            scrlVw!.setContentOffset(scrollPoint, animated: true)
        }
    }
    
}


extension ExpenseAddEditViewController: WC_HeaderViewDelegate {
    
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
