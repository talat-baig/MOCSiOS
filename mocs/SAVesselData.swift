//
//  SAVesselData.swift
//  mocs
//
//  Created by Talat Baig on 3/12/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

struct SAVesselData: Decodable {

    let refID: String?
    let vessel: String?
    let uom: String?
    let shipdQty: String?
    let pol: String?
    let pod: String?
    let currency: String?
    let price: String?
    let value: String?
    let goodsRcvd: String?
    let pendingShipmnt: String?
    let salesContrct: String?
    let buyrName: String?

    enum CodingKeys : String, CodingKey {
        case refID = "Reference No"
        case vessel = "Vessel Name"
        case uom = "UOM"
        case shipdQty = "Shipped Qty (Mt)"
        case pol = "POL"
        case pod = "POD"
        case currency = "Currency"
        case price = "Price"
        case value = "Value"
        case goodsRcvd = "Goods Received Against Shipment(Mt)"
        case pendingShipmnt = "Pending Shipment"
        case salesContrct = "Sales Contract"
        case buyrName = "Buyer Name"
    }

}
