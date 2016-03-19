//
//  ChangeDate.swift
//  Homepwner
//
//  Created by Akshay Iyer on 3/6/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class ChangeDate: UIViewController
{
    @IBOutlet var DateValue: UIDatePicker!
    var changeDateValue: NSDate!
    
    var item: Item!

    override func viewWillDisappear(animated: Bool) {
        view.endEditing(true)
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //DateValue.date = changeDateValue
        print("Hello World")
    }
    @IBAction func dateChangeSelection(sender: AnyObject) {
        changeDateValue = DateValue.date
    }
}
