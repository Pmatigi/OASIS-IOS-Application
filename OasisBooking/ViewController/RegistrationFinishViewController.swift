//
//  RegistrationFinishViewController.swift
//  OasisBooking
//
//  Created by Neeraj Mishra on 26/01/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit
import MBProgressHUD

class RegistrationFinishViewController: UIViewController {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCINNo: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!

   static var password : String = ""
   static var confirmPassword : String = ""
   static var usereName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backView.layer.cornerRadius = 7.0
        self.backView.clipsToBounds = true
        print(RegistrationFinishViewController.password)
        print(RegistrationFinishViewController.usereName)
        txtPhoneNo.inputAccessoryView = toolBar
       // txtCINNo.inputAccessoryView = toolBar
    }
    
    @IBAction func submitBtnClick(sender: UIButton!) {
        if self.txtPhoneNo.text == ""
        {
            self.presentAlert(withTitle: "", message: "Please enter phone number")
        }else if self.txtEmail.text == ""
        {
            self.presentAlert(withTitle: "", message: "Please enter email")
        }else if self.txtCINNo.text == ""
        {
            self.presentAlert(withTitle: "", message: "Please enter CIN number")
        }
        else{
            self.registrationWebbApi()
        }
    }
    @IBAction func doneBtnClick(sender: UIBarButtonItem!)
    {
        self.txtPhoneNo.resignFirstResponder()
       // self.txtCINNo.resignFirstResponder()
    }
    func validate(YourEMailAddress: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: YourEMailAddress)
    }
}

extension RegistrationFinishViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPhoneNo{
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 10
        }
        if textField == txtCINNo{
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 21
        }
            return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
       if textField == self.txtEmail ||  textField == self.txtCINNo{
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseInOut, animations:{
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y-110, width: self.view.frame.size.width, height: self.view.frame.size.height)
            })
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       if textField == self.txtEmail ||  textField == self.txtCINNo {
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseInOut, animations:{
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y+110, width: self.view.frame.size.width, height: self.view.frame.size.height)
            })
        }
    }
}

extension RegistrationFinishViewController {
    func registrationWebbApi() {
       
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.contentColor = UIColor.black
            hud.label.text = "Loading..."
        }
        let postObject = ["email":txtEmail.text!, "password":RegistrationFinishViewController.self.password, "username": RegistrationFinishViewController.self.usereName, "confirm_password":RegistrationFinishViewController.self.confirmPassword, "phone_number":txtPhoneNo.text!,"cin_number":txtCINNo.text!] as [String: Any]
        print(postObject)
        let webCnctn = WebConnectionViewController()
        webCnctn.downloadData(fromUrl: URLs.registrationUrl, isAuthRequest: false, postObject: postObject, requestType: "POST", compHandler:{ data, error in

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
                            guard let result = json["results"] as? [String: AnyObject]  else{return}
                            guard let token = result["token"] as? String else{return}
                            guard let user = result["user"] as? [String: AnyObject] else{return}
                            guard let msg = json["messages"] as? String else{return}
                           // self.performSegue(withIdentifier: "RegistrationFinishViewController", sender: self)
                            DataModel.shared.accessToken = token
                            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                            for aViewController in viewControllers {
                                if aViewController is ViewController {
                                    self.navigationController!.popToViewController(aViewController, animated: false)
                                }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
