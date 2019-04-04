//
//  SABuyerData.swift
//  mocs
//
//  Created by Talat Baig on 3/27/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

struct SABuyerData: Decodable {
    
    
    let refID: String?
    let scNo: String?
    let product: String?
    let quality: String?
    let size: String?
    let brand: String?
    
    enum CodingKeys : String, CodingKey {
        
        case refID = "ASRefID"
        case scNo = "Sales Contract No"
        case product = "Product"
        case quality = "Quality"
        case size = "Size"
        case brand = "Brand"
    }
    
}
