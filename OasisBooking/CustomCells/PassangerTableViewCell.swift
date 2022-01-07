//
//  PassangerTableViewCell.swift
//  OasisBooking
//
//  Created by Anuj Garg on 11/04/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit

class PassangerTableViewCell: UITableViewCell {

    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtContactNo: UILabel!
    @IBOutlet weak var txtGender: UILabel!
    @IBOutlet weak var txtSeatNum: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
