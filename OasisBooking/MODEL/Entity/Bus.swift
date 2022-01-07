//
//  Bus.swift
//  OasisBooking
//
//  Created by Anuj Garg on 05/03/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import Foundation

public class Bus : NSObject {
    var id : String?
    var bus_name : String?
    var bus_number : String?
    var source_id : String?
    var source_name : String?
    var destination_name : String?
    var destination_id : String?
    var total_seats : Int?
    var total_sleeper : Int?
    var total_sitting : Int?
    var bus_type_id : Int?
    var is_ac : Int?
    var operator_id : Int?
    var created_at : String?
    var updated_at : String?
    var operator_name : String?
    var total_fare : String?
    var start_time : String?
    var reached_time : String?
    var total_time : String?
    var is_available : Int?
    var bus_type_title : String?
    var bus_average_ratings : Int?
    var bus_seat_type : Int?
    var booked_seats : [Seat]?
    var bus_seats :  [Seat]?
    var upper_seats : [Seat]?
    var lower_seats : [Seat]?
    var bus_images : [BusImage]?
    var amenities :  [Amenities]?
    var ratings     :  [Ratings]?
    var boarding : [String]?
    var dropping : [String]?
}


extension Bus {
    
    public func allBusses (busList : NSArray)-> Array<Bus>{
        var busValues = Array<Bus>()
        for dict in busList {
            
            let busListTmp = Bus()
            let id = (dict as? NSDictionary)?.value(forKey: "id") as! Int
            
            busListTmp.id = String(id)
            busListTmp.bus_name       = (dict as? NSDictionary)?.value(forKey: "bus_name") as? String
            busListTmp.bus_number     = (dict as? NSDictionary)?.value(forKey: "bus_number") as? String
            busListTmp.source_id      = (dict as? NSDictionary)?.value(forKey: "source_id") as? String
            busListTmp.source_name      = (dict as? NSDictionary)?.value(forKey: "source_name") as? String
            busListTmp.destination_name      = (dict as? NSDictionary)?.value(forKey: "destination_name") as? String
            busListTmp.destination_id = (dict as? NSDictionary)?.value(forKey: "destination_id") as? String
            busListTmp.total_seats    = (dict as? NSDictionary)?.value(forKey: "total_seats") as? Int
            busListTmp.total_sleeper  = (dict as? NSDictionary)?.value(forKey: "total_sleeper") as? Int
            busListTmp.total_sitting  = (dict as? NSDictionary)?.value(forKey: "total_sitting") as? Int
            busListTmp.bus_type_id    = (dict as? NSDictionary)?.value(forKey: "bus_type_id") as? Int
            busListTmp.is_ac          = (dict as? NSDictionary)?.value(forKey: "is_ac") as? Int
            busListTmp.operator_id    = (dict as? NSDictionary)?.value(forKey: "operator_id") as? Int
            busListTmp.created_at     = (dict as? NSDictionary)?.value(forKey: "created_at") as? String
            busListTmp.updated_at     = (dict as? NSDictionary)?.value(forKey: "updated_at") as? String
            busListTmp.operator_name     = (dict as? NSDictionary)?.value(forKey: "operator_name") as? String
            busListTmp.total_fare     = (dict as? NSDictionary)?.value(forKey: "total_fare") as? String
            
            busListTmp.bus_type_title     = (dict as? NSDictionary)?.value(forKey: "bus_type_title") as? String
            busListTmp.start_time     = (dict as? NSDictionary)?.value(forKey: "start_time") as? String
            busListTmp.reached_time     = (dict as? NSDictionary)?.value(forKey: "reached_time") as? String
            busListTmp.total_time     = (dict as? NSDictionary)?.value(forKey: "total_time") as? String
            busListTmp.is_available     = (dict as? NSDictionary)?.value(forKey: "is_available") as? Int
            busListTmp.bus_average_ratings     = (dict as? NSDictionary)?.value(forKey: "bus_average_ratings") as? Int
            busListTmp.bus_seat_type     = (dict as? NSDictionary)?.value(forKey: "bus_seat_type") as? Int
            
            
            if let busUpperSeats = (dict as? NSDictionary)?.value(forKey: "upper_seats") as? NSArray {
                busListTmp.upper_seats     = Seat().allSeats(seatList: busUpperSeats)
            }
            if let busLowerSeats = (dict as? NSDictionary)?.value(forKey: "lower_seats") as? NSArray {
                busListTmp.lower_seats     = Seat().allSeats(seatList: busLowerSeats)
            }
            if let busSeats = (dict as? NSDictionary)?.value(forKey: "bus_seats") as? NSArray {
                busListTmp.bus_seats     = Seat().allSeats(seatList: busSeats)
            }
            if let busBookedSeats = (dict as? NSDictionary)?.value(forKey: "booked_seats") as? NSArray {
                busListTmp.booked_seats     = Seat().allSeats(seatList: busBookedSeats)
            }
            if let bus_images = (dict as? NSDictionary)?.value(forKey: "bus_images") as? NSArray {
                busListTmp.bus_images   = BusImage().allBusImage(busImageList: bus_images)
            }
            if let amenities = (dict as? NSDictionary)?.value(forKey: "bus_amenities") as? NSArray {
                busListTmp.amenities     = Amenities().allAmenities(amenitiesList: amenities)
            }
            if let ratings = (dict as? NSDictionary)?.value(forKey: "bus_ratings") as? NSArray {
                busListTmp.ratings     = Ratings().allratings(ratingsList: ratings)
            }
            
            if let boarding = (dict as? NSDictionary)?.value(forKey: "boarding_point") as? [String] {
                busListTmp.boarding     =  boarding
            }
            if let dropping = (dict as? NSDictionary)?.value(forKey: "drop_point") as? [String] {
                busListTmp.dropping     = dropping
            }
            
            busValues.append(busListTmp)
        }
        return busValues
    }
    
    
    
    public func busDetail(dict : NSDictionary)-> Bus {
        let bus = Bus()
        let id = dict.value(forKey: "id") as! Int
        
        bus.id = String(id)
        bus.bus_name            = dict.value(forKey: "bus_name") as? String
        bus.bus_number          = dict.value(forKey: "bus_number") as? String
        bus.source_id           = dict.value(forKey: "source_id") as? String
        bus.destination_id      = dict.value(forKey: "destination_id") as? String
        bus.total_seats         = dict.value(forKey: "total_seats") as? Int
        bus.total_sleeper       = dict.value(forKey: "total_sleeper") as? Int
        bus.total_sitting       = dict.value(forKey: "total_sitting") as? Int
        bus.bus_type_id         = dict.value(forKey: "bus_type_id") as? Int
        bus.is_ac               = dict.value(forKey: "is_ac") as? Int
        bus.operator_id         = dict.value(forKey: "operator_id") as? Int
        bus.created_at          = dict.value(forKey: "created_at") as? String
        bus.updated_at          = dict.value(forKey: "updated_at") as? String
        bus.bus_type_title      = dict.value(forKey: "bus_type_title") as? String
        bus.start_time          = dict.value(forKey: "start_time") as? String
        bus.reached_time        = dict.value(forKey: "reached_time") as? String
        bus.total_time          = dict.value(forKey: "total_time") as? String
        bus.is_available        = dict.value(forKey: "is_available") as? Int
        bus.bus_average_ratings = dict.value(forKey: "bus_average_ratings") as? Int
        bus.bus_seat_type       = dict.value(forKey: "bus_seat_type") as? Int
        
        
        if let busSeats = dict.value(forKey: "bus_seats") as? NSArray {
            bus.bus_seats   = Seat().allSeats(seatList: busSeats)
        }
        if let busBookedSeats = dict.value(forKey: "booked_seats") as? NSArray {
            bus.booked_seats     = Seat().allSeats(seatList: busBookedSeats)
        }
        
        if let bus_images = dict.value(forKey: "bus_images") as? NSArray {
            bus.bus_images   = BusImage().allBusImage(busImageList: bus_images)
        }
        if let amenities = dict.value(forKey: "amenities") as? NSArray {
            bus.amenities     = Amenities().allAmenities(amenitiesList: amenities)
        }
        if let boarding = dict.value(forKey: "boarding_point") as? [String] {
            bus.boarding     =  boarding
        }
        if let dropping = dict.value(forKey: "drop_point") as? [String] {
            bus.dropping     = dropping
        }
        
        if let busUpperSeats  = dict.value(forKey: "upper_seats") as? NSArray {
            bus.upper_seats   = Seat().allSeats(seatList: busUpperSeats)
        }
        if let busLowerSeats  = dict.value(forKey: "lower_seats") as? NSArray {
            bus.lower_seats   = Seat().allSeats(seatList: busLowerSeats)
        }
        return bus
    }
}
