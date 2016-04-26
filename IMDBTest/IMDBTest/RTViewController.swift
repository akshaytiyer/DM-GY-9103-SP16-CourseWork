//
//  RTViewController.swift
//  IMDBTest
//
//  Created by Akshay Iyer on 4/23/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class RTViewController: UIViewController
{
    @IBOutlet var myLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var imageLink: UILabel!
    @IBOutlet var synopsis: UITextView!
    @IBOutlet var releaseDate: UILabel!
    @IBOutlet var criticsRating: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var rottentomatoes: RottenTomatoesStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rottentomatoes.fetchRecentPhotos() {
            (rottenTomatoesResult) -> Void in
            
            switch rottenTomatoesResult {
            case let .Success(movies):
                print("Successfully found \(movies.count) recent movies")
               
                    
                    if let firstPhoto = movies.first {
                        self.rottentomatoes.fetchImageForMovie(firstPhoto) {
                          (imageResult) -> Void in
                            
                            switch imageResult {
                            case let .Success(image):
                                NSOperationQueue.mainQueue().addOperationWithBlock {
                                self.imageView.image = image
                                self.myLabel.text = movies.first!.title
                                self.yearLabel.text = String(movies.first!.year)
                                self.imageLink.text = String(movies.first!.imageURL)
                                self.synopsis.text = movies.first!.synopsis
                                self.releaseDate.text = movies.first!.releaseDate
                                self.criticsRating.text = String(movies.first!.criticsRating)
                                }
                            case let .Failure(error):
                                print("Error Downloading Image: \(error)")
                            }
                    }
 
                }
            case let .Failure(error):
                print("Error fetching recent photos: \(error)")
            }
        }
    }
}
