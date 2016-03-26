import UIKit

class ListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var listItemsStore: ListItemStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.becomeFirstResponder()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ListController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func clearCompletedItems(sender: UIButton) {
        listItemsStore.deleteCompletedItems()
        tableView.reloadData()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let text = textField.text {
            listItemsStore.createListItem(text)
            
            textField.text = ""
            tableView.reloadData()
        }
        
        textField.becomeFirstResponder()
        return true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItemsStore.allListItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListItemCell") as! ListItemTableViewCell
        
        let listItem = listItemsStore.allListItems[indexPath.row]
        
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
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let listItem = listItemsStore.allListItems[indexPath.row]
            listItemsStore.deleteListItem(listItem)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ListItemTableViewCell
        let listItem = listItemsStore.allListItems[indexPath.row]
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

