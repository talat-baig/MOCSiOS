//
//  CUListData.swift
//  mocs
//
//  Created by Talat Baig on 3/27/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

struct CUListData : Decodable {

    let cpID: String?
    let cpName: String?
    let billed: String?
    let unbilled: String?
    let credLimit: String?
    let AvlCreditLimit: String?
    let payments: String?
    let totalOutstanding: String?
    let currency: String?


    enum CodingKeys : String, CodingKey {
        case cpName = "Counterparty Name"
        case billed = "Billed Purchase"
        case unbilled = "Unbilled Purchase"
        case credLimit = "Credit Limit"
        case AvlCreditLimit = "Available Credit Limit"
        case payments = "Payments"
        case totalOutstanding = "Total Outstanding"
        case currency = "Currency"
        case cpID = "CP ID"
    }
}
