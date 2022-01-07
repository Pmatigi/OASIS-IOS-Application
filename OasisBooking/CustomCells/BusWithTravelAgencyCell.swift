//
//  BusWithTravelAgencyCell.swift
//  OasisBooking
//
//  Created by Neeraj Mishra on 04/02/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit


class BusWithTravelAgencyCell: UITableViewCell {
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblBusName: UILabel!
    @IBOutlet weak var lblBusType: UILabel!
    @IBOutlet weak var lblBusRate: UILabel!
    @IBOutlet weak var lbltotalSheets: UILabel!
    @IBOutlet weak var buttonRating: UIButton!
    @IBOutlet weak var buttonAmenities: UIButton!
    @IBOutlet weak var lblBustimings: UILabel!
    @IBOutlet weak var imgBusImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblRating.layer.cornerRadius = 10.0
        self.lblRating.clipsToBounds = true
        
//        self.imgBusImage.layer.cornerRadius = 32.5
//        self.imgBusImage.layer.borderColor = UIColor.lightGray as! CGColor
//        self.imgBusImage.layer.borderWidth = 0.3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
