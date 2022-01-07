//
//  Date+Format.swift
//  DateScrollPicker_Example
//
//  Created by Alberto Aznar de los Ríos on 21/11/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

extension Date {
    
    func format(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
