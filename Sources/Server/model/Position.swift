import StORM
import MongoDBStORM

class Position: MongoDBStORM {
    
    // Set some properties for the object
    // These properties are reflected in the database table
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
    override func to(_ this: StORMRow) {
        id               = this.data["_id"] as? String              ?? ""
        positionX        = this.data["positionX"] as? String        ?? ""
        positionY        = this.data["positionY"] as? String        ?? ""
        contactId        = this.data["contactId"] as? String        ?? ""
    }
   
}

