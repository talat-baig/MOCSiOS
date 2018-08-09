//
//  TravelClaimEditAddController.swift
//
//
//  Created by Talat Baig on 3/26/18.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Alamofire
import DropDown

protocol onTCRSubmit: NSObjectProtocol {
    func onOkClick() -> Void
}


class TravelClaimEditAddController: UIViewController, IndicatorInfoProvider, UIGestureRecognizerDelegate , notifyChilds_UC {
    
    
    weak var currentTxtFld: UITextField? = nil
    var response:Data?
    var typeOfTravel = String()
    var startDate = Date()
    var endDate = Date()
    var tcrNo = String()
    var counter = Int()
    
    var tcrEprArr : [TCREPRListData] = []
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var stckPot: UIStackView!
    @IBOutlet weak var btnCompany: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnBVertical: UIButton!
    @IBOutlet weak var txtFldStartDate: UITextField!
    @IBOutlet weak var txtFldEndDate: UITextField!
    @IBOutlet weak var txtFldPurposeVisit: UITextField!
    @IBOutlet weak var txtFldCitiesVisited: UITextField!
    @IBOutlet var datePickerTool: UIView!
    
    @IBOutlet weak var stckVw: UIStackView!
    @IBOutlet weak var tcSwitchControl: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var mySubVw: UIView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var vwCompany: UIView!
    
    @IBOutlet weak var vwBusiness: UIView!
    
    @IBOutlet weak var vwLocation: UIView!
    
    @IBOutlet weak var vwTripType: UIView!
    
    @IBOutlet weak var vwPot: UIView!
    
    @IBOutlet weak var vwPov: UIView!
    
    @IBOutlet weak var vwCities: UIView!
    
    weak var okTCRSubmit : onTCRSubmit?
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        if response != nil {
            /// Edit
            vwTopHeader.isHidden = true
            stckVw.frame  = CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height + 200)
            btnSubmit.setTitle("UPDATE",for: .normal)
            parseAndAssign()
            
        } else {
            /// Add
            btnCompany.setTitle(Session.company, for:.normal)
            btnLocation.setTitle(Session.location, for:.normal)
            btnBVertical.setTitle(Session.department, for:.normal)
            btnSubmit.setTitle("SAVE",for: .normal)
        }
        
        //        scrlVw.contentSize = CGSize(width: mySubVw.frame.size.width, height: mySubVw.frame.size.height)
        checkSwitchValue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        btnCompany.contentHorizontalAlignment = .left
        btnLocation.contentHorizontalAlignment = .left
        btnBVertical.contentHorizontalAlignment = .left
        
        tcSwitchControl.addTarget(self, action: #selector(switchToggled(_:)), for: UIControlEvents.valueChanged)
        
        txtFldEndDate.delegate = self
        txtFldStartDate.delegate = self
        txtFldPurposeVisit.delegate = self
        txtFldCitiesVisited.delegate = self
        
        txtFldStartDate.inputView = datePickerTool
        txtFldEndDate.inputView = datePickerTool
        
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Add New Claim"
        vwTopHeader.lblSubTitle.isHidden = true
        
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
        
        vwTripType.layer.borderWidth = 1
        vwTripType.layer.borderColor = UIColor.lightGray.cgColor
        vwTripType.layer.cornerRadius = 5
        vwTripType.layer.masksToBounds = true;
        
        vwPot.layer.borderWidth = 1
        vwPot.layer.borderColor = UIColor.lightGray.cgColor
        vwPot.layer.cornerRadius = 5
        vwPot.layer.masksToBounds = true;
        
        vwPov.layer.borderWidth = 1
        vwPov.layer.borderColor = UIColor.lightGray.cgColor
        vwPov.layer.cornerRadius = 5
        vwPov.layer.masksToBounds = true;
        
        vwCities.layer.borderWidth = 1
        vwCities.layer.borderColor = UIColor.lightGray.cgColor
        vwCities.layer.cornerRadius = 5
        vwCities.layer.masksToBounds = true;
        
    }
    
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        self.checkSwitchValue()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let lastView : UIView! = mySubVw.subviews.last
        let height = lastView.frame.size.height
        let pos = lastView.frame.origin.y
        let sizeOfContent = height + pos + 100
        
        scrlVw.contentSize.height = sizeOfContent
    }
    
    func checkSwitchValue() {
        
        if tcSwitchControl.isOn {
            typeOfTravel = "International"
        } else {
            typeOfTravel = "Domestic"
        }
    }
    
    func notifyChild(messg: String , success : Bool) {
        Helper.showVUMessage(message: messg, success: success)
    }
    
    func parseAndAssign() {
        let jsonResponse = JSON(response!)
        for(_,j):(String,JSON) in jsonResponse {
            
            btnCompany.setTitle(j["Company Name"].stringValue, for:.normal)
            btnLocation.setTitle( j["Location"].stringValue, for:.normal)
            btnBVertical.setTitle(j["Business Vertical"].stringValue, for:.normal)
            
            self.txtFldPurposeVisit.text = j["Purpose of Travel"].stringValue
            self.txtFldCitiesVisited.text = j["Places Visited"].stringValue
            
            print( j["Travel Start Date"].stringValue)
            startDate = Helper.convertToDate(dateString: j["Travel Start Date"].stringValue)
            endDate = Helper.convertToDate(dateString: j["Travel End Date"].stringValue)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let newStartDate = dateFormatter.string(from: startDate)
            let newEndDate = dateFormatter.string(from: endDate)
            
            
            self.txtFldStartDate.text = newStartDate
            self.txtFldEndDate.text = newEndDate
            
            if j["Type of Travel"].stringValue == "International" {
                tcSwitchControl.isOn = true
            } else {
                tcSwitchControl.isOn = false
            }
            
            // checkAllotedEPR(res: j["Alloted_EPR"].stringValue)
            
        }
    }
    
    
    
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    func insertOrUpdate(tcrRefNo:String ,travelType:String, bPurpose : String, places : String, fromStr : String ,toStr : String, eprStr : String = "", counter : Int = 0 ){
        
        if self.internetStatus != .notReachable {
            
            self.view.showLoading()
            var url = String()
            
            if response == nil {
                url = String.init(format: Constant.API.TCR_INSERT, Session.authKey, travelType, Helper.encodeURL(url:bPurpose), Helper.encodeURL(url:places), fromStr, toStr, eprStr)
            } else {
                url = String.init(format: Constant.API.TCR_UPDATE, Session.authKey, tcrRefNo, travelType, Helper.encodeURL(url:bPurpose),Helper.encodeURL(url:places), fromStr, toStr,  Helper.encodeURL(url:eprStr), counter)
            }
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result){
                    var messg = String()
                    
                    if self.tcrNo != "" {
                        messg = "Claim has been Updated Successfully"
                    } else {
                        messg = "Claim has been Added Successfully"
                    }
                    
                    let success = UIAlertController(title: "Success", message: messg, preferredStyle: .alert)
                    success.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        
                        if let d = self.okTCRSubmit {
                            d.onOkClick()
                        }
                        
                        if let navController = self.navigationController {
                            navController.popViewController(animated: true)
                        }
                        
                    }))
                    self.present(success, animated: true, completion: nil)
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    @IBAction func btnCompanyTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnCompany
        dropDown.dataSource = [Session.company]
        dropDown.show()
        self.handleTap()
    }
    
    
    @IBAction func btnLocationTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnLocation
        dropDown.dataSource = [Session.location]
        dropDown.show()
        self.handleTap()
    }
    
    @IBAction func btnBVerticalTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnBVertical
        dropDown.dataSource = [Session.department]
        dropDown.show()
        
        self.handleTap()
    }
    
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        if endDate < startDate {
            Helper.showMessage(message: "Start date can't be greater than end date")
            return
        }
        
        guard let strtDate = txtFldStartDate.text, !strtDate.isEmpty else {
            Helper.showMessage(message: "Please enter Start Date")
            return
        }
        
        guard let endDate = txtFldEndDate.text, !endDate.isEmpty else {
            Helper.showMessage(message: "Please enter End Date")
            return
        }
        
        guard let pov = txtFldPurposeVisit.text, !pov.isEmpty else {
            Helper.showMessage(message: "Please enter purpose of visit")
            return
        }
        
        guard let cv = txtFldCitiesVisited.text, !cv.isEmpty else {
            Helper.showMessage(message: "Please enter cities visited")
            return
        }
        
        self.handleTap()
        
        self.insertOrUpdate(tcrRefNo: tcrNo , travelType: typeOfTravel, bPurpose: pov , places: cv, fromStr: txtFldStartDate.text!, toStr: txtFldEndDate.text!, counter: counter )
        
    }
    
    
    @IBAction func btnDoneTapped(sender:UIButton){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if currentTxtFld == txtFldStartDate {
            txtFldStartDate.text = dateFormatter.string(from: datePicker.date) as String
            startDate = datePicker.date
        }
        
        if currentTxtFld == txtFldEndDate {
            txtFldEndDate.text = dateFormatter.string(from: datePicker.date) as String
            endDate = datePicker.date
        }
        
        self.view.endEditing(true)
    }
    
    @IBAction func btnCancelTapped(sender:UIButton){
        datePickerTool.isHidden = true
        self.view.endEditing(true)
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
    
}


extension TravelClaimEditAddController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        datePickerTool.isHidden = true
        
        switch textField {
            
        case txtFldStartDate:
            txtFldEndDate.becomeFirstResponder()
            
        case txtFldEndDate:
            txtFldPurposeVisit.becomeFirstResponder()
            
        case txtFldPurposeVisit:
            txtFldCitiesVisited.becomeFirstResponder()
            
        case txtFldCitiesVisited:
            self.view.endEditing(true)

        default: break
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        currentTxtFld = textField
        if textField == txtFldStartDate  {
            
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
        
        
        if textField == txtFldPurposeVisit {
            
            let scrollPoint:CGPoint = CGPoint(x:0, y:  vwTripType.frame.origin.y  )
            scrlVw!.setContentOffset(scrollPoint, animated: true)
        }
        
        if textField == txtFldCitiesVisited {
            
            let scrollPoint:CGPoint = CGPoint(x:0, y: vwPot.frame.origin.y)
            scrlVw!.setContentOffset(scrollPoint, animated: true)
        }
        
        return true
    }
    
}


extension TravelClaimEditAddController: WC_HeaderViewDelegate {
    
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


