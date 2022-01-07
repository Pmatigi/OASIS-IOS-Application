//
//  DataModel.swift
//  LightFoot
//
//  Created by Neeraj Mishra on 11/02/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//



import Foundation
import GoogleMaps
import GooglePlaces
import RealmSwift
import Stripe

private let AccessTokenKey = "AccessTokenKey"
private let AuthTokenkey = "AuthTokenkey"



public class DataModel {
    public static let UserDidLogin = NSNotification.Name("UserDidLogin")
    public static let UserDidLogout = NSNotification.Name("UserDidLogout")
    
    public static let shared = DataModel()
    private var loggedInUser: User?
    private let userDefaults = UserDefaults.standard
    static let realm: Realm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))

    public var isLoggedIn: Bool {
        if self.accessToken != nil{
            return true
        }
        return false
    }
    
    private func clearDatabase() {
        let realm = DataModel.realm
        try! realm.write {
            realm.deleteAll()
        }
    }
    
//    public var currentUser: User? {
//        guard let loggedInUser = self.loggedInUser else {
//            guard let currentUserId = currentUserId() else { return nil }
//            if let user = DataModel.realm.object(ofType: User.self, forPrimaryKey: currentUserId) {
//                self.loggedInUser =  user
//               // DataModel.shared.configureEverything(forUser: user)
//                return self.loggedInUser
//            }
//            return self.loggedInUser
//        }
//        return loggedInUser
//    }

    public static func saveLoggedinUser(user: User) {
        self.shared.userDefaults.set(user.id, forKey: "uid")
        self.shared.userDefaults.synchronize()
        NotificationCenter.default.post(name: DataModel.UserDidLogin, object: self)
    }
    
    
    public func logoutUser() {
//        User().logout() { [weak self] result in
//
//        }
        self.loggedInUser = nil
        self.accessToken = nil
       // User.removeAll()
       // Profile.removeAll() //TODO
        self.userDefaults.removeObject(forKey: "uid")
        self.userDefaults.synchronize()
        
    }
    
    func currentUserId() -> String? {
        return (self.userDefaults.object(forKey: "uid") as? String)
    }
    
    public var accessToken: String? {
        get {
            return self.userDefaults.value(forKey: AccessTokenKey) as? String
        } set {
            self.userDefaults.set(newValue, forKey: AccessTokenKey)
            self.userDefaults.synchronize()
        }
    }

    public var deviceId: String {
        guard let deviceId = self.userDefaults.string(forKey: "deviceId") else {
            let idForVendor = UIDevice.current.identifierForVendor?.uuidString
            self.userDefaults.set(idForVendor, forKey: "deviceId")
            self.userDefaults.synchronize()
            return idForVendor!
        }
        return deviceId
    }
        
    public func setUpStripe(){
        Stripe.setDefaultPublishableKey(Constants.STRIPE_Key)
    }
}



