//
//  TrackBusViewController.swift
//  OasisBooking
//
//  Created by Neeraj Mishra on 06/02/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class TrackBusViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var viewMap: GMSMapView!
    var tappedMarker = GMSMarker()
    var locationManager:CLLocationManager!
    var latVal = Double()
    var lngVal = Double()
    var source = String()
    var destination = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.determineMyCurrentLocation()
        // Add google map
        self.viewMap.delegate = self
         source = "\(30.3165),\(78.0322)"
         destination = "\(28.643091),\(77.218280)"
        
        let camera = GMSCameraPosition.camera(withLatitude: 28.524555,
                                              longitude: 77.275111,
                                              zoom: 0.0,
                                              bearing: 30,
                                              viewingAngle: 10)
        //Setting the googleView
        self.viewMap.camera = camera
        self.viewMap.delegate = self
        self.viewMap.mapType = .satellite
        self.viewMap?.isMyLocationEnabled = true
        self.viewMap.settings.myLocationButton = true
        self.viewMap.settings.compassButton = true
        self.viewMap.settings.zoomGestures = true
        self.viewMap.animate(to: camera)
        createMarker()
        self.viewMap.layoutIfNeeded()

        createRoute { (success) in
            
        }
    }
    @IBAction func backBtnClick(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
        
    func createMarker(){
         // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 30.3165, longitude: 78.0322)
        marker.title = "Dehradun"
        marker.snippet = "India"
        marker.map = viewMap

        //28.643091, 77.218280
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: 28.643091, longitude: 77.218280)
        marker1.title = "New Delhi"
        marker1.snippet = "India"
        marker1.map = viewMap
    }
    
    //For displaying current location on map - Location methods
      func determineMyCurrentLocation() {
          locationManager = CLLocationManager()
          locationManager.delegate = self
          locationManager.desiredAccuracy = kCLLocationAccuracyBest
          locationManager.requestAlwaysAuthorization()
          locationManager.startUpdatingLocation()
      }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         let myLocation:CLLocation = locations[0] as CLLocation
         self.latVal = myLocation.coordinate.latitude
         self.lngVal = myLocation.coordinate.longitude
         print("user latitude = \(myLocation.coordinate.latitude)")
         print("user longitude = \(myLocation.coordinate.longitude)")
         
         //moving map to location
         let coordinate = CLLocationCoordinate2D(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)as CLLocationCoordinate2D
         let cameraUpdate = GMSCameraUpdate.setTarget(coordinate)as GMSCameraUpdate
         let marker = GMSMarker(position: myLocation.coordinate)
          // marker.title = "Hello World"
           marker.map = viewMap
          viewMap.camera = GMSCameraPosition(target: myLocation.coordinate, zoom: 0, bearing: 0, viewingAngle: 0)
          viewMap.animate(with: cameraUpdate)
         
         // Stop Location Manager
         locationManager.stopUpdatingLocation()
     }

}


