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
            responseJson["test"] = 0.0
            try response.setBody(json: responseJson)
            
            
            responseJson["type"] = "register"
            let obj = User()
            let username = decoded!["username"]
            try obj.find(["username": username ?? "" ])
        
            

        
            if obj.id.isEmpty{
             try saveNew(username: username as! String,
                            password: decoded!["password"] as! String,
                            name: decoded!["name"] as! String,
                            phone: decoded!["phone"] as! String)
                
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
        
            if !obj.id.isEmpty{
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
            let position = Position()
            let session = Session()
            var responseJson = [String:Any]()
            responseJson["type"] = "getlocation"
            let sessionId = decoded!["sessionId"] as?String ?? ""
            try session.get(sessionId)
            if method == "get"{
                if !session.sessionId.isEmpty{
                    try position.find(["contactId": session.userId])
                    responseJson["state"] = "successful"
                    responseJson["positionX"] = position.positionX
                    responseJson["positionY"] = position.positionY
                }else{
                    responseJson["state"] = "fail"
                }
                
                    try response.setBody(json:responseJson)
                
                response.completed()
            }else if method == "send"{
                try position.get(session.userId)
                position.id = request.param(name:"id")!
                position.positionX = decoded!["positionX"] as! Double
                position.positionY = decoded!["positionY"] as! Double
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
                    obj.positionX = decoded!["positionX"] as! Double
                    obj.positionY = decoded!["obj.positionY"] as! Double
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
            try obj.find(["id":id!])
        
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
    
}
