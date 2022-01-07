//
//  USER.swift
//  OasisBooking
//
//  Created by Anuj Garg on 01/03/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

public class User: NSObject {
    var id :String?
    var email:String?
    var username:String?
    var roles:String?
    var activation_code:String?
    var email_verified_at:String?
    var status :String?
    var social_id :String?
    var social_type :String?
    var created_at :String?
    var updated_at :String?
    var first_name:String?
    var last_name:String?
    var cin_number:String?
    var image:String?
    var date_of_birth:String?
    var gender :String?
    var phone_no :String?
    var postal_code :String?
    var address :String?
    var city_id :String?
    var city_name :String?
    var country_id :String?
    var country_name :String?
    
    
//    override public static func primaryKey() -> String? {
//        return "id"
//    }
}


extension User {
    public func userDetail(dict : NSDictionary) -> User {
        do {
            let user = User()
            let id = String(dict.value(forKey: "id") as! Int)
            user.id = id
            user.email                = dict.value(forKey: "email") as? String
            user.username             = dict.value(forKey: "username") as? String
            user.roles                = dict.value(forKey: "roles") as? String
            user.activation_code      = dict.value(forKey: "activation_code") as? String
            user.email_verified_at    = dict.value(forKey: "email_verified_at") as? String
            user.status               = dict.value(forKey: "status") as? String
            user.social_id            = dict.value(forKey: "social_id") as? String
            user.social_type          = dict.value(forKey: "social_type") as? String
            user.created_at           = dict.value(forKey: "created_at") as? String
            user.updated_at           = dict.value(forKey: "updated_at") as? String
            
            user.first_name           = dict.value(forKey: "first_name") as? String
            user.last_name            = dict.value(forKey: "last_name") as? String
            user.cin_number           = dict.value(forKey: "cin_number") as? String
            user.image                = dict.value(forKey: "image") as? String
            user.date_of_birth        = dict.value(forKey: "date_of_birth") as? String
            user.gender               = dict.value(forKey: "gender") as? String
            user.phone_no             = dict.value(forKey: "phone_no") as? String
            user.postal_code          = dict.value(forKey: "postal_code") as? String
            user.address              = dict.value(forKey: "address") as? String
            user.city_id              = dict.value(forKey: "city_id") as? String
            user.city_name            = dict.value(forKey: "city_name") as? String
            user.country_id           = dict.value(forKey: "country_id") as? String
            user.country_name         = dict.value(forKey: "country_name") as? String
            
//            let realm = DataModel.realm
//            try realm.write {
//                realm.add(user, update: .modified)
//            }
            return user
        }catch {
            
        }
    }
}

//extension User {
//    static func removeAll() {
//        let realm = DataModel.realm
//        try! realm.write {
//            realm.delete(realm.objects(User.self))
//        }
//    }
//}
