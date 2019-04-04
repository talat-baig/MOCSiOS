//
//  ShipAppData.swift
//  mocs
//
//  Created by Talat Baig on 3/27/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

struct ShipAppData: Decodable {
    
    let refID: String?
    let compName: String?
    let bussVert: String?
    let location: String?
    let commodity: String?
    let buyrName: String?

    enum CodingKeys : String, CodingKey {
        case refID = "Reference ID"
        case compName = "Company Name"
        case location = "Location"
        case bussVert = "Business Vertical"
        case commodity = "Commodity"
        case buyrName = "Buyer Name"
    }
}
