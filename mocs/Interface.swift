//
//  Interface.swift
//  mocs
//
//  Created by Admin on 2/21/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import Foundation
protocol onButtonClickListener: NSObjectProtocol{
    func onViewClick(data:AnyObject) -> Void
    func onMailClick(data:AnyObject) -> Void
    func onApproveClick(data:AnyObject) -> Void
    func onDeclineClick(data:AnyObject) -> Void
}
