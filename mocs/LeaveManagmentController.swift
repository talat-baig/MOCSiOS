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

class LeaveManagmentController: UIViewController , UIGestureRecognizerDelegate{
    
    
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    @IBOutlet weak var txtFldEmpName: SearchTextField!
    @IBOutlet weak var vwTotalLeaves: UIView!
    @IBOutlet weak var btnTotalLeaves: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!

    @IBOutlet weak var txtFldFrom: UITextField!
    @IBOutlet weak var txtFldTo: UITextField!

    @IBOutlet weak var vwDept: UIView!
    
    @IBOutlet weak var vwFilter: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initialSetup()
        
    }
    

    func initialSetup() {
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        self.navigationController?.isNavigationBarHidden = true

        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = false
        vwTopHeader.btnRight.isHidden = false
        vwTopHeader.lblTitle.text = Constant.PAHeaderTitle.LMS
        vwTopHeader.lblSubTitle.isHidden = true
        
        Helper.addBordersToView(view: vwTotalLeaves , borderColor : AppColor.universalHeaderColor.cgColor)
        Helper.addBordersToView(view: vwDept , borderColor : AppColor.lightGray.cgColor, borderWidth : 1)
        Helper.addBordersToView(view: vwFilter, borderColor : AppColor.universalHeaderColor.cgColor)
        Helper.addBordersToView(view: txtFldFrom, borderColor : AppColor.lightGray.cgColor, borderWidth : 1)
        Helper.addBordersToView(view: txtFldTo, borderColor : AppColor.lightGray.cgColor, borderWidth : 1)
        Helper.addBordersToView(view: txtFldEmpName, borderColor : AppColor.lightGray.cgColor, borderWidth : 1)

        btnSubmit.layer.cornerRadius = 5.0

//        txtFldEmpName.filterStrings(self.prodArr)
        
        txtFldEmpName.theme.font = UIFont.systemFont(ofSize: 14)
        txtFldEmpName.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        txtFldEmpName.theme.borderWidth = 1.0
        txtFldEmpName.theme.bgColor = UIColor.white
        
        let imgVwCal = UIImageView(image: UIImage(named: "calender"))
        if let size = imgVwCal.image?.size {
            imgVwCal.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 10.0, height: size.height)
        }
        imgVwCal.contentMode = UIViewContentMode.scaleAspectFit
        
        txtFldFrom.rightView = imgVwCal
        self.txtFldFrom.rightViewMode = UITextFieldViewMode.always
        
//        txtFldTo.rightView = imgVwCal
//        self.txtFldTo.rightViewMode = UITextFieldViewMode.always

    }
    
    
    @IBAction func btnTotalLeavesTapped(_ sender: Any) {
    }
    
    @IBAction func btnDeptTapped(_ sender: Any) {
    }
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
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

