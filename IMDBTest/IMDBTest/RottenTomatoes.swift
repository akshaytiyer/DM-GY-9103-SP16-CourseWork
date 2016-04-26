//
//  RottenTomatoes.swift
//  IMDBTest
//
//  Created by Akshay Iyer on 4/23/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class RottenTomatoes {
    let title: String
    let year: Int
    let imageURL: NSURL
    let releaseDate: String
    let criticsRating: Int
    let synopsis: String
    var image: UIImage?
    
    init(title: String, year: Int, imageURL: NSURL, releaseDate: String, criticsRating: Int, synopsis: String)
    {
        self.title = title
        self.year = year
        self.imageURL = imageURL
        self.releaseDate = releaseDate
        self.criticsRating = criticsRating
        self.synopsis = synopsis
    }
}
