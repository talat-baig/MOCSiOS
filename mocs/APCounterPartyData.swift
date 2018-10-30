//
//  APCounterPartyData.swift
//  mocs
//
//  Created by Talat Baig on 10/29/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class APCounterPartyData: NSObject {
    
    var cpName = String()
    var company = String()
    var location = String()
    var bVertical = String()
    var balPayable = String()
    var totalInvValue = [AmountDetails]()
    var paidTillDate = String()
}
