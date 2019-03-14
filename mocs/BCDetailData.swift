//
//  BCDetailData.swift
//  mocs
//
//  Created by Talat Baig on 3/11/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

struct BCDetailData : Decodable {
    
    let chrgType: String?
    let chrgAmt: String?
    let currency: String?
    let bankName: String?
    let bankAccNo: String?
    let desc: String?
    let taxVal: String?

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
