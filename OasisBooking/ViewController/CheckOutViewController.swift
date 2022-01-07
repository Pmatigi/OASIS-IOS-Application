//
//  CheckOutViewController.swift
//  OasisBooking
//
//  Created by MYGOV4 on 25/04/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit
import Stripe
import BraintreeDropIn
import Braintree

class CheckoutViewController: UIViewController {
    
    static var newInstance: CheckoutViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "CheckoutViewController") as! CheckoutViewController
        return vc
    }
    
    @IBOutlet weak var paymntTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    var booking_id : String?
    var arrPaymentMethod = ["Debit card", "Credit card","Orange Money","Momo Money"]
    var arrImgPaymentMethod = ["debit", "credit","orangemoney","orangemoney"]
    var braintree_token : String?

}

extension CheckoutViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPaymentMethod.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentMethodCell", for: indexPath) as! BusWithTravelAgencyCell
        cell.lblRating.text = arrPaymentMethod[indexPath.row]
        cell.imgBusImage.image = UIImage(named: arrImgPaymentMethod[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 2 {
           let vc = OrangeMoneyPaymentViewController.newInstance
           vc.bookind_Id = self.booking_id
            vc.payment_type = .orange
           self.present(vc, animated: true, completion: nil)
        }else if indexPath.row == 3 {
            let vc = OrangeMoneyPaymentViewController.newInstance
            vc.bookind_Id = self.booking_id
            vc.payment_type = .momo
            self.present(vc, animated: true, completion: nil)
           //self.showDropIn(clientTokenOrTokenizationKey: "sandbox_fwxyfft3_4jtxwkgrm7fmzkhy")//"sandbox_6m78ffbj_4jtxwkgrm7fmzkhy")
            
        }
        else{
            let vc = PaymentViewController.newInstance
            vc.bookind_Id = self.booking_id
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
// Mark:-for paypal integration
//    func showDropIn(clientTokenOrTokenizationKey: String) {
//        let request =  BTDropInRequest()
//        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
//        { (controller, result, error) in
//            if (error != nil) {
//                print("ERROR",error)
//            } else if (result?.isCancelled == true) {
//                print("CANCELLED")
//            } else if let result = result {
//                guard let nuance = result.paymentMethod?.nonce else {return}
//                self.braintree_token = nuance
//                print("Nuance:", nuance)
//
//                // Use the BTDropInResult properties to update your UI
//                self.completePayment{ (success,message,ticketUrlString) in
//                    if success {
//                        DispatchQueue.main.async {
//                            let alert = UIAlertController(title: "Success!", message: message,preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: "ViewTicket", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
//                                guard let ticketUrl = URL(string: ticketUrlString!) else{return}
//                                self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
//                                UIApplication.shared.open(ticketUrl, options: [:]) { (success) in
//
//                                }
//                            }))
//                            self.present(alert, animated: true, completion: nil)
//                           // self.showAlertController(title: "Alert!", message: message)
//                        }
//                    }
//                    else {
//                        //failed
//                    }
//                }
//            }
//
//            controller.dismiss(animated: true, completion: nil)
//        }
//        self.present(dropIn!, animated: true, completion: nil)
//    }

}
