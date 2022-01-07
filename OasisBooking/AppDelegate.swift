//
//  AppDelegate.swift
//  OasisBooking
//
//  Created by Neeraj Mishra on 18/01/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
import Braintree


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    // Shared Appdelegate
    var shareDeleagte: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyA3wqXT9S0V61_WcoJeDcWaExodKCi87qU")
        GMSPlacesClient.provideAPIKey("AIzaSyA3wqXT9S0V61_WcoJeDcWaExodKCi87qU")
        
        DataModel.shared.setUpStripe()
        
        if !DataModel.shared.isLoggedIn, DataModel.shared.accessToken == nil {
            showAuthentication()
        }
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        BTAppSwitch.setReturnURLScheme("com.oasis.oasisBooking.payments")

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare("com.oasis.oasisBooking.payments") == .orderedSame {
            return BTAppSwitch.handleOpen(url, options: options)
        }
        return false
    }
    
   func showAuthentication() {
//       let storyboard = UIStoryboard(name: "OnBoarding", bundle: nil)
//    if #available(iOS 13.0, *) {
//        let onboardingVC = storyboard.instantiateViewController(identifier: "ViewController")
//       // (self.window?.rootViewController as? UINavigationController)!.present(onboardingVC, animated: true, completion: nil)
//        (self.window?.rootViewController as? UINavigationController)!.pushViewController(onboardingVC, animated: true)
//
//    } else {
//        // Fallback on earlier versions
//        let onboardingVC = storyboard.instantiateViewController(withIdentifier: "ViewController")
//        //(self.window?.rootViewController as? UINavigationController)!.present(onboardingVC, animated: true, completion: nil)
//       (self.window?.rootViewController as? UINavigationController)!.pushViewController(onboardingVC, animated: true)
//
//
//    }
//
    
        let storyboard = UIStoryboard(name: "OnBoarding", bundle: nil)
        let onboardingVC = ViewController.newInstance
        (self.window?.rootViewController as? UINavigationController)!.pushViewController(onboardingVC, animated: true)
    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "OasisBooking")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


extension UIViewController {

  func presentAlert(withTitle title: String, message : String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { action in
        print("You've pressed OK Button")
    }
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }

}
