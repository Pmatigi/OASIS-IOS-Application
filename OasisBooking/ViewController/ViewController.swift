//
//  ViewController.swift
//  OasisBooking
//
//  Created by Neeraj Mishra on 18/01/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit
import MBProgressHUD

class ViewController: UIViewController {
    @IBOutlet weak var btnRegistration: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtUserPassword: UITextField!

    
    static var newInstance: ViewController {
          let storyboard = UIStoryboard(name: "OnBoarding", bundle: nil)
          let vc = storyboard.instantiateViewController(
              withIdentifier: "ViewController") as! ViewController
          return vc
      }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backView.layer.cornerRadius = 7.0
        self.backView.clipsToBounds = true
        self.txtUserName.text = "oasisbus@gmail.com"
        self.txtUserPassword.text = "123456"
    }
     @IBAction func loginBtnClick(sender: UIButton!) {
        if self.txtUserName.text == ""
        {
            self.presentAlert(withTitle: "", message: "Please enter user name")
        }else if self.txtUserPassword.text == ""
        {
            self.presentAlert(withTitle: "", message: "Please enter password")
        }else{
            self.loginWebApi(txtUserName:txtUserName?.text ?? "", txtPwd:txtUserPassword.text ?? "")
        }
    }
    
    @available(iOS 13.0, *)
    @IBAction func forgotBtnClick(sender: UIButton){
        let forgotView = self.storyboard?.instantiateViewController(identifier: "ForgotPasswordViewController")as! ForgotPasswordViewController
            self.navigationController?.pushViewController(forgotView, animated: true)
    }
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ViewController {
    func loginWebApi(txtUserName: String, txtPwd: String) {
        print(txtUserName)
        print(txtPwd)
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.contentColor = UIColor.black
            hud.label.text = "Loading..."
        }
        let postObject = ["email":txtUserName, "password":txtPwd] as [String: Any]
        
        let webCnctn = WebConnectionViewController()
        webCnctn.downloadData(fromUrl: URLs.loginUrl, isAuthRequest: false, postObject: postObject, requestType: "POST", compHandler:{ data, error in

            guard error == nil else {
                //print(error?.localizedDescription ?? "Error Message")
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
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
                        MBProgressHUD.hide(for: self.view, animated: true)

                        let error = json["error"] as? Bool
                        if !error!{
                            do {
                            //Create tabbar and navigate to home screen
                            guard let result = json["results"] as? [String: AnyObject]  else{return}
                            guard let token = result["token"] as? String else{return}
                            guard let user = result["user"] as? NSDictionary else{return}
                            
                            let userDetail = try User().userDetail(dict: user)
                            guard (json["messages"] as? String) != nil else{return}
                        
                                print("user********",userDetail.username)
                             DataModel.saveLoggedinUser(user: userDetail)
                             DataModel.shared.accessToken = token
//                               let tabView = self.storyboard?.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
//                               self.navigationController?.present(tabView, animated: true, completion: nil)
                               self.navigationController?.popToRootViewController(animated: false)
                               DataModel.shared.accessToken = token
                            }
                            catch let error{
                                print(error)
                            }
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

