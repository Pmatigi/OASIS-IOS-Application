//
//  BookingHistoryCell.swift
//  OasisBooking
//
//  Created by Neeraj Mishra on 09/02/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit

class BookingHistoryCell: UITableViewCell {
    
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblFromTo: UILabel!
    @IBOutlet weak var lblBusType: UILabel!
    @IBOutlet weak var lblBusFareTotal: UILabel!
    @IBOutlet weak var lbldateOfjourney: UILabel!
    @IBOutlet weak var lblDayOfJourney: UILabel!
    @IBOutlet weak var lblTicketStatus: UILabel!
    @IBOutlet weak var lblBoardingPoint: UILabel!
    @IBOutlet weak var lbMonthYearBooking: UILabel!
    @IBOutlet weak var lblBusOperator: UILabel!
    @IBOutlet weak var lblticketId: UILabel!
    @IBOutlet weak var lblpnr: UILabel!
    @IBOutlet weak var lblseatNums: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(booking: Booking){
        print("Date is:",booking.date)
        self.lblTicketStatus.text = booking.booking_status
        self.lblFromTo.text = (booking.starting_point ?? "") + " - " + (booking.destination_point ?? "")
        self.lblBoardingPoint.text = "Boarding : \(booking.boarding_point ?? "")"
        self.lblseatNums.text = "PNR :\( booking.pnr_no ?? "")"  //joined(separator: ",")
        self.lblTicketStatus.text = booking.booking_status
        //let dateComponets = booking.booking_date?.split(separator: "/")
        self.lblDayOfJourney.text = booking.date!.getDayName()

        self.lbldateOfjourney.text = String(booking.date!.dayOfMonth())//String(dateComponets?[0] ?? "")
        self.lbMonthYearBooking.text = DateHelper.defaultDisplayStringForMonthYear(date: booking.date!)
    }
}
            
