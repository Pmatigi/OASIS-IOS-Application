//
//  BusDetailViewController.swift
//  OasisBooking
//
//  Created by Anuj Garg on 06/02/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit
import Presentr
import MBProgressHUD

public struct BusInfo {
    public var bus_id : String?
    public var source_id : String?
    public var destination_id : String?
    public var date_of_journey : String?
    public var time_of_journey : String?
    
    public init(bus_id: String, source_id: String?, destination_id: String, date_of_journey: String, time_of_journey: String?) {
        self.bus_id = bus_id
        self.source_id = source_id
        self.destination_id = destination_id
        self.date_of_journey = date_of_journey
        self.time_of_journey = time_of_journey
    }
}

enum busType: String {
    case lower
    case hybrid
    case sleeper
    
    var type: String {
        switch  self {
        case .lower:
            return SeatingMap().ordinary
        case .hybrid:
            return SeatingMap().hybrid
        case .sleeper:
            return SeatingMap().sleeper
        }
    }
}


class BusDetailViewController: UIViewController,ZSeatSelectorDelegate {
    
    @IBOutlet weak var seatsBgView: UIView!
    @IBOutlet weak var upperBgView: UIView!
    @IBOutlet weak var seatSegmntControl: UISegmentedControl!
    @IBOutlet weak var seatSleeperSegmntControl: UISegmentedControl!
    @IBOutlet weak var selectedSeatsLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var seatViewWidthCOnstraint: NSLayoutConstraint!
    @IBOutlet weak var upperViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentSleeperHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var buttonPhoto: UIButton!
    @IBOutlet weak var labelBusName: UILabel!
    @IBOutlet weak var labelJourneyToFrom: UILabel!
    @IBOutlet weak var labelDateOfJourney: UILabel!
    
    var strOperatorName: String?
    var strSourcestation: String?
    var strDestinationStation: String?
    var strFare: String?
    
    var isUpper = Bool()
    var isSleeper = Bool()
    
    var totalSleeperSelectedSeats = Array<String>()
    var totalUpperSelectedSeats = Array<String>()
    var totalLowerSelectedSeats = Array<String>()
    var totalSelectedSeats = Array<String>()

    
    
    var totalFareSleeperSeat = Float()
    var totalFareUpperSeat   = Float()
    var totalFareLowerSeat   = Float()
    static var totalFinalFare  = Float()



    //Presentr decleration
    let presenter: Presentr = {
        let width = ModalSize.full
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: (UIScreen.main.bounds.size.height-380.0)))
        var height = ModalSize.custom(size: 380)
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
    
    static var newInstance: BusDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "BusDetailViewController") as! BusDetailViewController
        return vc
    }
    
    var busInfo: BusInfo?
    var bus: Bus?
    let seats = ZSeatSelector()
    let lowerSleeper = ZSeatSelector()
    let upperSleeper = ZSeatSelector()
    var lastContentOffset: CGFloat = 0
    
    let lower : String = SeatingMap().ordinary
    let hybrid : String = SeatingMap().hybrid
    let sleeper : String = SeatingMap().sleeper
    var allSeatNumbers : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.observeLoginNotifications()
        print(bus)
        if self.bus != nil{
          self.setUpBus()
        }
    }
    
   func seatSelected(_ seat: ZSeat) {
//        print("Seat at row: \(seat.row) and column: \(seat.column)\n")
//        var seatNumber = ""
//        var busId = ""
//        var seatId = ""
//        var column = 0
//        var busSeats = [Seat]()
//        if isUpper {
//            guard let seatsUpper = self.bus?.upper_seats else{return}
//            busSeats = seatsUpper
//            print("upper seats",seats)
//        }
//        else{
//            guard let seatsLower = self.bus?.lower_seats else{return}
//            busSeats = seatsLower
//            print("lower seats",seats)
//        }
//
//        column = (seat.column > 1) ? (seat.column-1) : seat.column
//
//        if seat.row > 0  && column == 0 {
//            column = seat.row*4
//            seatNumber = (busSeats[column].seat_no!)
//            seatId = (busSeats[column].id)!
//            //busId = (self.bus?.bus_seats![column].bus_id)!
//        }
//        else{
//            column = (seat.row*4)+column
//            seatNumber = (busSeats[column].seat_no!)
//            seatId = (busSeats[column].id)!
//            //busId = (self.bus?.bus_seats![column].bus_id)!
//        }
//        //  print("Bus Id",busId)
//        print("Seat Id",seatId)
//        print("Seat No",seatNumber)
//
//      //  self.selectedSeatsLabel.text = seatNumber
   }
    
    @IBAction func backBtnClick(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getSelectedSeats(_ seats: NSMutableArray) {
        var total:Float = 0.0;
        var seatNumber : String = ""
        var busId = ""
        var seatId = ""
        var column = 0
        var busSeats = [Seat]()
        if isUpper {
            guard let seatsUpper = self.bus?.upper_seats else{return}
            busSeats = seatsUpper
            print("upper seats",seats)
        }
        else{
            guard let seatsLower = self.bus?.lower_seats else{return}
            let seatsLowerArray: Array<Seat> = seatsLower
            let sealtsSleeper = seatsLowerArray.filter{ ($0.seat_type?.lowercased().contains("sleeper"))!}
            let sealtsSeater = seatsLowerArray.filter{ ($0.seat_type?.lowercased().contains("seater"))!}
            
            if isSleeper{
               busSeats = sealtsSleeper
            }
            else {
               busSeats = sealtsSeater
            }
            print("lower seats",seats)
        }
        
        var selectedSeats = [String]()

        for i in 0..<seats.count {
            let seat:ZSeat  = seats.object(at: i) as! ZSeat
            column = (seat.column > 1) ? (seat.column-1) : seat.column
            
            if seat.row > 0  && column == 0 {
                column = seat.row*4
                seatNumber = (busSeats[column].seat_no!)
                seatId = (busSeats[column].id)!
            }
            else{
                column = (seat.row*4)+column
                seatNumber = (busSeats[column].seat_no!)
                seatId = (busSeats[column].id)!
            }
            
            selectedSeats.append(seatNumber)
            let seatString  = allSeatNumbers.isEmpty ? seatNumber : (allSeatNumbers + "," + seatNumber)
            allSeatNumbers =  seatString
            total += seat.price
        }
        
        self.selectedSeatsLabel.isHidden = false//(self.totalSelectedSeats.count == 0) ? true : false
        print(total)
        if isUpper{
            self.totalUpperSelectedSeats = selectedSeats
            self.totalFareUpperSeat = total
        }
        else if isSleeper{
            self.totalSleeperSelectedSeats = selectedSeats
            self.totalFareSleeperSeat = total
        }
        else{
             self.totalLowerSelectedSeats = selectedSeats
            self.totalFareLowerSeat = total
        }
        
        self.totalSelectedSeats = totalLowerSelectedSeats + totalUpperSelectedSeats + totalSleeperSelectedSeats
        self.selectedSeatsLabel.text = String(self.totalSelectedSeats.joined(separator: ","))
        BusDetailViewController.totalFinalFare = (totalFareUpperSeat + totalFareSleeperSeat + totalFareLowerSeat)
        self.totalCostLabel.text = "fcfa:\(BusDetailViewController.totalFinalFare)"
    }
    
    func scrollUp(constant: Float) {
       
    }
    
    func scrollDown(constant: Float) {
       
    }
    
    @IBAction func segmentButtonClick(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            //seat type is lower
            self.seatSleeperSegmntControl.isHidden = false
            self.segmentSleeperHeightConstraint.constant = 31
            isUpper = false
            isSleeper = false
            upperSleeper.removeFromSuperview()
            lowerSleeper.removeFromSuperview()
            self.seatSleeperSegmntControl.selectedSegmentIndex = 0
            if seats.isInitialised {
                self.seatsBgView.addSubview(seats)
            }
            else{
                var type = String()
                let seatTypeId = self.bus?.bus_seat_type
                
                if seatTypeId == 1 {
                    type = busType.lower.type
                }
                else if seatTypeId == 2 {
                    type = busType.sleeper.type
                }
                else if seatTypeId == 3 {
                    type = busType.lower.type
                }
                generateSeats(seat : type, view: self.seatsBgView, seatView: seats)
            }
        }
        else {
            isUpper = true
            seats.removeFromSuperview()
            lowerSleeper.removeFromSuperview()
            self.seatSleeperSegmntControl.isHidden = true
            self.segmentSleeperHeightConstraint.constant = 0
            
            if upperSleeper.isInitialised {
                self.seatsBgView.addSubview(upperSleeper)
            }
            else{
                generateSeats(seat : sleeper, view: seatsBgView,seatView: upperSleeper )
            }
            // seat type is upper
        }
    }
    
    
    @IBAction func sgmntSeaterSleeperClick(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            //seat type is seater
            isSleeper = false
            isUpper = false
            lowerSleeper.removeFromSuperview()
            upperSleeper.removeFromSuperview()
            if seats.isInitialised {
                self.seatsBgView.addSubview(seats)
            }
            else{
                let type = busType.lower.type
                generateSeats(seat : type, view: self.seatsBgView, seatView: seats)
            }
        }
        else {
            isSleeper = true
            isUpper = false
            seats.removeFromSuperview()
            upperSleeper.removeFromSuperview()

            if lowerSleeper.isInitialised {
                self.seatsBgView.addSubview(lowerSleeper)
            }
            else{
                generateSeats(seat : sleeper, view: seatsBgView,seatView: lowerSleeper)
            }
            // seat type is upper
        }
    }
    
    
    
    @IBAction func proceedButtonClick(_ sender: Any) {
        let vc = BoardingPointViewController.newInstance
        var seats = [String]()
        if let selectedSeats = self.selectedSeatsLabel.text?.split(separator: ",") {
            
            for seat in selectedSeats{
                seats.append(String(seat))
            }
        }
        if !seats.isEmpty {
            vc.boardingPoint = self.bus?.boarding
            vc.droppingPoint = self.bus?.dropping
            vc.selectedSeats = seats
            vc.bus = self.bus
            customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
        }
        else{
            // show alert select atleast one seat first
            self.showAlertController(title: "Alert!", message: "In order to complete booking select atleast one seat")
        }
    }
    
    @IBAction func photosButtonClick(_ sender: Any) {
        let vc = BusImagesCollectionViewController.newInstance
        vc.type = popUpType.bus.rawValue
        vc.imagesBus = bus!.bus_images!
        if bus?.bus_images?.count == 0{return}
        customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
    }
    
    
    public func setUpBus(){
        //gesture recognisers
        seatsBgView.layer.cornerRadius = 2
        seatsBgView.layer.borderWidth = 0.5
        seatsBgView.layer.borderColor = UIColor.gray.cgColor
        seatsBgView.clipsToBounds = true
        
        self.labelBusName.text =  "\( strOperatorName ?? "") " + "(\( bus?.bus_number ?? ""))"
        self.labelJourneyToFrom.text = (strSourcestation ?? "") + " to \(strDestinationStation ?? "")"
        self.lblPrice.text =  "Fcfa: " + "\( strFare ?? "") "
        self.selectedSeatsLabel.isHidden = true
        labelDateOfJourney.text = "Booking Date :\(BusBookingViewController.selectedDateForBooking)"
        seats.isScrollEnabled = true
        seats.bounces = true
        upperSleeper.bounces = true
        upperSleeper.isScrollEnabled = true
        
        
       // let sleeperSeats = Int(self.bus!.total_sleeper ?? 0)
        let seatTypeId = self.bus?.bus_seat_type
        let busTypeId = self.bus?.bus_type_id
        
        if busTypeId == 2{
            self.segmentHeightConstraint.constant =  31
            self.seatSegmntControl.isHidden = false
        }
        else {
            self.segmentHeightConstraint.constant =  0
            self.seatSegmntControl.isHidden = true
        }
        
        var type = String()
        
        if seatTypeId == 1{
            type = busType.lower.type
        }
        else if seatTypeId == 2{
            type = busType.sleeper.type
        }
        else if seatTypeId == 3{
            type = busType.lower.type//busType.hybrid.type
            self.segmentSleeperHeightConstraint.constant =  31
            self.seatSleeperSegmntControl.isHidden = false
        }
        generateSeats(seat: type, view: seatsBgView, seatView: seats)
    }
}

extension BusDetailViewController {
    
    fileprivate func generateSeats(seat : String,view : UIView, seatView : ZSeatSelector) {
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let busDetail = self.bus else {return}
        
        seatView.frame = CGRect(x: 10, y: 30, width:self.seatsBgView.frame.size.width, height: self.seatsBgView.frame.size.height)
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                seatView.setSeatSize(CGSize(width: 40, height: 45))
            case 1334:
                print("iPhone 6/6S/7/8")
                var height = (seatSegmntControl.selectedSegmentIndex == 0) ? self.seatsBgView.frame.size.height-170 : self.seatsBgView.frame.size.height
                if isSleeper{
                    height =  (seatSegmntControl.selectedSegmentIndex == 0) ? self.seatsBgView.frame.size.height : self.seatsBgView.frame.size.height
                }
                else{
                    height =  (seatSegmntControl.selectedSegmentIndex == 0) ? self.seatsBgView.frame.size.height-170 : self.seatsBgView.frame.size.height
                }
                seatView.frame = CGRect(x: 5, y: 30, width:self.seatsBgView.frame.size.width, height: height)
                seatView.setSeatSize(CGSize(width: 50, height: 55))
            case 1920, 2208, 1792, 2688:
                print("iPhone 6+/6S+/7+/8+")
                print("iPhone XR/ 11 ")
                print("iPhone XS Max/11 Pro Max")
                seatView.setSeatSize(CGSize(width: 55, height: 60))
            case 2436:
                print("iPhone X/XS/11 Pro")
                var height = (seatSegmntControl.selectedSegmentIndex == 0) ? self.seatsBgView.frame.size.height-100 : self.seatsBgView.frame.size.height
                if isSleeper{
                    height =  (seatSegmntControl.selectedSegmentIndex == 0) ? self.seatsBgView.frame.size.height : self.seatsBgView.frame.size.height
                }
                else{
                    height =  (seatSegmntControl.selectedSegmentIndex == 0) ? self.seatsBgView.frame.size.height-170 : self.seatsBgView.frame.size.height-100
                }
                seatView.frame = CGRect(x: 5, y: 30, width:self.seatsBgView.frame.size.width, height: height)
                seatView.setSeatSize(CGSize(width: 48, height: 50))
            default:
                print("Unknown")
            }
        }
        // seats.setSeatSize(CGSize(width: 55, height: 60))
        seatView.setAvailableImage(UIImage(named: "A")!,
                                   andUnavailableImage:UIImage(named: "S")!,
                                   andDisabledImage:   UIImage(named: "U")!,
                                   andSelectedImage:   UIImage(named: "S")!,
                                   andSleeperImage:    UIImage(named: "L")!,
                                   andSleeperSelectedImage: UIImage(named: "Z")!)
        seatView.layout_type = "Normal"
       // if let fare =  bus?.total_fare {
           seatView.sleeperSeatPrice = 493//NSString(string: fare).floatValue
           seatView.seat_price = 493//NSString(string: fare).floatValue
     //   }
        seatView.isInitialised = true
        //seatView.selected_seat_limit = 3
        seatView.setMap(seat, bus: self.bus!,isUpper: isUpper, isSleeper: self.isSleeper)
        seatView.seatSelectorDelegate = self
        view.addSubview(seatView)
        seatView.contentSize.height = seatView.contentSize.height+250
    }
}



