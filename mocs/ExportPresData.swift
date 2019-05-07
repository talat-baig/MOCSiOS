//
//  ExportPresData.swift
//  mocs
//
//  Created by Talat Baig on 4/8/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

struct ExportPresData: Decodable {
    
    let docID: String?
    let buyrName: String?
    let scNo: String?
    let invNo: String?
    
    enum CodingKeys : String, CodingKey {

        case docID = "Doc Reference Id"
        case buyrName = "Buyer Name"
        case scNo = "Sales Contract Number"
        case invNo = "Invoice Number"
    }
}
