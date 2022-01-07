//
//  Booking.swift
//  OasisBooking
//
//  Created by Anuj Garg on 29/03/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import Foundation
import UIKit

public class Booking : NSObject {
        var booking_id : String?
        var pnr_no : String?
        var starting_point : String?
        var destination_point : String?
        var passenger_phone : String?
        var boarding_point : String?
        var passenger_name : String?
        var drop_point : String?
        var total_fare_accepted : String?
        var booking_time : String?
        var booking_date : String?
        var booking_status : String?
        var ticket_id : String?
        var seat_number : [String]?
        var booking_date_time : String?
        var ticket_pdf : String?

    


    var date: Date? {
        if let dateString = booking_date_time {
        return DateHelper.dateFromString(dateString: dateString, format: "yyyy-MM-dd HH:mm:ss")!
        }
        else{
            return nil
        }
    }
}

extension Booking {
    
    public func allBooking(bookList : NSArray)-> Array<Booking>{
        var busValues = Array<Booking>()
        for dict in bookList {
            
            let bookListTmp = Booking()
            let booking_id = (dict as? NSDictionary)?.value(forKey: "booking_id") as! Int
            bookListTmp.booking_id = String(booking_id)
            bookListTmp.pnr_no       = (dict as? NSDictionary)?.value(forKey: "pnr_no") as? String
            bookListTmp.passenger_name      = (dict as? NSDictionary)?.value(forKey: "passenger_name") as? String
            bookListTmp.passenger_phone      = (dict as? NSDictionary)?.value(forKey: "passenger_phone") as? String
            bookListTmp.boarding_point      = (dict as? NSDictionary)?.value(forKey: "boarding_point") as? String
            bookListTmp.drop_point     = (dict as? NSDictionary)?.value(forKey: "drop_point") as? String
            bookListTmp.starting_point = (dict as? NSDictionary)?.value(forKey: "starting_point") as? String
            bookListTmp.destination_point    = (dict as? NSDictionary)?.value(forKey: "destination_point") as? String
            bookListTmp.total_fare_accepted  = (dict as? NSDictionary)?.value(forKey: "total_fare_accepted") as? String
            bookListTmp.booking_time  = (dict as? NSDictionary)?.value(forKey: "booking_time") as? String
            bookListTmp.booking_date    = (dict as? NSDictionary)?.value(forKey: "booking_date") as? String
            bookListTmp.booking_status          = (dict as? NSDictionary)?.value(forKey: "booking_status") as? String
            bookListTmp.ticket_id     = (dict as? NSDictionary)?.value(forKey: "ticket_id") as? String
            bookListTmp.passenger_name     = (dict as? NSDictionary)?.value(forKey: "passenger_name") as? String
            bookListTmp.seat_number     = (dict as? NSDictionary)?.value(forKey: "seat_number") as? [String]
            bookListTmp.booking_date_time     = (dict as? NSDictionary)?.value(forKey: "booking_date_time") as? String
            
             bookListTmp.ticket_pdf     = (dict as? NSDictionary)?.value(forKey: "ticket_pdf") as? String

            busValues.append(bookListTmp)
        }
     return busValues
    }
}
    





