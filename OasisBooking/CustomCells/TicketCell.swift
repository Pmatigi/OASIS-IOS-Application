//
//  TicketCell.swift
//  OasisBooking
//
//  Created by Neeraj Mishra on 01/04/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit

class TicketCell: UITableViewCell {
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewMiddle: UIView!
    @IBOutlet weak var lblStartPoint: UILabel!
    @IBOutlet weak var lblEndPoint: UILabel!
    @IBOutlet weak var lblJurDate: UILabel!
    
    
   @IBOutlet weak var lblFrom: UILabel!
   @IBOutlet weak var lblTo: UILabel!
   @IBOutlet weak var lblBusType: UILabel!
   @IBOutlet weak var lblBusOperator: UILabel!
   @IBOutlet weak var lblpassangerName: UILabel!

   @IBOutlet weak var lblBusFareTotal: UILabel!
   @IBOutlet weak var lblDayOfJourney: UILabel!
   @IBOutlet weak var lblTime: UILabel!

   @IBOutlet weak var lblTicketStatus: UILabel!
   @IBOutlet weak var lblBoardingPoint: UILabel!
   @IBOutlet weak var lblDropingPoint: UILabel!
   @IBOutlet weak var lblticketId: UILabel!
   @IBOutlet weak var lblpnr: UILabel!
   @IBOutlet weak var lblseatNums: UILabel!

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
   public func configure(booking: Booking){
      //  self.lblTicketStatus.text = booking.booking_status
        self.lblFrom.text = booking.starting_point ?? ""
        self.lblTo.text = booking.destination_point ?? ""
        self.lblBoardingPoint.text = booking.boarding_point ?? ""
        self.lblseatNums.text = booking.seat_number?.joined(separator: ",")
       // self.lblTicketStatus.text = booking.booking_status
        self.lblJurDate.text =  DateHelper.defaultDisplayStringForHomeDate(date: booking.date!)
        self.lblBusFareTotal.text =  "fcfa : \(booking.total_fare_accepted ?? "")"
        self.lblticketId.text =  booking.ticket_id
        self.lblDropingPoint.text =  booking.drop_point
        self.lblTime.text = DateHelper.defaultDisplayTime(date: booking.date!)// booking.booking_time
        self.lblpnr.text =  booking.booking_id
        //let dateComponets = booking.booking_date?.split(separator: "/")
        //self.lbldateOfjourney.text = String(dateComponets?[0] ?? "")
       // self.lbMonthYearBooking.text = String(dateComponets?.dropFirst().joined(separator: "/") ?? "")
    }

}
