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

class TravelRequestAddEditController: UIViewController, IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "TRAVEL DETAILS")
    }
    
    let arrTravelType = ["Flight" , "Hotel", "Rental Car/ Taxi Service", "Travel Advance (if yes, then anticipated trip expenses)"]
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mySubVw: UIView!

    @IBOutlet weak var btnTermsConditions: UIButton!
    
    @IBOutlet weak var scrlvw: UIScrollView!
    @IBOutlet var datePickerTool: UIView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var btnAgreeTermsConds: UIButton!
    
    @IBOutlet weak var txtReqDate: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        self.navigationController?.isNavigationBarHidden = true
        vwTopHeader.isHidden = true
        
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.lblTitle.text = "Add New Claim"
        vwTopHeader.lblSubTitle.isHidden = true
        
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        txtReqDate.inputView = datePickerTool
        
        btnTermsConditions.contentHorizontalAlignment = .left
        
        let currentDate = Date()
        let formatter = DateFormatter()
        
        datePicker.date = currentDate
        datePicker.maximumDate = currentDate
        datePicker.minimumDate = currentDate

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let modDate = dateFormatter.string(from: currentDate)
        txtReqDate.text = modDate
        
        checkTermsConditionsBtn()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrlvw.contentSize = CGSize(width: mySubVw.frame.size.width, height: 600 )
    }
    
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage {
        
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysTemplate)
    }

    
    @IBAction func btnTermsCondTapped(_ sender: Any) {
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
//            var contentInset:UIEdgeInsets = self.scrlVw.contentInset
//            contentInset.bottom = keyboardHeight
            
//            self.scrlVw.isScrollEnabled = true
//            self.scrlVw.contentInset = contentInset
        }
    }
    
    
    /// Invoked before hiding keyboard and used to move view down
    @objc func keyboardWillHide(notification: NSNotification) {
//        self.scrlVw.isScrollEnabled = true
        let contentInset:UIEdgeInsets = .zero
//        self.scrlVw.contentInset = contentInset
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
    
    
    
    func checkTermsConditionsBtn() {

        if btnAgreeTermsConds.imageView?.image == #imageLiteral(resourceName: "unchecked_black") {
            btnAgreeTermsConds.setImage(#imageLiteral(resourceName: "checked_black"), for: .normal)
            btnSubmit.isEnabled = true
            btnSubmit.alpha = 1.0
            
        } else {
            btnAgreeTermsConds.setImage(#imageLiteral(resourceName: "unchecked_black"), for: .normal)
            btnSubmit.isEnabled = false
            btnSubmit.alpha = 0.5
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
        return true
    }
}


extension TravelRequestAddEditController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return arrTravelType.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let view = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath)
        view.textLabel?.text = arrTravelType[indexPath.row]
        view.imageView?.image = #imageLiteral(resourceName: "checked_black")
        view.imageView?.tag = indexPath.row
//        view.imageView?.frame.size.height = 14
//        view.imageView?.frame.size.width = 14
//        view.imageView?.image = imageWithImage(image: #imageLiteral(resourceName: "checked"), scaledToSize: CGSize(width: 11, height: 11))/
        view.selectionStyle = .none
        view.textLabel?.font = UIFont.systemFont(ofSize: 14)
        view.textLabel?.numberOfLines = 0
        
        
        return view

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.imageView?.image == #imageLiteral(resourceName: "checked_black") {
            cell?.imageView?.image = #imageLiteral(resourceName: "unchecked_black")
        } else {
            
            cell?.imageView?.image = #imageLiteral(resourceName: "checked_black")
        }
        
    }
    
    
   
    
}

extension TravelRequestAddEditController: WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any) {
        
    }
    
    func topMenuLeftButtonTapped(sender: Any) {
        self.presentLeftMenuViewController(sender as AnyObject)
    }
    
    func topMenuRightButtonTapped(sender: Any) {
        self.presentRightMenuViewController(sender as AnyObject)
        
    }
    
}


