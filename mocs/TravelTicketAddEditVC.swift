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

class TravelTicketAddEditVC: UIViewController , IndicatorInfoProvider, UIGestureRecognizerDelegate {
    
    var ttData = TTData()
    
    var arrCompany = ["Technogen IT Services","Phoenix Global Trade Solutions","Phoenix Global DMCC"]
    var arrTrvlrName = ["Talat","Ravi","Hardik"]
    
    var compResponse : Data?
    var arrCompData : [GroupCompany] = []
    var arrTravlrData : [TravellerData] = []
    
    let chooseTraveller = DropDown()
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCompany: UIButton!
    
    @IBOutlet weak var mySubVw: UIView!
    @IBOutlet weak var btnTrvllerName: UIButton!
    
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
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PRIMARY DETAILS")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initalSetup()
        
        let ttAddEditVC = self.parent as! TTBaseViewController
        ttAddEditVC.saveTTAddEditReference(vc: self)
        
        parseAndAssignCompaniesData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
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
        //        stckVw.frame  = CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height + 200)
        
        Helper.addBordersToView(view: vwTrvlComp)
        Helper.addBordersToView(view: vwDept)
        Helper.addBordersToView(view: vwTrvlMode)
        Helper.addBordersToView(view: vwTrvlName)
        Helper.addBordersToView(view: vwDebtAcNme)
        Helper.addBordersToView(view: vwTrvlClass)
        Helper.addBordersToView(view: vwTrvType)
        Helper.addBordersToView(view: vwPurpose)
        
        
        btnCompany.contentHorizontalAlignment = .left
        btnTrvllerName.contentHorizontalAlignment = .left
        txtDept.textAlignment = .left
        btnTrvlClass.contentHorizontalAlignment = .left
        btnTrvlMode.contentHorizontalAlignment = .left
        
        swtchGuest.addTarget(self, action: #selector(guestType(mySwitch:)), for: UIControlEvents.valueChanged)
        swtchPurpose.addTarget(self, action: #selector(purposeType(mySwitch:)), for: UIControlEvents.valueChanged)
        swtchTrvlType.addTarget(self, action: #selector(trvType(mySwitch:)), for: UIControlEvents.valueChanged)
        
        //        parseAndAssignCompaniesData()
        
    }
    
    func parseAndAssignCompaniesData(){
        
        var arrCompData: [GroupCompany] = []
        
        let responseJson = JSON(compResponse!)
        for(_,j):(String,JSON) in responseJson {
            
            let data = GroupCompany()
            
            data.compName = j["GroupCompanyName"].stringValue
            
            data.compCity = j["GroupCompanyCity"].stringValue
            
            data.compCode = j["GroupCompanyCode"].intValue
            
            data.baseCurr = j["GroupCompanyBaseCurrency"].stringValue
            
            print( j["GroupCompanyName"].stringValue)
            
            if j["Delegation"] == JSON.null {
                data.delegation = false
            } else {
                data.delegation = true
            }
            
            arrCompData.append(data)
            self.arrCompData = arrCompData
        }
        
    }
    
    //
    //    func parseAndAssignTravellerData(){
    //
    //        var arrTrvlDta: [TravellerData] = []
    //
    //        let responseJson = JSON(compResponse!)
    //        for(_,j):(String,JSON) in responseJson {
    //
    //            let data = TravellerData()
    //
    //            data.compName = j["GroupCompanyName"].stringValue
    //
    //            data.compCity = j["GroupCompanyCity"].stringValue
    //
    //            data.compCode = j["GroupCompanyCode"].intValue
    //
    //            data.baseCurr = j["GroupCompanyBaseCurrency"].stringValue
    //
    //            print( j["GroupCompanyName"].stringValue)
    //
    //            if j["Delegation"] == JSON.null {
    //                data.delegation = false
    //            } else {
    //                data.delegation = true
    //            }
    //
    //            arrCompData.append(data)
    //            self.arrCompData = arrCompData
    //        }
    //
    //    }
    //
    //
    //
    
    
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
        scrlVw.contentSize = CGSize(width: mySubVw.frame.size.width, height: 800 )
        
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
            //            lbl.text = "International"
        } else {
            //            lblTrvType.text = "Domestic"
        }
    }
    
    @objc func purposeType(mySwitch: UISwitch) {
        if mySwitch.isOn {
            lblPurpse.text = "Personal"
        } else {
            lblPurpse.text = "Official"
        }
    }
    
    
    @IBAction func btnNextTapped(_ sender: Any) {
        
        let home = self.parent as! TTBaseViewController
        
        home.deptStr = txtDept.text!
        
        home.moveToViewController(at: 1, animated: true)
    }
    
    
    @IBAction func btnCompanyTapped(_ sender: Any) {
        
        let dropDown = DropDown()
        dropDown.anchorView = btnCompany
        
        let arrComp = self.arrCompData.map { $0.compName }
        dropDown.dataSource = arrComp
        
        dropDown.selectionAction = { [weak self] (index, item) in
            
            self?.btnCompany.setTitle(item, for: .normal)
            
            if !(self?.isCompanyDelegated(item: item))! {
                
                self?.swtchGuest.isOn = false
                self?.swtchGuest.isEnabled = false
                self?.swtchGuest.isUserInteractionEnabled = false
                
                self?.btnTrvllerName.setTitle("-", for: .normal)
                self?.btnTrvllerName.isEnabled = false
                self?.txtDept.isUserInteractionEnabled = false
                
            } else {
                
                self?.swtchGuest.isEnabled = true
                self?.swtchGuest.isUserInteractionEnabled = true
                
                self?.btnTrvllerName.isEnabled = true
                self?.txtDept.isUserInteractionEnabled = true
                
                guard let ccode = self?.getCompanyCode(item: item) else {
                    return
                }
                self?.getTravllerList(compId: ccode, comp:  { result  in
                    
                    if result {
                        
                        if (self?.arrTravlrData.count)! > 0 {
                            print(index)
                            
                            let arrTrvlr = self?.arrTravlrData.map { $0.fullName  }
                            
                            guard let newArr = arrTrvlr else {
                                return
                            }
                            
                            
                            if newArr.count > 0 {
                                self?.chooseTraveller.dataSource = newArr
                                self?.btnTrvllerName.setTitle(newArr.first, for: .normal)
                                
                            } else {
                                self?.chooseTraveller.dataSource = []
                                self?.btnTrvllerName.setTitle("-", for: .normal)
                                
                            }
                        }
                    } else {
                        
                    }
                })
                
            }
            
        }
        dropDown.show()
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
                    }
                    self.arrTravlrData = newArry
                    comp(true)
                } else {
                    comp(false)
                }
            }))
        } else {
            Helper.showNoInternetMessg()
            comp(false)
        }
    }
    
    
    @IBAction func btnTrvlrNameTapped(_ sender: Any) {
        
        chooseTraveller.anchorView = btnTrvllerName
        chooseTraveller.selectionAction = { [weak self] (index, item) in
            self?.btnTrvllerName.setTitle(item, for: .normal)
        }
        chooseTraveller.show()
    }
    
    
    
    @IBAction func btnTravelModeTapped(_ sender: Any) {
        
        
    }
    
    
    @IBAction func btnTravelClassTapped(_ sender: Any) {
        
        
    }
    
    
    @IBAction func btnDebitAcNameTapped(_ sender: Any) {
        
        
    }
    
    
    
    
}

extension TravelTicketAddEditVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.handleTap()
        return true
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
