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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    @IBAction func addNewItem(sender: AnyObject) {
        //Create a new item and add it to the store
        let newItem = itemStore.createItem()
        if let index = itemStore.allItems.indexOf(newItem) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            //Insert this new row into the table
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < itemStore.allItems.count
        {
        let item = itemStore.allItems[indexPath.row]
        if item.valueInDollars > 50
        {
            cell.backgroundColor = UIColor.redColor()
        }
        else
        {
            cell.backgroundColor = UIColor.greenColor()
        }
        }
        else
        {
            cell.backgroundColor = UIColor.clearColor()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        //update the model
        itemStore.moveItemsAtIndex(sourceIndexPath.item, toIndex: destinationIndexPath.row)
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Remove"
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //If the table view is asking to commit a delete command
        if editingStyle == .Delete {
            let item = itemStore.allItems[indexPath.row]
            
            let title  = "Remove \(item.name)"
            let message  = "Are you sure you want to remove this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Remove", style: .Destructive, handler: { (action) -> Void in
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
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return !(indexPath.row == itemStore.allItems.count)
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if proposedDestinationIndexPath.row == itemStore.allItems.count
        {
            return NSIndexPath(forRow: proposedDestinationIndexPath.row - 1,  inSection: 0)
        }
        else
        {
            return proposedDestinationIndexPath
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count + 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //If the triggered segue is the "ShowItem" 
        if segue.identifier == "ShowItem" {
            
            //Figure out which row was tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                
                //Get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController
                        = segue.destinationViewController as! DetailViewController
                detailViewController.item = item
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Create an instance of UITableViewCell, with default appearence
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        //Update the labels with the new prefereed text size
        cell.updateLables()
        
        //Set the text on the cell with description of the item
        //That is the nth index of items, where n = row this cell
        //Will appear on the tableview
        if indexPath.row < itemStore.allItems.count
        {
            let item = itemStore.allItems[indexPath.row]
            cell.nameLabel.text = item.name
            cell.serialNumberLabel.text = item.serialNumber
            cell.valueLabel.text = "$\(item.valueInDollars)"
        }
        else
        {
            cell.nameLabel.text = "No More Items"
            cell.serialNumberLabel.text = ""
            cell.valueLabel.text = ""
        }
        return cell
    }
}
