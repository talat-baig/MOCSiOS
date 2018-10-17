//
//  TravelTicketInformationVC.swift
//  mocs
//
//  Created by Talat Baig on 9/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Alamofire
import DropDown


protocol getDatesDelegate: NSObjectProtocol {
    func getDatesFromTicketInfo(bookDate : String, expdate : String) -> Void
}

class TravelTicketInformationVC: UIViewController, IndicatorInfoProvider , UIGestureRecognizerDelegate , notifyChilds_UC {
    
    var carrierResponse : Data?
    var currResponse : Data?
    var trvlAgentResponse : Data?
    var repMngrResponse : Data?
    
    var arrCarrier : [String] = []
    var arrCurrency : [String] = []
    var arrTrvlAgent : [String] = []
    var arrEPRList : [TravelTicktEPR] = []
    var arrRepMngr : [ReportingManager] = []
    
    var empId : String = ""
    
    var startDate = Date()
    var endDate = Date()
    var isRepMngrSelected = false
    
    var ticktsDateDelegate : getDatesDelegate?
    
    weak var trvTcktData : TravelTicketData!
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var stckVw: UIStackView!
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var innerStckVw: UIStackView!
    @IBOutlet weak var mySubVw: UIView!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnCarrier: UIButton!
    
    @IBOutlet weak var txtBookingDate: UITextField!
    @IBOutlet weak var txtExpiryDate: UITextField!
    @IBOutlet weak var txtTicktNo: UITextField!
    @IBOutlet weak var txtTicktPnrNo: UITextField!
    @IBOutlet weak var txtTicktCost: UITextField!
    @IBOutlet weak var txtTrvlStatus: UITextField!
    @IBOutlet weak var txtComments: UITextView!
    @IBOutlet weak var txtInvoiceNo: UITextField!
    
    @IBOutlet weak var switchAdvance: UISwitch!
    
    @IBOutlet weak var btnAdvances: UIButton!
    @IBOutlet weak var btnApprovedBy: UIButton!
    @IBOutlet weak var btnTrvlAgent: UIButton!
    @IBOutlet weak var btnCurrncy: UIButton!
    
    
    @IBOutlet weak var vwCarrier: UIView!
    @IBOutlet weak var vwTicktNo: UIView!
    @IBOutlet weak var vwTicktIssueDte: UIView!
    @IBOutlet weak var vwTicktExpiryDte: UIView!
    @IBOutlet weak var vwPNRNo: UIView!
    @IBOutlet weak var vwtrvlAgent: UIView!
    @IBOutlet weak var vwTrvlStatus: UIView!
    @IBOutlet weak var vwTicktCost: UIView!
    @IBOutlet weak var vwInvoice: UIView!
    @IBOutlet weak var vwApprvdBy: UIView!
    @IBOutlet weak var vwCommnts: UIView!
    
    @IBOutlet weak var vwSelectEPR: UIView!
    @IBOutlet weak var txtCarrier: UITextField!
    
    @IBOutlet weak var txtCurrency: UITextField!
    
    @IBOutlet var datePickerTool: UIView!
    
    @IBOutlet weak var txtTrvlAgent: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var currentTxtFld: UITextField? = nil
    
    @IBOutlet weak var txtEprAmtCurrncy: UITextField!
    
    
    @IBOutlet weak var txtApprvdBy: UITextField!
    
    var repMngr : String = ""
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "TICKET INFORMATION")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initalSetup()
        
        if trvTcktData != nil {
            /// Edit
            assignDataToFields()
            
        } else {
            /// Add
            switchAdvance.isOn = false
            checkSwitchState(mySwitchState:  switchAdvance.isOn )
        }
        
        txtTrvlStatus.isEnabled = false
    }
    
    
    
    func assignDataToFields() {
        
        txtCarrier.text = trvTcktData.carrier
        txtTicktNo.text = trvTcktData.ticktNum
        
        let issueDateStr = trvTcktData.issueDate
        let expDateStr = trvTcktData.expiryDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let newDate1  = dateFormatter.date(from: issueDateStr)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let issueDate = dateFormatter.string(from:newDate1!)
        txtBookingDate.text = issueDate
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd-MMM-yyyy"
        let newDate2  = dateFormatter2.date(from: expDateStr)
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        let expDate = dateFormatter2.string(from:newDate2!)
        
        txtExpiryDate.text = expDate
        
        guard let booking = txtBookingDate.text else {
            return
        }
        
        guard let expiry = txtExpiryDate.text else {
            return
        }
        
        if let d = self.ticktsDateDelegate {
            d.getDatesFromTicketInfo(bookDate: booking, expdate: expiry )
        }
        
        txtTicktPnrNo.text = trvTcktData.ticktPNRNum
        txtTicktCost.text = trvTcktData.ticktCost
        txtCurrency.text = trvTcktData.tCurrency
        
        txtTrvlStatus.text = trvTcktData.ticktStatus
        
        txtTrvlAgent.text = trvTcktData.agent
        txtInvoiceNo.text = trvTcktData.invoiceNum
        txtComments.text = trvTcktData.trvlComments
        
        switchAdvance.isOn = trvTcktData.trvlAdvance
        checkSwitchState(mySwitchState: trvTcktData.trvlAdvance)
        
        if trvTcktData.trvlAprNum == "" {
            btnAdvances.setTitle("Select EPR No.", for: .normal)
        } else {
            btnAdvances.setTitle(trvTcktData.trvlAprNum, for: .normal)
        }
        
        isRepMngrSelected = true
        txtApprvdBy.text = trvTcktData.approvdBy
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let ttBaseVC = self.parent as? TTBaseViewController
        ttBaseVC?.saveTTInfoReference(vc: self)
        
        if !isRepMngrSelected {
            txtApprvdBy.text = ttBaseVC?.repMngr
        }
        
        guard let newEmpId = ttBaseVC?.empID else {
            return
        }
        self.empId = newEmpId
    }
    
    
    func initalSetup() {
        
        
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
        
        Helper.addBordersToView(view: vwTicktIssueDte)
        Helper.addBordersToView(view: vwTrvlStatus)
        Helper.addBordersToView(view: vwTrvlStatus)
        Helper.addBordersToView(view: vwtrvlAgent)
        Helper.addBordersToView(view: vwTicktExpiryDte)
        Helper.addBordersToView(view: vwApprvdBy)
        Helper.addBordersToView(view: vwTicktCost)
        Helper.addBordersToView(view: vwTicktNo)
        Helper.addBordersToView(view: vwCarrier)
        Helper.addBordersToView(view: vwPNRNo)
        Helper.addBordersToView(view: vwInvoice)
        Helper.addBordersToView(view: vwCommnts)
        
        switchAdvance.addTarget(self, action: #selector(isAdvance(mySwitch:)), for: UIControlEvents.valueChanged)
        
        txtBookingDate.inputView = datePickerTool
        txtExpiryDate.inputView = datePickerTool
        
        parseAndAssignCarrierList()
        parseAndAssignCurrencyList()
        parseAndAssignAgentList()
        parseAndAssignRepMngrList()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
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
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    func notifyChild(messg: String, success: Bool) {
        
    }
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if currentTxtFld == txtBookingDate {
            
            //check if expriy date is selected
            if txtExpiryDate.text != "" {
                let expiryDate = Helper.convertToDateFormat2(dateString: txtExpiryDate.text!)

                // Check if Expiry is day greater that Booking/Issue Date
                if self.isDate1GreaterThanDate2(date1: expiryDate , date2: datePicker.date )  {
                    txtBookingDate.text = dateFormatter.string(from: datePicker.date) as String
                    startDate = datePicker.date
                } else {
                    // dont assign booking date value
                    Helper.showMessage(message: "Please Select Booking/Issue date properly. Booking date could not be greater than expiry date")
                }
            } else { // assign date value to booking date txtfld
            txtBookingDate.text = dateFormatter.string(from: datePicker.date) as String
            startDate = datePicker.date
            }
        }
        
        if currentTxtFld == txtExpiryDate {
            txtExpiryDate.text = dateFormatter.string(from: datePicker.date) as String
            endDate = datePicker.date
        }
        self.view.endEditing(true)
        
        guard let booking = txtBookingDate.text, !booking.isEmpty else {
            return
        }
        guard let expiry = txtExpiryDate.text, !expiry.isEmpty  else {
            return
        }
        
        let currntDate = Date()
        let expiryDate = Helper.convertToDateFormat2(dateString: expiry)

        if self.isDate1GreaterThanDate2(date1: expiryDate , date2: currntDate) {
            txtTrvlStatus.text = "Valid"
        } else {
            txtTrvlStatus.text = "Expired"
        }
        
        if let d = self.ticktsDateDelegate {
            d.getDatesFromTicketInfo(bookDate: booking, expdate: expiry )
        }
        
    }
    
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        
        datePickerTool.isHidden = true
        self.view.endEditing(true)
    }
    
    func parseAndAssignCarrierList() {
        
        var arrCarrierNme: [String] = []
        let responseJson = JSON(carrierResponse!)
        
        for(_,j):(String,JSON) in responseJson{
            let newCarr = j["CarrierName"].stringValue
            arrCarrierNme.append(newCarr)
        }
        self.arrCarrier = arrCarrierNme
    }
    
    func parseAndAssignCurrencyList() {
        
        var arrCurr: [String] = []
        let responseJson = JSON(currResponse!)
        
        for(_,j):(String,JSON) in responseJson{
            let newCurr = j["Currency"].stringValue
            arrCurr.append(newCurr)
        }
        self.arrCurrency = arrCurr
    }
    
    func parseAndAssignAgentList() {
        
        var arrAgent: [String] = []
        let responseJson = JSON(trvlAgentResponse!)
        
        for(_,j):(String,JSON) in responseJson{
            let newCurr = j["TravelAgentName"].stringValue
            arrAgent.append(newCurr)
        }
        self.arrTrvlAgent = arrAgent
    }
    
    func parseAndAssignRepMngrList() {
        
        var arrRepMngr: [ReportingManager] = []
        let responseJson = JSON(repMngrResponse!)
        
        for(_,j):(String,JSON) in responseJson {
            
            let newItem = ReportingManager()
            
            newItem.repMngrName = j["ReportingManagerName"].stringValue
            newItem.repMngrId = j["ReportingManager"].stringValue
            
            arrRepMngr.append(newItem)
        }
        self.arrRepMngr = arrRepMngr
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrlVw.contentSize = CGSize(width: mySubVw.frame.size.width, height: 1520 )
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        
        let home = self.parent as! TTBaseViewController
        home.moveToViewController(at: 2, animated: true)
    }
    
    
    @objc func isAdvance(mySwitch: UISwitch) {
        checkSwitchState(mySwitchState:  mySwitch.isOn )
    }
    
    
    func checkSwitchState( mySwitchState : Bool ) {
        
        if mySwitchState {
            btnAdvances.isEnabled = true
            btnAdvances.layer.borderColor = UIColor.lightGray.cgColor
            btnAdvances.layer.borderWidth = 1
        } else {
            btnAdvances.isEnabled = false
            btnAdvances.layer.borderColor = AppColor.lightGray.cgColor
            btnAdvances.layer.borderWidth = 0.5
            btnAdvances.setTitle("Select EPR No.", for: .normal)
            self.txtEprAmtCurrncy.text = ""
        }
    }
    
    func getEPRAdvValue(comp : @escaping(Bool, [TravelTicktEPR]) -> ()) {
        
        var newArr : [TravelTicktEPR] = []
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.TT.TT_GET_EPR_LIST, Session.authKey, self.empId)
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result) {
                    
                    let jsonRes = JSON(response.result.value!)
                    let jsonArray = jsonRes.arrayObject as! [[String:AnyObject]]
                    
                    newArr.removeAll()
                    
                    if jsonArray.count > 0 {
                        
                        for(_,j):(String,JSON) in jsonRes {
                            
                            let newObj = TravelTicktEPR()
                            //                            newObj.eprMainId = j["EmployeePaymentRequestMainID"].stringValue
                            newObj.eprRefId = j["EPRMainReferenceID"].stringValue
                            newObj.eprAmt = j["EPRitemsAmount"].stringValue
                            newObj.eprCurr = j["Currency"].stringValue
                            
                            newArr.append(newObj)
                        }
                        
                    }
                    comp(true, newArr)
                } else {
                    comp(false, newArr)
                }
            }))
        } else {
            Helper.showNoInternetMessg()
            return
        }
        
    }
    
    @IBAction func btnCarrierTapped(_ sender: Any) {
    }
    
    @IBAction func btnCurrencyTapped(_ sender: Any) {
    }
    
    @IBAction func btnTrvlAgentTapped(_ sender: Any) {
    }
    
    
    @IBAction func btnAdvanceTapped(_ sender: Any) {
        
        getEPRAdvValue(comp:  {  (result, arrEprVal) in
            if result {
                if arrEprVal.count > 0 {
                    
                    let chooseEpr = DropDown()
                    chooseEpr.anchorView = self.btnAdvances
                    chooseEpr.dataSource = arrEprVal.map {$0.eprRefId}
                    chooseEpr.selectionAction = { [weak self] (index, item) in
                        self?.btnAdvances.setTitle(item, for: .normal)
                        
                        self?.txtEprAmtCurrncy.text = arrEprVal[index].eprAmt  + " " +  arrEprVal[index].eprCurr
                    }
                    chooseEpr.show()
                } else {
                    Helper.showMessage(message: "No EPR Data found for the Traveller")
                }
            }
        })
    }
    
    
    func addDropDwnToCarrierTxtFld() {
        
        let chooseCarrier = DropDown()
        chooseCarrier.anchorView = txtCarrier
        chooseCarrier.dataSource = self.arrCarrier
        chooseCarrier.selectionAction = { [weak self] (index, item) in
            self?.txtCarrier.text = item
        }
        chooseCarrier.show()
    }
    
    func addDropDwnToCurrencyTxtFld() {
        
        let chooseCurr = DropDown()
        chooseCurr.anchorView = txtCurrency
        chooseCurr.dataSource = self.arrCurrency
        chooseCurr.selectionAction = { [weak self] (index, item) in
            self?.txtCurrency.text = item
        }
        chooseCurr.show()
    }
    
    func addDropDwnToRepMngrTxtFld() {
        
        let chooseApprvdBy = DropDown()
        chooseApprvdBy.anchorView = txtApprvdBy
        chooseApprvdBy.dataSource = self.arrRepMngr.map { $0.repMngrName }
        chooseApprvdBy.selectionAction = { [weak self] (index, item) in
            self?.txtApprvdBy.text = item
            self?.isRepMngrSelected = true
        }
        chooseApprvdBy.show()
    }
    
    func addDropDwnToTrvlAgntTxtFld() {
        
        let chooseAgnt = DropDown()
        chooseAgnt.anchorView = txtTrvlAgent
        chooseAgnt.dataSource = self.arrTrvlAgent
        chooseAgnt.selectionAction = { [weak self] (index, item) in
            self?.txtTrvlAgent.text = item
        }
        chooseAgnt.show()
    }
    
    
    func isDate1GreaterThanDate2( date1 : Date, date2 : Date) -> Bool {
        

        var val = false
        
        let order = Calendar.current.compare(date1, to: date2, toGranularity: .day)
        
        switch order {
            
        case .orderedAscending:
            print("date1 is earlier than date2")
            val = false
            
        case .orderedSame:
            print("The two dates are the same")
            val = true
            
        case .orderedDescending:
            print("date1 is later than date2")
            val = true
        }
        return val
    }
    
    func isTrvlStatusValid(expiry : String ) -> Bool {
        
        let expiryDate = Helper.convertToDateFormat2(dateString: expiry)
        let currntDate = Date()
        
        var val = false
        
        let order = Calendar.current.compare(expiryDate, to: currntDate, toGranularity: .day)
//        switch expiryDate.compare(currntDate) {
        
        switch order {

        case .orderedAscending:
            print("expiryDate is earlier than currntDate")
            val = false
            
        case .orderedSame:
            print("The two dates are the same")
            val = true
            
        case .orderedDescending:
            print("expiryDate is later than currntDate")
            val = true
        }
        return val
    }
    
}


extension TravelTicketInformationVC: UITextFieldDelegate , UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        datePickerTool.isHidden = true
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        var val : Bool = true
        
        currentTxtFld = textField
        
        switch textField {
            
        case txtBookingDate :
            
            datePickerTool.isHidden = false
            datePicker.maximumDate = Date.distantFuture
            datePicker.minimumDate = Date.distantPast
            val = true
            
        case txtExpiryDate :
            
            let startDte = txtBookingDate.text
            
            if startDte != "" {
                
                txtExpiryDate.reloadInputViews()
                datePickerTool.isHidden = false
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let newStartDate = dateFormatter.date(from: startDte!)
                datePicker.minimumDate = newStartDate
                datePicker.maximumDate = Date.distantFuture
                val = true
                
            } else {
                self.view.makeToast("Please enter Booking date")
                datePickerTool.isHidden = true
                
                val = false
            }
            
        case txtCarrier :
            self.addDropDwnToCarrierTxtFld()
            val = false
            
        case txtTrvlAgent :
            self.addDropDwnToTrvlAgntTxtFld()
            val = false
            
        case txtCurrency :
            self.addDropDwnToCurrencyTxtFld()
            val = false
            
        case txtApprvdBy :
            self.addDropDwnToRepMngrTxtFld()
            val = false
            
        case txtTicktPnrNo, txtTicktCost :
            let scrollPoint:CGPoint = CGPoint(x:0, y:  vwTicktNo.frame.origin.y + 20  )
            scrlVw!.setContentOffset(scrollPoint, animated: true)
            
        default : break
        }
        return val
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView ==  txtComments {
            let scrollPoint:CGPoint = CGPoint(x:0, y:  vwSelectEPR.frame.origin.y + 60  )
            scrlVw!.setContentOffset(scrollPoint, animated: true)
        }
    }
    
}





