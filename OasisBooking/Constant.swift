//
//  Constant.swift
//  LightFoot
//
//  Created by Neeraj Mishra on 09/01/20.
//  Copyright © 2020 LightFoot. All rights reserved.
//


import Foundation
import UIKit

public struct Constants {
    public static let GMSServicesProvideAPIKey     = "AIzaSyA3wqXT9S0V61_WcoJeDcWaExodKCi87qU"
    public static let GMSPlacesClientProvideAPIKey = "AIzaSyA3wqXT9S0V61_WcoJeDcWaExodKCi87qU"
    
    public static let STRIPE_Key = "pk_test_VyYdLu2prBQgNfgnkdqU9Ulu000kOechup"
    public static let STRIPE_SECRET = "sk_test_8Oopy5pNufJyn2qhMKsKEdPT00Qq8TX34n"
}

public struct Images {
    public static let placeholderImage = UIImage(named: "Node-Placeholder")!
    public static let notificationPlaceholderImage = UIImage(named: "icon-n")!
    public static let nodeFavPlaceholderImage = UIImage(named: "-Placeholder")!
}

public struct APIConfig {
    static var baseUrl = "https://oasisbookings.com/api/"
}

public struct URLs {
    public static let loginUrl                  = APIConfig.baseUrl + "login"
    public static let registrationUrl           = APIConfig.baseUrl + "register"
    public static let getCityUrl                = APIConfig.baseUrl + "get-city"
    public static let searchBusUrl              = APIConfig.baseUrl + "search-bus"
    public static let busDetailsUrl             = APIConfig.baseUrl + "bus-details"
    public static let myBookingsUrl             = APIConfig.baseUrl + "my-bookings"
    public static let changePasswordsUrl        = APIConfig.baseUrl + "change_password"
    public static let UploadProfileImageUrl     = APIConfig.baseUrl + "profile_image"
    public static let getUserProfileUrl         = APIConfig.baseUrl + "get_profile"
    public static let bookingUrl                = APIConfig.baseUrl + "booking"
    public static let PaymentUrl                = APIConfig.baseUrl + "make-payment"
    public static let cancelTicketUrl           = APIConfig.baseUrl + "cancel-booking"
    public static let braintree_PaymentUrl      = APIConfig.baseUrl + "make-braintree-payment"
    public static let get_pagesUrl              = APIConfig.baseUrl + "get-page"
    public static let OrangeMoneyPaymentUrl     = APIConfig.baseUrl + "iwomi-payment-request"
    public static let OrangeMoneyPaymenStatustUrl     = APIConfig.baseUrl + "iwomi-payment-status"
    public static let sendOTP                   = APIConfig.baseUrl + "send-otp"
    public static let changePassword            = APIConfig.baseUrl + "change-password"

   // https://oasisbookings.com/api/get_pages.txt
}

public struct Storyboard {
     static let Main = "Main"
}

public struct colors {
    static let orange = "F09A38"
    static let green = "76D672"
    static let blue = "3273ED"    
}


