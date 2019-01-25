//
//  LMSGridData.swift
//  mocs
//
//  Created by Talat Baig on 1/18/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

class LMSGridData: NSObject {

    var typeOfLeave = ""
    var available = ""
    var utilized = ""
    var total = ""
    var leaveBalId = ""
    var isActive = ""
    var lapseStatus = ""
}

//
//[
//    {
//        "LeaveBalanceID":3979,
//        "Leave Type":"AL",
//        "Available Leave":1.00,
//        "Utilized":0.00,
//        "Total Leave":1.00,
//        "LeaveBalanceLapseStatus":"No",
//        "IsActive":"True"
//    }
//]
//[
//    {
//        "LeaveBalanceID":3979,
//        "Leave Type":"AL",
//        "Available Leave":1,
//        "Utilized":0,
//        "Total Leave":1,
//        "LeaveBalanceLapseStatus":"No",
//        "IsActive":"True"
//    }
//]
