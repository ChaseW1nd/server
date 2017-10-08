//
//  Session.swift
//  ServerPackageDescription
//
//  Created by Siming Gu on 8/10/17.
//

import StORM
import MongoDBStORM

class Session: MongoDBStORM {
    
    // Set some properties for the object
    // These properties are reflected in the database table
    var sessionId                : String = ""
    var userId                   : String = ""
    
    
    // The name of the database table
    override init() {
        super.init()
        _collection = "sessions"
    }
    
    
    // The mapping that translates the database info back to the object
    override func to(_ this: StORMRow) {
        sessionId        = this.data["_sessionId"] as? String        ?? ""
        userId           = this.data["userId"] as? String            ?? ""
    }
    
}
