//
//  Delete.swift
//  MongoDBStORM-Demo
//
//  Created by Jonathan Guthrie on 2017-01-11.
//
//

import StORM
import MongoDBStORM




/* =============================================================================================
Deleting object
============================================================================================= */
//func deleteObject(id:String) throws {
//
//
//    // Now we delete the object directly.
//    let deleting = User()
//        do {
//            try deleting.find(["_id":id])
//            if !deleting.id.isEmpty {
//                try deleting.delete()
//            } else if deleting.results.cursorData.totalRecords > 1 {
//                for row in deleting.rows() {
//                    try row.delete()
//                }
//            }
//        } catch {
//            throw error
//        }
//    print("'deleteObject' - Object deleted, id \(id)")
//
//}




/* =============================================================================================
Deleting object
============================================================================================= */
func deleteObjectByID(id:String) throws {


	// Now we create a new object
	// Then we delete by reference
	// This means the object we are deleting has not been loaded into the new instance.
	let objForDelete = User()

	do {
		try objForDelete.get(id)
		try objForDelete.delete()
	} catch {
		throw error
	}
	print("'deleteObjectByID' - Object deleted, id \(objForDelete.id)")
	
}
