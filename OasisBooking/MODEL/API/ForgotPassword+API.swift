//
//  ForgotPassword+API.swift
//  OasisBooking
//
//  Created by MYGOV4 on 23/01/21.
//  Copyright © 2021 OasisBooking. All rights reserved.
//

import Foundation
import MBProgressHUD

//http://127.0.0.1:8080/api/send-otp

extension ForgotPasswordViewController{
    
    func SendOtp(complitionHandller: @escaping (Bool, String?)-> Void) {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.contentColor = UIColor.black
            hud.label.text = "Loading..."
        }
        let postObject = ["email":txtEmail.text!] as [String: Any]
        //print(postObject)
        let webCnctn = WebConnectionViewController()
        webCnctn.downloadData(fromUrl: URLs.sendOTP, isAuthRequest: false, postObject: postObject, requestType: "POST", compHandler:{ data, error in

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
                            guard let message = json["message"] as? String  else { return }
                            complitionHandller(true, message)
                           
                        }
                        else{
                            //print error
                            guard let msg = json["messages"] as? NSDictionary else{return}
                            let keys = msg.allKeys
                            var messages = String()
                            for key in keys {
                                let keyString =  key as? String
                                let msgString = msg.value(forKey: keyString!) as! NSArray
                                messages =  messages +  " " + (msgString[0] as! String)
                                print(messages)
                            }
                            self.showAlertController(title: "Alert", message :messages)
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


extension ChangePasswordViewController{
    
   public func changePassword(complitionHandller: @escaping (Bool, String?)-> Void) {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.contentColor = UIColor.black
            hud.label.text = "Loading..."
        }
    let postObject = ["email":self.email!,"otp":txtOtp.text!,"password":txtpassword.text!,"confirm_password":txtConfPass.text!] as [String: Any]
        //print(postObject)
        let webCnctn = WebConnectionViewController()
        webCnctn.downloadData(fromUrl: URLs.changePassword, isAuthRequest: false, postObject: postObject, requestType: "POST", compHandler:{ data, error in

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
                            guard let message = json["message"] as? String  else { return }
                           // self.showAlertController(title: "Success!", message: message)
                           // self.navigationController?.popViewController(animated: true)
                            complitionHandller(true, message)
                        }
                        else{
                            //print error
                            if let msg = json["messages"] as? NSDictionary {
                                let keys = msg.allKeys
                                var messages = String()
                                for key in keys {
                                    let keyString =  key as? String
                                    let msgString = msg.value(forKey: keyString!) as! NSArray
                                    messages =  messages +  " " + (msgString[0] as! String)
                                    print(messages)
                                }
                                self.showAlertController(title: "Alert", message :messages)
                            }
                            else{
                                if let msg = json["message"] as? String{
                                    self.showAlertController(title: "Alert", message :msg)
                                }
                            }
                            
                            //print(msg)
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
