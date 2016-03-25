import UIKit

class ListItemStore {
    
    var allListItems = [ListItem]()
    let listItemArchiveURL: NSURL = {
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent("listItems.archive")
        
    }()
    
    init() {
        if let archivedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(listItemArchiveURL.path!) as? [ListItem] {
            allListItems += archivedItems
        }
    }
    
    func createListItem(text: String) -> ListItem {
        let newItem = ListItem(itemDescription: text)
        
        allListItems.append(newItem)
        
        return newItem
    }
    
    func deleteListItem(item: ListItem) {
        if let index = allListItems.indexOf(item) {
            allListItems.removeAtIndex(index)
        }
    }
    
    func saveChanges() -> Bool {
        return NSKeyedArchiver.archiveRootObject(allListItems, toFile: listItemArchiveURL.path!)
    }
}