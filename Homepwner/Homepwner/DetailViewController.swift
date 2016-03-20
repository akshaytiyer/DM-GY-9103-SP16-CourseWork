//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Akshay Iyer on 3/5/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet var imageView: UIImageView!
    

    @IBOutlet var nameField: CustomTextField!
    @IBOutlet var serialNumberField: CustomTextField!
    @IBOutlet var valueField: CustomTextField!
    @IBOutlet var dateLabel: UILabel!
    

    var changeDate: ChangeDate!
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    var imageStore: ImageStore!
    
    @IBAction func removePicture(sender: AnyObject) {
        
        //Get the item key
        let key = item.itemKey
        
        //Delete Item from Cache for that Image
        imageStore.deleteImageforKey(key)
        
        //Set the image view to nil
        imageView.image = nil
        
    }
    @IBAction func takePicture(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        
        //If the device has a camera, take a picture, otherwise
        //Just pick from photo library
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera)
        {
            imagePicker.sourceType = .Camera
        }
        else
        {
            imagePicker.sourceType = .PhotoLibrary
        }
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        //Get picked image from info directory
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        //Store the image in the ImageStore for the item's key
        imageStore.setImage(image, forKey: item.itemKey)
        
        //Put that image on the screen in the image view
        imageView.image = image
        
        //Take the image picker off the screen
        //You must dismiss method call
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var newDate: NSDate!
    var count=0
    
    let numberFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        return formatter
    }()
    
    @IBAction func buttonTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Clear first responder
        view.endEditing(true)
        
        //"Save" changes to item
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        
        
        if let valueText = valueField.text,
            value = numberFormatter.numberFromString(valueText) {
                item.valueInDollars = value.integerValue
        }
        else {
            item.valueInDollars = 0
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        //valueField.text = "\(item.valueInDollars)"
        //dateLabel.text = "\(item.dateCreated)"
        valueField.text = numberFormatter.stringFromNumber(item.valueInDollars)
        dateLabel.text = dateFormatter.stringFromDate(item.dateCreated)
        
        //Get the item key
        let key = item.itemKey
        
        //if there is an associated image with the item
        //Display it within the image view
        let imageToDisplay = imageStore.imageforKey(key)
        imageView.image = imageToDisplay
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChangeDate" {
                let dateViewController = segue.destinationViewController as! ChangeDate
                dateViewController.changeDateValue = item.dateCreated
            }
        }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
