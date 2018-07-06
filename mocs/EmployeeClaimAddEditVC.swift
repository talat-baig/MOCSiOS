//
//  EmployeeClaimAddEditVC.swift
//  mocs
//
//  Created by Talat Baig on 6/12/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Alamofire
import DropDown

class EmployeeClaimAddEditVC: UIViewController, UIGestureRecognizerDelegate ,IndicatorInfoProvider, UIPickerViewDelegate, UIPickerViewDataSource, addEPRAdvancesDelegate {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    
    weak var currentTxtFld: UITextField? = nil
    var pickerData: [String] = [String]()
    var arrCurrency: [String] = [String]()
    var isAdvance = true
    var response:Data?
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    
    @IBOutlet weak var btnReqCurrency: UIButton!
    @IBOutlet weak var btnReqDate: UIButton!
    @IBOutlet weak var txtFldClaimType: UITextField!
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var btnCompany: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnBVertical: UIButton!
    
    @IBOutlet weak var vwCompany: UIView!
    @IBOutlet weak var vwBusiness: UIView!
    @IBOutlet weak var vwLocation: UIView!
    @IBOutlet weak var vwClaimType: UIView!
    @IBOutlet weak var vwPot: UIView!
    @IBOutlet weak var vwReqCurrency: UIView!
    
    @IBOutlet weak var claimPicker: UIPickerView!
    @IBOutlet weak var txtFldStartDate: UITextField!
    @IBOutlet weak var txtFldEndDate: UITextField!
    
    
    @IBOutlet weak var txtFldReqDate: UITextField!
    @IBOutlet weak var stckVw: UIStackView!
    @IBOutlet var datePickerTool: UIView!
    @IBOutlet var claimTypePickerTool: UIView!
    
    @IBOutlet weak var mySubVw: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnOpenEPRVal: UIButton!
    
    @IBOutlet weak var txtReqValDate: UITextField!
    @IBOutlet weak var vwOpenEPR: UIView!
    
    var isToUpdate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
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
        
        pickerData = ["Advance", "Claim Reimbursement"]
        arrCurrency = ["AED", "AFN", "INR", "AUD" , "BSD", "DOP", "CUC" ]
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Add New Claim"
        vwTopHeader.lblSubTitle.isHidden = true
        
        btnCompany.contentHorizontalAlignment = .left
        btnLocation.contentHorizontalAlignment = .left
        btnBVertical.contentHorizontalAlignment = .left
        
        txtFldClaimType.inputView = claimTypePickerTool
        txtFldStartDate.inputView = datePickerTool
        txtFldEndDate.inputView = datePickerTool
        
        vwCompany.layer.borderWidth = 1
        vwCompany.layer.borderColor = UIColor.lightGray.cgColor
        vwCompany.layer.cornerRadius = 5
        vwCompany.layer.masksToBounds = true;
        
        vwLocation.layer.borderWidth = 1
        vwLocation.layer.borderColor = UIColor.lightGray.cgColor
        vwLocation.layer.cornerRadius = 5
        vwLocation.layer.masksToBounds = true;
        
        vwBusiness.layer.borderWidth = 1
        vwBusiness.layer.borderColor = UIColor.lightGray.cgColor
        vwBusiness.layer.cornerRadius = 5
        vwBusiness.layer.masksToBounds = true;
        
        vwPot.layer.borderWidth = 1
        vwPot.layer.borderColor = UIColor.lightGray.cgColor
        vwPot.layer.cornerRadius = 5
        vwPot.layer.masksToBounds = true;
        
        vwClaimType.layer.borderWidth = 1
        vwClaimType.layer.borderColor = UIColor.lightGray.cgColor
        vwClaimType.layer.cornerRadius = 5
        vwClaimType.layer.masksToBounds = true;
        
        vwReqCurrency.layer.borderWidth = 1
        vwReqCurrency.layer.borderColor = UIColor.lightGray.cgColor
        vwReqCurrency.layer.cornerRadius = 5
        vwReqCurrency.layer.masksToBounds = true;
        
        btnReqCurrency.layer.borderWidth = 1
        btnReqCurrency.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0).cgColor
        btnReqCurrency.layer.cornerRadius = 5
        btnReqCurrency.layer.masksToBounds = true;
        
        btnOpenEPRVal.layer.borderWidth = 1
        btnOpenEPRVal.layer.borderColor = UIColor.lightGray.cgColor
        btnOpenEPRVal.layer.cornerRadius = 5
        btnOpenEPRVal.layer.masksToBounds = true;
        
        btnCompany.setTitle(Session.company, for:.normal)
        btnLocation.setTitle(Session.location, for:.normal)
        btnBVertical.setTitle(Session.department, for:.normal)
        
        txtFldReqDate.inputView = datePickerTool
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        txtFldReqDate.text = dateString
        
        if isToUpdate {
            /// Edit
            vwTopHeader.isHidden = true
            stckVw.frame  = CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height + 200)
            btnSubmit.setTitle("UPDATE",for: .normal)
            //            parseAndAssign()
            
        } else {
            /// Add
            btnCompany.setTitle(Session.company, for:.normal)
            btnLocation.setTitle(Session.location, for:.normal)
            btnBVertical.setTitle(Session.department, for:.normal)
            btnSubmit.setTitle("SAVE",for: .normal)
        }
        
        showHideEPRBtn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let lastView : UIView! = mySubVw.subviews.last
        let height = lastView.frame.size.height
        let pos = lastView.frame.origin.y
        let sizeOfContent = height + pos + 100
        
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
    
    
    @IBAction func btnPickerDoneTapped(_ sender: Any) {
        
        txtFldClaimType.text = isAdvance ? "Advance" : "Claim Reimbursement"
        showHideEPRBtn()
        
        self.view.endEditing(true)
    }
    
    func showHideEPRBtn() {
        
        if isAdvance {
            vwOpenEPR.isHidden = true
        } else {
            vwOpenEPR.isHidden = false
        }
    }
    
    
    @IBAction func btnReqCurrencyTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnReqCurrency
        dropDown.dataSource = arrCurrency
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnReqCurrency.setTitle(item, for: .normal)
        }
        dropDown.show()
    }
    
    
    
    @IBAction func btnPickerCancelTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnDoneTapped(sender:UIButton){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if currentTxtFld == txtFldStartDate {
            txtFldStartDate.text = dateFormatter.string(from: datePicker.date) as String
            //            startDate = datePicker.date
        }
        
        if currentTxtFld == txtFldEndDate {
            txtFldEndDate.text = dateFormatter.string(from: datePicker.date) as String
            //            endDate = datePicker.date
        }
        
        self.view.endEditing(true)
    }
    
    @IBAction func btnCancelTapped(sender:UIButton){
        datePickerTool.isHidden = true
        self.view.endEditing(true)
    }
    
    
    @IBAction func btnEPRAdvancesTapped(_ sender: Any) {
        
        //        // Call EPR API
        //        if internetStatus != .notReachable{
        //            self.view.showLoading()
        //            let url:String = String.init(format: Constant.TCR.TCR_EPR_LIST, Session.authKey)
        //            Alamofire.request(url).responseData(completionHandler: ({ response in
        //                self.view.hideLoading()
        //                if Helper.isResponseValid(vc: self, response: response.result){
        //
        //                    let jsonRes = JSON(response.result.value!)
        //                    let jsonArray = jsonRes.arrayObject as! [[String:AnyObject]]
        //
        //                    if jsonArray.count > 0 {
        //                        var tempArr1 : [TCREPRListData] = []
        //
        //                        for(_,j):(String,JSON) in jsonRes {
        //                            let newObj = TCREPRListData()
        //                            newObj.eprRefId = j["EPRMainReferenceID"].stringValue
        //                            newObj.eprAmt = j["EPRitemsAmount"].stringValue
        //                            newObj.isSelect = false
        //                            tempArr1.append(newObj)
        //                        }
        //
        //                        var tempArr2 : [TCREPRListData] = []
        //
        //
        //                        for newEpr in tempArr1 {
        //                            for newTmp in self.tcrEprArr {
        //                                if newEpr.eprRefId == newTmp.eprRefId {
        //                                    tempArr2.append(newEpr)
        //                                }
        //                            }
        //                        }
        //
        //                        for newObj in tempArr2 {
        //                            if let index = tempArr1.index(where: { $0.eprRefId == newObj.eprRefId }) {
        //                                tempArr1.remove(at: index)
        //                            }
        //                        }
        //
        //                        self.tcrEprArr.append(contentsOf: tempArr1)
        //
        //                        let eprView = Bundle.main.loadNibNamed("EPRListView", owner: nil, options: nil)![0] as! EPRListView
        //                        eprView.setEprData(arrData: self.tcrEprArr)
        //                        eprView.delegate = self
        //                        DispatchQueue.main.async {
        //                            self.navigationController?.view.addMySubview(eprView)
        //                        }
        //                    } else {
        //                        if self.tcrEprArr.count > 0 {
        let eprView = Bundle.main.loadNibNamed("EPRListView", owner: nil, options: nil)![0] as! EPRListView
        //        eprView.setEprData(arrData: self.tcrEprArr)
        eprView.delegate = self
        DispatchQueue.main.async {
            self.navigationController?.view.addMySubview(eprView)
        }
        //                        } else {
        //                            Helper.showMessage(message: "You have no advances")
        //                        }
        //                    }
        //                }
        //            }))
        //        }else{
        //            Helper.showMessage(message: "No Internet, Please Try Again")
        //        }
    }
    
    @IBAction func btnCompanyTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnCompany
        dropDown.dataSource = [Session.company]
        dropDown.show()
    }
    
    
    @IBAction func btnLocationTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnLocation
        dropDown.dataSource = [Session.location]
        dropDown.show()
    }
    
    @IBAction func btnBVerticalTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnBVertical
        dropDown.dataSource = [Session.department]
        dropDown.show()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        txtFldClaimType.text = pickerData[row]
        if pickerData[row] == "Advance" {
            isAdvance = true
        } else {
            isAdvance = false
        }
    }
    
    
    @IBAction func btnUpdateTapped(_ sender: Any) {
    }
    
    func onAddTap(eprIdString: String, tempArr: [TCREPRListData]) {
        
    }
    
    func onCancelTap() {
        
    }
}

extension EmployeeClaimAddEditVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        datePickerTool.isHidden = true
        //
        //        switch textField {
        //
        //        case txtFldStartDate:
        //            txtFldEndDate.becomeFirstResponder()
        //
        //        case txtFldEndDate:
        ////            txtFldPurposeVisit.becomeFirstResponder()
        //
        //        case txtFldPurposeVisit:
        ////            txtFldCitiesVisited.becomeFirstResponder()
        //
        //        case txtFldCitiesVisited:
        //            self.view.endEditing(true)
        //        // btnSubmit.sendActions(for: .touchUpInside)
        //        default: break
        //        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        currentTxtFld = textField
        if textField == txtFldStartDate  {
            
            datePickerTool.isHidden = false
            datePicker.maximumDate = Date()
            datePicker.minimumDate = Date.distantPast
            
        } else if textField == txtReqValDate  {
            
            datePickerTool.isHidden = false
            datePicker.maximumDate = Date()
            datePicker.minimumDate = Date.distantPast
            
        } else if textField == txtFldEndDate  {
            
            let startDte = txtFldStartDate.text
            
            if startDte != "" {
                txtFldEndDate.reloadInputViews()
                datePickerTool.isHidden = false
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let newStartDate = dateFormatter.date(from: startDte!)
                datePicker.minimumDate = newStartDate
                datePicker.maximumDate = Date.distantFuture
            } else {
                
                self.view.makeToast("Please enter start date")
                datePickerTool.isHidden = true
                return false
            }
            
        }
        
        if textField == txtFldReqDate {
            
            let scrollPoint:CGPoint = CGPoint(x:0, y:  vwBusiness.frame.origin.y  )
            scrlVw!.setContentOffset(scrollPoint, animated: true)
        }
        
        
        return true
    }
    
    
}


extension EmployeeClaimAddEditVC: WC_HeaderViewDelegate {
    
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
