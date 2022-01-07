//
//  BusDetail+API.swift
//  OasisBooking
//
//  Created by Anuj Garg on 18/03/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import Foundation
import MBProgressHUD

extension AvailableBusViewController {

    func getBusDetailApi(busInfoDict:BusInfo?, complitionHandller: @escaping (Bool,Bus?)-> Void) {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.contentColor = UIColor.black
            hud.label.text = "Loading..."
        }
        guard let busInfo = busInfoDict else { return }
        let postObject = ["bus_id": busInfo.bus_id!,"source_id": busInfo.source_id!, "destination_id": busInfo.destination_id!,"date_of_journey": busInfo.date_of_journey!,"time_of_journey": busInfo.time_of_journey!] as [String: Any]
        print(postObject)
        let webCnctn = WebConnectionViewController()
        webCnctn.downloadData(fromUrl: URLs.busDetailsUrl, isAuthRequest: false, postObject: postObject, requestType: "POST", compHandler:{ data, error in

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
                            guard let buses = json as? NSDictionary  else{return}
                            let bus = Bus().busDetail(dict: buses)
                            //self.bus = bus
                            complitionHandller(true,bus)
                        }
                        else{
                            guard let msg = json["message"] as? String else{
                                return
                            }
                            self.showAlertController(title: "Alert", message :msg)
                            print(msg)
                            complitionHandller(false,nil)
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
