//
//  FileInfo.swift
//  mocs
//
//  Created by Talat Baig on 4/3/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

class FileInfo {
    
    var order = Int()
    var fData : Data?
    var fName =  String()
    var fDesc =  String()
    var fExtension =  String()
    var fUploadState = Bool()
    
    var notifInfo = NotifInfo()
    
}

class NotifInfo {
    
    var notifName = String()
    var notifIdentifier = IndexPath()
}

