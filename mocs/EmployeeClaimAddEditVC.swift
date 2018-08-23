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
import NotificationBannerSwift
import DropDown


protocol onECRSubmit: NSObjectProtocol {
    func onOkClick() -> Void
}

class EmployeeClaimAddEditVC: UIViewController, UIGestureRecognizerDelegate ,IndicatorInfoProvider, addEPRAdvancesDelegate, notifyChilds_UC {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    weak var currentTxtFld: UITextField? = nil
    //    var pickerData: [String] = [String]()
    var arrCurrency: [String] = [String]()
    var arrPaymentType: [String] = [String]()
    var arrClaimType: [String] = [String]()
    var arrCompName: [String] = [String]()
    var arrDept: [String] = [String]()
    var arrLocation: [String] = [String]()
    var arrBenfName: [String] = [String]()
    
    
    
    var empCurrencyRes = String()
    var ecrNo = String()
    var isAdvance = true
    
    var ecrDta = EmployeeClaimData()
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    
    @IBOutlet weak var btnReqCurrency: UIButton!
    @IBOutlet weak var btnReqDate: UIButton!
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var btnClaimType: UIButton!
    @IBOutlet weak var btnCompany: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnBVertical: UIButton!
    
    @IBOutlet weak var vwClaimType: UIView!
    @IBOutlet weak var vwPaymentMthd: UIView!
    @IBOutlet weak var vwBenfName: UIView!
    @IBOutlet weak var btnBenfName: UIButton!
    @IBOutlet weak var vwCompany: UIView!
    @IBOutlet weak var vwBusiness: UIView!
    @IBOutlet weak var vwLocation: UIView!
    @IBOutlet weak var vwReqCurrency: UIView!
    
    @IBOutlet weak var claimPicker: UIPickerView!
    
    @IBOutlet weak var btnPaymentMethd: UIButton!
    
    @IBOutlet weak var myStckVw: UIStackView!
    @IBOutlet weak var txtFldReqDate: UITextField!
    @IBOutlet weak var stckVw: UIStackView!
    @IBOutlet var datePickerTool: UIView!
    @IBOutlet var claimTypePickerTool: UIView!
    
    @IBOutlet weak var mySubVw: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnOpenEPRVal: UIButton!
    
    @IBOutlet weak var vwOpenEPR: UIView!
    
    weak var okECRSubmit : onECRSubmit?
    var tcrEprArr : [TCREPRListData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        
        
        txtFldReqDate.inputView = datePickerTool
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        txtFldReqDate.text = dateString
        
        arrCurrency = parseAndAssignCurrency()
        
        if ecrNo != ""  {
            /// Edit
            
            arrPaymentType = [ecrDta.paymntMethd]
            
            var claimType = String()
            
            if ecrDta.claimType == "Reimbursement" {
                claimType = "Claim Reimbursement"
            } else {
                claimType = ecrDta.claimType
            }
            arrClaimType = [claimType]
            
            arrCompName = [ecrDta.companyName]
            arrDept = [ecrDta.employeeDepartment]
            arrLocation = [ecrDta.location]
            arrBenfName = [ecrDta.benefName]
            
            
            self.accessOpenAdvancesBtn(item: claimType)
            
            
            vwTopHeader.isHidden = true
            stckVw.frame  = CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height + 200)
            
            btnSubmit.setTitle("UPDATE",for: .normal)
            
            
            
            
            
            
            
            
            assignDataToViews()
            
        } else {
            /// Add
            
            arrPaymentType = ["CASH", "ET", "Cheque", "DD" , "Company Card", "Bank Settlement" ]
            arrClaimType = ["Advance", "Claim Reimbursement"]
            arrCompName = [Session.company]
            arrDept = [Session.department]
            arrLocation = [Session.location]
            arrBenfName = [Session.user]
            
            btnCompany.setTitle(Session.company, for:.normal)
            btnLocation.setTitle(Session.location, for:.normal)
            btnBVertical.setTitle(Session.department, for:.normal)
            btnBenfName.setTitle(Session.user, for:.normal)
            
            btnSubmit.setTitle("SAVE",for: .normal)
            
            
        }
        
        
        
        
    }
    
    func initialSetup() {
        
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
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Add New Claim"
        vwTopHeader.lblSubTitle.isHidden = true
        
        btnCompany.contentHorizontalAlignment = .left
        btnLocation.contentHorizontalAlignment = .left
        btnBVertical.contentHorizontalAlignment = .left
        btnBenfName.contentHorizontalAlignment = .left
        btnPaymentMethd.contentHorizontalAlignment = .left
        btnClaimType.contentHorizontalAlignment = .left
        
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
        
        vwClaimType.layer.borderWidth = 1
        vwClaimType.layer.borderColor = UIColor.lightGray.cgColor
        vwClaimType.layer.cornerRadius = 5
        vwClaimType.layer.masksToBounds = true;
        
        vwBenfName.layer.borderWidth = 1
        vwBenfName.layer.borderColor = UIColor.lightGray.cgColor
        vwBenfName.layer.cornerRadius = 5
        vwBenfName.layer.masksToBounds = true;
        
        
        vwPaymentMthd.layer.borderWidth = 1
        vwPaymentMthd.layer.borderColor = UIColor.lightGray.cgColor
        vwPaymentMthd.layer.cornerRadius = 5
        vwPaymentMthd.layer.masksToBounds = true;
        
        
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
        btnBenfName.setTitle(Session.user, for:.normal)
        
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
        scrlVw.contentSize = CGSize(width: mySubVw.frame.size.width, height: 800 )
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
    
    func notifyChild(messg: String , success : Bool) {
        Helper.showVUMessage(message: messg, success: success)
    }
    
    
    func assignDataToViews() {
        
        //        arrPaymentType = [ecrDta.paymntMethd]
        
        btnCompany.setTitle(ecrDta.companyName, for:.normal)
        btnLocation.setTitle( ecrDta.location, for:.normal)
        btnBVertical.setTitle(ecrDta.employeeDepartment, for:.normal)
        btnBenfName.setTitle(ecrDta.benefName, for:.normal)
        btnPaymentMethd.setTitle(ecrDta.paymntMethd, for:.normal)
        
        if ecrDta.claimType == "Reimbursement" {
            btnClaimType.setTitle("Claim Reimbursement", for:.normal)
        } else {
            btnClaimType.setTitle(ecrDta.claimType, for:.normal)
        }
        
        
        
        //        var claimType = String()
        //
        //        if ecrDta.claimType == "Reimbursement" {
        //            claimType = "Claim Reimbursement"
        //        } else {
        //            claimType = ecrDta.claimType
        //        }
        
        //        arrClaimType = [claimType]
        //        btnClaimType.setTitle(claimType, for:.normal)
        
        
        //        self.accessOpenAdvancesBtn(item: claimType)
        
        if ecrDta.eprValue == "" {
            
        } else {
            checkAllotedEPR(res:  ecrDta.eprValue )
        }
        
        
        let newReqDate = Helper.convertToDate(dateString: ecrDta.requestedDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let modDate = dateFormatter.string(from: newReqDate)
        txtFldReqDate.text = modDate
        
        btnReqCurrency.setTitle(ecrDta.currency, for:.normal)
    }
    
    
    func parseAndAssignCurrency() -> [String] {
        
        let jsonObj = JSON.init(parseJSON:Session.currency)
        var currArr = [String]()
        
        for(_,j):(String,JSON) in jsonObj{
            let newCurr = j["Currency"].stringValue
            currArr.append(newCurr)
        }
        return currArr
    }
    
    
    func checkAllotedEPR(res : String) {
        
        var json = JSON.init(parseJSON: res)
        let jsonArr = json.arrayObject as! [[String:Any]]
        
        if jsonArr.count > 0 {
            for(_,j):(String,JSON) in json {
                let newObj = TCREPRListData()
                newObj.eprRefId = j["EPR_REF_ID"].stringValue
                let newAmt = Float(j["Total_Requested_Value"].stringValue)
                
                newObj.eprAmt = newAmt!
                newObj.isSelect = true
                self.tcrEprArr.append(newObj)
            }
        }
        let refIdStrings =  self.tcrEprArr.map {$0.eprRefId}
        
        let advancesString = refIdStrings.joined(separator: ",")
        
        if refIdStrings.isEmpty {
            btnOpenEPRVal.setTitle("Open Advances", for: .normal)
        } else {
            btnOpenEPRVal.setTitle(advancesString, for: .normal)
        }
    }
    
    //    func showHideEPRBtn() {
    //
    //        if isAdvance {
    //            btnOpenEPRVal.isEnabled = false
    //            btnOpenEPRVal.layer.borderColor = AppColor.lightGray.cgColor
    //
    //        } else {
    //            btnOpenEPRVal.isEnabled = true
    //            btnOpenEPRVal.layer.borderColor = UIColor.lightGray.cgColor
    //        }
    //    }
    
    
    @IBAction func btnReqCurrencyTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnReqCurrency
        dropDown.dataSource = arrCurrency
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnReqCurrency.setTitle(item, for: .normal)
        }
        dropDown.show()
    }
    
    @IBAction func btnClaimType(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnClaimType
        dropDown.dataSource = arrClaimType
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnClaimType.setTitle(item, for: .normal)
            self?.accessOpenAdvancesBtn(item: item)
            //            if item == "Advance" {
            //                self?.btnOpenEPRVal.isEnabled = false
            //                self?.btnOpenEPRVal.layer.borderColor = AppColor.lightGray.cgColor
            //            } else {
            //                self?.btnOpenEPRVal.isEnabled = true
            //                self?.btnOpenEPRVal.layer.borderColor = UIColor.lightGray.cgColor
            //            }
        }
        dropDown.show()
    }
    
    func accessOpenAdvancesBtn(item : String) {
        
        if item == "Advance" {
            self.btnOpenEPRVal.isEnabled = false
            self.btnOpenEPRVal.layer.borderColor = AppColor.lightGray.cgColor
        } else {
            self.btnOpenEPRVal.isEnabled = true
            self.btnOpenEPRVal.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBAction func btnPaymentTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnPaymentMethd // UIView or UIBarButtonItem
        dropDown.dataSource = arrPaymentType
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnPaymentMethd.setTitle(item, for: .normal)
        }
        dropDown.show()
    }
    
    @IBAction func btnPickerCancelTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnDoneTapped(sender:UIButton){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if currentTxtFld == txtFldReqDate {
            
        }
        
        self.view.endEditing(true)
    }
    
    @IBAction func btnDatePickerDone(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        //        if currentTxtFld == txtFldReqDate {
        txtFldReqDate.text = dateFormatter.string(from: datePicker.date) as String
        self.view.endEditing(true)
        //        }
        
    }
    
    
    
    @IBAction func btnCancelTapped(sender:UIButton){
        datePickerTool.isHidden = true
        self.view.endEditing(true)
    }
    
    
    @IBAction func btnEPRAdvancesTapped(_ sender: Any) {
        
        //
        //        let eprView = Bundle.main.loadNibNamed("EPRListView", owner: nil, options: nil)![0] as! EPRListView
        //        //        eprView.setEprData(arrData: self.tcrEprArr)
        //        eprView.delegate = self
        //        DispatchQueue.main.async {
        //            self.navigationController?.view.addMySubview(eprView)
        //        }
        
        
        // Call EPR API
        if internetStatus != .notReachable{
            self.view.showLoading()
            let url:String = String.init(format: Constant.TCR.TCR_EPR_LIST, Session.authKey)
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    
                    let jsonRes = JSON(response.result.value!)
                    let jsonArray = jsonRes.arrayObject as! [[String:AnyObject]]
                    
                    if jsonArray.count > 0 {
                        var tempArr1 : [TCREPRListData] = []
                        
                        for(_,j):(String,JSON) in jsonRes {
                            let newObj = TCREPRListData()
                            newObj.eprRefId = j["EPRMainReferenceID"].stringValue
                            newObj.eprAmt = Float(j["EPRitemsAmount"].stringValue)!
                            newObj.isSelect = false
                            tempArr1.append(newObj)
                        }
                        
                        var tempArr2 : [TCREPRListData] = []
                        
                        
                        for newEpr in tempArr1 {
                            for newTmp in self.tcrEprArr {
                                if newEpr.eprRefId == newTmp.eprRefId {
                                    tempArr2.append(newEpr)
                                }
                            }
                        }
                        
                        for newObj in tempArr2 {
                            if let index = tempArr1.index(where: { $0.eprRefId == newObj.eprRefId }) {
                                tempArr1.remove(at: index)
                            }
                        }
                        
                        self.tcrEprArr.append(contentsOf: tempArr1)
                        
                        let eprView = Bundle.main.loadNibNamed("EPRListView", owner: nil, options: nil)![0] as! EPRListView
                        eprView.setEprData(arrData: self.tcrEprArr)
                        eprView.delegate = self
                        DispatchQueue.main.async {
                            self.navigationController?.view.addMySubview(eprView)
                        }
                    } else {
                        if self.tcrEprArr.count > 0 {
                            let eprView = Bundle.main.loadNibNamed("EPRListView", owner: nil, options: nil)![0] as! EPRListView
                            eprView.setEprData(arrData: self.tcrEprArr)
                            eprView.delegate = self
                            DispatchQueue.main.async {
                                self.navigationController?.view.addMySubview(eprView)
                            }
                        } else {
                            Helper.showMessage(message: "You have no Advances")
                        }
                    }
                }
            }))
        }else{
            Helper.showMessage(message: "No Internet, Please Try Again")
        }
        
        
    }
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        if btnPaymentMethd.titleLabel?.text == "-" {
            Helper.showMessage(message: "Please enter Payment Method")
            return
        }
        
        if btnClaimType.titleLabel?.text == "-" {
            Helper.showMessage(message: "Please enter Claim Type")
            return
        }
        
        
        var claimType = Int()
        
        if btnClaimType.titleLabel?.text == "Advance" {
            claimType = 1
        } else {
            claimType = 2
        }
        
        guard let reqDate = txtFldReqDate.text, !reqDate.isEmpty else {
            Helper.showMessage(message: "Please enter Date")
            return
        }
        
        if btnReqCurrency.titleLabel?.text == "-" {
            Helper.showMessage(message: "Please enter Currency")
            return
        }
        
        guard let pymnt = btnPaymentMethd.titleLabel?.text, !pymnt.isEmpty else {
            Helper.showMessage(message: "Something went wrong! Please try again")
            return
        }
        
        guard let currency = btnReqCurrency.titleLabel?.text, !currency.isEmpty else {
            Helper.showMessage(message: "Something went wrong! Please try again")
            return
        }
        
        
        guard let eprStr = btnOpenEPRVal.titleLabel?.text else {
            Helper.showMessage(message: "Something went wrong! Please try again")
            return
        }
        
        var eprString = String()
        
        if btnOpenEPRVal.titleLabel?.text == "Open Advances" {
            eprString = ""
        } else {
            eprString = eprStr
        }
        
        
        self.addOrEditClaim(ecrRefNo: ecrNo, claimType: claimType, paymntMethd: pymnt, ReqDate: reqDate, eprAdvanceVal: eprString , currency: currency, counter : (ecrDta.counter))
        
        
        //        if eprString == "Open Advances" {
        //            self.addOrEditClaim(ecrRefNo: ecrNo, claimType: claimType, paymntMethd: pymnt, ReqDate: reqDate, eprAdvanceVal: "", currency: currency, counter : (ecrDta?.counter)!)
        //
        //        } else {
        //            self.addOrEditClaim(ecrRefNo: ecrNo, claimType: claimType, paymntMethd: pymnt, ReqDate: reqDate, eprAdvanceVal: "", currency: currency,counter : (ecrDta?.counter)!)
        //        }
    }
    
    
    func addOrEditClaim( ecrRefNo : String,  claimType : Int, paymntMethd : String, ReqDate : String, eprAdvanceVal : String, currency : String , counter : Int = 0) {
        
        
        if self.internetStatus != .notReachable {
            
            self.view.showLoading()
            var url = String()
            var newRecord = [String : Any]()
            
            if ecrNo == "" {
                
                url = String.init(format: Constant.API.ECR_ADD, Session.authKey, claimType)
                newRecord = ["EPRMainRequestedPaymentMode": paymntMethd , "EPRMainOpenAdvanceValue": "", "EPRMainRequestedValueDate": ReqDate, "EPRMainRequestedCurrency": currency] as [String : Any]
                
            } else {
                
                url = String.init(format: Constant.API.ECR_UPDATE, Session.authKey, counter , ecrRefNo)
                newRecord = ["EPRMainRequestedValueDate": txtFldReqDate.text ?? "" , "EPRMainRequestedCurrency": currency] as [String : Any]
            }
            
            
            Alamofire.request(url, method: .post, parameters: newRecord, encoding: JSONEncoding.default)
                .responseString(completionHandler: {  response in
                    self.view.hideLoading()
                    debugPrint(response.result.value as Any)
                    
                    let jsonResponse = JSON.init(parseJSON: response.result.value!)
                    
                    if jsonResponse["ServerMsg"].stringValue == "Success" {
                        
                        
                        var messg = String()
                        
                        if self.ecrNo != "" {
                            messg = "Claim has been Updated Successfully"
                        } else {
                            messg = "Claim has been Added Successfully"
                        }
                        
                        
                        let success = UIAlertController(title: "Success", message: messg, preferredStyle: .alert)
                        success.addAction(UIAlertAction(title: "OK", style: .default, handler: {(UIAlertAction) -> Void in
                            
                            if let d = self.okECRSubmit {
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
    
    
    @IBAction func btnCompanyTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnCompany
        dropDown.dataSource = arrCompName
        dropDown.show()
    }
    
    
    @IBAction func btnLocationTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnLocation
        dropDown.dataSource = arrLocation
        dropDown.show()
    }
    
    @IBAction func btnBVerticalTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnBVertical
        dropDown.dataSource = arrDept
        dropDown.show()
    }
    
    @IBAction func btnBenfNameTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnBenfName
        dropDown.dataSource = arrBenfName
        dropDown.show()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    @IBAction func btnUpdateTapped(_ sender: Any) {
    }
    
    func onAddTap(eprIdString: String, tempArr: [TCREPRListData]) {
        if eprIdString == "" {
            btnOpenEPRVal.setTitle("Open Advances", for: .normal)
        } else {
            btnOpenEPRVal.setTitle(eprIdString, for: .normal)
        }
        self.tcrEprArr = tempArr
    }
    
    func onCancelTap() {
        let eprString = btnOpenEPRVal.currentTitle
        if eprString != "" {
            let newStrArr = eprString?.components(separatedBy: ",")
            for newTmp in self.tcrEprArr {
                for j in newStrArr! {
                    if newTmp.eprRefId == j {
                        newTmp.isSelect = true
                    }
                }
            }
        }

    }
}

extension EmployeeClaimAddEditVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        datePickerTool.isHidden = true
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtFldReqDate {
            
            datePickerTool.isHidden = false
            
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
