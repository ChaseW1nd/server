//
//  Create.swift
//  MongoDBStORM-Demo
//
//  Created by Jonathan Guthrie on 2017-01-11.
//
//

import StORM
import MongoDBStORM


func saveNew(username:String,password:String,name:String,phone:String) throws -> () {

	let obj = User()
	obj.id = obj.newUUID()
	obj.username = username
	obj.password = password
    obj.name = name
    obj.phone = phone
    

	do {
		try obj.save()
	} catch {
		throw error
	}

	print("'saveNew' - Object created with new id of \(obj.id)")
}

func login(username:String,password:String) -> Bool{
    let obj = User()
    
      do  {try obj.find(["username":username,"password":password])}
    catch{
        print(error)
        return false;
    }
    if !obj.id.isEmpty{
        print("login")
        return true
    }else{
        return false
    }
}




