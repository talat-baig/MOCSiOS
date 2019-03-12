//
//  BCRefData.swift
//  mocs
//
//  Created by Talat Baig on 3/11/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

struct BCRefData : Decodable {

    let refID: String?
    let chrgDate: String?
    let chrgAmt: String?
    
    enum CodingKeys : String, CodingKey {
        case refID = "Reference ID"
        case chrgDate = "Charge Date"
        case chrgAmt = "Charge Amount (USD)"
    }
    
}
