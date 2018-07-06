//
//  FilterData.swift
//  mocs
//
//  Created by Talat Baig on 4/10/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit


class Company: NSObject {
    var compName = String()
    var compCode = String()
    var isExpanded = false
}

class Location: NSObject {
    var locName = String()
    var isExpanded = false
}


class DataObject: NSObject {
    
    var name : String?  /// Business name
    var code : String?  /// Business code
    var children : [DataObject]?
    var company : Company?     /// Comp name code
    var location : Location?    /// Loc name

    var isSelect : Bool = false
    
    init(name : String, code : String, children: [DataObject] = [] , company : Company = Company() , location : Location = Location()) {
        self.name = name
        self.code = code
        self.children = children
        self.company = company
        self.location = location
    }
}

