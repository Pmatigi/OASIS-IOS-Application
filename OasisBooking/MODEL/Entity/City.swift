//
//  City.swift
//  OasisBooking
//
//  Created by Anuj Garg on 04/03/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import Foundation
import UIKit

public class City : NSObject {
    var cityName : String?
    var cityId : String?
}


extension City {
    public func getAllCities(completionHandler: @escaping(Array<City>?, Bool) -> Void){
                
        let webCnctn = WebConnectionViewController()
        webCnctn.downloadData(fromUrl: URLs.getCityUrl, isAuthRequest: false, postObject: nil, requestType: "GET", compHandler:{ data, error in

            guard error == nil else {
                //print(error?.localizedDescription ?? "Error Message")
                DispatchQueue.main.async {
                }
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

                        let error = json["error"] as? Bool
                        if !error!{
                            //Create tabbar and navigate to home screen
                            guard let city = json["city"] as? NSArray  else{return}
                            print(city)
                            var cityValues = Array<City>()
                            for dict in city{
                                let cityTmp = City()
                                let id = (dict as? NSDictionary)?.value(forKey: "id") as! Int
                                cityTmp.cityId = String(id)
                                cityTmp.cityName = (dict as? NSDictionary)?.value(forKey: "name") as? String
                                cityValues.append(cityTmp)
                            }
                            print(cityValues)
                            completionHandler(cityValues,true)
                        }
                        else{
                            //print error
                            guard let msg = json["messages"] as? NSDictionary else{return}
                            let keys = msg.allValues as NSArray
                            completionHandler(nil,false)
                            print(msg)
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
                DispatchQueue.main.async {

                }
            }
        })
    }
}
