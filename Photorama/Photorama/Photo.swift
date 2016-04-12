//
//  Photo.swift
//  Photorama
//
//  Created by Akshay Iyer on 4/11/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class Photo {
    
    let title: String
    let remoteURL: NSURL
    let photoID: String
    let dateTaken: NSDate
    var image: UIImage?

    init(title: String, photoID: String, remoteURL: NSURL, dateTaken: NSDate)
    {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}

extension Photo: Equatable {}

func == (lhs: Photo, rhs: Photo) -> Bool {
    //Two photos are the same if they have the same photo ID
    return lhs.photoID == rhs.photoID
}