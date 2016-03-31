import UIKit

class ListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var list: List!
    var listStore: ListStore!
    var indexPathToMove: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = list.name
        
        textField.becomeFirstResponder()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ListController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ListController.reorderTable(_:)))
        tableView.addGestureRecognizer(longPress)
    }
    
    @IBAction func clearCompletedItems(sender: UIButton) {
        listStore.deleteCompletedItems(list)
        tableView.reloadData()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let text = textField.text {
            listStore.createListItem(list, text: text)
            
            textField.text = ""
            tableView.reloadData()
        }
        
        textField.becomeFirstResponder()
        return true
    }
    
    func reorderTable(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let location = longPress.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(location)
        
        
        switch longPress.state {
        case .Began:
            // set item to reorder
            if indexPath == nil {
                return
            }
            
            let cell = tableView.cellForRowAtIndexPath(indexPath!)
            cell?.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
            indexPathToMove = indexPath!
            break
        case .Changed:
            if indexPath == nil || indexPathToMove == nil || indexPathToMove == indexPath! {
                return
            }
            
            // Move item with pretty animations in the table
            tableView.moveRowAtIndexPath(indexPathToMove!, toIndexPath: indexPath!)
            // Ensure order will be persisted
            swap(&list.items[indexPathToMove!.row], &list.items[indexPath!.row])
            
            indexPathToMove = indexPath!
            break
        case .Ended:
            let cell = tableView.cellForRowAtIndexPath(indexPathToMove!)
            cell?.backgroundColor = UIColor.whiteColor()
            break
        default:
            break
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListItemCell") as! ListItemTableViewCell
        
        let listItem = list.items[indexPath.row]
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: listItem.itemDescription)
        
        if listItem.completed == true {
            cell.textLabel?.textColor = UIColor.lightGrayColor()
            cell.tintColor = UIColor.lightGrayColor()
            
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            
        } else { // Item not completed
            cell.textLabel?.textColor = UIColor.blackColor()
            
            attributeString.removeAttribute(NSStrikethroughStyleAttributeName, range: NSMakeRange(0, attributeString.length))
            
        }
        
        cell.textLabel?.attributedText = attributeString
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let listItem = list.items[indexPath.row]
            listStore.deleteListItem(list, item: listItem)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ListItemTableViewCell
        let listItem = list.items[indexPath.row]
        let attributedText = cell.textLabel?.attributedText as! NSMutableAttributedString
        
        // Toggle strikethrough and completed attribute
        if listItem.completed == true {
            listItem.completed = false
            cell.textLabel?.textColor = UIColor.blackColor()
            
            attributedText.removeAttribute(NSStrikethroughStyleAttributeName, range: NSMakeRange(0, attributedText.length))
        } else {
            listItem.completed = true
            cell.textLabel?.textColor = UIColor.lightGrayColor()
            cell.tintColor = UIColor.lightGrayColor()
            
            attributedText.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributedText.length))
            
        }
        
        cell.textLabel?.attributedText = attributedText
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

