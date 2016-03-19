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
    }
    
    func imageforKey(key: String) -> UIImage? {
        return cache.objectForKey(key) as? UIImage
    }
    
    func deleteImageforKey(key: String) {
        cache.removeObjectForKey(key)
    }
    
}
