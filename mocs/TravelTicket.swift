//
//  TravelTicket.swift
//  mocs
//
//  Created by Talat Baig on 10/10/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation

struct TravelTicket: Codable {
    
    var refId : String = ""
    var trvlrId : String = ""
    var compName : String = ""
    var compCode : Int = 0
    var compLoc : String = ""
    var guest : Int = 0
    var trvlrName : String = ""
    var trvlrDept : String = ""
    var trvlrRefNum : String = ""
    var trvlPurpose : String = ""
    var trvlType : String = ""
    var trvlMode : String = ""
    var trvlClass : String = ""
    var trvlDebitAc : String = ""
    var trvlCarrier : String = ""
    var trvlTicktNum : String = ""
    var trvlTIssue : String = ""
    var trvlTExpiry : String = ""
    var trvlPNRNum : String = ""
    var trvlCost : String = ""
    var trvlCurrncy : String = ""
    var trvlTicktStatus : String = ""
    var trvlInvoiceNum : String = ""
    var trvlAgent : String = ""
    var trvlAdvance : String = ""
    var trvlComments : String = ""
    var trvlEPRNum : String = ""
    var trvlApprovedBy : String = "" // EmpID
    var trvlPostingStatus : String = ""
    var trvlPostedBy : String = ""
    var trvlPostindDate : String = "2018-10-12"
    var trvlVoucherNum : String = ""
    var trvlCounter : String = ""
    var trvlItinry : [TTItinerary] = []
    var trvVoucher : [TTVoucher] = []

    
    enum CodingKeys : String, CodingKey {
        case refId = "RefID"
        case trvlrId = "TravellerID"
        case compName = "TravellerCompanyName"
        case compCode = "TravellerCompanyCode"
        case compLoc = "TravellerCompanyLocation"
        case guest = "Guest"
        case trvlrName = "TravellerName"
        case trvlrDept = "TravellerDepartment"
        case trvlrRefNum = "TravellerReferenceNo"
        case trvlPurpose = "TravellerPurpose"
        case trvlType = "TravellerType"
        case trvlMode = "TravellerMode"
        case trvlClass = "TravellerClass"
        case trvlDebitAc = "TravellerDebitACName"

        case trvlCarrier = "TravellerCarrier"
        case trvlTicktNum = "TravellerTicketNo"
        case trvlTIssue = "TravellerTicketIssue"
        case trvlTExpiry = "TravellerTicketExpire"
        case trvlPNRNum = "TravellerTicketPNRNo"
        case trvlCost = "TravellerTicketCost"
        case trvlCurrncy = "TravellerTicketCurrency"
        case trvlTicktStatus = "TravellerTicketStatus"
        case trvlInvoiceNum = "TravellerInvoiceNo"
        case trvlAgent = "TravellerTravelAgent"
        case trvlAdvance = "TravellerAdvancePaidStatus"
        case trvlComments = "TravellerRemarks"
        case trvlEPRNum = "TravellerAPRNo"
        case trvlApprovedBy = "TravellerApprovedBy"
        case trvlPostingStatus = "TravellerACPostingStatus"
        case trvlPostedBy = "TravellerPostedBy"
        case trvlPostindDate = "TravellerPostingDate"
        case trvlVoucherNum = "TravellerVoucherNo"
        case trvlCounter = "TravellerCounter"
        case trvlItinry = "TravelItinery"
        case trvVoucher = "TravelItineryVouchers"

        
    }
    
}


struct TTItinerary : Codable {
    
    var itinryId : String = ""
    var trvlRefNum : String = ""
    var depCity : String = ""
    var arrvlCity : String = ""
    var itinryDate : String = ""
    var tItinryStatus : String = ""
    var itinryRefundStatus : String = ""
    var itinryAddedBy : String = ""
    var itinryAddedDate : String = "2018-10-12"
    var itinryModifBy : String = ""
    var itinryModifDate : String = "2018-10-12"
    var itinryCanceldBy : String = ""
    var itinryCanceldDate : String = "2018-10-12"
    var status : String = ""
    var flightNum : String = ""
    var itatCode : String = ""
    var depTime : String = ""
    
    enum CodingKeys : String, CodingKey {
        
        case itinryId = "TravelItineraryID"
        case trvlRefNum = "TravelTravellerReferenceNo"
        case depCity = "TravelItineraryDepartureCity"
        case arrvlCity = "TravelItineraryArrivalCity"
        case itinryDate = "TravelItineraryDate"
        case tItinryStatus = "TravelItineraryStatus"
        case itinryRefundStatus = "TravelItineraryRefundStatus"
        case itinryAddedBy = "Addedby"
        case itinryAddedDate = "Addedbysysdt"
        case itinryModifBy = "Modifiedby"
        case itinryModifDate = "Modifiedsysdt"
        case itinryCanceldBy = "Cancelledby"
        case itinryCanceldDate = "Cancelledsysdt"
        case status = "Status"
        case flightNum = "FlightNumber"
        case itatCode = "ITATcode"
        case depTime = "DepartureTime"
    }
    
}

//public List<TravelTicketVoucher> TravelItineryVouchers { get; set; }

struct TTVoucher : Codable {
    
    var docId : String = ""
    var docModName : String = ""
    var docCompName : String = ""
    var docLoc : String = ""
    var docBU : String = ""
    var docRefNum : String = ""
    var docName : String = ""
    var docDesc : String = ""
    var docPath : String = ""
    var docCategry : String = ""
    var docType : String = ""
    var addedBy : String = ""
    var addedDate : String = ""
    var isDeleted : String = ""
    var cancelldBy : String = ""
    var cancelldDate : String = ""
    var docBckpPath : String = ""
    
    enum CodingKeys : String, CodingKey {
        
        case docId = "DocumentID"
        case docModName = "DocumentModuleName"
        case docCompName = "DocumentCompanyName"
        case docLoc = "DocumentLocation"
        case docBU = "DocumentBusinessUnit"
        case docRefNum = "DocumentReferenceNumber"
        case docName = "DocumentName"
        case docDesc = "DocumentDescription"
        case docPath = "DocumentPhysicalPath"
        case docCategry = "DocumentCategory"
        case docType = "DocumentType"
        case addedBy = "AddedByUser"
        case addedDate = "AddedDate"
        case isDeleted = "IsDeleted"
        case cancelldBy = "CancelledBy"
        case cancelldDate = "CancelledDate"
        case docBckpPath = "DocumentBackupPath"
    }
    
}
