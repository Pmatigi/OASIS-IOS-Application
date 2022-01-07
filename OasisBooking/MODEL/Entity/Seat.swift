//
//  Seat.swift
//  OasisBooking
//
//  Created by Anuj Garg on 18/03/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import Foundation

public class Seat : NSObject {
    var id : String?
    var bus_id : String?
    var seat_no : String?
    var created_at : String?
    var updated_at : String?
    var is_booked : Int?
    var booking_id : String?
    var seat_type : String?
    
    var isSeatBooked : Bool = false {
        didSet{
            if self.is_booked! == 0 {
                isSeatBooked = false
            }
            else {
                isSeatBooked = true
            }
        }
    }
}

extension Seat {
    public func allSeats (seatList : NSArray)-> [Seat]{
        var seatValues = [Seat]()
        for dict in seatList {
            let seatListTmp = Seat()
            let id = String((dict as? NSDictionary)?.value(forKey: "id") as! Int)
            seatListTmp.id = id
            seatListTmp.bus_id         = (dict as? NSDictionary)?.value(forKey: "bus_id") as? String
            seatListTmp.seat_no        = (dict as? NSDictionary)?.value(forKey: "seat_no") as? String
            seatListTmp.created_at     = (dict as? NSDictionary)?.value(forKey: "created_at") as? String
            seatListTmp.updated_at     = (dict as? NSDictionary)?.value(forKey: "updated_at") as? String
            seatListTmp.seat_type      = (dict as? NSDictionary)?.value(forKey: "seat_type") as? String

            if let isBooked = (dict as? NSDictionary)?.value(forKey: "is_booked") as? Int {
               seatListTmp.is_booked  = isBooked
            }
            if let bookingId = (dict as? NSDictionary)?.value(forKey: "booking_id") as? String{
               seatListTmp.booking_id  = bookingId
            }
            //seatListTmp.booking_id     = (dict as? NSDictionary)?.value(forKey: "booking_id") as? String
            seatValues.append(seatListTmp)
        }
     return seatValues
    }
}

