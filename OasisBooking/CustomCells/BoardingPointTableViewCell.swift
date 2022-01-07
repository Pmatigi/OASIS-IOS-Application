//
//  BoardingPointTableViewCell.swift
//  OasisBooking
//
//  Created by Anuj Garg on 08/03/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit

class BoardingPointTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblPoint: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType =  isSelected ? .checkmark : .none
        // Configure the view for the selected state
    }
    
}
