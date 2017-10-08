//
//  Handler.swift
//  ServerPackageDescription
//
//  Created by Siming Gu on 8/10/17.
//

import PerfectHTTP
import StORM

class Handlers {
    
    // Basic "main" handler - simply outputs "Hello, world!"
    static func main(request:HTTPRequest, response:HTTPResponse)->() {
        response.setBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
            response.completed()
        
    }
    
    static func register(request:HTTPRequest, response:HTTPResponse)->() {
//        response.setBody(string: "<html><title>Hello, world!</title><body>register</body></html>")
//        response.appendBody(string: request.param(name: "username")!)
        var responseJson = [String:Any]()
        responseJson["type"] = "register"
        let obj = User()
        do  {try obj.find(["username":request.param(name: "username") ?? ""])}
        catch{
            print(error)
            
        }
        if obj.id.isEmpty{
            do{try saveNew(username: request.param(name: "username")!, password: request.param(name: "password")!, name: request.param(name: "name")!, phone: request.param(name: "phone")!)}
            catch{
                print( error)
            }
            responseJson["state"] = "successful"
        }else{
            responseJson["state"] = "fail"
        }
        response.completed()
        
    }
    
    static func login(request:HTTPRequest, response:HTTPResponse)->() {
        
        let obj = User()
        let username = request.param(name: "username")
        let password = request.param(name: "password")
        var responseJson = [String:Any]()
        
        responseJson["type"] = "login"
        do  {try obj.find(["username":username ?? "" ,"password":password ?? ""])}
        catch{
            print(error)
            
        }
        if !obj.id.isEmpty{
            print(obj.id+"login")
            
            responseJson["state"] = "successful"
        }else{
            print("login fail")
            
            responseJson["type"] = "fail"
        }
        do{
            try response.setBody(json:responseJson)
        }catch{
            print(error)
        }
        response.completed()
        
    }
    static func location(request:HTTPRequest, response:HTTPResponse)->(){
        let method = request.param(name: "method")
        let obj = Position()
        var responseJson = [String:Any]()
        responseJson["type"] = "getlocation"
        if method == "get"{
            let id = request.param(name:"id") ?? ""
            do{
                try obj.find(["contactId":id ?? "" ])
                
            }catch{
                
            }
            if !obj.id.isEmpty{
                responseJson["state"] = "successful"
                responseJson["positionX"] = obj.positionX
                responseJson["positionY"] = obj.positionY
            }else{
                responseJson["state"] = "fail"
            }
            do{
                try response.setBody(json:responseJson)
            }catch{
                print(error)
            }
            response.completed()
        }else{
            obj.id = request.param(name:"id")!
            obj.positionX = request.param(name:"positionX")!
            obj.positionY = request.param(name:"positionY")!
            if !obj.id.isEmpty{
                responseJson["state"] = "successful"
            }else{
                responseJson["state"] = "fail"
            }
            do{
                try response.setBody(json:responseJson)
            }catch{
                print(error)
            }
            response.completed()
        }
    }
    
    static func start(request:HTTPRequest, response:HTTPResponse)->() {
        var responseJson = [String:Any]()
        responseJson["type"] = "start"
        let obj = Position()
        do  {try obj.find(["id":request.param(name: "id") ?? ""])}
        catch{
            print(error)
            
        }
        if obj.id.isEmpty{
            do{
                obj.id = request.param(name: "id")!
                obj.positionX = request.param(name: "positionX")!
                obj.positionY = request.param(name: "positionY")!
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
        response.completed()
    }
    
    static func end(request:HTTPRequest, response:HTTPResponse)->() {
        var responseJson = [String:Any]()
        responseJson["type"] = "end"
        let obj = Position()
        do  {try obj.find(["id":request.param(name: "id") ?? ""])}
        catch{
            print(error)
            
        }
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
        response.completed()
    }
    
}
