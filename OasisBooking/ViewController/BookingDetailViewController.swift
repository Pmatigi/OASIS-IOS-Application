//
//  BookingDetailViewController.swift
//  OasisBooking
//
//  Created by Neeraj Mishra on 25/01/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit

class BookingDetailViewController: UIViewController {
    
    
    @IBOutlet weak var tblBookingStatus: UITableView!
    private let refreshControl = UIRefreshControl()
    
    
    var currentBooking : Array<Booking> = []
    var cancelledBooking : Array<Booking> = []
    var pastBooking : Array<Booking> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tblBookingStatus.contentInset = UIEdgeInsets(top: -33, left: 0, bottom: 0, right: 0)
        
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tblBookingStatus.refreshControl = refreshControl
        } else {
            tblBookingStatus.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
        self.fetchData()
        // self.tblBookingHistory.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        fetchData()
    }
    
    func fetchData(){
        self.getBusBookingDetailApi { (success) in
            if success {
                self.tblBookingStatus.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @IBAction func getDirectionsClicked(_ sender: Any) {
        //UIApplication.shared.openURL(URL(string:"https://www.google.com/maps/@42.585444,13.007813,6z")!)
       // if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps://?saddr=&daddr=\(28.643091),\(77.218280)&directionsmode=driving")!)
            
//        } else {
//            self.showAlertController(message: "please install google maps")
//        }
    }
}

// Extension UItableview datasource and delegates

extension BookingDetailViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currentBooking.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        /*  let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as! TicketCell
         cell.viewTop.layer.cornerRadius = 12.0
         cell.viewTop.clipsToBounds = true
         cell.viewMiddle.layer.cornerRadius = 15.0
         cell.viewMiddle.clipsToBounds = true
         return cell*/
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingHistoryCell", for: indexPath) as! BookingHistoryCell
        cell.configure(booking: self.currentBooking[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TicketDetailViewController.newInstance
        vc.booking = self.currentBooking[indexPath.row]
        self.modalPresentationStyle = .fullScreen;
        vc.isCurrentBooking = true
        self.present(vc, animated: true, completion: nil)
    }}
