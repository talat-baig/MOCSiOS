//
//  SAProdData.swift
//  mocs
//
//  Created by Talat Baig on 3/14/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

struct SAProdData : Decodable {
    
    let lotNo: String?
    let prod: String?
    let sku: String?
    let mode: String?

    enum CodingKeys : String, CodingKey {
        case lotNo = "Lot No"
        case prod = "Product"
        case sku = "SKU"
        case mode = "Mode Of Transport"
    }
    
}
