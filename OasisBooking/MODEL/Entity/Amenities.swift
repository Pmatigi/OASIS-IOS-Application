//
//  Amenities.swift
//  OasisBooking
//
//  Created by Anuj Garg on 21/03/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import Foundation

public class  Amenities : NSObject {
    var id : String?
    var name : String?
}

extension  Amenities {
    public func allAmenities (amenitiesList : NSArray)-> [Amenities]{
        var amenities = [Amenities]()
        for dict in amenitiesList {
            let amenitiesListTmp = Amenities()
            let id = String((dict as? NSDictionary)?.value(forKey: "id") as! Int)
            amenitiesListTmp.id = id
            //amenitiesListTmp.bus_id           = (dict as? NSDictionary)?.value(forKey: "bus_id") as? String
            amenitiesListTmp.name            = (dict as? NSDictionary)?.value(forKey: "name") as? String
            //amenitiesListTmp.amenities_id     = (dict as? NSDictionary)?.value(forKey: "amenities_id") as? String
            amenities.append(amenitiesListTmp)
        }
     return amenities
    }
}
