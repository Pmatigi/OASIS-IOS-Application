//
//  UIImage+Helper.swift
//  OasisBooking
//
//  Created by Anuj Garg on 04/04/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import Foundation
import UIKit


extension UIImageView{
    func dowloadFromServer(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit, completionHandler : @escaping (UIImage)-> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
            let data = data, error == nil,
            let image = UIImage(data: data)
            else { return }
        completionHandler(image)
        }.resume()
}
}
