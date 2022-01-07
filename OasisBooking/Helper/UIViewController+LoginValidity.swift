

import UIKit
import Foundation

extension UIViewController {
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func checkIfLoggedInElseAsk() -> Bool {
        if DataModel.shared.isLoggedIn {
            return true
        }
        let alert = UIAlertController(title: "Login Alert", message: "You can continue booking by signing in",preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "SignIn",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        self.proceedToLogin()
                                        
        }))
        self.present(alert, animated: true, completion: nil)
        return false
    }
    
    
    func proceedToLogin() {
        self.appDelegate.showAuthentication()
    }
    func proceedToLogout(){
        DataModel.shared.logoutUser()
    }
    
    func observeLoginNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIViewController.setupForUserLoginStatus),
            name: DataModel.UserDidLogout,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIViewController.setupForUserLoginStatus),
            name: DataModel.UserDidLogin,
            object: nil
        )
    }
    
    @objc func setupForUserLoginStatus() {
        
    }
    
    func showAlertController(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
//            //Cancel Action
//        }))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
                                        
        }))
    }
}

