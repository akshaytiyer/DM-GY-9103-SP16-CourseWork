//
//  Photo.swift
//  Photorama
//
//  Created by Akshay Iyer on 4/26/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit
import CoreData


class Photo: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    var image: UIImage?
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        //Give the properties their initial values
        title = ""
        photoID = ""
        remoteURL = NSURL()
        photoKey = NSUUID().UUIDString
        dateTaken = NSDate()
    }

}
