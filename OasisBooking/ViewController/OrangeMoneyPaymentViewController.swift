//
//  OrangeMoneyPaymentVIewControllerViewController.swift
//  OasisBooking
//
//  Created by MYGOV4 on 22/12/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit

public enum paymentType :String{
   case momo   = "momo"
   case orange = "om"
}

class OrangeMoneyPaymentViewController: UIViewController {
    
    var bookind_Id : String? = nil
    var payment_type : paymentType? = .momo
    var mobile_no : String? = nil
    
    
    @IBOutlet weak var txtMobileNum: UITextField!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet var doneBtn: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        toolbar.setItems([doneButton, spaceButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        txtMobileNum.inputAccessoryView = toolbar
        toolbar.sizeToFit()
    }
    
    @objc func doneClick() {
        txtMobileNum?.resignFirstResponder()
    }
    
    static var newInstance: OrangeMoneyPaymentViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "OrangeMoneyPaymentViewController") as! OrangeMoneyPaymentViewController
        return vc
    }
    
    func proceedPayment() {
        self.mobile_no =  txtMobileNum.text
        
        self.completePayment{ (success,message,paymentStatus) in
            if success {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Success!", message: "Did you confirm your pin in this payment",preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "cancel", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
                        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                        }))
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
                        self.paymentStatus{ (success,message,ticketUrlString) in
                            if success {
                                DispatchQueue.main.async {
                                    guard let ticketUrl = URL(string: ticketUrlString!) else{return}
                                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                                    UIApplication.shared.open(ticketUrl, options: [:]) { (success) in
                                    }
                                }
                            }
                            else {
                                self.showAlertController(message: "Sorry!,payment failed!!")
                            }
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                //failed
                self.showAlertController(message: "Sorry!,payment failed!!")
            }
        }
    }


 @IBAction func paymentButtonClick(_ sender: Any) {
    if !txtMobileNum.text!.isEmpty{
     self.proceedPayment()
    }
 }

}
