//
//  ViewController.Helper.swift
//  LightFoot
//
//  Created by Anuj Garg on 10/01/20.
//  Copyright © 2020 LightFoot. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

var oflineNetworkView = UIView()


extension UIViewController {
    func showAlertController(title: String? = nil, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okayAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        present(alertController, animated: true, completion: nil)
    }
}
    
    
//NETWORK VIEW

extension UIViewController {

    func NetworkCheck(){
        oflineNetworkView.removeFromSuperview()
        let window = UIApplication.shared.keyWindow!
        oflineNetworkView = UIView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height))
        window.addSubview(oflineNetworkView);
        oflineNetworkView.backgroundColor = UIColor.white
        let imgView = UIImageView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height))
        imgView.backgroundColor = UIColor.white
        imgView.image = UIImage(named: "no_internet_img.png")
        imgView.contentMode = .scaleAspectFit
        oflineNetworkView.addSubview(imgView)
        
        
        let button = UIButton(frame: CGRect(x: window.frame.origin.x, y: window.frame.height-40, width: window.frame.width, height: 40))
        button.backgroundColor = UIColor.white
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        oflineNetworkView.addSubview(button)
        window.addSubview(oflineNetworkView)
    }
    
    @objc func buttonAction(sender: UIButton!) {
           let webCnctn = WebConnectionViewController()
           if webCnctn.isConnectedToNetwork(){
            oflineNetworkView.removeFromSuperview()
            AppDelegate().shareDeleagte.window?.rootViewController?.viewDidLoad()
           }
       }
}

