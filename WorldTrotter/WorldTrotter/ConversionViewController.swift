//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Akshay Iyer on 2/9/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class ConversionViewController : UIViewController, UITextFieldDelegate {
    
    
    let numberFormatter: NSNumberFormatter = {
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.maximumFractionDigits = 1
        nf.minimumFractionDigits = 0
        return nf
    } ()
    
    @IBOutlet var celsiusLabel: UILabel!
    
    var fahrenheitValue: Double? {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Double? {
        if let value = fahrenheitValue {
            return (value - 32) * (5/9)
        }
        else {
            return nil
        }
    }
    
    
    func updateCelsiusLabel() {
        if let value = celsiusValue {
            celsiusLabel.text = numberFormatter.stringFromNumber(value)
        }
        else {
            celsiusLabel.text = "???"
        }
    }
    
    @IBOutlet var textField: UITextField!
    
    func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
            
            let existingTextHasDecimalSeperator = textField.text?.rangeOfString(".")
            let replacementTextHasDecimalSeperator = string.rangeOfString(".")
            
            if existingTextHasDecimalSeperator != nil && replacementTextHasDecimalSeperator != nil {
                return false
            }
            else
            {
            return true
            }
    }
    
    @IBAction func fahrenheitFieldEditingChanged(textField : UITextField)    {
       //celsiusLabel.text = textField.text
        
        if let text = textField.text, value = Double(text) {
            fahrenheitValue = value
        }
        else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        textField.resignFirstResponder()
    }
}