import UIKit

class ListStore {
    
    var allLists = [List]()
    
    let listArchiveURL: NSURL = {
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent("myImportantLists.archive")
        
    }()
    
    init() {
        if let archivedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(listArchiveURL.path!) as? [List] {
            allLists += archivedItems
        }
    }
    
    func createNewList(name: String) -> List {
        let newList = List(name: name)
        
        allLists.append(newList)
        
        return newList
    }
    
    func deleteList(list: List) {
        if let index = allLists.indexOf(list) {
            list.items.removeAll()
            allLists.removeAtIndex(index)
        }
    }
    
    //
    // Manage List's items
    //
    
    func createListItem(list: List, text: String) -> ListItem {
        let newItem = ListItem(itemDescription: text)
        
        list.items.append(newItem)
        
        return newItem
    }
    
    func deleteListItem(list: List, item: ListItem) {
        if let index = list.items.indexOf(item) {
            list.items.removeAtIndex(index)
        }
    }
    
    func deleteCompletedItems(list: List) {
        for item in list.items {
            if item.completed == true {
                deleteListItem(list, item: item)
            }
        }
    }
    
    func saveChanges() -> Bool {
        return NSKeyedArchiver.archiveRootObject(allLists, toFile: listArchiveURL.path!)
    }
}