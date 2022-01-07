//
//  ConfirmBooking.swift
//  OasisBooking
//
//  Created by Anuj Garg on 12/04/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//


import Foundation
import MBProgressHUD

extension PassengerViewController {

    func confirmBookingApi(complitionHandller: @escaping (Bool, String?)-> Void) {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.contentColor = UIColor.black
            hud.label.text = "confirming..."
        }
        if !self.checkIfLoggedInElseAsk() { return }
        guard let userId = DataModel.shared.currentUserId() else{
            return
        }
        
        guard let bus = self.bus else {return}
        //if DataModel.shared.isLoggedIn
        let postObject = ["bus_id": bus.id!,"customer_id": userId,"from_id": bus.source_id!,"to_id": bus.destination_id!,"total_fare": BusDetailViewController.totalFinalFare,"date_of_journey": BusBookingViewController.selectedDateForBooking,"time_of_journey": "10:30","seat_no": self.arrSheetCount!,"passengers_detail": self.arrpassanger] as [String: Any]
        print(postObject)
        let webCnctn = WebConnectionViewController()
        webCnctn.downloadData(fromUrl: URLs.bookingUrl, isAuthRequest: true, postObject: postObject, requestType: "POST", compHandler:{ data, error in

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
                        print(json)
                        MBProgressHUD.hide(for: self.view, animated: true)

                        let error = json["error"] as? Bool
                        if !error!{
                            //Create tabbar and navigate to home screen
                            guard let bookings = json["booking_details"] as? NSArray  else{return}
                            guard let dict = bookings[0] as? NSDictionary else {return}
                            guard let id = dict.value(forKey: "id") as? Int else {return}
                            let bookingId = String(id)
                            let msg = json["success_messages"] as! String
                            print(msg)
                            complitionHandller(true, bookingId)
                        }
                        else{
                            guard let msg = json["error_messages"] as? String else {
                             return
                            }
                            self.showAlertController(title: "Alert", message :msg)
                            print(msg)
                            complitionHandller(false, nil)
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlertController(title: "Alert", message :error.localizedDescription)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    complitionHandller(false,nil)

                }
            }
        })
    }
}
