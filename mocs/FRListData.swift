//
//  FRListData.swift
//  mocs
//
//  Created by Talat Baig on 4/5/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

struct FRListData: Decodable {

    let trnsDate: String?
    let refID: String?
    let remBank: String?
    let remAccnt: String?
    let remTo: String?
    let remToBnk: String?
    let remToAC: String?
    let modeOfRem: String?
    let remCurr: String?
    let remAmt: String?
    let remCharges: String?
    let remCCY: String?
    let currPair: String?
    let fxRate: String?
    let curr: String?
    let reason: String?
    let remAmtFCY: String?

    enum CodingKeys : String, CodingKey {
        
        case trnsDate = "Transaction Date"
        case refID = "Reference ID"
        case remBank = "Remitting Bank"
        case remAccnt = "Remitting A/c"
        case remTo = "Remitted To"
        case remToBnk = "Remitted to Bank"
        case remToAC = "Remitted to A/c"
        case modeOfRem = "Mode of Remittance"
        case remCurr = "Remit Cur"
        case remAmt = "Remit Amount (net)"
        case remCharges = "Total Remittance Charges /CCY"
        case remCCY = "Total Remittance CCY"
        case remAmtFCY = "Remitted Amount (FCY)"
        case currPair = "Currency Pair"
        case fxRate = "FX Rate"
        case curr = "Cur"
        case reason = "Reason For Remittance"
    }
   
}
