
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

import StORM
import MongoDBStORM
import PerfectTurnstileMongoDB
import PerfectRequestLogger
import TurnstilePerfect

//StORMdebug = true
//RequestLogFile.location = "./requests.log"

// Used later in script for the Realm and how the user authenticates.
//let pturnstile = TurnstilePerfectRealm()


// Set the connection variables
MongoDBConnection.host = "localhost:27017"
MongoDBConnection.database = "perfect_testing"
// MongoDBConnection.authmode = .standard
// MongoDBConnection.username = "simingdb"
//MongoDBConnection.password = "NW7eChuv9p7TblBWvrZ7hIxBf26kR6pWcELTNlTXVDlsgGcGI7RHsqb1ESkpLVlOhDlS1qYZPEi1d53zqmnOyw=="
// Connect the AccessTokenStore
//tokenStore = AccessTokenStore()

// Create HTTP server.
let server = HTTPServer()

// Register routes and handlers
//let authWebRoutes = makeWebAuthRoutes()
//let authJSONRoutes = makeJSONAuthRoutes("/api/v1")

// Add the routes to the server.
//server.addRoutes(authWebRoutes)
//server.addRoutes(authJSONRoutes)

// Adding a test route
var routes = Routes()
//routes.add(method: .get, uri: "/api/v1/test", handler: AuthHandlersJSON.testHandler)
routes.add(method: .get, uri: "/test", handler: Handlers.main)
routes.add(method: .get, uri: "/register", handler: Handlers.register)
routes.add(method: .get, uri: "/location", handler: Handlers.location)
routes.add(method: .get, uri: "/login", handler: Handlers.login)
routes.add(method: .get, uri: "/logout", handler: Handlers.main)
routes.add(method: .get, uri: "/start", handler: Handlers.start)
routes.add(method: .get, uri: "/energencecall", handler: Handlers.main)
routes.add(method: .get, uri: "/end", handler: Handlers.end)




// An example route where authentication will be enforced
//routes.add(method: .get, uri: "/api/v1/check", handler: {
//    request, response in
//    response.setHeader(.contentType, value: "application/json")
//
//    var resp = [String: String]()
//    resp["authenticated"] = "AUTHED: \(request.user.authenticated)"
//    resp["authDetails"] = "DETAILS: \(request.user.authDetails)"
//
//    do {
//        try response.setBody(json: resp)
//    } catch {
//        print(error)
//    }
//    response.completed()
//})


// An example route where auth will not be enforced
//routes.add(method: .get, uri: "/api/v1/nocheck", handler: {
//    request, response in
//    response.setHeader(.contentType, value: "application/json")
//
//    var resp = [String: String]()
//    resp["authenticated"] = "AUTHED: \(request.user.authenticated)"
//    resp["authDetails"] = "DETAILS: \(request.user.authDetails)"
//
//    do {
//        try response.setBody(json: resp)
//    } catch {
//        print(error)
//    }
//    response.completed()
//})



// Add the routes to the server.
server.addRoutes(routes)


// Setup logging
//let myLogger = RequestLogger()

// add routes to be checked for auth
//var authenticationConfig = AuthenticationConfig()
//authenticationConfig.include("/api/v1/check")
//authenticationConfig.exclude("/api/v1/login")
//authenticationConfig.exclude("/api/v1/register")

//let authFilter = AuthFilter(authenticationConfig)

// Note that order matters when the filters are of the same priority level
//server.setRequestFilters([pturnstile.requestFilter])
//server.setResponseFilters([pturnstile.responseFilter])
//
//server.setRequestFilters([(authFilter, .high)])
//
//server.setRequestFilters([(myLogger, .high)])
//server.setResponseFilters([(myLogger, .low)])


// Where to serve static files from
//server.documentRoot = "./webroot"


// Add the routes to the server.
server.addRoutes(routes)

// Set a listen port of 8181
server.serverPort = 8181

do {
    // Launch the HTTP server.
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
