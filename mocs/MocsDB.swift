////
////  MocsDB.swift
////
////
////  Created by Talat Baig on 5/31/18.
////
//
//import UIKit
//import SQLite
//import Foundation
//
//
//class MocsDB {
//
//    // Can't init is singleton
//    private init() {
//    }
//
//    // MARK: Shared Instance
//    static var shared = MocsDB()
//
//    /// Copy database from app bundle to app directory
//    static func setUpDatabase() {
//
//        /// Move database file from bundle to documents folder
//        let fileManager = FileManager.default
//        let documentsUrl = fileManager.urls(for: .documentDirectory,
//                                            in: .userDomainMask)
//        guard documentsUrl.count != 0 else {
//            /// Could not find documents URL
//            return
//        }
//
//        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("Database.db")
//
//        if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
//            debugPrint("DB does not exist in documents folder")
//
//            let bundleURL = Bundle.main.url(forResource: "Database", withExtension: "db")!
//            do {
//                try fileManager.copyItem(atPath: (bundleURL.path), toPath: finalDatabaseURL.path)
//            } catch let error as NSError {
//                debugPrint("Couldn't copy file to final location! Error:\(error.description)")
//            }
//
//        } else {
//            debugPrint("Database file found at path: \(finalDatabaseURL.path)")
//        }
//    }
//
//    /// Set db connection
//    lazy var db: Connection? = {
//
//        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//        let fullDestPath = URL(fileURLWithPath: destPath).appendingPathComponent("Database.db")
//
//        do {
//            return try Connection(fullDestPath.path)
//        } catch {
//            debugPrint("\n", error)
//        }
//        return nil
//    }()
//
//
//    func getVoucherData(tcrId : String) -> [VoucherData] {
//
//        do {
//
//            guard let stmt = try db?.prepare("SELECT * FROM Voucher WHERE tcrId like '\(tcrId)'") else { return [] }
//
//            var arrVoucher = [VoucherData]()
//
//            for row in stmt {
//
//                if let docName = row[0] as? String, let docPath = row[1] as? String, let docDesc = row[2] as? String, let isDownloaded = row[3] as? Int64, let isUploading = row[4] as? Int64  {
//
//                    let voucherObj = VoucherData()
//
//                    voucherObj.documentName = docName
//                    voucherObj.documentPath = docPath
//                    voucherObj.documentDesc = docDesc
//
//                    let isfUploading = Int(isUploading) == 1 ? true : false
//                    voucherObj.isFileUploading = isfUploading
//
//                    voucherObj.documentDesc = docDesc
//
//                    let isfDownload = Int(isDownloaded) == 1 ? true : false
//                    voucherObj.isFileDownloaded = isfDownload
//
//                    arrVoucher.append(voucherObj)
//                }
//            }
//            return arrVoucher
//        } catch {
//            return []
//        }
//
//    }
//
//    func insertVoucherData(tcrID: String, docName: String, docDesc: String, docFilePath: String, isDownloaded: Bool, isUploading : Bool) -> Bool {
//        var recordFound = false
//
//        do {
//            let selectQuery = ("SELECT * FROM Voucher WHERE documentName like '\(docName)' AND tcrId like '\(tcrID)' LIMIT 1")
//            //
//            guard let stmtSelect = try db?.prepare(selectQuery) else { return false }
//
//            for _ in stmtSelect {
//                recordFound = true
//            }
//
//            if recordFound {
//                do {
//                    guard let stmtUpdate = try db?.prepare("UPDATE Voucher SET isDownloaded = ?, documentDescription = ? , documentPath = ?, WHERE tcrId = ? AND documentName = ?, isUploading = ?") else { return false }
//
//                    try stmtUpdate.run(isDownloaded, docDesc, docFilePath , tcrID, docName, isUploading )
//                    return true
//                } catch {
//                    return false
//                }
//            } else {
//                do {
//                    guard let stmtInsert = try db?.prepare("INSERT INTO Voucher (tcrId, isDownloaded, documentDescription, documentPath, documentName, isUploading) VALUES (?, ?, ?, ?, ?, ?)") else { return false }
//
//                    try stmtInsert.run(tcrID, isDownloaded, docDesc, docFilePath, docName)
//                    return true
//                } catch {
//                    return false
//                }
//            }
//        } catch {
//            return false
//        }
//    }
//
//
//
//}
