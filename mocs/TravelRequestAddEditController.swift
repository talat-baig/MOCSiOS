//
//  TravelRequestAddEditController.swift
//  mocs
//
//  Created by Talat Baig on 9/12/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Alamofire
import DropDown
import NotificationBannerSwift


protocol onTRFSubmit: NSObjectProtocol {
    func onOkClick() -> Void
}

class TravelRequestAddEditController: UIViewController, IndicatorInfoProvider, UIGestureRecognizerDelegate {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "TRAVEL DETAILS")
    }
    
    var arrCurrency: [String] = [String]()
    
    
    let arrTravelType = ["Flight" , "Hotel", "Rental Car/ Taxi Service", "Travel Advance (if yes, then anticipated trip expenses)"]
    
    weak var okTRFSubmit : onTRFSubmit?
    
    var response:Data?
    
    @IBAction func btnAddItinry(_ sender: Any) {
    }
    weak var trvReqData : TravelRequestData!
    
    var reqNum = ""
    @IBOutlet weak var stckVw: UIStackView!
    @IBOutlet weak var lblReqNo: UILabel!
    @IBOutlet weak var lblEmpName: UILabel!
    @IBOutlet weak var lblEmpCode: UILabel!
    @IBOutlet weak var lblEmpDesgn: UILabel!
    @IBOutlet weak var lblEmpDept: UILabel!
    @IBOutlet weak var lblRepMngr: UILabel!
    
    @IBOutlet weak var lblFlight: UILabel!
    @IBOutlet weak var lblHotel: UILabel!
    @IBOutlet weak var lblRentCar: UILabel!
    @IBOutlet weak var lblTrvlAdv: UILabel!
    
    @IBOutlet weak var vwTrvlArrngmnt: UIView!
    @IBOutlet weak var vwAccmpndBy: UIView!
    @IBOutlet weak var vwReason: UIView!
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    @IBOutlet weak var btnCurrency: UIButton!
    
    @IBOutlet weak var mySubVw: UIView!
    
    @IBOutlet weak var stckVwReasn: UIStackView!
    @IBOutlet weak var txtVwReason: UITextView!
    @IBOutlet weak var btnTermsConditions: UIButton!
    
    @IBOutlet weak var txtFldAmount: UITextField!
    @IBOutlet weak var scrlvw: UIScrollView!
    @IBOutlet var datePickerTool: UIView!
    
    @IBOutlet weak var vwAmt: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var btnAgreeTermsConds: UIButton!
    
    @IBOutlet weak var txtAccmpndBy: UITextView!
    @IBOutlet weak var txtReqDate: UITextField!
    
    @IBOutlet weak var btnFlight: UIButton!
    @IBOutlet weak var btnHotel: UIButton!
    @IBOutlet weak var btnRentCar: UIButton!
    @IBOutlet weak var btnTravelAdv: UIButton!
    
    @IBOutlet weak var lblEnterAmt: UILabel!
    @IBOutlet weak var lblCurrncy: UILabel!
    
    var isTravlAdv = false
    var isFlight = false
    var isHotel = false
    var isRentCar = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup() // Initial UI setup
        disableTnCBtn()  // Disable Terms n Conditions btn
        assignEmpData() // Assign EMployee data from session to UI fields
        
        if trvReqData != nil {
            /// Edit
            vwTopHeader.isHidden = true
            stckVw.frame  = CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height + 200)
            btnSubmit.setTitle("UPDATE",for: .normal)
            assignDataToFields()

        } else {
            /// Add
            disableTravelAdvVw()
            btnSubmit.setTitle("SAVE",for: .normal)
        }
    }
    
    func initialSetup() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        self.navigationController?.isNavigationBarHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Add New Request"
        vwTopHeader.lblSubTitle.isHidden = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        
        txtReqDate.inputView = datePickerTool
        txtVwReason!.layer.borderWidth = 1
        txtVwReason!.layer.borderColor = UIColor.gray.cgColor
        txtAccmpndBy!.layer.borderWidth = 1
        txtAccmpndBy!.layer.borderColor = UIColor.gray.cgColor
        btnTermsConditions.contentHorizontalAlignment = .left
        
        let currentDate = Date()
        
        datePicker.date = currentDate
        datePicker.maximumDate = currentDate
        datePicker.minimumDate = currentDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let modDate = dateFormatter.string(from: currentDate)
        txtReqDate.text = modDate
        
        arrCurrency = Helper.parseAndAssignCurrency()
        
        btnCurrency.layer.cornerRadius = 3
        btnCurrency.layer.borderWidth = 0.5
        btnCurrency.layer.borderColor = AppColor.lightGray.cgColor
        
        txtFldAmount.layer.borderColor = AppColor.lightGray.cgColor
        
        Helper.addBordersToView(view: vwAmt)
    }
    
    
    func assignEmpData() {
        
        lblEmpCode.text = Session.empCode
        lblEmpDept.text = Session.department
        lblEmpDesgn.text = Session.designation
        lblEmpName.text = Session.user
        lblRepMngr.text = Session.reportMngr
        
    }
    
    func assignDataToFields() {
        
        lblReqNo.text = trvReqData.reqNo
      
        let newReqDate = Helper.convertToDate(dateString: trvReqData.reqDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let modDate = dateFormatter.string(from: newReqDate)

        txtReqDate.text = modDate
        
        txtVwReason.text = trvReqData.reason
        txtAccmpndBy.text = trvReqData.accmpnd

        
        let trvArrgnmntStr =  trvReqData.trvArrangmnt
        
        if trvArrgnmntStr != "" {
            
            let strArr = trvArrgnmntStr.components(separatedBy: ",")
            
            for str in strArr {
                
                switch str {
                    
                case "Flight" : isFlight = true
                    break
                case "Hotel" : isHotel = true
                    break
                case "Rental Car / Taxi Service":  isRentCar = true
                    break
                    
                case "Travel Advance" : isTravlAdv = true
                txtFldAmount.text = trvReqData.trvelAdvnce
                btnCurrency.setTitle(trvReqData.currency, for: .normal)
                    break
                    
                default:
                    break
                }
            }
        }
        
        setupArrangmntBtns()
        
        if !isTravlAdv {
            disableTravelAdvVw()
        }
        
    }
    
    func setupArrangmntBtns() {
        
        if isFlight {
            btnFlight.setImage(#imageLiteral(resourceName: "checked_black"), for: .normal)
        }
        
        if isHotel {
            btnHotel.setImage(#imageLiteral(resourceName: "checked_black"), for: .normal)
        }
        
        if isTravlAdv {
            btnTravelAdv.setImage(#imageLiteral(resourceName: "checked_black"), for: .normal)
        }
        
        if isRentCar {
            btnRentCar.setImage(#imageLiteral(resourceName: "checked_black"), for: .normal)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        scrlvw.contentSize = CGSize(width: mySubVw.frame.size.width, height: 1077 )
    }
    
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage {
        
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysTemplate)
    }
    
    
    @IBAction func btnTermsCondTapped(_ sender: Any) {
        
        self.handleTap()
        let tcView = Bundle.main.loadNibNamed("TermsCondistionsView", owner: nil, options: nil)![0] as! TermsCondistionsView
        DispatchQueue.main.async {
            self.navigationController?.view.addMySubview(tcView)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            var keyboardHeight : CGFloat
            keyboardHeight = keyboardRectangle.height
            var contentInset:UIEdgeInsets = self.scrlvw.contentInset
            contentInset.bottom = keyboardHeight
            
            self.scrlvw.isScrollEnabled = true
            self.scrlvw.contentInset = contentInset
        }
    }
    
    
    /// Invoked before hiding keyboard and used to move view down
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrlvw.isScrollEnabled = true
        let contentInset:UIEdgeInsets = .zero
        self.scrlvw.contentInset = contentInset
    }
    
    /// Handle user tap when keyboard is open
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @IBAction func btnDatePickerDone(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtReqDate.text = dateFormatter.string(from: datePicker.date) as String
        self.view.endEditing(true)
    }
    
    @IBAction func btnCancelTapped(sender:UIButton){
        datePickerTool.isHidden = true
        self.view.endEditing(true)
    }
    
    
    @IBAction func checkTermsAndConds(_ sender: Any) {
        
        checkTermsConditionsBtn()
    }
    
    
    @IBAction func btnCurrencyTapped(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = btnCurrency
        dropDown.dataSource = arrCurrency
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.btnCurrency.setTitle(item, for: .normal)
        }
        dropDown.show()
    }
    
    
    @IBAction func btnFlightTapped(_ sender: Any) {
        
        if btnFlight.imageView?.image == #imageLiteral(resourceName: "unchecked_black") {
            btnFlight.setImage(#imageLiteral(resourceName: "checked_black"), for: .normal)
            isFlight = true
        } else {
            isFlight = false
            btnFlight.setImage(#imageLiteral(resourceName: "unchecked_black"), for: .normal)
        }
    }
    
    @IBAction func btnHotelTapped(_ sender: Any) {
        
        if btnHotel.imageView?.image == #imageLiteral(resourceName: "unchecked_black") {
            btnHotel.setImage(#imageLiteral(resourceName: "checked_black"), for: .normal)
            isHotel = true
        } else {
            isHotel = false
            btnHotel.setImage(#imageLiteral(resourceName: "unchecked_black"), for: .normal)
        }
    }
    
    @IBAction func btnRentCarTapped(_ sender: Any) {
        if btnRentCar.imageView?.image == #imageLiteral(resourceName: "unchecked_black") {
            btnRentCar.setImage(#imageLiteral(resourceName: "checked_black"), for: .normal)
            isRentCar = true
        } else {
            isRentCar = false
            btnRentCar.setImage(#imageLiteral(resourceName: "unchecked_black"), for: .normal)
        }
    }
    
    
    @IBAction func btnTravelAdvTapped(_ sender: Any) {
        checktravelExp()
    }
    
    func checktravelExp() {
        
        if btnTravelAdv.imageView?.image == #imageLiteral(resourceName: "unchecked_black") {
            
            isTravlAdv = true
            btnTravelAdv.setImage(#imageLiteral(resourceName: "checked_black"), for: .normal)
            enableTravelAdvVw()
        } else {
            
            isTravlAdv = false
            btnTravelAdv.setImage(#imageLiteral(resourceName: "unchecked_black"), for: .normal)
            disableTravelAdvVw()
        }
        
    }
    
    
    func enableTravelAdvVw() {
        
        self.btnCurrency.isEnabled = true
        txtFldAmount.isUserInteractionEnabled = true
        lblEnterAmt.textColor = .black
        lblCurrncy.textColor = UIColor.black
        Helper.addBordersToView(view: vwAmt)
    }
    
    func disableTravelAdvVw() {
        
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColor.lightGray.cgColor
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true;
        
        lblEnterAmt.textColor = AppColor.lightGray
        lblCurrncy.textColor = AppColor.lightGray
        
        txtFldAmount.isUserInteractionEnabled = false
        if txtFldAmount.text != "" {
            txtFldAmount.text = ""
        }
        
        self.btnCurrency.isEnabled = false
        btnCurrency.titleLabel?.textColor = AppColor.lightGray
        
        if btnCurrency.titleLabel?.text != "" {
            btnCurrency.titleLabel?.text = "-"
        }
    }
    
    func enableTnCBtn() {
        btnSubmit.isEnabled = true
        btnSubmit.alpha = 1.0
    }
    
    func disableTnCBtn() {
        btnSubmit.isEnabled = false
        btnSubmit.alpha = 0.5
    }
    
    func checkTermsConditionsBtn() {
        
        if btnAgreeTermsConds.imageView?.image == #imageLiteral(resourceName: "unchecked_black") {
            btnAgreeTermsConds.setImage(#imageLiteral(resourceName: "checked_black"), for: .normal)
            enableTnCBtn()
            
        } else {
            btnAgreeTermsConds.setImage(#imageLiteral(resourceName: "unchecked_black"), for: .normal)
            disableTnCBtn()
        }
    }
    
    
    @IBAction func btnDone(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtReqDate.text = dateFormatter.string(from: datePicker.date) as String
        self.view.endEditing(true)
    }
    
    
    @IBAction func btnCancel(_ sender: Any) {
        
        datePickerTool.isHidden = true
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        var hotel = String()
        var rentCar = String()
        var flight = String()
        var travAdv = String()
        var arrList : [String] = []
        var newList = String()
        var amnt : String = ""
        var curr : String = ""
        
        self.handleTap()
        
        arrList.removeAll()
        
        if isRentCar || isHotel || isFlight || isTravlAdv {
            
            if isFlight {
                flight = lblFlight.text!
                arrList.append(flight)
            }
            
            if isHotel {
                hotel = lblHotel.text!
                arrList.append(hotel)
            }
            
            if isRentCar {
                rentCar = lblRentCar.text!
                arrList.append(rentCar)
            }
            
            if isTravlAdv {
                
                guard let amt = txtFldAmount.text, !amt.isEmpty else {
                    Helper.showMessage(message: "Enter Amount")
                    return
                }
                amnt = amt
                
                guard let currncy = btnCurrency.titleLabel?.text, !currncy.isEmpty else {
                    Helper.showMessage(message: "Select Currency")
                    return
                }
                
                curr = currncy
                
                travAdv = "Travel Advance"
                arrList.append(travAdv)
            }
            
            newList = arrList.joined(separator: ",")
            print("newList",newList)
        } else {
            
            Helper.showMessage(message: "Please Select Needed Travel Arrangement")
            return
        }
        
       
        
        self.addOrEditRequest(reqNo: reqNum , travArrngStr: newList, amt :  amnt , curr : curr , accmpndBy: txtAccmpndBy.text , reasonStr: txtVwReason.text)
        
        
        
    }
    
    
    
    func addOrEditRequest(reqNo:String = "", travArrngStr :String , amt : String = "", curr : String = "", accmpndBy : String = "" , reasonStr : String = "" ) {
        
        if self.internetStatus != .notReachable {
            
            self.view.showLoading()
            var url = String()
            var newRecord = [String : Any]()
            
            if reqNo == ""  {
                url = String.init(format: Constant.TRF.TRF_ADD, Session.authKey)
            } else {
                url = String.init(format: Constant.TRF.TRF_UPDATE, Session.authKey , trvReqData.trfId)
            }
            
            newRecord = ["ReasonForTravel": reasonStr , "Accompanied": accmpndBy, "TravelArrangement": travArrngStr, "TravelAdvance": amt , "Currency" : curr ] as [String : Any]

            Alamofire.request(url, method: .post, parameters: newRecord, encoding: JSONEncoding.default)
                .responseString(completionHandler: {  response in
                    self.view.hideLoading()
                    debugPrint(response.result.value as Any)
                    
                    let jsonResponse = JSON.init(parseJSON: response.result.value!)
                    
                    if jsonResponse["ServerMsg"].stringValue == "Success" {
                        
                        var messg = String()
                        
                        if self.reqNum != "" {
                            messg = "Request has been Updated Successfully"
                        } else {
                            messg = "Request has been Added Successfully"
                        }
                        
                        let success = UIAlertController(title: "Success", message: messg, preferredStyle: .alert)
                        success.addAction(UIAlertAction(title: "OK", style: .default, handler: {(UIAlertAction) -> Void in
                            
                            if let d = self.okTRFSubmit {
                                d.onOkClick()
                            }
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(success, animated: true, completion: nil)
                    }  else {
                        
                        NotificationBanner(title: "Something Went Wrong!", subtitle: "Please Try again later", style:.info).show()
                    }
                })
        } else {
            Helper.showNoInternetMessg()
        }
    }
    
}

extension TravelRequestAddEditController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        datePickerTool.isHidden = true
        self.view.endEditing(true)
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtReqDate {
            datePickerTool.isHidden = false
        }
        
        if textField == txtFldAmount {
            let scrollPoint:CGPoint = CGPoint(x:0, y:  vwTrvlArrngmnt.frame.origin.y + 30 )
            scrlvw!.setContentOffset(scrollPoint, animated: true)
        }
        
        return true
    }
}

extension TravelRequestAddEditController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == txtVwReason {
            let scrollPoint:CGPoint = CGPoint(x:0, y:  vwReason.frame.origin.y - 20 )
            scrlvw!.setContentOffset(scrollPoint, animated: true)
        }
        
        if textView == txtAccmpndBy {
            let scrollPoint:CGPoint = CGPoint(x:0, y:  vwAccmpndBy.frame.origin.y  )
            scrlvw!.setContentOffset(scrollPoint, animated: true)
        }
        
    }
    
}



extension TravelRequestAddEditController: WC_HeaderViewDelegate {
    
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


