//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Akshay Iyer on 4/11/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        print("Reached Here")
        super.viewDidLoad()
        
        store.fetchRecentPhotos() {
            (PhotosResult) -> Void in
            
            switch PhotosResult {
            case let .Success(photos):
                    print("Successfully found \(photos.count) recent photos")
                
                    if let firstPhoto = photos.first {
                        self.store.fetchImageForPhoto(firstPhoto) {
                            (imageResult) -> Void in
                            
                            switch imageResult {
                            case let .Success(image):
                                //self.imageView.image = image
                                NSOperationQueue.mainQueue().addOperationWithBlock {
                                    self.imageView.image = image
                                }
                                
                            case let .Failure(error):
                                print("Error downloading image: \(error)")
                            }
                        }
                    }
                
            case let .Failure(error):
                    print("Error fetching recent photos: \(error)")
            }
        }
    }
}
