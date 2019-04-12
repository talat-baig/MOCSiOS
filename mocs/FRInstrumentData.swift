//
//  FRInstrumentData.swift
//  mocs
//
//  Created by Talat Baig on 4/5/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

struct FRInstrumentData: Decodable {

    let commodity: String?
    let product: String?
    let vessel: String?
    let instVal: String?
    let allInstNo: String?
    let instCur: String?
    let allocNow: String?
    let bal: String?
    let contractNo: String?
    let financeApprvl: String?


    enum CodingKeys : String, CodingKey {

        case commodity = "Commodity"
        case product = "Product"
        case vessel = "Vessel"
        case allInstNo = "Allocated Instrument No"
        case instVal = "Instrument Value"
        case instCur = "Instrument Currency"
        case allocNow = "Allocated Now"
        case bal = "Balance"
        case contractNo = "Contract No"
        case financeApprvl = "Finance Approval"

    }
    
   
}
