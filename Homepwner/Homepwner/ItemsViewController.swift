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
    var less50 = [Item]()
    var more50 = [Item]()
    var splitItems = [[Item]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background.jpg"))
        let lastLineItem = Item(random: false)
        itemStore.allItems.append(lastLineItem)
        print(itemStore.allItems.count)
        
        for i in 0...itemStore.allItems.count-2
        {
            if itemStore.allItems[i].valueInDollars < 50
            {
                less50.append(itemStore.allItems[i])
                print(itemStore.allItems[i].name)
            }
            else
            {
                more50.append(itemStore.allItems[i])
                print(itemStore.allItems[i].name)
            }
        }

        less50.append(itemStore.allItems[itemStore.allItems.count-1])
        splitItems.append(less50)
        more50.append(itemStore.allItems[itemStore.allItems.count-1])
        splitItems.append(more50)

        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let islastline = splitItems[indexPath.section][indexPath.row]
        if islastline.name == "No More Items to Display" {
            return 44
        }else {
            return 60
        }
    }

    let headerTitles = ["Less Than 50", "More Than 50"]
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return splitItems[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Create an instance of UITableViewCell, with default appearence
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        
        //Set the text on the cell with description of the item
        //That is the nth index of items, where n = row this cell
        //Will appear on the tableview
        
        let item = splitItems[indexPath.section][indexPath.row]
        

        cell.textLabel?.text = item.name
        if item.name == "No More Items to Display" {
            cell.textLabel?.font = UIFont(name: "Arial", size: 10)
        }else {
            cell.textLabel?.font = UIFont(name: "Arial", size: 20)
        }
        
        
        if item.name == "No More Items to Display"
        {
        cell.detailTextLabel?.text = ""
        }
        else
        {
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        }
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
}
