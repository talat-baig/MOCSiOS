//
//  AddNewItineraryVC.swift
//  mocs
//
//  Created by Talat Baig on 9/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NotificationBannerSwift


protocol onItinryAddDelegate: NSObjectProtocol {
    func onOkClick() -> Void
}


class AddNewItineraryVC: UIViewController {
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    weak var currentTxtFld: UITextField? = nil
    
    @IBOutlet var datePickerTool: UIView!
    
    var trfData = TravelRequestData()
    
    var itnryListData : ItineraryListData?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var scrlVw: UIScrollView!
    
    @IBOutlet weak var vwDestination: UIView!
    
    @IBOutlet weak var vwDepDate: UIView!
    
    @IBOutlet weak var vwReturnDate: UIView!
    
    @IBOutlet weak var vwEstdDays: UIView!
    
    @IBOutlet weak var txtFldDest: UITextField!
    
    @IBOutlet weak var txtFldDeptDate: UITextField!
    
    @IBOutlet weak var txtFldRetDate: UITextField!
    
    @IBOutlet weak var txtEstdDays: UITextField!
    
    weak var okItinryAddDelegate : onItinryAddDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        initialSetup()
       
        
        if itnryListData != nil {
            /// Edit
            assignData()
        } else {
            /// Add
//            setupDefaultValues()
        }
    }
    
    func assignData() {
        
        txtFldDest.text = itnryListData?.dest
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let newDepDate = Helper.convertToDate(dateString: (itnryListData?.depDate)!)
        let newRetDate = Helper.convertToDate(dateString: (itnryListData?.retDate)!)

        let modDepDate = dateFormatter.string(from: newDepDate)
        let modRetDate = dateFormatter.string(from: newRetDate)

        txtFldDeptDate.text = modDepDate
        txtFldRetDate.text = modRetDate
        
//        txtFldDeptDate.text = itnryListData?.depDate
        txtEstdDays.text = itnryListData?.estDays
        
    }
    
    func initialSetup() {
    
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Add New Itinerary"
        vwTopHeader.lblSubTitle.isHidden = true
        
        
        Helper.addBordersToView(view: vwDestination)
        Helper.addBordersToView(view: vwDepDate)
        Helper.addBordersToView(view: vwReturnDate)
        Helper.addBordersToView(view: vwEstdDays)
        
        txtFldDeptDate.inputView = datePickerTool
        txtFldRetDate.inputView = datePickerTool
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if currentTxtFld == txtFldDeptDate {
            txtFldDeptDate.text = dateFormatter.string(from: datePicker.date) as String
            //             let startDate = dateFormatter.date(from: txtFldDeptDate.text!)!
        }
        
        
        if currentTxtFld == txtFldRetDate {
            txtFldRetDate.text = dateFormatter.string(from: datePicker.date) as String
            let startDate = dateFormatter.date(from: txtFldDeptDate.text!)!
            
            let endDate = dateFormatter.date(from: txtFldRetDate.text!)!
            
            let estDays =  Helper.daysBetweenDates(startDate:startDate , endDate: endDate)
            txtEstdDays.text = String(format: "%d", estDays)
        }
        
        self.view.endEditing(true)
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        
        datePickerTool.isHidden = true
        self.view.endEditing(true)
    }
    
    
    
    
    @IBAction func btnSubmit(_ sender: Any) {
        
        guard let dest = txtFldDest.text, !dest.isEmpty else {
            Helper.showMessage(message: "Please enter Destination")
            return
        }
        
        guard let depDate = txtFldDeptDate.text, !depDate.isEmpty else {
            Helper.showMessage(message: "Please enter Departure Date")
            return
        }
        
        guard let retDate = txtFldRetDate.text, !retDate.isEmpty else {
            Helper.showMessage(message: "Please enter Return Date")
            return
        }
        
        if self.internetStatus != .notReachable {
            
            self.view.showLoading()
            var url = String()
            var newRecord = [String : Any]()

            
            if itnryListData == nil {
                
                 url = String.init(format: Constant.TRF.ITINERARY_ADD, Session.authKey, trfData.trfId )
                 newRecord = ["Destination": dest, "DepartureDate": depDate, "ReturnDate": retDate] as [String : Any]
                
            } else {
                
                guard let itinId = itnryListData?.ItinID else {
                    Helper.showMessage(message: "Sorry! Unable to process")
                    return
                }
                
                url = String.init(format: Constant.TRF.ITINERARY_UPDATE, Session.authKey, itinId )
                newRecord = ["Destination": dest, "DepartureDate": depDate, "ReturnDate": retDate] as [String : Any]
              
            }
            
            Alamofire.request(url, method: .post, parameters: newRecord, encoding: JSONEncoding.default)
                .responseString(completionHandler: {  response in
                    self.view.hideLoading()
                    debugPrint(response.result.value as Any)
                    
                    let jsonResponse = JSON.init(parseJSON: response.result.value!)
                    print(jsonResponse)
                    
                    if jsonResponse["ServerMsg"].stringValue == "Success" {
                        let success = UIAlertController(title: "Success", message: "Itinerary Added Successfully", preferredStyle: .alert)
                        success.addAction(UIAlertAction(title: "OK", style: .default, handler: {(UIAlertAction) -> Void in
                            
                            if let d = self.okItinryAddDelegate {
                                d.onOkClick()
                            }
                        }))

                        self.navigationController?.popViewController(animated: true)

                    }  else {
                        
                        NotificationBanner(title: "Something Went Wrong!", subtitle: "Please Try again later", style:.info).show()
                    }
                })
        }
    }
    
}



extension AddNewItineraryVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        datePickerTool.isHidden = true
        
        switch textField {
            
        case txtFldDest:
            txtFldDeptDate.becomeFirstResponder()
            
        case txtFldDeptDate:
            txtFldRetDate.becomeFirstResponder()
            self.view.endEditing(true)
            
        default: break
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        currentTxtFld = textField
        if textField == txtFldDeptDate  {
            
            datePickerTool.isHidden = false
            
            let today = Date()
            let tomorrow = Calendar.current.date(byAdding: .day, value: 3, to: today)
            
            datePicker.maximumDate = Date.distantFuture
            datePicker.minimumDate = tomorrow
            
        } else if textField == txtFldRetDate  {
            
            let startDte = txtFldDeptDate.text
            
            if startDte != "" {
                txtFldRetDate.reloadInputViews()
                datePickerTool.isHidden = false
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let newStartDate = dateFormatter.date(from: startDte!)
                datePicker.minimumDate = newStartDate
                datePicker.maximumDate = Date.distantFuture
                
                
            } else {
                
                self.view.makeToast("Please Enter Departure date")
                datePickerTool.isHidden = true
                return false
            }
        }
        
        return true
    }
    
}



extension AddNewItineraryVC: WC_HeaderViewDelegate {
    
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


