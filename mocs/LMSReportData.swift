//
//  LMSReportData.swift
//  mocs
//
//  Created by Talat Baig on 4/24/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

struct LMSReportData: Decodable {
    
    let empName: String?
    //    let empID: String?
    let totalLeaves: Double?
    let usedLeaves: Double?
    let balLeaves: Double?
    let balLeavesMonth : String?
    let balLeavesYear : String?
    
    enum CodingKeys : String, CodingKey {
        case empName = "LeaveBalanceEmployeeName"
        //        case empID = "EmpId"
        case totalLeaves = "LeaveBalanceTotalLeaves"
        case usedLeaves = "LeaveBalanceUsed"
        case balLeaves = "LeaveBalanceNoOfLeave"
        case balLeavesMonth = "LeaveBalanceMonth"
        case balLeavesYear = "LeaveBalanceYear"
        
    }
}
