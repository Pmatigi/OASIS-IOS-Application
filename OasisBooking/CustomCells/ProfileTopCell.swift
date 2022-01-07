//
//  ProfileTopCell.swift
//  OasisBooking
//
//  Created by Neeraj Mishra on 06/02/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit

class ProfileTopCell: UITableViewCell {
     @IBOutlet weak var imgProfile: UIImageView!
     @IBOutlet weak var lblName: UILabel!
     @IBOutlet weak var lblEmail: UILabel!
     @IBOutlet weak var lblMobileNo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height/2.0
        //self.imgProfile.layer.borderWidth = 1.0
       // self.imgProfile.layer.backgroundColor = UIColor.lightGray.cgColor
        self.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
