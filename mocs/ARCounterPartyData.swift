//
//  ARCounterPartyData.swift
//  mocs
//
//  Created by Talat Baig on 4/4/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class ARCounterPartyData: NSObject {
 
    var cpName = String()

    var company = String()
    var location = String()
    var bVertical = String()

    var totalInvQnty = String()
    var totalInvValue = [AmountDetails]()
    var totalAmtRecieved = [AmountDetails]()
    var amtRecievable = String()
    
}
