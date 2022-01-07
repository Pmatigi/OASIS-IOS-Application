//
//  AvailableBusViewController.swift
//  OasisBooking
//
//  Created by Neeraj Mishra on 04/02/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit
import Presentr

public enum popUpType : String{
    case bus
    case rating
    case amenities
}

class AvailableBusViewController: UIViewController {
    @IBOutlet weak var tblAvailableBus: UITableView!
    @IBOutlet weak var lblRouts: UILabel!
    
    
    //Presentr decleration
    let presenter: Presentr = {
        let width = ModalSize.full
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: (UIScreen.main.bounds.size.height-150.0)))
        var height = ModalSize.custom(size: 150.0)
        let customType = PresentationType.custom(width: width, height: height, center: center)
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVertical
        customPresenter.dismissTransitionType = .coverVertical
        customPresenter.roundCorners = true
        customPresenter.backgroundColor = .clear
        customPresenter.backgroundOpacity = 0.5
        customPresenter.dismissOnSwipe = true
        customPresenter.dismissOnSwipeDirection = .bottom
        return customPresenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tblAvailableBus.contentInset = UIEdgeInsets(top: -33, left: 0, bottom: 0, right: 0)
    }
    
    var availableBuses : Array<Bus> = []
    var journeyDate :String?
    
    
    @IBAction func backBtnClick(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AvailableBusViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return availableBuses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusWithTravelAgencyCell", for: indexPath) as! BusWithTravelAgencyCell
        cell.imgBusImage.layer.cornerRadius = 32.5
        cell.imgBusImage.layer.borderColor = UIColor.darkGray.cgColor
        cell.imgBusImage.layer.borderWidth = 0.3
        
        self.lblRouts.text = (availableBuses[0].destination_name ?? "") + " To " + (availableBuses[0].source_name ?? "")
        cell.lblBusName.text = availableBuses[indexPath.row].bus_name
        cell.lbltotalSheets.text = "| Available seats: " + "\(availableBuses[indexPath.row].total_seats ?? 0)"
        cell.buttonRating.tag = indexPath.row
        if let rating = availableBuses[indexPath.row].bus_average_ratings {
            if rating != nil
            {
                cell.lblRating.text = String(rating)
            }else
            {
                cell.lblRating.text = "0.0"
            }
        }
        else{
            cell.lblRating.text = "0.0"
        }
        if availableBuses[indexPath.row].bus_images!.count > 0 {
            if let path = availableBuses[indexPath.row].bus_images![0].path as? String{
                if let imageUrl = URL(string: path) {
                    cell.imgBusImage.sd_setImage(with:imageUrl, completed: nil)
                }
            }
        }
        var seatTypeId = self.availableBuses[indexPath.row].bus_seat_type
           var type = String()
        
           if seatTypeId == 1{
               type = "Seater"
           }
           else if seatTypeId == 2{
               type = "Sleeper"
           }
           else if seatTypeId == 3{
               type = "Seater/Sleeper"
           }
        let ac = availableBuses[indexPath.row].is_ac == 1 ? "AC" : "Non AC"
        
        cell.lblBusType.text = ac + " " + type

        
        // cell.lblRating.text = availableBuses[indexPath.row].bus_average_ratings
        // cell.buttonRating.setTitle(availableBuses[indexPath.row].bus_average_ratings, for: .normal)
        cell.buttonRating.addTarget(self, action: #selector(showRating(_:)), for: .touchUpInside)
        cell.buttonAmenities.tag = indexPath.row
        cell.lblBustimings.text = availableBuses[indexPath.row].start_time! + " - " + availableBuses[indexPath.row].reached_time!
        cell.lblBusRate.text = "Fcfa :\(availableBuses[indexPath.row].total_fare ?? "")"
        cell.buttonAmenities.addTarget(self, action: #selector(showBusAmenities(_:)), for: .touchUpInside)
        // cell.buttonAmenities.addTarget(self, action: #selector(showBusAmenities(bus:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let busDetail = availableBuses[indexPath.row]
        let busInfo = BusInfo(bus_id: busDetail.id!, source_id: busDetail.source_id, destination_id: busDetail.destination_id!, date_of_journey: journeyDate!, time_of_journey: "10.30")
        self.getBusDetailApi(busInfoDict: busInfo) { (success,bus) in
            if success {
                DispatchQueue.main.async {
                    let vc = BusDetailViewController.newInstance
                    vc.bus = bus
                    vc.strOperatorName = busDetail.operator_name
                    vc.strSourcestation = busDetail.source_name
                    vc.strDestinationStation = busDetail.destination_name
                    vc.strFare = busDetail.total_fare
                    
                    if (bus?.lower_seats!.isEmpty)!{
                        self.showAlertController(message: "No Seats available at this time")
                    }
                    self.modalPresentationStyle = .fullScreen;
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
}

extension AvailableBusViewController {
    
    @IBAction func showBusAmenities(_ sender: UIButton) {
        let bus = availableBuses[sender.tag]
        let vc = BusImagesCollectionViewController.newInstance
        vc.type = popUpType.amenities.rawValue
        if bus.amenities?.count != 0 {
            vc.imageAmenities = bus.amenities!
            self.customPresentViewController(self.presenter, viewController: vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func showRating(_ sender: UIButton) {
        let vc = BusImagesCollectionViewController.newInstance
        let bus = availableBuses[sender.tag]
        vc.type = popUpType.rating.rawValue
        if bus.ratings?.count != 0 {
            vc.arrRating = bus.ratings!
            self.customPresentViewController(self.presenter, viewController: vc, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination, sender) {
        case ("BusDetailSegueId"?, let vc as BusDetailViewController, let sender as Bus):
            vc.bus = sender
        default: break
        }
        super.prepare(for: segue, sender: sender)
    }
}
