//
//  Session.swift
//  ServerPackageDescription
//
//  Created by Siming Gu on 2/10/17.
//

import StORM
import MongoDBStORM

class User: MongoDBStORM {

	// Set some properties for the object
	// These properties are reflected in the database table
	var id				: String = ""
	var username		: String = ""
    var password        : String = ""
	var name		    : String = ""
	var phone			: String = ""


	// The name of the database table
	override init() {
		super.init()
		_collection = "users"
	}


	// The mapping that translates the database info back to the object
	override func to(_ this: StORMRow) {
		id				= this.data["_id"] as? String			?? ""
		username		= this.data["username"] as? String		?? ""
        password        = this.data["password"] as? String      ?? ""
		name		    = this.data["name"] as? String		    ?? ""
		phone			= this.data["phone"] as? String			?? ""
	}

}
