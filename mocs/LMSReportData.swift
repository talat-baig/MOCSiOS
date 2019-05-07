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
    let empID: String?
    let totalLeaves: String?
    let usedLeaves: String?
    let balLeaves: String?

    enum CodingKeys : String, CodingKey {
        case empName = "Employee Name"
        case empID = "EmpId"
        case totalLeaves = "Total Leaves"
        case usedLeaves = "Used Leaves"
        case balLeaves = "Balance Leaves"
    }
}
