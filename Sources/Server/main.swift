
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

import StORM
import MongoDBStORM
import PerfectTurnstileMongoDB
import PerfectRequestLogger
import TurnstilePerfect

// Set the parameter for database
MongoDBConnection.host = "localhost:27017"
MongoDBConnection.database = "perfect_testing"

let server = HTTPServer()

// Adding a test route
var routes = Routes()

routes.add(uri: "/test", handler: Handlers.main)
routes.add(uri: "/register", handler: Handlers.register)
routes.add(uri: "/location", handler: Handlers.location)
routes.add(uri: "/login", handler: Handlers.login)
routes.add(uri: "/logout", handler: Handlers.main)
routes.add(uri: "/start", handler: Handlers.start)
routes.add(uri: "/energencecall", handler: Handlers.logout)
routes.add(uri: "/end", handler: Handlers.end)
routes.add(uri: "/contact", handler: Handlers.contact)


server.addRoutes(routes)

// Set a listen port of 8181
server.serverPort = 8181

do {
    // Launch the HTTP server.
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
