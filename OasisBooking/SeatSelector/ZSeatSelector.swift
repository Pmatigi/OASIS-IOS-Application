//
//  ZSeatSelector.swift
//  ZSeatSelector_Swift
//
//  Created by Ricardo Zertuche on 8/24/15.
//  Copyright © 2015 Ricardo Zertuche. All rights reserved.
//

import UIKit

protocol ZSeatSelectorDelegate {
    func seatSelected(_ seat: ZSeat)
    func getSelectedSeats(_ seats: NSMutableArray)
    func scrollUp(constant : Float)
    func scrollDown(constant : Float)
}

class ZSeatSelector: UIScrollView, UIScrollViewDelegate {
    
    var seatSelectorDelegate: ZSeatSelectorDelegate?
    var seat_width:     CGFloat = 20.0
    var seat_height:    CGFloat = 20.0
    var selected_seats          = NSMutableArray()
    var seat_price:      Float   = 0.0
    var sleeperSeatPrice:Float  = 0.0
    var available_image     = UIImage()
    var unavailable_image   = UIImage()
    var disabled_image      = UIImage()
    var selected_image      = UIImage()
    var selected_Sleeper_image      = UIImage()
    var sleeper_image       = UIImage()
    let zoomable_view       = UIView()
    var selected_seat_limit:Int = 0
    var layout_type          = ""
    var height:              CGFloat = 20.0
    var isInitialised       = Bool()
    
    
    var lastContentOffset: CGFloat = 0
    
    // MARK: - Init and Configuration
    
    func setSeatSize(_ size: CGSize){
        seat_width  = size.width
        seat_height = size.height
        height = seat_height
    }
    
    func setMap(_ map: String,bus : Bus,isUpper: Bool,isSleeper: Bool) {
        
        if (layout_type == "Normal"){
            var initial_seat_x: Int = 0
            var initial_seat_y: Int = 0
            var final_width: Int = 0
            var j = 0
            var seats : [Seat]
            if isUpper {
                guard let seatsUpper = bus.upper_seats else{return}
                seats = seatsUpper
                print("upper seats",seats)
            }
            else{
                guard let seatsLower = bus.lower_seats else{return}
                let seatsLowerArray: Array<Seat> = seatsLower
                let sealtsSleeper = seatsLowerArray.filter{ ($0.seat_type?.lowercased().contains("sleeper"))!}
                let sealtsSeater = seatsLowerArray.filter{ ($0.seat_type?.lowercased().contains("seater"))!}
                if isSleeper && !sealtsSleeper.isEmpty {
                     seats = sealtsSleeper
                }
                else{
                    seats = sealtsSeater
                }               
            }
            print("map count",map.count)
            let busSeatType = bus.bus_seat_type
            var count = (map.count > seats.count) ? seats.count : map.count

            var i = 0
            while i < count {
                if (j == seats.count){
                    break
                }
                print("I",i)
                print("count",count)
                print("J",j)

                var isSeatBooked = Bool()

                let seat_at_position = map[i]
                let seat = seats[j]
                
                guard let isBooked = seat.is_booked else{return}
                guard let isSleeper = seat.seat_type else{return}
                if isBooked == 0 {
                    isSeatBooked = false
                }
                else {
                    isSeatBooked = true
                }
                
                print("SEATno^^^^",seat.seat_no)
                print("SEAT$$$$$",seat.is_booked!)
                print("isBooked*******",seat.isSeatBooked)
                print("isSLEEPER*******",seat.seat_type)
                
                if seat_at_position == "S" {
                    createSeatButtonWithPosition(initial_seat_x, and: initial_seat_y, isAvailable: false, isDisabled: true, type: seat_at_position, isSleeper: false, unAvailable: false)
                    initial_seat_x += 1
                    j+=1
                } else if seat_at_position == "A" {
                    createSeatButtonWithPosition(initial_seat_x, and: initial_seat_y, isAvailable: !isSeatBooked, isDisabled: isSeatBooked,type: seat_at_position, isSleeper: false, unAvailable: isSeatBooked)
                    initial_seat_x += 1
                    j+=1
                } else if seat_at_position == "L" {
                    createSeatButtonWithPosition(initial_seat_x, and: initial_seat_y, isAvailable: !isSeatBooked, isDisabled: isSeatBooked,type: seat_at_position, isSleeper: true, unAvailable: isSeatBooked)
                    initial_seat_x += 1
                    j+=1
                }else if seat_at_position == "D" {
                    createSeatButtonWithPosition(initial_seat_x, and: initial_seat_y, isAvailable: false, isDisabled: false,type: seat_at_position, isSleeper: false, unAvailable: true)
                    initial_seat_x += 1
                    j+=1
                }
                else if seat_at_position == "U" {
                    createSeatButtonWithPosition(initial_seat_x, and: initial_seat_y, isAvailable: !isSeatBooked, isDisabled: isSeatBooked,type: seat_at_position, isSleeper: false, unAvailable: isSeatBooked)
                    initial_seat_x += 1
                    j+=1
                }
                else if seat_at_position == "Z" {
                    createSeatButtonWithPosition(initial_seat_x, and: initial_seat_y, isAvailable: !isSeatBooked, isDisabled: isSeatBooked, type: seat_at_position, isSleeper: true, unAvailable: !isSeatBooked)
                    initial_seat_x += 1
                    j+=1
                }
                else if seat_at_position == "_" {
                    initial_seat_x += 1
                    if busSeatType == 2{
                         count+=2
                    }
                    else{
                         count+=1
                    }
                  
                    print("count is :",count)
                } else {
                    if busSeatType == 2{
                         count+=2
                    }
                    else{
                         count+=1
                    }
                    if initial_seat_x > final_width {
                        final_width = initial_seat_x
                    }
                    initial_seat_x = 0
                    initial_seat_y += 1
                }
                i += 1
            }
            
            zoomable_view.frame = CGRect(x: 0, y: 0, width: CGFloat(final_width) * seat_width, height: CGFloat(initial_seat_y) * seat_height+30)
            self.contentSize = zoomable_view.frame.size
            selected_seats = NSMutableArray()
            
            self.delegate = self
            self.addSubview(zoomable_view)
        } else {
            
        }
    }
    
    func createSeatButtonWithPosition(_ initial_seat_x: Int, and initial_seat_y: Int, isAvailable available: Bool, isDisabled disabled: Bool, type: Character, isSleeper : Bool, unAvailable: Bool) {
        if isSleeper {
            seat_height = height*2
        }
        else{
            seat_height = height*1
        }
        let seatButton = ZSeat(frame: CGRect(
            x: CGFloat(initial_seat_x) * seat_width,
            y: CGFloat(initial_seat_y) * seat_height,
            width: CGFloat(seat_width),
            height: CGFloat(seat_height)))
        if available && disabled {
            self.setSeatAsDisabled(seatButton)
        }
        else {
            if available && !disabled {
                if isSleeper{
                    self.setSeatAsSleeper(seatButton)
                }
                else{
                    self.setSeatAsAvaiable(seatButton)
                }
            }
            else {
                if isSleeper{
                  self.setSeatAsSleeperUnavaiable(seatButton)

                }
                else{
                    self.setSeatAsUnavaiable(seatButton)
                }
            }
        }
        print("price",self.seat_price)
        seatButton.available = available
        seatButton.disabled = disabled
        seatButton.row = initial_seat_y
        seatButton.column = initial_seat_x
        seatButton.price =  isSleeper ? self.sleeperSeatPrice : seat_price
        seatButton.isSleeper = isSleeper
        seatButton.unavailable = unAvailable
        seatButton.addTarget(self, action: #selector(ZSeatSelector.seatSelected(_:)), for: .touchDown)
        zoomable_view.addSubview(seatButton)
    }
    
    // MARK: - Seat Selector Methods
    
    fileprivate func removeSeat(_ sender: ZSeat) {
        print("this is selected seat")
        selected_seats.remove(sender)
        if !sender.available && sender.disabled {
            self.setSeatAsDisabled(sender)
        }
        else {
            if  !sender.disabled {
                if sender.isSleeper {
                    self.setSeatAsSleeper(sender)
                }
                else{
                    self.setSeatAsAvaiable(sender)
                }
            }
        }
        seatSelectorDelegate?.seatSelected(sender)
        seatSelectorDelegate?.getSelectedSeats(selected_seats)
    }
    
    @objc func seatSelected(_ sender: ZSeat) {
        if sender.selected_seat && !sender.unavailable {
            removeSeat(sender)
            return
        }
        
        if !sender.selected_seat && sender.available {
            if selected_seat_limit != 0 {
                checkSeatLimitWithSeat(sender)
            }
            else {
                if sender.isSleeper {
                    self.setSeatAsSelectedSleeper(sender)
                }
                else{
                    self.setSeatAsSelected(sender)
                }
                selected_seats.add(sender)
            }
        }
        else {
            selected_seats.remove(sender)
            if sender.available && sender.disabled {
                self.setSeatAsDisabled(sender)
            }
            else {
                if sender.available && !sender.disabled {
                    if sender.isSleeper {
                        self.setSeatAsSelectedSleeper(sender)
                    }
                    else{
                        self.setSeatAsSelected(sender)
                    }
                }
            }
        }
        
        seatSelectorDelegate?.seatSelected(sender)
        seatSelectorDelegate?.getSelectedSeats(selected_seats)
    }
    
    func checkSeatLimitWithSeat(_ sender: ZSeat) {
        if selected_seats.count < selected_seat_limit {
            if sender.isSleeper{
                setSeatAsSelectedSleeper(sender)
            }
            else{
                setSeatAsSelected(sender)
            }
            selected_seats.add(sender)
        }
        else {
            let seat_to_make_avaiable: ZSeat = selected_seats[0] as! ZSeat
            if seat_to_make_avaiable.disabled {
                self.setSeatAsDisabled(seat_to_make_avaiable)
            }
            else {
                if seat_to_make_avaiable.isSleeper {
                    self.setSeatAsSleeper(seat_to_make_avaiable)
                }
                else {
                    self.setSeatAsAvaiable(seat_to_make_avaiable)
                }
            }
            selected_seats.remove(seat_to_make_avaiable)
            if sender.isSleeper {
                self.setSeatAsSelectedSleeper(sender)
            }
            else{
                self.setSeatAsSelected(sender)
            }
            selected_seats.add(sender)
        }
    }
    
    // MARK: - Seat Images & Availability
    
    func setAvailableImage(_ available_image: UIImage, andUnavailableImage unavailable_image: UIImage, andDisabledImage disabled_image: UIImage, andSelectedImage selected_image: UIImage,andSleeperImage sleeperImage: UIImage,andSleeperSelectedImage sleeperSelectedImage: UIImage) {
        self.available_image = available_image
        self.unavailable_image = unavailable_image
        self.disabled_image = disabled_image
        self.selected_image = selected_image
        self.sleeper_image = sleeperImage
        self.selected_Sleeper_image = sleeperSelectedImage
    }
    
    func setSeatAsUnavaiable(_ sender: ZSeat) {
        sender.setImage(unavailable_image, for: UIControl.State())
        sender.selected_seat = true
    }
    func setSeatAsSleeperUnavaiable(_ sender: ZSeat) {
        sender.setImage(selected_Sleeper_image, for: UIControl.State())
        sender.selected_seat = true
    }
    func setSeatAsAvaiable(_ sender: ZSeat) {
        sender.setImage(available_image, for: UIControl.State())
        sender.selected_seat = false
    }
    func setSeatAsDisabled(_ sender: ZSeat) {
        sender.setImage(disabled_image, for: UIControl.State())
        sender.selected_seat = false
    }
    public func setSeatAsSelected(_ sender: ZSeat) {
        sender.setImage(selected_image, for: UIControl.State())
        sender.selected_seat = true
    }
    
    func setSeatAsSelectedSleeper(_ sender: ZSeat) {
        sender.setImage(selected_Sleeper_image, for: UIControl.State())
        sender.selected_seat = true
    }
    
    func setSeatAsSleeper(_ sender: ZSeat) {
        sender.setImage(sleeper_image, for: UIControl.State())
        sender.contentMode = .scaleAspectFit
        sender.selected_seat = false
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("zoom")
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.subviews[0]
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print(scale)
    }
    
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let constant  = (self.lastContentOffset < scrollView.contentOffset.y) ? 100.0 : 189.0
        seatSelectorDelegate?.scrollDown(constant:Float(constant))
        
        if self.lastContentOffset == scrollView.contentOffset.y {
            seatSelectorDelegate?.scrollDown(constant: 189.0)
        }
    }
}


class ZSeat: UIButton {
    var row:            Int     = 0
    var column:         Int     = 0
    var available:      Bool    = true;
    var disabled:       Bool    = true;
    var selected_seat:  Bool    = false;
    var sleeper_seat:   Bool    = true;
    var price:          Float   = 0.0
    var isSleeper:      Bool    = false;
    var unavailable:    Bool    = false;
    var seatNumber :    String  = "";
}

extension String {
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
}

