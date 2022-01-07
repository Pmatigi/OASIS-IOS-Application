//
//  Paymet+API.swift
//  OasisBooking
//
//  Created by MYGOV4 on 28/04/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import Foundation
import MBProgressHUD

extension PaymentViewController {

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
        
        guard let bookingId = self.bookind_Id else {return}
        guard let token = self.stripe_token else {return}

        //if DataModel.shared.isLoggedIn
 
    let postObject = ["stripe_token": token,"booking_id": bookingId] as [String: Any]
        print(postObject)
        let webCnctn = WebConnectionViewController()
        webCnctn.downloadData(fromUrl: URLs.PaymentUrl, isAuthRequest: true, postObject: postObject, requestType: "POST", compHandler:{ data, error in
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


extension OrangeMoneyPaymentViewController {

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
        
        guard let bookingId = self.bookind_Id else {return}
        guard let type = self.payment_type?.rawValue else {return}
        guard let mobileNo = self.mobile_no else {return}
        //if DataModel.shared.isLoggedIn
 
    let postObject = ["payment_type": type,"booking_id": bookingId,"mobile_no":mobileNo] as [String: Any]
        print(postObject)
        let webCnctn = WebConnectionViewController()
        webCnctn.downloadData(fromUrl: URLs.OrangeMoneyPaymentUrl, isAuthRequest: true, postObject: postObject, requestType: "POST", compHandler:{ data, error in
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
                        if error!{
                            //Create tabbar and navigate to home screen
                           // guard let bookings = json["booking_details"] as? NSArray  else{return}
                            let payemtStatus = json["payment_status"] as! String
                            let msg = json["messages"] as! String
                            print(msg)
                            if payemtStatus == "pending"{
                             complitionHandller(true, msg, payemtStatus)
                            }
                            else{
                                complitionHandller(false, msg, payemtStatus)
                            }
                        }
                        else{
                            guard let msg = json["messages"] as? String else {
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

extension OrangeMoneyPaymentViewController {

 func paymentStatus(complitionHandller: @escaping (Bool, String?,String?)-> Void) {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.contentColor = UIColor.black
            hud.label.text = "processsing payment..."
        }
        if !self.checkIfLoggedInElseAsk() { return }
        guard let userId = DataModel.shared.currentUserId() else{
            return
        }
        
        guard let bookingId = self.bookind_Id else {return}
       
        //if DataModel.shared.isLoggedIn
 
    let postObject = ["booking_id": bookingId] as [String: Any]
        print(postObject)
        let webCnctn = WebConnectionViewController()
        webCnctn.downloadData(fromUrl: URLs.OrangeMoneyPaymenStatustUrl, isAuthRequest: true, postObject: postObject, requestType: "POST", compHandler:{ data, error in
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
                            let link = json["ticket_link"] as! String
                            let msg = json["messages"] as! String
                            print(msg)
                            complitionHandller(true, msg, link)
                        }
                        else{
                            guard let msg = json["messages"] as? String else {
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
