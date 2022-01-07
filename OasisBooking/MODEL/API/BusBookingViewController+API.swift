//
//  BusBookingViewController+API.swift
//  OasisBooking
//
//  Created by Anuj Garg on 05/03/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import Foundation
import MBProgressHUD

extension BusBookingViewController {
    
        func SearcbBusApi() {
           
            DispatchQueue.main.async {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.contentColor = UIColor.black
                hud.label.text = "searching..."
            }
            let postObject = ["source_id":source.cityId!, "destination_id":destination.cityId!,"date_of_journey":self.selectedDate,"time_of_journey" : "10:30"] as [String: Any]
            print(postObject)
            let webCnctn = WebConnectionViewController()
            webCnctn.downloadData(fromUrl: URLs.searchBusUrl, isAuthRequest: false, postObject: postObject, requestType: "POST", compHandler:{ data, error in

                guard error == nil else {
                    //print(error?.localizedDescription ?? "Error Message")
                    return
                }
                guard let data = data else {
                    return
                }
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                        DispatchQueue.main.async {
                            print(json)
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let error = json["error"] as? Bool
                            if !error!{
                                //Create tabbar and navigate to home screen
                                guard let buses = json["bus_list"] as? NSArray else{return}
                                guard let journeyDate = json["date_of_journey"] as? String else{return}
                               
                               let availableBusViewController = self.storyboard?.instantiateViewController(withIdentifier: "AvailableBusViewController") as! AvailableBusViewController
                               availableBusViewController.availableBuses = Bus().allBusses(busList: buses)
                                availableBusViewController.journeyDate = journeyDate
                               self.navigationController?.present(availableBusViewController, animated: true, completion: nil)
                            }
                            else{
                                guard let msg = json["message"] as? String else{
                                    return
                                }
                                self.showAlertController(title: "Alert", message :msg)
                                print(msg)
                            }
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.showAlertController(title: "Alert", message :error.localizedDescription)
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
            })
        }
    }
