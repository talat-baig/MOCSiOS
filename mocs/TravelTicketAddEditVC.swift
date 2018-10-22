//
//  TravelTicketAddEditVC.swift
//  mocs
//
//  Created by Talat Baig on 9/26/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NotificationCenter
import DropDown
import SwiftyJSON
import Alamofire


protocol getRepMngrDelegate: NSObjectProtocol {
    func getRepMngrFromChild(repMgr : String, empId : String) -> Void
    func getTrvlrNameFromChild(trvlName : String) -> Void
    func getCompDetailsFromChild(compCode : Int, loc : String, compName : String) -> Void
}


class TravelTicketAddEditVC: UIViewController , IndicatorInfoProvider, UIGestureRecognizerDelegate , notifyChilds_UC {
    
    //    var ttData = TravelTicketData()
    weak var ttData : TravelTicketData!
    
    var compResponse : Data?
    var debitAcResponse : Data?
    var trvlModeResposne : Data?
    var guest : String = ""
    
    var arrCompData : [GroupCompany] = []
    var arrTravlrData : [TravellerData] = []
    var arrDebitAcList : [String] = []
    var arrTravlType : [TravelModeType] = []
    
    let chooseTraveller = DropDown()
    let chooseBClass = DropDown()
    let chooseDebitAc = DropDown()
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCompany: UIButton!
    
    @IBOutlet weak var mySubVw: UIView!
    @IBOutlet weak var btnTrvllerName: UIButton!
    
    @IBOutlet weak var vwTravName: UIView!
    
    @IBOutlet weak var txtFldTrvlName: UITextField!
    @IBOutlet weak var swtchGuest: UISwitch!
    
    @IBOutlet weak var swtchPurpose: UISwitch!
    
    @IBOutlet weak var swtchTrvlType: UISwitch!
    
    @IBOutlet weak var btnTrvlMode: UIButton!
    
    @IBOutlet weak var btnTrvlClass: UIButton!
    
    @IBOutlet weak var btnDebtAcNo: UIButton!
    
    @IBOutlet weak var vwTrvlComp: UIView!
    @IBOutlet weak var vwTrvlName: UIView!
    @IBOutlet weak var vwDept: UIView!
    @IBOutlet weak var vwTrvlMode: UIView!
    @IBOutlet weak var vwTrvlClass: UIView!
    @IBOutlet weak var vwDebtAcNme: UIView!
    
    @IBOutlet weak var vwGuest: UIView!
    @IBOutlet weak var lblTrvType: UILabel!
    
    @IBOutlet weak var lblPurpse: UILabel!
    
    @IBOutlet weak var vwTrvType: UIView!
    
    @IBOutlet weak var vwPurpose: UIView!
    
    @IBOutlet weak var stckVw: UIStackView!
    
    @IBOutlet weak var txtDept: UITextField!
    
    @IBOutlet weak var txtDebitAcName: UITextField!
    
    @IBOutlet weak var vwDebtAcName: UIView!
    
    @IBOutlet weak var txtTravelMode: UITextField!
    
    @IBOutlet weak var txtTrvlClass: UITextField!
    
    @IBOutlet weak var txtCompny: UITextField!
    
    var canEditTravellrName : Bool = false
    
    var canEditDebitAc : Bool = false
    
    var repMngrDelegate : getRepMngrDelegate?
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initalSetup()
        
        let ttBase = self.parent as! TTBaseViewController
        ttBase.saveTTAddEditReference(vc: self)
        txtDept.isUserInteractionEnabled = false

        self.arrTravlType = parseAndAssignTravelModeData()
        
        parseAndAssignDebitAc()
        parseAndAssignCompaniesData()
        
        if ttData != nil {
            /// Edit
            assignDataToFields()
            
            // note : First assign data to fields then disable or enable fields
            txtCompny.isEnabled = false
            txtFldTrvlName.isEnabled = false
            txtTravelMode.isEnabled = false
            swtchGuest.isEnabled = false
            swtchTrvlType.isEnabled = false
        } else {
            /// Add
            swtchPurpose.isOn = false
            checkPurposeSwitch()
            
//            parseAndAssignCompaniesData()
            
            swtchGuest.isEnabled = true
            swtchTrvlType.isEnabled = false
            
            txtCompny.isEnabled = true
            txtFldTrvlName.isEnabled = true
            txtTravelMode.isEnabled = true
            swtchTrvlType.isEnabled = true
            
            txtCompny.text = self.arrCompData[0].compName
            self.checkCompanyCodeAndGetTravellerData(compCode: self.arrCompData[0].compCode)
        }
    }
    
    
    func assignDataToFields() {
        
        txtCompny.text = ttData.tCompName
        
        self.getTravllerList(compId: Int(ttData.tCompCode)!, comp: {result in
            
            if result {
                if let d = self.repMngrDelegate {
                    d.getTrvlrNameFromChild(trvlName: self.ttData.trvlrName )
                }

            } else {
                
            }
        })
        
        txtFldTrvlName.text = ttData.trvlrName
        txtDept.text = ttData.trvlrDept
        
        if ttData.trvlrType == "Domestic" {
            swtchTrvlType.isOn = false
        } else {
            swtchTrvlType.isOn = true
        }
        
        lblTrvType.text = ttData.trvlrType
        
        if ttData.trvlrPurpose == "Official" {
            swtchPurpose.isOn = false
        } else {
            swtchPurpose.isOn = true
        }
        
        lblPurpse.text = ttData.trvlrPurpose
        
        if ttData.guest == 1 {
            swtchGuest.isOn = true
        } else {
            swtchGuest.isOn = false
        }
        
        txtTravelMode.text = ttData.trvlrMode
        txtTrvlClass.text = ttData.trvlrClass
        txtDebitAcName.text = ttData.debitACName
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
        guard  let compName = txtCompny.text, !compName.isEmpty else {
            return
        }
        
        let compCode = self.getCompanyCode(item: compName)
        let compLoc = self.getCompanyLoc(item: compName)
//        let trvlrName = txtFldTrvlName.text

        if let d = self.repMngrDelegate {
            d.getCompDetailsFromChild(compCode: compCode, loc: compLoc, compName : compName)
            }
        
        self.view.endEditing(true)
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
        
        Helper.addBordersToView(view: vwTrvlComp)
        Helper.addBordersToView(view: vwDept)
        Helper.addBordersToView(view: vwTrvlMode)
        Helper.addBordersToView(view: vwTrvlName)
        Helper.addBordersToView(view: vwDebtAcNme)
        Helper.addBordersToView(view: vwTrvlClass)
        Helper.addBordersToView(view: vwTrvType)
        Helper.addBordersToView(view: vwPurpose)
        Helper.addBordersToView(view: btnCompany)
        
        btnCompany.contentHorizontalAlignment = .left
        btnTrvllerName.contentHorizontalAlignment = .left
        txtDept.textAlignment = .left
        btnTrvlClass.contentHorizontalAlignment = .left
        btnTrvlMode.contentHorizontalAlignment = .left
        
        swtchGuest.addTarget(self, action: #selector(guestType(mySwitch:)), for: UIControlEvents.valueChanged)
        swtchPurpose.addTarget(self, action: #selector(purposeType(mySwitch:)), for: UIControlEvents.valueChanged)
        swtchTrvlType.addTarget(self, action: #selector(trvType(mySwitch:)), for: UIControlEvents.valueChanged)
       
        
    }
    
    func parseAndAssignCompaniesData(){
        
        var arrCompData: [GroupCompany] = []
        
        guard let compRes = compResponse else {
            return
        }
        
        let responseJson = JSON(compRes)
        
        for(_,j):(String,JSON) in responseJson {
            
            let data = GroupCompany()
            data.compName = j["GroupCompanyName"].stringValue
            data.compCity = j["GroupCompanyCity"].stringValue
            data.debitACName = j["DebitACName"].stringValue
            data.compCode = j["GroupCompanyCode"].intValue
            data.baseCurr = j["GroupCompanyBaseCurrency"].stringValue
            
            if j["Delegation"] == JSON.null {
                data.delegation = false
            } else {
                data.delegation = true
            }
            arrCompData.append(data)
            
        }
        
        self.arrCompData = arrCompData

//        txtCompny.text = self.arrCompData[0].compName
//        self.checkCompanyCodeAndGetTravellerData(compCode: self.arrCompData[0].compCode)
        
    }
    
    func notifyChild(messg: String, success: Bool) {
        
    }
    
    func parseAndAssignDebitAc() {
        
        var arrAcName: [String] = []
        let responseJson = JSON(debitAcResponse!)
        
        for(_,j):(String,JSON) in responseJson{
            let newCurr = j["GroupCompany"].stringValue
            arrAcName.append(newCurr)
        }
        self.arrDebitAcList = arrAcName
    }
    
    
    func parseAndAssignTravelModeData() -> [TravelModeType] {
        
        var trvlModeType = [TravelModeType]()
        
        let jsonObj = JSON(trvlModeResposne)
        
        for(_,j):(String,JSON) in jsonObj {
            let trvlType = TravelModeType()
            trvlType.mode = j["Mode"].stringValue
            
            let jsonTrvlClassObj = j["TravelClasses"].arrayValue
            
            for item in jsonTrvlClassObj {
                
                let bClassName = item["BussinessClassName"].stringValue
                
                print(bClassName)
                trvlType.classes.append(bClassName)
            }
            trvlModeType.append(trvlType)
        }
        return trvlModeType
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
        scrlVw.contentSize = CGSize(width: mySubVw.frame.size.width, height: 840 )
        print(scrlVw.contentSize)
    }
    
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @objc func trvType(mySwitch: UISwitch) {
        if mySwitch.isOn {
            lblTrvType.text = "International"
        } else {
            lblTrvType.text = "Domestic"
        }
    }
    
    @objc func guestType(mySwitch: UISwitch) {
        
        if mySwitch.isOn {
            
            self.guest = "Guest"
            self.txtFldTrvlName.text = ""
            checkCompanyCodeAndGetTravellerData(compCode: 0)
//            txtDept.text = "NA"
            
        } else {            
            guard let compnyTitle = txtCompny.text else {
                return
            }
            self.guest = "Employee"
            let ccode = getCompanyCode(item: compnyTitle)
            checkCompanyCodeAndGetTravellerData(compCode: ccode)
        }
    }
    
    @objc func purposeType(mySwitch: UISwitch) {
        
        if mySwitch.isOn {
            lblPurpse.text = "Personal"
            self.canEditDebitAc = true  // textfld editing is enabled
            if txtDebitAcName.text != "" {
                txtDebitAcName.text = ""
            }
          
        } else {
            lblPurpse.text = "Official"
            self.canEditDebitAc = false  // textfld editing is enabled
            self.view.endEditing(true)
           
        }
    }
    
    
    @IBAction func btnNextTapped(_ sender: Any) {
        
        let home = self.parent as! TTBaseViewController
        home.moveToViewController(at: 1, animated: true)
    }
    
    
    func addDropDownToCompnyTextFld() {
        
        let dropDown = DropDown()
        dropDown.anchorView = txtCompny
        
        let arrComp = self.arrCompData.map { $0.compName }
        dropDown.dataSource = arrComp
        
        dropDown.selectionAction = { [weak self] (index, item) in
            //            self?.btnCompany.setTitle(item, for: .normal)
            self?.txtCompny.text = item
            if (self?.swtchGuest.isOn)! {
                self?.guestType(mySwitch: (self?.swtchGuest)!)
                
            }
            // check if company is delegated
            if !(self?.isCompanyDelegated(item: item))! {
                
                self?.swtchGuest.isOn = false
                self?.swtchGuest.isEnabled = false
                self?.swtchGuest.isUserInteractionEnabled = false
                
                if (self?.swtchGuest.isOn)! {
                    self?.swtchGuest.isOn = false
                }
                
                self?.txtFldTrvlName.text = ""
                self?.canEditTravellrName = false
                self?.txtFldTrvlName.isEnabled = false
                self?.txtDept.text = ""
                
            } else {
                
                self?.swtchGuest.isEnabled = true
                self?.swtchGuest.isUserInteractionEnabled = true
                //                self?.canEditTravellrName = false
                self?.txtFldTrvlName.isEnabled = true
                
                guard let ccode = self?.getCompanyCode(item: item) else {
                    return
                }
                self?.checkCompanyCodeAndGetTravellerData(compCode: ccode)
            }
        }
        dropDown.show()
    }
    
    
   
    
    func checkCompanyCodeAndGetTravellerData(compCode : Int) {
        
        self.getTravllerList(compId: compCode, comp:  { result  in
            
            if result {
                
                if (self.arrTravlrData.count) > 0 {
                    
                    let arrTrvlr = self.arrTravlrData.map { $0.fullName  }
                    
                    if arrTrvlr.count > 0 {
                        self.chooseTraveller.dataSource = arrTrvlr
                        
                        self.txtFldTrvlName.text = arrTrvlr.first
                        self.txtDept.text = self.arrTravlrData[0].dept // Dept
                        self.canEditTravellrName = false //textfld editing is disabled
                        self.view.endEditing(true)
                        self.getReportingMngr(loginId: self.arrTravlrData[0].loginId ,comp: { res, repMngr  in
                            
                            if let d = self.repMngrDelegate {
                                d.getRepMngrFromChild(repMgr: repMngr, empId : self.arrTravlrData[0].empId)
                            }
                            
                        }) // Reporting Mngr
                    } else {
                        self.chooseTraveller.dataSource = []
                        self.txtFldTrvlName.text = ""
                        self.canEditTravellrName = true  // textfld editing is enabled
                        self.txtDept.text = ""
                    }
                }
            } else {
                self.chooseTraveller.dataSource = []
                self.txtDept.text = ""
                self.txtFldTrvlName.text = ""
                self.canEditTravellrName = true  // textfld editing is enabled
                
                if let d = self.repMngrDelegate {
                    d.getRepMngrFromChild(repMgr: "", empId: "" )
                }
            }
        })
        
    }
    
    
    func isCompanyDelegated(item : String) -> Bool {
        
        let compnyObject = self.arrCompData.filter{ $0.compName == item }.first
        guard let compDelegated = compnyObject?.delegation else {
            return false
        }
        return compDelegated
    }
    
    
    
    func getCompanyCode(item : String) -> Int {
        
        let compnyObject = self.arrCompData.filter{ $0.compName == item }.first
        guard let compCode = compnyObject?.compCode else {
            return 0
        }
        return compCode
    }
    
    
    func getCompanyLoc(item : String) -> String {
        
        let compnyObject = self.arrCompData.filter{ $0.compCity == item }.first
        guard let compCity = compnyObject?.compCity else {
            return ""
        }
        return compCity
    }
   
    
//    func getTrvlerEMPId(item : String) -> Int {
//
//        let compnyObject = self.arrTravlrData.filter{ $0.empId == item }.first
//        guard let compCode = compnyObject?.compCode else {
//            return 0
//        }
//        return compCode
//    }
    
    func getTravllerList(compId : Int, comp : @escaping(Bool) -> ()) {
        
        var newArry : [TravellerData] = []
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.TT.TT_GET_TRAVELLER_LIST, Session.authKey, compId)
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result) {
                    
                    let jsonResponse = JSON(response.result.value!);
                    let jsonArray = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    newArry.removeAll()
                    
                    if jsonArray.count > 0 {
                        
                        for(_,j):(String,JSON) in jsonResponse {
                            
                            let data = TravellerData()
                            data.compId = j["CompanyId"].intValue
                            data.refId = j["RefID"].stringValue
                            data.dept = j["Department"].stringValue
                            data.empId = j["EMPID"].stringValue
                            data.loginId = j["LoginID"].stringValue
                            data.fullName = j["FullName"].stringValue
                            newArry.append(data)
                        }
                        self.arrTravlrData = newArry
                        comp(true)
                    } else {
                        comp(false)
                    }
                } else {
                    comp(false)
                }
            }))
        } else {
            Helper.showNoInternetMessg()
            comp(false)
        }
    }
    
    func getReportingMngr(loginId : String,  comp : @escaping (Bool,String) -> ()){
        
        var repMngr = ""
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.TT.TT_GET_REPORTING_MNGR, Session.authKey, loginId)
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                if Helper.isResponseValid(vc: self, response: response.result) {
                    
                    let jsonResponse = JSON(response.result.value)
                    
                    for(_,j):(String,JSON) in jsonResponse{
                        repMngr = j["ReportingManagerName"].stringValue
                    }
                    
                    comp(true,repMngr )
                } else {
                    comp(false,repMngr )
                }
            }))
        } else {
            Helper.showNoInternetMessg()
            comp(false,"")
        }
    }
    
    func checkPurposeSwitch() {
        self.purposeType(mySwitch: swtchPurpose)
    }

    func addDropDownToTrvlModeTxtFld() {
        
        let chooseTrvlMode = DropDown()
        chooseTrvlMode.anchorView = txtTravelMode
        chooseTrvlMode.dataSource = self.arrTravlType.map { $0.mode }
        
        chooseTrvlMode.selectionAction = { [weak self] (index, item) in
            self?.txtTravelMode.text = item
            self?.chooseBClass.dataSource = (self?.arrTravlType[index].classes)!
            self?.txtTrvlClass.text = self?.arrTravlType[index].classes.first
        }
        chooseTrvlMode.show()
    }
    
    func addDropDownToTrvlClass() {
        
        chooseBClass.anchorView = txtTrvlClass
        
        // Edit mode add datasource to travlClass based on trvlMode
        if self.ttData != nil {
            let arrTrlclass = self.arrTravlType.filter{ $0.mode == self.ttData.trvlrMode}.first
            guard let newArr = arrTrlclass?.classes else {
                return
            }
            self.chooseBClass.dataSource = newArr
        }
        
        chooseBClass.selectionAction = { [weak self] (index, item) in
            self?.txtTrvlClass.text = item
        }
        chooseBClass.show()
    }
    
    func addDropDownToDebitAc() {
        
        chooseDebitAc.anchorView = txtDebitAcName
        chooseDebitAc.dataSource = self.arrDebitAcList
        chooseDebitAc.selectionAction = { [weak self] (index, item) in
            self?.txtDebitAcName.text = item
        }
        chooseDebitAc.show()
    }
    
    func addDropDownToTrvlTxtFld() {
        
        chooseTraveller.anchorView = txtFldTrvlName
        chooseTraveller.selectionAction = { [weak self] (index, item) in
            
            self?.txtFldTrvlName.text = item
            
            let dept = self?.arrTravlrData[index].dept
            self?.txtDept.text = dept
            
            var loginId = ""
            var empId = ""
            
            if let loginID = self?.arrTravlrData[index].loginId  {
                loginId = loginID
            }
            
            if let empID = self?.arrTravlrData[index].empId  {
                empId = empID
            }
            
            self?.getReportingMngr(loginId: loginId , comp: { res, repMngr  in
                
                if let d = self?.repMngrDelegate {
                    d.getRepMngrFromChild(repMgr: repMngr, empId : empId)
                }
            })
        }
        chooseTraveller.show()
    }
    
}

extension TravelTicketAddEditVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.handleTap()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        var val : Bool = true
        
        switch textField {
            
            
        case txtCompny :
            addDropDownToCompnyTextFld()
            val = false
            
        case txtFldTrvlName :
            
            if self.canEditTravellrName {
                val = true
            } else {
                self.addDropDownToTrvlTxtFld()
                val = false
            }
            
        case txtTravelMode :
            self.addDropDownToTrvlModeTxtFld()
            val = false
            
        case txtTrvlClass :
            
            if txtTravelMode.text != "" {
                self.addDropDownToTrvlClass()
            } else {
                Helper.showMessage(message: "Please Enter Travel Mode")
            }
            val = false
            
        case txtDebitAcName :
            
            if self.canEditDebitAc {
                val = true
            } else {
                self.addDropDownToDebitAc()
                val = false
            }
            
        default : break
            
        }
        return val
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var val : Bool = true
        if textField == txtFldTrvlName {
            
            if self.canEditTravellrName {
                
                val = true
            } else {
                val = false
            }
        }
        return val
    }
    
}

extension TravelTicketAddEditVC: WC_HeaderViewDelegate {
    
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
