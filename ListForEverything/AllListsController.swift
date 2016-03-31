import UIKit

class AllListsController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var listStore: ListStore!
    var newListController: UIAlertController?
    var indexPathToMove: NSIndexPath?
    
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Lists"
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.reorderTable(_:)))
        listTableView.addGestureRecognizer(longPress)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listStore.allLists.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell") as! ListTableViewCell
        let list = listStore.allLists[indexPath.row]
        
        cell.textLabel?.text = list.name
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let list = listStore.allLists[indexPath.row]
            listStore.deleteList(list)
            self.listTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    @IBAction func createList(sender: AnyObject) {
        newListController = UIAlertController(title: "Add a new list",
                                              message: nil,
                                              preferredStyle: .Alert)
        newListController!.addTextFieldWithConfigurationHandler {
            (textField) -> Void in
            textField.placeholder = "New List"
            textField.addTarget(self, action: #selector(AllListsController.newListNameTextChanged(_:)), forControlEvents: .EditingChanged)
        }
        
        let okAction = UIAlertAction(title: "Create", style: .Default) {
            (action) -> Void in
            if let newListName = self.newListController?.textFields?.first?.text {
                self.listStore.createNewList(newListName)
                self.listTableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        okAction.enabled = false
        
        newListController?.addAction(okAction)
        newListController?.addAction(cancelAction)
        
        self.presentViewController(newListController!, animated: true, completion: nil)
        
    }
    
    func newListNameTextChanged(sender: UITextField) {
        if let alertcontroller = self.presentedViewController as? UIAlertController {
            let newListName = alertcontroller.textFields?.first?.text
            let submitAction = alertcontroller.actions.first
            if submitAction != nil && newListName != nil && newListName!.characters.count > 0 {
                submitAction!.enabled = true
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowList" {
            if let row = listTableView.indexPathForSelectedRow?.row {
                let list = listStore.allLists[row]
                let listController = segue.destinationViewController as! ListController
                listController.list = list
                listController.listStore = listStore
            }
        }
    }
    
    func reorderTable(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let location = longPress.locationInView(listTableView)
        let indexPath = listTableView.indexPathForRowAtPoint(location)
        
        
        switch longPress.state {
        case .Began:
            // set item to reorder
            if indexPath == nil {
                return
            }
            
            let cell = listTableView.cellForRowAtIndexPath(indexPath!)
            cell?.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
            indexPathToMove = indexPath!
            break
        case .Changed:
            if indexPath == nil || indexPathToMove == nil || indexPathToMove == indexPath! {
                return
            }
            
            // Move item with pretty animations in the table
            listTableView.moveRowAtIndexPath(indexPathToMove!, toIndexPath: indexPath!)
            // Ensure order will be persisted
            swap(&listStore.allLists[indexPathToMove!.row], &listStore.allLists[indexPath!.row])
            
            indexPathToMove = indexPath!
            break
        case .Ended:
            let cell = listTableView.cellForRowAtIndexPath(indexPathToMove!)
            cell?.backgroundColor = UIColor.whiteColor()
            break
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

