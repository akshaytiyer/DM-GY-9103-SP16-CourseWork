//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Akshay Iyer on 2/23/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    var itemStore: ItemStore!
    
    @IBAction func addNewItem(sender: AnyObject) {
        //Create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        if let index = itemStore.allItems.indexOf(newItem) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            //Insert this new row into the table
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }

        }
    
    @IBAction func toggleEditingMode(sender: AnyObject) {
        //If your are currently in the editing mode
        if editing {
            //Change text of button to inform user of state
            sender.setTitle("Edit", forState: .Normal)
            
            //Turn off editing mode
            setEditing(false, animated: true)
        }
        else
        {
            //Change text of button to inform user of state
            sender.setTitle("Done", forState: .Normal)
            
            //Enter editing mode
            setEditing(true, animated: true)
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        //update the model
        itemStore.moveItemsAtIndex(sourceIndexPath.item, toIndex: destinationIndexPath.row)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //If the table view is asking to commit a delete command
        if editingStyle == .Delete {
            let item = itemStore.allItems[indexPath.row]
            
            let title  = "Delete \(item.name)"
            let message  = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
                //Remove the item from the store
                self.itemStore.removeItem(item)
                
                //Also remove that row from the table with an animation
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            })
            ac.addAction(deleteAction)
            
            //Present the alert controller
            presentViewController(ac, animated: true, completion: nil)
            
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Create an instance of UITableViewCell, with default appearence
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        //Update the labels with the new prefereed text size
        cell.updateLables()
        
        //Set the text on the cell with description of the item
        //That is the nth index of items, where n = row this cell
        //Will appear on the tableview
        
        let item = itemStore.allItems[indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"

        return cell
    }
}
