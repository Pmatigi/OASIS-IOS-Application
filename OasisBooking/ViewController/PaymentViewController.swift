//
//  PaymentViewController.swift
//  OasisBooking
//
//  Created by MYGOV4 on 19/04/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit
import Stripe
import SafariServices


class PaymentViewController: UIViewController {
    
    static var newInstance: PaymentViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "PaymentViewController") as! PaymentViewController
        return vc
    }
    
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet var doneBtn: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var stripe_token : String?
    var bookind_Id : String? = nil
    
    lazy var cardTextField: STPPaymentCardTextField = {
        let cardTextField = STPPaymentCardTextField()
        return cardTextField
    }()
    
    lazy var payButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.setTitle("Pay", for: .normal)
        button.addTarget(self, action: #selector(pay), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [cardTextField, payButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        paymentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalToSystemSpacingAfter: paymentView.leftAnchor, multiplier: 2),
            view.rightAnchor.constraint(equalToSystemSpacingAfter: stackView.rightAnchor, multiplier: 2),
            paymentView.topAnchor.constraint(equalToSystemSpacingBelow: paymentView.topAnchor, multiplier: 200),
        ])
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        toolbar.setItems([doneButton, spaceButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        cardTextField.inputAccessoryView = toolbar
        toolbar.sizeToFit()
        
    }
    
    @objc func doneClick() {
        cardTextField.resignFirstResponder()
    }
    
    @objc func pay() {
      collectdardData()        
    }
    
    
    
    func collectdardData() {
        
        // Creating the card parameters:
        //card parameters
        let stripeCardParams = STPCardParams()
        stripeCardParams.number = cardTextField.cardNumber
        stripeCardParams.expMonth = cardTextField.expirationMonth
        stripeCardParams.expYear = cardTextField.expirationYear
        stripeCardParams.cvc = cardTextField.cvc
        
        //converting into token
        let config = STPPaymentConfiguration.shared()
        let stpApiClient = STPAPIClient(publishableKey: Constants.STRIPE_Key)//STPAPIClient.init(configuration: config)
        stpApiClient.createToken(withCard: stripeCardParams) { (token, error) in
            
            if error == nil {
                print("token is :", token)
                self.stripe_token = token?.tokenId
                self.completePayment{ (success,message,ticketUrlString) in
                    if success {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Success!", message: message,preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "ViewTicket", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
                                guard let ticketUrl = URL(string: ticketUrlString!) else{return}
//                                let safariVC = SFSafariViewController(url: ticketUrl, entersReaderIfAvailable: false)
//                                    self.view.window!.rootViewController?.dismiss(animated: true, completion: {
//                                         self.present(safariVC, animated: true)
//                                    })
                                self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                                UIApplication.shared.open(ticketUrl, options: [:]) { (success) in

                                }
                            }))
                            self.present(alert, animated: true, completion: nil)
                           // self.showAlertController(title: "Alert!", message: message)
                        }
                    }
                    else {
                        //failed
                    }
                }
            } else {
                //token generation failed
                print("token generation failed")
            }
        }
    }

    
    @IBAction func paymentButtonClick(_ sender: Any) {
        
    }
    
    
    @IBAction func backaButtonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}









