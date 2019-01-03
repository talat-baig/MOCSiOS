//
//  SSListData.swift
//  mocs
//
//  Created by Talat Baig on 12/11/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class SSListData: NSObject {
    var company = String()
    var location = String()
    var bVertical = String()
    var totalValUSD = String()   // balance for FPS module
    var totalValue = [AmountDetails]()
    
    var totalPaid = String()
    var totalRequested = String()

}
