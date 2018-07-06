//
//  AROverallData.swift
//  mocs
//
//  Created by Talat Baig on 4/3/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit


class AmountDetails {
    
    var currency = String()
    var amount =  String()
}

class AROverallData {
    
    var totalInvQnty = String()
    var totalInvValue = [AmountDetails]()
    var totalAmtRecieved = [AmountDetails]()
    var amtRecievable = String()
}
