
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
routes.add(method: .post, uri: "/register", handler: Handlers.register)
routes.add(method: .post, uri: "/location", handler: Handlers.location)
routes.add(method: .post, uri: "/login", handler: Handlers.login)
routes.add(method: .post, uri: "/logout", handler: Handlers.main)
routes.add(method: .post, uri: "/start", handler: Handlers.start)
routes.add(method: .post, uri: "/energencecall", handler: Handlers.logout)
routes.add(method: .post, uri: "/end", handler: Handlers.end)


server.addRoutes(routes)

// Set a listen port of 8181
server.serverPort = 8181

do {
    // Launch the HTTP server.
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
