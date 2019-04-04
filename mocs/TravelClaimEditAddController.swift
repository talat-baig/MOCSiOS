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


class TravelClaimEditAddController: UIViewController, IndicatorInfoProvider, UIGestureRecognizerDelegate , notifyChilds_UC , addEPRAdvancesDelegate  {
   
    weak var currentTxtFld: UITextField? = nil
    var response:Data?
    var typeOfTravel = String()
    var startDate = Date()
    var endDate = Date()
    var tcrNo = String()
    var counter = Int()
    
    var tcrEprArr : [TCREPRListData] = []

    @IBOutlet weak var btnAdvances: UIButton!
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
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        btnCompany.contentHorizontalAlignment = .left
        btnLocation.contentHorizontalAlignment = .left
        btnBVertical.contentHorizontalAlignment = .left
        
        tcSwitchControl.addTarget(self, action: #selector(switchToggled(_:)), for: UIControl.Event.valueChanged)
        
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
        
        Helper.addBordersToView(view: vwCompany)
        Helper.addBordersToView(view: vwLocation)
        Helper.addBordersToView(view: vwBusiness)
        Helper.addBordersToView(view: vwTripType)
        Helper.addBordersToView(view: vwPot)
        Helper.addBordersToView(view: vwPov)
        Helper.addBordersToView(view: vwCities)
        
        Helper.addBordersToView(view: btnAdvances)

//        btnAdvances.layer.cornerRadius = 5
//        btnAdvances.layer.borderWidth = 1
//        btnAdvances.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    
    func parseAndAssign() {
        let jsonResponse = JSON(response!)
        for(_,j):(String,JSON) in jsonResponse {
            
            btnCompany.setTitle(j["Company Name"].stringValue, for:.normal)
            btnLocation.setTitle( j["Location"].stringValue, for:.normal)
            btnBVertical.setTitle(j["Business Vertical"].stringValue, for:.normal)
            
            self.txtFldPurposeVisit.text = j["Purpose of Travel"].stringValue
            self.txtFldCitiesVisited.text = j["Places Visited"].stringValue
            
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
            
            if j["Alloted_EPR"].stringValue == "" {
                
            } else {
                checkAllotedEPR(res: j["Alloted_EPR"].stringValue)
            }
            
        }
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
    
    @objc func handleTap() {
        self.view.endEditing(true)
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
    
    
    func onAddTap(eprIdString: String, tempArr: [TCREPRListData]) {
        if eprIdString == "" {
            btnAdvances.setTitle("Open Advances", for: .normal)
        } else {
            btnAdvances.setTitle(eprIdString, for: .normal)
        }
        self.tcrEprArr = tempArr
    }
    
    
    func onCancelTap() {
        let eprString = btnAdvances.currentTitle
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
            btnAdvances.setTitle("Open Advances", for: .normal)
        } else {
            btnAdvances.setTitle(advancesString, for: .normal)
        }
    }
    
    @IBAction func btnEPRAdvancesTapped(_ sender: Any) {
        
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
    
 
    
    func insertOrUpdate(tcrRefNo:String ,travelType:String, bPurpose : String, places : String, fromStr : String ,toStr : String,  counter : Int = 0 , eprStr : String ) {
        
        if self.internetStatus != .notReachable {
            
            self.view.showLoading()
            var url = String()
            
            if response == nil {
                url = String.init(format: Constant.API.TCR_INSERT, Session.authKey, travelType, Helper.encodeURL(url:bPurpose), Helper.encodeURL(url:places), fromStr, toStr, eprStr)
            } else {
                url = String.init(format: Constant.API.TCR_UPDATE, Session.authKey, tcrRefNo, travelType, Helper.encodeURL(url:bPurpose),Helper.encodeURL(url:places), fromStr, toStr, counter , Helper.encodeURL(url:eprStr))
            }
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result) {
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
        
        
        if let eprString = btnAdvances.titleLabel?.text {

            if eprString == "Open Advances" {
                self.insertOrUpdate(tcrRefNo: tcrNo , travelType: typeOfTravel, bPurpose: pov , places: cv, fromStr: txtFldStartDate.text!, toStr: txtFldEndDate.text!, counter: counter , eprStr: "" )
                
            } else {
                self.insertOrUpdate(tcrRefNo: tcrNo , travelType: typeOfTravel, bPurpose: pov , places: cv, fromStr: txtFldStartDate.text!, toStr: txtFldEndDate.text!, counter: counter ,  eprStr: eprString)
            }
            
        }
        
      
//        self.insertOrUpdate(tcrRefNo: tcrNo , travelType: typeOfTravel, bPurpose: pov , places: cv, fromStr: txtFldStartDate.text!, toStr: txtFldEndDate.text!, counter: counter , )
        
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


