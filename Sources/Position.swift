

import StORM
import MongoDBStORM

class Position: MongoDBStORM {
    
    // Set some properties for the object
    // These properties are reflected in the database table
    // NOTE: First param in class should be the ID.
    var id                : String = ""
    var positionX        : String = ""
    var positionY        : String = ""
    var contactId            : String = ""
    
    
    // The name of the database table
    override init() {
        super.init()
        _collection = "positions"
    }
    
    
    // The mapping that translates the database info back to the object
    // This is where you would do any validation or transformation as needed
    override func to(_ this: StORMRow) {
        id                = this.data["_id"] as? String            ?? ""
        positionX        = this.data["positionX"] as? String        ?? ""
        positionY        = this.data["positionY"] as? String        ?? ""
        contactId        = this.data["contactId"] as? String        ?? ""
    }
    
    // A simple iteration.
    // Unfortunately necessary due to Swift's introspection limitations
    func rows() -> [Position] {
        var rows = [Position]()
        for i in 0..<self.results.rows.count {
            let row = Position()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}

