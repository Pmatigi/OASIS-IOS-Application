//
//  BusImageCollectionViewCell.swift
//  OasisBooking
//
//  Created by Anuj Garg on 09/03/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit

class BusImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var busImagesView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    
    override func awakeFromNib() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.6
        self.layer.cornerRadius = 5
    }
    
}
