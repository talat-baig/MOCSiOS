//
//  AddLeaveData.swift
//  mocs
//
//  Created by Talat Baig on 1/23/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON


struct AddLeaveData: Codable {
    
    var leavId : String = ""
    var shortName : String = ""
    var fromDate : String = ""
    var toDate : String = ""
    var noOfDays : String = ""
    var leaveContact : String = ""
    var remarks : String = ""
//    var approvingMngr : String = ""
    var supportDoc : [TTVoucher] = []
    var delegation : String = ""

    
    enum CodingKeys : String, CodingKey {
        
        case leavId = "LeaveApplicationID"
        case shortName = "LeaveApplicationLeaveShortName"
        case fromDate = "LeaveApplicationFromDate"
        case toDate = "LeaveApplicationToDate"
        case noOfDays = "LeaveApplicationDaysCount"
        case leaveContact = "LeaveApplicationLeaveContact"
//        case approvingMngr = "LeaveApplicationLeaveContact"
        case remarks = "LeaveApplicationRemarks"
        case supportDoc = "LeaveApplicationSupportingDoc"
        case delegation = "LeaveApplicationDelegationWork"
    }
}
