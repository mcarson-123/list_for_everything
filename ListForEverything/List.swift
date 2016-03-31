import UIKit

class List: NSObject, NSCoding {
    var name: String
    let dateCreated: NSDate
    var items: [ListItem] = []
    
    init(name: String) {
        self.name = name
        self.dateCreated = NSDate()
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.dateCreated = aDecoder.decodeObjectForKey("dateCreated") as! NSDate
        self.items = aDecoder.decodeObjectForKey("items") as! [ListItem]
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(dateCreated, forKey: "dateCreated")
        aCoder.encodeObject(items, forKey: "items")
    }
}