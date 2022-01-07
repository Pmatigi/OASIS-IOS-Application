//
//  Booking+API.swift
//  OasisBooking
//
//  Created by Anuj Garg on 29/03/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import Foundation
import MBProgressHUD

extension MyBookingViewController {

    func getBusBookingDetailApi(complitionHandller: @escaping (Bool)-> Void) {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.contentColor = UIColor.black
            hud.label.text = "Loading..."
        }
        if !self.checkIfLoggedInElseAsk() { return }
        let userId = DataModel.shared.currentUserId()
        //if DataModel.shared.isLoggedIn 
        let postObject = ["customer_id": userId] as [String: Any]
        print(postObject)
        let webCnctn = WebConnectionViewController()
        webCnctn.downloadData(fromUrl: URLs.myBookingsUrl, isAuthRequest: false, postObject: postObject, requestType: "POST", compHandler:{ data, error in

            guard error == nil else {
                //print(error?.localizedDescription ?? "Error Message")
                return
            }
            guard let data = data else {
                return
            }
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] {
                    DispatchQueue.main.async {
                        //print(json)
                        MBProgressHUD.hide(for: self.view, animated: true)

                        let error = json["error"] as? Bool
                        if !error!{
                            //Create tabbar and navigate to home screen
                            guard let bookings = json["bookings"] as? NSDictionary  else{return}
                            guard let currentBooking = bookings["current_booking"] as? NSArray else{return}
                            guard let cancelledBooking = bookings["cancelled_booking"] as? NSArray else{return}
                            guard let pastBooking = bookings["past_booking"] as? NSArray else{return}

                            self.currentBooking = Booking().allBooking(bookList: currentBooking)
                            self.cancelledBooking = Booking().allBooking(bookList: cancelledBooking)
                            self.pastBooking = Booking().allBooking(bookList: pastBooking)
                            complitionHandller(true)
                        }
                        else{
                            guard let msg = json["error_messages"] as? String else{
                                return
                            }
                            self.showAlertController(title: "Alert", message :msg)
                            print(msg)
                            complitionHandller(false)
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlertController(title: "Alert", message :error.localizedDescription)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    complitionHandller(false)

                }
            }
        })
    }
}
