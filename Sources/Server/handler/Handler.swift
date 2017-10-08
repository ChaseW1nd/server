//
//  Handler.swift
//  ServerPackageDescription
//
//  Created by Siming Gu on 8/10/17.
//

import PerfectHTTP
import StORM
import PerfectLib

class Handlers {
    
    // Basic "main" handler - simply outputs "Hello, world!"
    static func main(request:HTTPRequest, response:HTTPResponse)->() {
        response.setBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
            response.completed()
        
    }
    
    static func register(request:HTTPRequest, response:HTTPResponse)->() {
        
        let jsonString = request.postBodyString
       
        
        do{
            print(String(describing: jsonString))
            let decoded = try jsonString!.jsonDecode() as? [String:Any]
            print(decoded ?? "null")
            var responseJson = [String:Any]()
//            responseJson["test"] = 0.0
            try response.setBody(json: responseJson)
            
            
            responseJson["type"] = "register"
            let obj = User()
            let username = decoded!["username"]
            try obj.find(["username": username ?? "" ])
        
            

        
            if obj.results.rows[0].data.isEmpty{
             try saveNew(username: username as! String,
                            password: decoded!["password"] as! String,
                            name: decoded!["name"] as! String,
                            phone: decoded!["phone"] as! String)
                
                responseJson["state"] = "successful"
            }else{
                responseJson["state"] = "fail"
            }
            try response.setBody(json:responseJson)
            print(responseJson)
        }catch{
            print(error)
        }
        
        response.completed()
        
    }
    
    static func login(request:HTTPRequest, response:HTTPResponse)->() {
        
        
        
        
        do{
            let session = Session()
            let jsonString = request.postBodyString
            print(String(describing: jsonString))
            let decoded = try jsonString!.jsonDecode() as? [String:Any]
            print(decoded ?? "null")
            let obj = User()
            let username = decoded!["username"]
            let password = decoded!["password"]
            var responseJson = [String:Any]()
            
            responseJson["type"] = "login"
            try obj.find(["username":username ?? "" ,"password":password ?? ""])
        
            if !obj.results.rows[0].data.isEmpty{
                print(obj.id+"login")
                session.userId = obj.id
                let u1 = UUID()
                session.sessionId = u1.string
                responseJson["state"] = "successful"
            }else{
                print("login fail")
                
                responseJson["state"] = "fail"
            }
        
            try response.setBody(json:responseJson)
        }catch{
            print(error)
        }
        response.completed()
        
    }
    
    static func location(request:HTTPRequest, response:HTTPResponse)->(){
        do{
            let jsonString = request.postBodyString
            print(String(describing: jsonString))
            let decoded = try jsonString!.jsonDecode() as? [String:Any]
            print(decoded ?? "null")
            let method = decoded!["method"] as?String ?? ""
            print(method)
            let position = Position()
            let session = Session()
            var responseJson = [String:Any]()
            responseJson["type"] = "getlocation"
            let sessionId = decoded!["sessionId"] as?String ?? ""
            print(sessionId)
            try session.get(sessionId)
            print(session.userId)
            if method == "get"{
                if !session.sessionId.isEmpty{
                    let mcursor = StORMCursor()
                    try position.find(["contactId":session.userId],cursor:mcursor)
//                    try position.get("3333")
                    print(position.contactId)
                    print(mcursor.totalRecords)
                    if mcursor.totalRecords > 0 {
                        responseJson["state"] = "successful"
                        responseJson["positionX"] = position.results.rows[0].data["positionX"]
                        responseJson["positionY"] = position.results.rows[0].data["positionY"]
                    }else{
                        responseJson["state"] = "successful"
                        responseJson["positionX"] = position.positionX
                        responseJson["positionY"] = position.positionY
                    }
                }else{
                    responseJson["state"] = "fail"
                }
                
                    try response.setBody(json:responseJson)
                
                response.completed()
            }else if method == "send"{
                try position.get(session.userId)
                position.positionX = decoded!["positionX"] as! String
                position.positionY = decoded!["positionY"] as! String
                if !position.id.isEmpty{
                    try position.save()
                    responseJson["state"] = "successful"
                }else{
                    responseJson["state"] = "fail"
                }
                
                try response.setBody(json:responseJson)
            }
        }catch{
            print(error)
        }
            response.completed()
        
    }
    
    static func start(request:HTTPRequest, response:HTTPResponse)->() {
        do{
            let jsonString = request.postBodyString
            print(String(describing: jsonString))
            let decoded = try jsonString!.jsonDecode() as? [String:Any]
            print(decoded ?? "null")
            var responseJson = [String:Any]()
            responseJson["type"] = "start"
            let obj = Position()
            let id = decoded!["id"]
            try obj.get(id as! String)
            
            if obj.id.isEmpty{
                do{
                    obj.id = id as! String
                    obj.positionX = decoded!["positionX"] as! String
                    obj.positionY = decoded!["obj.positionY"] as! String
                    obj.contactId = request.param(name: "contactId")!
                    try obj.save();
                }
                catch{
                    print( error)
                }
                responseJson["state"] = "successful"
            }else{
                responseJson["state"] = "fail"
            }
            try response.setBody(json:responseJson)
        }catch{
            print(error)
        }
        response.completed()
    }
    
    static func end(request:HTTPRequest, response:HTTPResponse)->() {
        do{
            let jsonString = request.postBodyString
            print(String(describing: jsonString))
            let decoded = try jsonString!.jsonDecode() as? [String:Any]
            print(decoded ?? "null")
        
            var responseJson = [String:Any]()
            responseJson["type"] = "end"
            let obj = Position()
            let id = decoded!["id"]
            try obj.get(id as! String)
        
            if !obj.id.isEmpty{
                do{
                    obj.id = request.param(name: "id")!
                    try obj.delete();
                }
                catch{
                    print( error)
                }
                responseJson["state"] = "successful"
            }else{
                responseJson["state"] = "fail"
            }
            try response.setBody(json:responseJson)
            response.completed()
        }catch{
              print(error)
        }
    }
    
    static func logout(request:HTTPRequest, response:HTTPResponse)->(){
        
        print(logout)
    }
    
    static func contact(request:HTTPRequest, response:HTTPResponse)->(){
        do{
            let jsonString = request.postBodyString
            print(String(describing: jsonString)+"123")
            let decoded = try jsonString!.jsonDecode() as? [String:Any]
            print(decoded ?? "null"+"12331")
            
            var responseJson = [String:Any]()
            responseJson["type"] = "contact"
        
            let session = Session()
            let user = User()
            let myCursor = StORMCursor()
            try session.get(decoded!["sessionId"] as? String ?? "")
            if !session.sessionId.isEmpty && decoded!["method"] as?String ?? "" == "get" {
                user.id = session.userId
                try user.find(["contactOf":session.userId], cursor: myCursor)
                print(user.results.rows[0].data)
                for i in 0...myCursor.totalRecords {
                    responseJson[String(i)] = user.results.rows[i].data
                }
            }else if !session.sessionId.isEmpty && decoded!["method"] as?String ?? "" == "add" {
                let contact = User()
                let contactName = decoded!["contactName"]
                try contact.find(["contactName":contactName ?? ""])
                let newContact = User()
                newContact.id = contact.results.rows[0].data["id"] as! String
                newContact.contactOf  = session.userId
                try newContact.save()
                responseJson["state"] = "successful"


            }else{
                responseJson["state"] = "fail"
            }
        }catch{
            print(error)
        }
    }

    
}
