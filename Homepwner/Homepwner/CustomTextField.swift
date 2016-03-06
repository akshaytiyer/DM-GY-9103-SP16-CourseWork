//
//  CustomTextField.swift
//  Homepwner
//
//  Created by Akshay Iyer on 3/5/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

    
    class CustomTextField: UITextField{
        override func becomeFirstResponder() -> Bool{
            super.becomeFirstResponder()
            print("Became First Responder")
            self.borderStyle = .Line
            return true
        }
        
        override func resignFirstResponder() -> Bool{
            super.becomeFirstResponder()
            print("Resigned from First Responder")
            self.borderStyle = .RoundedRect
            return true
        }
    }
    