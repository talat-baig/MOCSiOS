//
//  DetailsController.swift
//  mocs
//
//  Created by Admin on 3/13/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import SwiftyJSON

/// Employee Details Screen
class DetailsController: UIViewController {
    
    /// Variable of type Data
    var response:Data!
    
    /// Employee Id as String
    var empId : String = ""
    
    /// Label Employee name
    @IBOutlet weak var txtEmpName: UILabel!
    
    /// Label Company
    @IBOutlet weak var txtCompany: UILabel!
    
    /// Label Department
    @IBOutlet weak var txtDepartment: UILabel!
    
    /// Label Email
    @IBOutlet weak var txtEmail: UILabel!
    
    /// Label for Mobile 1
    @IBOutlet weak var txtMobile1: UILabel!
    
    /// Label for Mobile 2
    @IBOutlet weak var txtMobile2: UILabel!
    
    /// Top Header View
    @IBOutlet weak var vwTopHeader: WC_HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwTopHeader.delegate = self
        vwTopHeader.btnLeft.isHidden = true
        vwTopHeader.btnRight.isHidden = true
        vwTopHeader.btnBack.isHidden = false
        
        vwTopHeader.lblTitle.text = "Employee ID"
        vwTopHeader.lblSubTitle.text = empId
        parseResponse(response: response)
    }
 
    /// Method to parse json response data and assign to UI elements
    func parseResponse(response:Data) {
        
        let jsonObj = JSON(response)
        for(_,j):(String,JSON) in jsonObj{
            txtEmpName.text = j["Employee Name"].stringValue
            txtCompany.text = j["Group Company"].stringValue
            txtDepartment.text = j["Department"].stringValue
            txtEmail.text = j["Official Email"].stringValue
            txtMobile1.text = j["Mobile 1"].stringValue
            txtMobile2.text = j["Mobile 2"].stringValue
        }
    }
    
}

// MARK: - WC_HeaderViewDelegate methods
extension DetailsController: WC_HeaderViewDelegate {
    
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

