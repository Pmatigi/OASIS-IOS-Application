//
//  ChangePasswordViewController.swift
//  OasisBooking
//
//  Created by MYGOV4 on 23/01/21.
//  Copyright © 2021 OasisBooking. All rights reserved.
//



import UIKit
import Foundation


class ChangePasswordViewController: UIViewController {
     @IBOutlet weak var backView: UIView!
     @IBOutlet weak var txtOtp: UITextField!
     @IBOutlet weak var txtpassword: UITextField!
     @IBOutlet weak var txtConfPass: UITextField!
     @IBOutlet var doneBtn: UIBarButtonItem!
     @IBOutlet weak var toolbar: UIToolbar!

     var email : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backView.layer.cornerRadius = 7.0
        self.backView.clipsToBounds = true
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        toolbar.setItems([doneButton, spaceButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        txtOtp.inputAccessoryView = toolbar
        toolbar.sizeToFit()
    }
    
    @objc func doneClick() {
        txtOtp?.resignFirstResponder()
    }

    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnClick(sender: UIButton!) {
        if self.txtOtp.text == ""
        {
            self.presentAlert(withTitle: "", message: "Please enter OTP")
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
        // call API
        self.changePassword { (success, message) in
            if success {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Success!", message: message, preferredStyle: .alert)

                    let okayAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                        for aViewController in viewControllers {
                            if aViewController is ViewController {
                                self.navigationController!.popToViewController(aViewController, animated: false)
                            }
                        }
                    }
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            else{
                
            }
        }
        }
    }
}


extension ChangePasswordViewController: UITextFieldDelegate{
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

