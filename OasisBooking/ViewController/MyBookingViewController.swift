//
//  MyBookingViewController.swift
//  OasisBooking
//
//  Created by Neeraj Mishra on 07/02/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit

class MyBookingViewController: UIViewController {
    @IBOutlet weak var tblBookingHistory: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var arrSection = ["Current Booking","Cancel Booking","Past Booking"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        segmentControl.addTarget(self, action: #selector(MyBookingViewController.indexChanged(_:)), for: .valueChanged)
        
        // self.tblBookingHistory.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.getBusBookingDetailApi { (success) in
            if success {
                self.tblBookingHistory.reloadData()
            }
        }
    }
    var currentBooking : Array<Booking> = []
    var cancelledBooking : Array<Booking> = []
    var pastBooking : Array<Booking> = []
    
    @IBAction func backBtnClick(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func indexChanged(_ sender: UISegmentedControl) {
//        if segmentControl.selectedSegmentIndex == 0 {
//            tblBookingHistory.reloadData()
//        } else if segmentControl.selectedSegmentIndex == 1 {
//            tblBookingHistory.reloadData()
//        } else if segmentControl.selectedSegmentIndex == 2 {
//            tblBookingHistory.reloadData()
//        }
        tblBookingHistory.reloadData()

    }
}

// Extension UItableview datasource and delegates

extension MyBookingViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if segmentControl.selectedSegmentIndex == 0 {
            return currentBooking.count
        }else if segmentControl.selectedSegmentIndex == 1{
            return pastBooking.count
        }
        else{
            return cancelledBooking.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingHistoryCell", for: indexPath) as! BookingHistoryCell
        let booking: Booking?
        if segmentControl.selectedSegmentIndex == 0 {
            booking = currentBooking[indexPath.row]
        }else if segmentControl.selectedSegmentIndex == 1{
            booking = pastBooking[indexPath.row]
        }
        else{
            booking = cancelledBooking[indexPath.row]
        }
        cell.configure(booking: booking!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TicketDetailViewController.newInstance
        
        self.modalPresentationStyle = .fullScreen;
        if segmentControl.selectedSegmentIndex == 0 {
            vc.booking = self.currentBooking[indexPath.row]
            vc.isCurrentBooking = true
        }else if segmentControl.selectedSegmentIndex == 1{
            vc.booking = self.pastBooking[indexPath.row]
        }
        else{
            vc.booking = self.cancelledBooking[indexPath.row]
        }
        self.present(vc, animated: true, completion: nil)
    }
}
