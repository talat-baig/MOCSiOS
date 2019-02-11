//
//  LeaveManagmentController.swift
//  mocs
//
//  Created by Talat Baig on 1/7/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SearchTextField
import DropDown

class LeaveManagmentController: UIViewController , UIGestureRecognizerDelegate {
    
    
    var arrDept : [String] = []
    
    var fromDate = Date()
    var toDate = Date()
    var navTitle = ""
    
    var lmsData : [LMSEmpData] = []
    var lmsAllData : [LMSEmpData] = []
    
    
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var vwOuter: UIView!
    @IBOutlet weak var vwEmpHeader: UIView!
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var txtFldEmpName: SearchTextField!
    
    @IBOutlet weak var btnTotalLeaves: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    
    @IBOutlet weak var btnDept: UIButton!
    
    @IBOutlet weak var txtFldFrom: UITextField!
    @IBOutlet weak var txtFldTo: UITextField!
    
    @IBOutlet weak var vwDept: UIView!
    @IBOutlet weak var vwFilter: UIView!
    
    
    @IBOutlet var datePickerTool: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    weak var currentTxtFld: UITextField? = nil
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnRight.isHidden = true  // Hides filter button on the top right
        vwTopHeader.btnBack.isHidden = false  // Hides filter button on the top right
        vwTopHeader.lblTitle.text = Constant.PAHeaderTitle.LMS
        vwTopHeader.lblSubTitle.isHidden = true
        
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.handleTap()
        //        self.initialSetup()
        self.getPendingLeaves()
    }
    
    
    func initialSetup() {
        
        Helper.addBordersToView(view: vwDept , borderColor : AppColor.lightGray.cgColor, borderWidth : 1)
        Helper.addBordersToView(view: txtFldFrom, borderColor : AppColor.lightGray.cgColor, borderWidth : 1)
        Helper.addBordersToView(view: txtFldTo, borderColor : AppColor.lightGray.cgColor, borderWidth : 1)
        Helper.addBordersToView(view: txtFldEmpName, borderColor : AppColor.lightGray.cgColor, borderWidth : 1)
        
        btnSubmit.layer.cornerRadius = 5.0
        btnReset.layer.cornerRadius = 5.0
        btnDept.contentHorizontalAlignment = .left
        
        vwEmpHeader.layer.shadowOpacity = 0.25
        vwEmpHeader.layer.shadowOffset = CGSize(width: 0, height: 2)
        vwEmpHeader.layer.shadowRadius = 1
        vwEmpHeader.layer.shadowColor = UIColor.gray.cgColor
        
        btnTotalLeaves.layer.cornerRadius = 5.0
        btnTotalLeaves.layer.shadowOpacity = 0.25
        btnTotalLeaves.layer.shadowOffset = CGSize(width: 0, height: 2)
        btnTotalLeaves.layer.shadowRadius = 1
        btnTotalLeaves.layer.shadowColor = UIColor.gray.cgColor
        btnTotalLeaves.contentHorizontalAlignment = .center
        btnTotalLeaves.titleLabel?.textAlignment = .center

        txtFldEmpName.theme.font = UIFont.systemFont(ofSize: 14)
        txtFldEmpName.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        txtFldEmpName.theme.borderWidth = 1.0
        txtFldEmpName.theme.bgColor = UIColor.white
        txtFldEmpName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtFldEmpName.frame.height))
        txtFldEmpName.leftViewMode = .always
        
        let imgVwCal1 = UIImageView(image: UIImage(named: "calender"))
        if let size = imgVwCal1.image?.size {
            imgVwCal1.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 10.0, height: size.height)
        }
        imgVwCal1.contentMode = UIViewContentMode.scaleAspectFit
        txtFldFrom.rightView = imgVwCal1
        txtFldFrom.rightViewMode = UITextFieldViewMode.always
        
        txtFldFrom.delegate = self
        txtFldTo.delegate = self
        
        txtFldFrom.inputView = datePickerTool
        txtFldTo.inputView = datePickerTool
        
        let imgVwCal2 = UIImageView(image: UIImage(named: "calender"))
        if let size = imgVwCal2.image?.size {
            imgVwCal2.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 10.0, height: size.height)
        }
        imgVwCal2.contentMode = UIViewContentMode.scaleAspectFit
        txtFldTo.rightView = imgVwCal2
        txtFldTo.rightViewMode = UITextFieldViewMode.always
        
        btnDept.setTitle("Select Department", for: .normal)
    }
    
    @objc func getPendingLeaves() {
        
        
        self.getAllPendingLeaves { (res1) in
            if res1 {
                self.getPendingLeavesByFilter { (res2, tpl) in
                    if res2 {
                        self.lblCount.text = String(format: "%d", tpl)
                        self.txtFldEmpName.filterStrings(self.lmsData.map { $0.empName })
                    } else {
                       
                    }
                }
            } else {

            }
        }
    }
    
    
    @objc func getAllPendingLeaves(comp : @escaping(Bool) -> ()) {
        
        if internetStatus != .notReachable {
            
            var newLMSData : [LMSEmpData] = []
            let url = String.init(format: Constant.LMS.GET_ALL_LEAVES, Session.authKey)
            print("All Pending : ", url)
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                
                if Helper.isResponseValid(vc: self, response: response.result){
                    let jsonResponse = JSON(response.result.value!)
                    let jsonArray = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    self.lmsAllData.removeAll()
                    if jsonArray.count > 0 {
                        
                        for(_,j):(String,JSON) in jsonResponse{
                            let data = LMSEmpData()
                            
                            data.empName = j["Employee Name"].stringValue
                            
                            if j["Reason"].stringValue == "" {
                                data.reason =  "-"
                            } else {
                                data.reason =  j["Reason"].stringValue
                            }
                            
                            data.empId = j["Employee Code"].stringValue
                            data.dept = j["Department"].stringValue
                            data.status = j["Reporting Manager Status"].stringValue
                            data.noOfLeaves = j["Applied Leaves"].stringValue
                            
                            newLMSData.append(data)
                            
                        }
                        self.lmsAllData = newLMSData
                        comp(true)
                    }
                    comp(true)
                } else {
                    comp(false)
                }
            }))
        } else {
            comp(false)
        }
        
    }
    
    
    @objc func getPendingLeavesByFilter( emp : String = "" , dept : String = "" , from : String = ""  , to : String = "" ,comp : @escaping(Bool, Int) -> ()) {
        
        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.LMS.GET_BY_FILTER, Session.authKey, Helper.encodeURL(url:dept) , Helper.encodeURL(url:from) , Helper.encodeURL(url:to) ,  Helper.encodeURL(url:emp))
            print("LMS URL", url)
            self.view.showLoading()
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                
                if Helper.isResponseValid(vc: self, response: response.result) {
                    
                    var lmsData1: [LMSEmpData] = []
                    
                    let jsonResponse = JSON(response.result.value!)
                    let array = jsonResponse.arrayObject as! [[String:AnyObject]]
                    
                    if array.count > 0 {
                        var totalCount : Int = 0
                        for(_,json):(String,JSON) in jsonResponse {
                            
                            let lmsDta = LMSEmpData()
                            let empName = json["Employee Name"].stringValue
                            let dept = json["Department"].stringValue
                            lmsDta.empName = empName
                            lmsDta.dept = dept
                            
                            let totalCnt = json["Total Pending Leaves"].stringValue
                            totalCount =  Int(totalCnt) ?? 0
                            
                            lmsDta.noOfLeaves = json["Applied Leaves"].stringValue
                            lmsDta.empId = json["Employee Code"].stringValue
                            
                            if json["Reason"].stringValue == "" {
                                lmsDta.reason =  "-"
                            } else {
                                lmsDta.reason =  json["Reason"].stringValue
                            }
                            
                            lmsDta.status = json["Reporting Manager Status"].stringValue
                            lmsData1.append(lmsDta)
                        }
                        
                        self.lmsData = lmsData1
                        
                        let arrDep = self.lmsData.map { $0.dept }
                        
                        //                        let uniqueUnordered = Array(Set(arrDep))
                        let uniqueOrdered = Array(NSOrderedSet(array: arrDep))
                        
                        self.arrDept = uniqueOrdered as! [String]
                        
                        comp(true, totalCount)
                    } else {
                        comp(true, 0)
                    }
                } else {
                    comp(false, 0)
                }
            }))
            
        } else {
            Helper.showNoInternetMessg()
            comp(false, 0)
        }
    }
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        if currentTxtFld == txtFldFrom {
            txtFldFrom.text = dateFormatter.string(from: datePicker.date) as String
            fromDate = datePicker.date
        }
        
        if currentTxtFld == txtFldTo {
            txtFldTo.text = dateFormatter.string(from: datePicker.date) as String
            toDate = datePicker.date
        }
        
        self.view.endEditing(true)
    }
    
    @IBAction func btnCancelTapped(sender:UIButton){
        datePickerTool.isHidden = true
        self.view.endEditing(true)
    }
    
    @IBAction func btnTotalLeavesTapped(_ sender: Any) {
        
        if self.lmsAllData.count == 0 {
            self.view.makeToast("No Employee Leave data found")
        } else {
            
            let lmsEmpList = self.storyboard?.instantiateViewController(withIdentifier: "LMSEmployeeListVC") as! LMSEmployeeListVC
            lmsEmpList.arrayList = self.lmsAllData
            self.navigationController?.pushViewController(lmsEmpList, animated: true)
        }
        
    }
    
    @IBAction func btnResetTapped(_ sender: Any) {
        
        if txtFldEmpName?.text != "" || txtFldTo?.text != "" ||  txtFldFrom?.text != "" ||  btnDept?.titleLabel?.text != "" {
            txtFldEmpName.text = ""
            txtFldTo.text = ""
            txtFldFrom.text = ""
            btnDept.setTitle("Select Department", for: .normal)
        }
        
    }
    
    @IBAction func btnDeptTapped(_ sender: Any) {
        
        let dropDown = DropDown()
        dropDown.anchorView = btnDept
        dropDown.dataSource = self.arrDept
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnDept.setTitle(item, for: .normal)
        }
        dropDown.show()
        
        self.handleTap()
    }
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        let empName = txtFldEmpName?.text ?? ""
        
        var dept = ""
        if btnDept.titleLabel?.text == "Select Department" {
            dept =  ""
        } else {
            dept =  btnDept.titleLabel?.text ?? ""
        }
        
        
        let fromDate = txtFldFrom?.text ?? ""
        let toDate = txtFldTo?.text ?? ""
        
        if empName.isEmpty && dept.isEmpty && fromDate.isEmpty && toDate.isEmpty {
            self.view.makeToast("Please Enter at least one Filter")
            return
        } else {
            
            self.getEmpListAndNavigate( empNAme : empName , dept : dept , from : fromDate, to : toDate  )
            //  let lmsEmpList = self.storyboard?.instantiateViewController(withIdentifier: "LMSEmployeeListVC") as! LMSEmployeeListVC
            //  self.navigationController?.pushViewController(lmsEmpList, animated: true)
        }
        
    }
    
    func getEmpListAndNavigate( empNAme : String = "" , dept : String = "" , from : String = "", to : String = ""  ) {
        
        self.getPendingLeavesByFilter(emp :empNAme , dept : dept , from : from, to : to, comp: { res,cnt in
            
            if res {
                let lmsEmpList = self.storyboard?.instantiateViewController(withIdentifier: "LMSEmployeeListVC") as! LMSEmployeeListVC
                lmsEmpList.arrayList = self.lmsData
                self.navigationController?.pushViewController(lmsEmpList, animated: true)
            } else {
                self.view.makeToast("No Employee Leave data found. Try by changing filter")
            }
            
        })
    }
    
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    func enableSubmit() {
        
    }
    
    func validateFilter() {
        
    }
    
}

// MARK: - UITextField delegate methods
extension LeaveManagmentController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        datePickerTool.isHidden = true
        
        if textField == txtFldEmpName {
            self.view.endEditing(true)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        currentTxtFld = textField
        
        if textField == txtFldFrom  {
            
            datePickerTool.isHidden = false
            datePicker.maximumDate = Date.distantFuture
            datePicker.minimumDate = Date.distantPast
            
        } else if textField == txtFldTo  {
            
            let fromDte = txtFldFrom.text
            
            if fromDte != "" {
                txtFldTo.reloadInputViews()
                datePickerTool.isHidden = false
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                
                let newfromDte = dateFormatter.date(from: fromDte!)
                datePicker.minimumDate = newfromDte
                datePicker.maximumDate = Date.distantFuture
            } else {
                
                self.view.makeToast("Please Select From Date First")
                datePickerTool.isHidden = true
                return false
            }
        }
        return true
    }
    
}


/// Mark: - WC_HeaderViewDelegate methods
extension LeaveManagmentController: WC_HeaderViewDelegate {
    
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

