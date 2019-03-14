//
//  SARefData.swift
//  mocs
//
//  Created by Talat Baig on 3/12/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

struct SARefData : Decodable {
    
    let refID: String?
    let suppName: String?
    let addDate: String?
    let purContract: String?

    enum CodingKeys : String, CodingKey {
        case refID = "RSA Reference Id"
        case suppName = "Supplier Name"
        case addDate = "Advise Date"
        case purContract = "Purchase Contract"

    }
 
}
