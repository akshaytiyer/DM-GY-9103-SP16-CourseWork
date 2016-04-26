//
//  RTAPI.swift
//  IMDBTest
//
//  Created by Akshay Iyer on 4/23/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import Foundation

enum RottenTomatoesResult {
    case Success([RottenTomatoes])
    case Failure(ErrorType)
}

enum RottenTomatoesError: ErrorType {
    case InvalidJSONData
}

struct RTAPI {
    
    
    private static func tomatoesFromJSONObject(json: [String : AnyObject]) -> RottenTomatoes? {
        guard let title = json["title"] as? String,
                  year = json["year"] as? Int,
                  url = json["posters"]!["original"] as? String,
                  imageURL = NSURL(string: url),
                  releaseDate = json["release_dates"]!["theater"] as? String,
                  criticsRating = json["ratings"]!["critics_score"] as? Int,
                  synopsis = json["synopsis"] as? String
                else {
            //Don't have enough information to construct a Title
            return nil
        }
        //print(dateFormatter.dateFromString(json["release_dates"]!["theater"]))
        print(json["ratings"]!["critics_score"])
        return RottenTomatoes(title: title, year: year, imageURL: imageURL, releaseDate: releaseDate, criticsRating: criticsRating, synopsis: synopsis)
        
    }
    
    static func tomatoesFromJSONData(data: NSData) -> RottenTomatoesResult {
        do {
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            guard let jsonDictionary = jsonObject as? [NSObject: AnyObject],
                moviesArray = jsonDictionary["movies"] as? [[String: AnyObject]] else {
                    //The JSON Structure doesn't match our expectations
                    return .Failure(RottenTomatoesError.InvalidJSONData)
            }
            print("Hello")
            var finalTomatoes = [RottenTomatoes]()
            for movieJSON in moviesArray {
                if let movies = tomatoesFromJSONObject(movieJSON) {
                    finalTomatoes.append(movies)
                }
            }
            
            print(finalTomatoes.count)
            print(moviesArray.count)
            
            if finalTomatoes.count == 0 && moviesArray.count > 0 {
                //We weren't able to parse any of the movies
                //Maybe the JSON format for photos has changed
                print("Reached Here")
                return .Failure(RottenTomatoesError.InvalidJSONData)
            }
            
            return .Success(finalTomatoes)
        }
        catch let error {
            return .Failure(error)
        }
    }
}