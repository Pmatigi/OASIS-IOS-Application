//
//  RouteTracker+API.swift
//  OasisBooking
//
//  Created by MYGOV4 on 09/06/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import Foundation
import MBProgressHUD
import GoogleMaps

extension TrackBusViewController {

    func createRoute(complitionHandller: @escaping (Bool)-> Void) {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.contentColor = UIColor.black
            hud.label.text = "Loading..."
        }
       
        let webCnctn = WebConnectionViewController()
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(source)&destination=\(destination)&mode=driving"
        print("url is",url)
        webCnctn.downloadData(fromUrl: url, isAuthRequest: false, postObject: nil, requestType: "GET", compHandler:{ data, error in

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

                        if let routes = json["routes"] as? [NSDictionary] {
                            //Create tabbar and navigate to home screen
                         for route in routes
                         {
                             let routeOverviewPolyline = route["overview_polyline"] as? NSDictionary
                             let points = routeOverviewPolyline?["points"] as? String
                             let path = GMSPath.init(fromEncodedPath: points!)
                             let polyline = GMSPolyline.init(path: path)
                            print("points",points)
                             polyline.strokeColor = UIColor.blue
                             polyline.strokeWidth = 2
                             polyline.map = self.viewMap
                         }
                            complitionHandller(true)
                       }
                        else{
                            self.showAlertController(title: "Alert", message :"Route can not be drawn.")
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
