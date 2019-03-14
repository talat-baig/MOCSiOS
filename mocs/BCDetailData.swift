//
//  BCDetailData.swift
//  mocs
//
//  Created by Talat Baig on 3/11/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

struct BCDetailData : Decodable {
    
    var chrgType: String = ""
    var chrgAmt: String = ""
    var currency: String = ""
    var bankName: String = ""
    var bankAccNo: String = ""
    var desc: String = "-"
    var taxVal: String = ""

    enum CodingKeys : String, CodingKey {
        case chrgType = "Charge Type"
        case chrgAmt = "Charge Amount (USD)"
        case currency = "Currency"
        case bankName = "Bank"
        case bankAccNo = "Bank Account Number"
        case desc = "Description"
        case taxVal = "Tax Values (USD)"
    }
}
