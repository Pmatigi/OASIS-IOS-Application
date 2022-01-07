
//
//  RegistrationViewController.swift
//  OasisBooking
//
//  Created by Neeraj Mishra on 26/01/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
     @IBOutlet weak var backView: UIView!
     @IBOutlet weak var txtUserName: UITextField!
     @IBOutlet weak var txtpassword: UITextField!
     @IBOutlet weak var txtConfPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backView.layer.cornerRadius = 7.0
        self.backView.clipsToBounds = true
    }

    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nextBtnClick(sender: UIButton!) {
        if self.txtUserName.text == ""
        {
            self.presentAlert(withTitle: "", message: "Please enter user name")
        }else if self.txtpassword.text == ""
        {
            self.presentAlert(withTitle: "", message: "Please enter password")
        }else if self.txtConfPass.text == ""
        {
            self.presentAlert(withTitle: "", message: "Please enter password")
        }else if self.txtpassword.text != self.txtConfPass.text
        {
            self.presentAlert(withTitle: "", message: "Password not matched")
        }
        else{
           let regFinishView = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationFinishViewController") as! RegistrationFinishViewController
            RegistrationFinishViewController.usereName = self.txtUserName.text!
            RegistrationFinishViewController.password = self.txtpassword.text!
            RegistrationFinishViewController.confirmPassword = self.txtConfPass.text!
            self.navigationController?.pushViewController(regFinishView, animated: true)        }
    }
}
extension RegistrationViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
       if textField == self.txtpassword ||  textField == self.txtConfPass{
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseInOut, animations:{
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y-110, width: self.view.frame.size.width, height: self.view.frame.size.height)
            })
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtpassword ||  textField == self.txtConfPass {
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseInOut, animations:{
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y+110, width: self.view.frame.size.width, height: self.view.frame.size.height)
            })
        }
    }
}
