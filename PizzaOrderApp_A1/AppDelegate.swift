//
//  AppDelegate.swift
//  PizzaOrderApp_A1
//
//  Created by Janasi Rajput on 2026-02-08.
//

import UIKit
import SQLite3

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var databaseName: String = "PizzaDatabase.db"
    var databasePath: String = ""
    var orders: [OrderData] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir = documentPaths[0]
        databasePath = documentsDir.appending("/" + databaseName)
        
        checkAndCreateDatabase()
        readDataFromDatabase()
        return true
    }
    
    func checkAndCreateDatabase() {
        var db: OpaquePointer? = nil
        if sqlite3_open(databasePath, &db) == SQLITE_OK {
            let createTableString = """
            CREATE TABLE IF NOT EXISTS entries (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                deliveryDate TEXT,
                address TEXT,
                size INTEGER,
                meatToppings TEXT,
                vegToppings TEXT,
                avatar TEXT
            )
            """
            var createTableStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
                sqlite3_step(createTableStatement)
                sqlite3_finalize(createTableStatement)
            }
            sqlite3_close(db)
        }
    }
    func saveImageToDisk(image: UIImage, fileName: String) {
        let fileManager = FileManager.default
        // Finds the app's document folder
        guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let imagePath = documentsPath.appendingPathComponent(fileName)
        
        // Converts the image to data and writes it to the file path
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            try? imageData.write(to: imagePath)
        }
    }
    
    func insertIntoDatabase(order: OrderData) -> Bool {
        var db: OpaquePointer? = nil
        var returnCode: Bool = true
        
        if sqlite3_open(databasePath, &db) == SQLITE_OK {
            var insertStatement: OpaquePointer? = nil
            let insertString = "INSERT INTO entries (deliveryDate, address, size, meatToppings, vegToppings, avatar) VALUES (?, ?, ?, ?, ?, ?)"
            
            if sqlite3_prepare_v2(db, insertString, -1, &insertStatement, nil) == SQLITE_OK {
                
                // We convert to NSString, then get the raw utf8String pointer for SQLite
                sqlite3_bind_text(insertStatement, 1, ((order.deliveryDate ?? "") as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, ((order.address ?? "") as NSString).utf8String, -1, nil)
                
                // Int32 is used for integers
                sqlite3_bind_int(insertStatement, 3, Int32(order.size ?? 0))
                
                sqlite3_bind_text(insertStatement, 4, ((order.meatToppings ?? "") as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 5, ((order.vegToppings ?? "") as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 6, ((order.avatar ?? "") as NSString).utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) != SQLITE_DONE {
                    returnCode = false
                }
                sqlite3_finalize(insertStatement)
            }
            sqlite3_close(db)
        } else {
            returnCode = false
        }
        
        readDataFromDatabase()
        return returnCode
    }
    
    func readDataFromDatabase() {
        orders.removeAll()
        var db: OpaquePointer? = nil
        
        if sqlite3_open(databasePath, &db) == SQLITE_OK {
            var queryStatement: OpaquePointer? = nil
            let queryString = "SELECT * FROM entries"
            
            if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    let id = Int(sqlite3_column_int(queryStatement, 0))
                    
                    // SAFE UNWRAPPING: Check if column is null before calling String(cString:)
                    let date = sqlite3_column_text(queryStatement, 1) != nil ? String(cString: sqlite3_column_text(queryStatement, 1)!) : ""
                    let addr = sqlite3_column_text(queryStatement, 2) != nil ? String(cString: sqlite3_column_text(queryStatement, 2)!) : ""
                    let size = Int(sqlite3_column_int(queryStatement, 3))
                    let meat = sqlite3_column_text(queryStatement, 4) != nil ? String(cString: sqlite3_column_text(queryStatement, 4)!) : ""
                    let veg = sqlite3_column_text(queryStatement, 5) != nil ? String(cString: sqlite3_column_text(queryStatement, 5)!) : ""
                    let av = sqlite3_column_text(queryStatement, 6) != nil ? String(cString: sqlite3_column_text(queryStatement, 6)!) : ""
                    
                    let data = OrderData()
                    data.initWithData(
                        theRow: id,
                        theDate: date,
                        theAddress: addr,
                        theSize: size,
                        theMeat: meat,
                        theVeg: veg,
                        theAvatar: av
                    )
                    orders.append(data)
                }
                sqlite3_finalize(queryStatement)
            }
            sqlite3_close(db)
        }
    }
}
