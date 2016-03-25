import UIKit

class ListItem: NSObject, NSCoding {
    var itemDescription: String
    let dateCreated: NSDate
    var completed: Bool = false
    
    init(itemDescription: String) {
        self.itemDescription = itemDescription
        self.dateCreated = NSDate()
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.itemDescription = aDecoder.decodeObjectForKey("itemDescription") as! String
        self.dateCreated = aDecoder.decodeObjectForKey("dateCreated") as! NSDate
        self.completed = aDecoder.decodeBoolForKey("completed")
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(itemDescription, forKey: "itemDescription")
        aCoder.encodeObject(dateCreated, forKey: "dateCreated")
        aCoder.encodeBool(completed, forKey: "completed")
    }
}