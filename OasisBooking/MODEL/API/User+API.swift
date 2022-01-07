//
//  User+API.swift
//  OasisBooking
//
//  Created by Anuj Garg on 01/03/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import Foundation
import MBProgressHUD

extension ProfileViewController {
    
    func getUserProfile() {
        
        guard let id = DataModel.shared.currentUserId() else{return}
        let postObject = ["user_id": id] as [String: Any]
        print(postObject)
        
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.contentColor = UIColor.black
            hud.label.text = ""
        }
                
        let webCnctn = WebConnectionViewController()
        webCnctn.downloadData(fromUrl: URLs.getUserProfileUrl, isAuthRequest: true, postObject: postObject, requestType: "POST", compHandler:{ data, error in
            
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
                    
                    print(json)
                    let error = json["error"] as? Bool
                    if !error!{
                        //Create tabbar and navigate to home screen
                        guard let userDict = json["results"] as? NSDictionary else{return}
                       // DispatchQueue.main.async {
                        let user = try User().userDetail(dict: userDict)
                        print(user)
                        self.user = user
                       // }
                    }
                    else{
                        guard let msg = json["message"] as? String else{
                            return
                        }
                        self.showAlertController(title: "Alert", message :msg)
                        print(msg)
                    }
                    // }
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
    
    
    func uploadProfileImage(profileImage:UIImage, userId:String, complitionHandller: @escaping (Bool, NSDictionary?)-> Void) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let strToken = "Bearer " + DataModel.shared.accessToken!
        print(strToken)
        
        let headers = [
            //"content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
            "authorization":strToken]
        let parameters = [
            [
                "name": "user_id",
                "value": userId
            ],
            [
                "name": "profile_picture",
                "value": userId
            ]
            
        ]
        
        let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        
        let body = NSMutableData()
        
        for param in parameters {
            let paramName = param["name"]!
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append(String(format: "Content-Disposition: form-data; name=\"\(paramName)\"\r\n\r\n").data(using: String.Encoding.utf8)!)
            
            if let paramValue = param["value"] {
                body.append("\r\n\r\n\(paramValue)".data(using: String.Encoding.utf8)!)
            }
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }
        
        guard let data = profileImage.jpegData(compressionQuality: 1.0) else { return }
        
        // if let imageData = UIImageJPEGRepresentation(feedImage, 0.5) {
        //define the data post parameter
        let mimeType = "image/jpeg"
        let fileName = "profilePic.png"
        // let key = "feedImageFile"
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        // body.append("Content-Disposition:form-data; name=\"profile_picture\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"profile_picture\"; filename=\"\(fileName)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(data)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        //}
        let request = NSMutableURLRequest(url: NSURL(string: URLs.UploadProfileImageUrl)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = body as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        let error = json["error"] as? Bool
                        if !error!{
                            //Create tabbar and navigate to home screen
                            guard let dict = json["results"] as? NSDictionary else{return}
                            DispatchQueue.main.async {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                complitionHandller(true,dict)
                                self.showAlertController(title: "Success!", message :(json["messages"] as? String))

                                //let user =  User().userDetail(dict: userDict)
                                // print(user)
                            }
                        }
                        else{
                        
                        guard let msg = json["errors"] as? NSDictionary else{return}
                        let keys = msg.allKeys
                        var messages = String()
                        for key in keys {
                            let keyString =  key as? String
                            let msgString = msg.value(forKey: keyString!) as! NSArray
                            messages =  messages +  " " + (msgString[0] as! String)
                            print(messages)
                        }
                        self.showAlertController(title: "Alert", message :messages)
                        complitionHandller(false,nil)
                    }
                        
                    }
                } catch let error {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        
                    }
                }
            }
        })
        
        dataTask.resume()
    }
    
}
