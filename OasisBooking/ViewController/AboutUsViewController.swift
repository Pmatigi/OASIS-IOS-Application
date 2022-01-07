//
//  AboutUsViewController.swift
//  OasisBooking
//
//  Created by Neeraj Mishra on 09/02/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit
import MBProgressHUD

class AboutUsViewController: UIViewController {

    @IBOutlet weak var txtAboutUs: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        getAboutUsData()
    }
    
    
    func getAboutUsData() {
       
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.contentColor = UIColor.black
            hud.label.text = "searching..."
        }
        let postObject = ["type":"about_us"] as [String: Any]
        print(postObject)
        let webCnctn = WebConnectionViewController()
        webCnctn.downloadData(fromUrl: URLs.get_pagesUrl, isAuthRequest: false, postObject: postObject, requestType: "POST", compHandler:{ data, error in

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
                            guard let data = json["page_data"] as? NSDictionary else{return}
                            let text = data["description"] as? String
                            self.txtAboutUs.text = text
                        }
                        else{
                            guard let msg = json["message"] as? String else{
                                return
                            }
                            self.showAlertController(title: "Alert", message :msg)
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
    
 @IBAction func backBtnClick(sender: UIButton!) {
     self.dismiss(animated: true, completion: nil)
 }
}
