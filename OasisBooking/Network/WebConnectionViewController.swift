//
//  WebConnectionViewController.swift
//  LightFoot
//
//  Created by Neeraj Mishra on 20/12/19.
//  Copyright © 2019 LightFoot. All rights reserved.
//


import UIKit
import SystemConfiguration

class WebConnectionViewController: UIViewController {
    
    public func downloadData(fromUrl: String,isAuthRequest : Bool, postObject :[String : Any]?, requestType : String, compHandler:@escaping (Data?, Error?)->Void ){
        
        if isConnectedToNetwork(){
            let url = NSURL(string: fromUrl)
            let request = NSMutableURLRequest.init(url: url! as URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 50.0)
            
            //Request Type GET/POST
            request.httpMethod = requestType
            
            if isAuthRequest{
                let strToken = "Bearer " + DataModel.shared.accessToken!
                print(strToken)
                let headers = [
                    "authorization": strToken
                ]
                request.allHTTPHeaderFields = headers
            }
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            if requestType == "POST" {
                if let myTmpDict = postObject {
                    let jsonData = try? JSONSerialization.data(withJSONObject: myTmpDict , options: .prettyPrinted)
                    request.httpBody = jsonData
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                }
            }
            // make the request
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                //Call completion handler clouser
                compHandler(data, error)
            })
            task.resume()
        }
        else{
            self.NetworkCheck()
        }
    }
    
    public func isConnectedToNetwork() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}


extension WebConnectionViewController {
    
       
}
