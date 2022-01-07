//
//  Ratings.swift
//  OasisBooking
//
//  Created by Anuj Garg on 03/04/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import Foundation


public class  Ratings : NSObject {
    var id : String?
    var review : String?
    var rating : String?
}

extension Ratings {
    public func allratings (ratingsList : NSArray)-> [Ratings]{
        var ratings = [Ratings]()
        for dict in ratingsList {
            let ratingsListTmp = Ratings()
            let id                = (dict as? NSDictionary)?.value(forKey: "user_id")
            ratingsListTmp.id     = id as? String
            ratingsListTmp.rating = (dict as? NSDictionary)?.value(forKey: "ratings") as? String
            ratingsListTmp.review = (dict as? NSDictionary)?.value(forKey: "review") as? String
            
            ratings.append(ratingsListTmp)
        }
     return ratings
    }
}
