//
//  ForgotPasswordViewController.swift
//  OasisBooking
//
//  Created by Nex Mishra on 20/01/21.
//  Copyright © 2021 OasisBooking. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btnForogotPwd: UIButton!
    @IBOutlet weak var txtEmail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.backView.layer.cornerRadius = 5.0
        self.backView.clipsToBounds = true

    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func forgotBtnClick(_ sender: Any) {
        self.SendOtp { (success, message) in
            if success{
                self.showAlertController(title: "Success!", message: message)
                let storyboard = UIStoryboard(name: "OnBoarding", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
                vc.email = self.txtEmail.text
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                self.showAlertController(title: "Alert!", message: message)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
