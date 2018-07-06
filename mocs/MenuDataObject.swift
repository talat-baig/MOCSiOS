//
//  MenuDataObject.swift
//  mocs
//
//  Created by Talat Baig on 6/14/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class MenuDataObject: NSObject {
    
    var name : String?  /// Menu name
    var children : [MenuDataObject]?
    var storybrdName : String
    var vcName : String
    var imageName : UIImage
    var isExpanded : Bool = false
    
    init(name : String, children: [MenuDataObject] = [], storybdNAme : String, vcName : String, imageName : UIImage) {
        self.name = name
        self.children = children
        self.storybrdName = storybdNAme
        self.vcName = vcName
        self.imageName = imageName
    }
    
}
