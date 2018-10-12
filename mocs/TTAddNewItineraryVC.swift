//
//  TTAddNewItineraryVC.swift
//  mocs
//
//  Created by Talat Baig on 10/9/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON


protocol onTTItinryAddDelegate: NSObjectProtocol {
    func onOkClick(itnryObj : TTItineraryListData) -> Void
    func onOkEditClick(itnryObj : TTItineraryListData, index : Int) -> Void
}

class TTAddNewItineraryVC: UIViewController , UIGestureRecognizerDelegate {

    var arrCityList : [String] = []
    
    var depDate : String = ""
    var retDate : String = ""
    
    var arrTravelStatus : [String] = ["Used","Unused"]
    var index = 0
    weak var ttItnry : TTItineraryListData?
    weak var okTTItnryAddDel : onTTItinryAddDelegate?

    @IBOutlet weak var vwTopHeader: WC_HeaderView!

    @IBOutlet weak var stckVwCity: UIStackView!
    weak var currentTxtFld: UITextField? = nil

    @IBOutlet weak var stckVwDateTime: UIStackView!
    
    @IBOutlet weak var vwArrvlCity: UIView!
    @IBOutlet weak var vwDestCity: UIView!
    @IBOutlet weak var vwFlightNum: UIView!
    @IBOutlet weak var vwITATCode: UIView!
    @IBOutlet weak var vwTrvlStatus: UIView!
    
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var txtFlightNum: UITextField!
    
    @IBOutlet weak var txtArrvCity: UITextField!
    
    @IBOutlet weak var txtDepTime: UITextField!
    
    @IBOutlet weak var vwDepDate: UIView!
    @IBOutlet weak var txtITATCode: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    
    @IBOutlet weak var txtTrvlStatus: UITextField!
    @IBOutlet weak var txtDestCity: UITextField!
    
    @IBOutlet var datePickerTool: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var mySubVw: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        initialSetup()
        
        getCityList()
        
        if ttItnry != nil {
            assignDataToFields()
            txtTrvlStatus.isUserInteractionEnabled = true
            btnAdd.setTitle("UPDATE", for: .normal)
        } else {
            txtTrvlStatus.text = "Unused"
            txtTrvlStatus.isUserInteractionEnabled = false
            btnAdd.setTitle("ADD", for: .normal)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let lastView : UIView! = mySubVw.subviews.last
        let height = lastView.frame.size.height
        let pos = lastView.frame.origin.y
        let sizeOfContent = height + pos + 30
        
        scrlVw.contentSize.height = sizeOfContent
    }
    
    func initialSetup() {
        
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Add New Itinerary"
        vwTopHeader.lblSubTitle.isHidden = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        Helper.addBordersToView(view: vwArrvlCity)
        Helper.addBordersToView(view: vwDestCity)
        Helper.addBordersToView(view: vwFlightNum)
        Helper.addBordersToView(view: vwITATCode)
        Helper.addBordersToView(view: vwTrvlStatus)
        
        txtDate.inputView = datePickerTool
        txtDepTime.inputView = datePickerTool
    }
    
    func assignDataToFields() {
        
        txtFlightNum.text = ttItnry?.flightNo
        txtDestCity.text = ttItnry?.destCity
        txtArrvCity.text = ttItnry?.arrvlCity
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let newDate1  = dateFormatter.date(from: (ttItnry?.depDate)!)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let issueDate = dateFormatter.string(from:newDate1!)
        txtDate.text = issueDate
        
//        txtDate.text = ttItnry?.depDate
        
        txtDepTime.text = ttItnry?.depTime
        txtITATCode.text = ttItnry?.itatCode
        txtTrvlStatus.text = ttItnry?.trvlStatus
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        datePickerTool.isHidden = true
        self.view.endEditing(true)
    }
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        
        if datePicker.datePickerMode == .date {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            txtDate.text = dateFormatter.string(from: datePicker.date) as String
            
        } else {
            let timeFormatter = DateFormatter()
            timeFormatter.dateStyle = .none
            timeFormatter.dateFormat = "HH:mm"
            
            txtDepTime.text = timeFormatter.string(from: datePicker.date)
        }
    
        self.view.endEditing(true)
    }
    
    func getCityList() {
        
        var arrCityName: [String] = []

        if internetStatus != .notReachable {
            
            let url = String.init(format: Constant.TT.TT_GET_CITY_LIST, Session.authKey)
            self.view.showLoading()
            
            Alamofire.request(url).responseData(completionHandler: ({ response in
                self.view.hideLoading()
                
                if Helper.isResponseValid(vc: self, response: response.result) {
                    
                    let jsonResponse = JSON(response.result.value)
                    
                    for(_,j):(String,JSON) in jsonResponse{
                       
                        let cityNme = j["cityname"].stringValue
                        arrCityName.append(cityNme)
                    }
                     self.arrCityList = arrCityName
                }
            }))
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @IBAction func btnAddTapped(_ sender: Any) {
        
        let newItinry = TTItineraryListData()
        
        guard  let depCity = txtDestCity.text, !depCity.isEmpty else {
            Helper.showMessage(message: "Please select Departure City")
            return
        }
        
        guard  let arrCity = txtArrvCity.text, !arrCity.isEmpty else {
            Helper.showMessage(message: "Please select Arrival City")
            return
        }
        
        guard  let depDate = txtDate.text, !depDate.isEmpty else {
            Helper.showMessage(message: "Please select Date")
            return
        }
        
        newItinry.flightNo = txtFlightNum.text!
        newItinry.destCity = depCity
        newItinry.arrvlCity = arrCity
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate1  = dateFormatter.date(from: depDate)
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let newDepDate = dateFormatter.string(from:newDate1!)
      
        
        newItinry.depDate = newDepDate
        newItinry.itatCode = txtITATCode.text!
        newItinry.depTime = txtDepTime.text!
        newItinry.trvlStatus = txtTrvlStatus.text!
        
        var messg = String()
        
        if ttItnry != nil {
            messg = "Itinerary Updated Succesfully"
        } else {
            messg = "Itinerary Added Succesfully"
        }
        
        let successAlrt = UIAlertController(title: "Success", message: messg , preferredStyle: .alert)
        
        successAlrt.addAction(UIAlertAction(title: "OK", style: .default, handler: {(UIAlertAction) -> Void in
            
            if let d = self.okTTItnryAddDel {
                
                if self.ttItnry != nil {
                    d.onOkEditClick(itnryObj: newItinry, index:self.index )
                } else {
                    d.onOkClick(itnryObj : newItinry)
                }
            }
            
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(successAlrt, animated: true, completion: nil)
    }
    
    func addDropDwnToDestCityTxtFld() {
      
        let chooseDestCity = DropDown()
        chooseDestCity.anchorView = txtDestCity
        chooseDestCity.dataSource = self.arrCityList
        chooseDestCity.selectionAction = { [weak self] (index, item) in
            self?.txtDestCity.text = item
        }
        chooseDestCity.show()
    }
    
    
    func addDropDwnToArrvlCityTxtFld() {
        
         let chooseArrvlCity = DropDown()
        chooseArrvlCity.anchorView = txtArrvCity
        chooseArrvlCity.dataSource = self.arrCityList
        chooseArrvlCity.selectionAction = { [weak self] (index, item) in
            self?.txtArrvCity.text = item
        }
        chooseArrvlCity.show()
    }
 
    func addDropDwnToTrvlStatusTxtFld() {
        
        let chooseTrvlStatus = DropDown()
        chooseTrvlStatus.anchorView = txtTrvlStatus
        chooseTrvlStatus.dataSource = self.arrTravelStatus
        chooseTrvlStatus.selectionAction = { [weak self] (index, item) in
            self?.txtTrvlStatus.text = item
        }
        chooseTrvlStatus.show()
    }
}

extension TTAddNewItineraryVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
  
        datePickerTool.isHidden = true
        self.handleTap()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        var val = true
        if textField == txtTrvlStatus {
            val = false
        }
        return val
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        var val = true
        currentTxtFld = textField
        
        switch textField {
            
        case txtDate :
            datePicker.datePickerMode = .date
            datePickerTool.isHidden = false
            
            if  depDate != "" && retDate != "" {
                
                datePicker.maximumDate = Helper.convertToDateFormat2(dateString: retDate)
                datePicker.minimumDate = Helper.convertToDateFormat2(dateString: depDate)
                val = true
            } else {
                Helper.showMessage(message: "Please Select Ticket Booking Date and Ticket Expiry Date first")
                val = false
            }
            
        case txtDepTime :
            datePickerTool.isHidden = false
            datePicker.datePickerMode = .time
            datePicker.locale = Locale(identifier: "en_GB")
            datePicker.maximumDate = Date.distantFuture
            datePicker.minimumDate = Date.distantPast
            
        case txtArrvCity :
            self.handleTap()
            addDropDwnToArrvlCityTxtFld()
            val = false
            
        case txtDestCity :
            self.handleTap()
            addDropDwnToDestCityTxtFld()
            val = false
            
        case txtITATCode :
            let scrollPoint:CGPoint = CGPoint(x:0, y:  stckVwCity.frame.origin.y  )
            scrlVw!.setContentOffset(scrollPoint, animated: true)
            val = true
            
        case txtTrvlStatus :
            addDropDwnToTrvlStatusTxtFld()
              
//            let scrollPoint:CGPoint = CGPoint(x:0, y:  stckVwDateTime.frame.origin.y  )
//            scrlVw!.setContentOffset(scrollPoint, animated: true)
            val = false
            
        default :
            val = true
            break
        }
        return val
    }
    
}

extension TTAddNewItineraryVC: WC_HeaderViewDelegate {
    
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
