//
//  ShipAppProdData.swift
//  mocs
//
//  Created by Talat Baig on 4/4/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

struct ShipAppProdData: Decodable {

    let qty: String?
    let price: String?
    let value: String?
    let blNo: String?
    let blDate: String?
    let saStatus: String?

    enum CodingKeys : String, CodingKey {
        case qty = "Qty(Mt)"
        case price = "Price"
        case value = "Value"
        case blNo = "BLNo"
        case blDate = "BLDate"
        case saStatus = "Shipment Advise Status"
    }
    
}
