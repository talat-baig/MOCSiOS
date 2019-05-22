//
//  EPBillDetailData.swift
//  mocs
//
//  Created by Talat Baig on 4/8/19.
//  Copyright © 2019 Rv. All rights reserved.
//

import UIKit

struct EPBillDetailData: Decodable {
    
    let descPort: String?
    let loadPort: String?
    let sob: String?
    let eta: String?
    let docsRcvdDate: String?
    let paymentMethod: String?
    let bankName: String?
    let awbNo: String?
    let bnkRefNo: String?
    let docPic: String?
    let stp: String?
    let rtp: String?
    let invQty: String?
    let invVal: String?
    let ccy: String?
    let reason: String?
    let fundsRcptVal: String?

    enum CodingKeys : String, CodingKey {
        
        case descPort = "Descharge Port"
        case loadPort = "Load Port"
        case sob = "SOB"
        case eta = "ETA"
        case docsRcvdDate = "Docs Rcvd Date"
        case paymentMethod = "Payment Method"
        case bankName = "Bank Name"
        case awbNo = "AWBNo"
        case bnkRefNo = "BankRefNo"
        case docPic = "DocPic"
        case stp = "STP"
        case rtp = "RTP"
        case invQty = "Invoice_Qty"
        case invVal = "Invoice_Value"
        case ccy = "CCY"
        case reason = "Reason for Delay"
        case fundsRcptVal = "Funds Receipts Value"
    }

}
