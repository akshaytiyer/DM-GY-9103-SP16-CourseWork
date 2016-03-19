//
//  ImageStore.swift
//  Homepwner
//
//  Created by Akshay Iyer on 3/18/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit
class ImageStore {
    let cache = NSCache()
    
    func setImage(image:UIImage, forKey key: String) {
        cache.setObject(image, forKey: key)
        
        //Create full URL for image
        let imageURL = imageURLForKey(key)
        
        //Turn image into JPEG Data
        if let data = UIImagePNGRepresentation(image) {
            //Write it into full URL
            data.writeToURL(imageURL, atomically: true)
            
        }
    }
    
    func imageURLForKey(key: String) -> NSURL
    {
     let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
     let documentDirectory = documentsDirectories.first!
    
     return documentDirectory.URLByAppendingPathComponent(key)
    }
    
    func imageforKey(key: String) -> UIImage? {
        
        if let existingImage = cache.objectForKey(key) as? UIImage {
            return existingImage
        }
        
        let imageURL = imageURLForKey(key)
        guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path!) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key)
        return imageFromDisk
    }
    
    func deleteImageforKey(key: String) {
        cache.removeObjectForKey(key)
        
        let imageURL = imageURLForKey(key)
        do
        {
            try NSFileManager.defaultManager().removeItemAtURL(imageURL)
        }
        catch let deleteError
        {
            print("Error removing the image from the disk \(deleteError)")
        }
    }
    
}
