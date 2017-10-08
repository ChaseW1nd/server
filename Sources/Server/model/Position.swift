import StORM
import MongoDBStORM

class Position: MongoDBStORM {
    
    // Set some properties for the object
    // These properties are reflected in the database table
    var id                : String = ""
    var positionX        : Double = 0
    var positionY        : Double = 0
    var contactId            : String = ""
    
    
    // The name of the database table
    override init() {
        super.init()
        _collection = "positions"
    }
    
    
    // The mapping that translates the database info back to the object
    override func to(_ this: StORMRow) {
        id               = this.data["_id"] as? String              ?? ""
        positionX        = this.data["positionX"] as? Double        ?? 0
        positionY        = this.data["positionY"] as? Double        ?? 0
        contactId        = this.data["contactId"] as? String        ?? ""
    }
   
}

