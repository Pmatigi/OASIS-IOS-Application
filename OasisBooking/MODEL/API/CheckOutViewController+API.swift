//
//  CheckOutViewController+API.swift
//  OasisBooking
//
//  Created by MYGOV4 on 21/06/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import Foundation
import MBProgressHUD

extension CheckoutViewController {

 func completePayment(complitionHandller: @escaping (Bool, String?,String?)-> Void) {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.contentColor = UIColor.black
            hud.label.text = "processsing payment..."
        }
        if !self.checkIfLoggedInElseAsk() { return }
        guard let userId = DataModel.shared.currentUserId() else{
            return
        }
        
        guard let bookingId = self.booking_id else {return}
        guard let token = self.braintree_token else {return}

        //if DataModel.shared.isLoggedIn
 
    let postObject = ["braintree_token": token,"booking_id": bookingId] as [String: Any]
        print(postObject)
        let webCnctn = WebConnectionViewController()
        webCnctn.downloadData(fromUrl: URLs.braintree_PaymentUrl, isAuthRequest: true, postObject: postObject, requestType: "POST", compHandler:{ data, error in
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
                           // guard let bookings = json["booking_details"] as? NSArray  else{return}
                            let ticketUrlString = json["ticket_link"] as! String
                            let msg = json["message"] as! String
                            print(msg)
                            complitionHandller(true, msg, ticketUrlString)
                        }
                        else{
                            guard let msg = json["message"] as? String else {
                             return
                            }
                            self.showAlertController(title: "Alert", message :msg)
                            print(msg)
                            complitionHandller(false, nil, nil)
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlertController(title: "Alert", message :error.localizedDescription)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    complitionHandller(false,nil,nil)

                }
            }
        })
    }
}
