//
//  BoardingPointViewController.swift
//  OasisBooking
//
//  Created by Anuj Garg on 07/03/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit

class BoardingPointViewController: UIViewController {
    
    @IBOutlet weak var tblBoardingPointBus: UITableView!
    @IBOutlet weak var btnBoarding: UIButton!
    @IBOutlet weak var btnDropping: UIButton!
    @IBOutlet weak var imgBoarding: UIImageView!
    @IBOutlet weak var imgDropping: UIImageView!
    
    var isDroppoingSelected: Bool = false{
        didSet{
            self.tblBoardingPointBus.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tblBoardingPointBus.contentInset = UIEdgeInsets(top: -33, left: 0, bottom: 0, right: 0)
    }
    
    static var newInstance: BoardingPointViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "BoardingPointViewController") as! BoardingPointViewController
        return vc
    }
    
    var boardingPoint :[String]?
    var droppingPoint :[String]?
    var selectedSeats :[String]?
    var bus: Bus?
    
    var selectedBoardingPoint = String()
    var selectedDropingPoint = String()
    
    
    @IBAction func backBtnClick(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBoarding(sender: UIButton!) {
        
        UIView.animate(withDuration: 1.0) {
            self.btnBoarding.setTitleColor(UIColor.white, for: UIControl.State.normal)
            self.btnBoarding.layer.backgroundColor = UIColor.clear.cgColor
            self.btnBoarding.layer.backgroundColor =  UIColor(hex: "6A86FC").cgColor
            self.imgBoarding.backgroundColor = UIColor.white
            self.btnDropping.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
            self.btnDropping.backgroundColor = UIColor.white
        }
        self.isDroppoingSelected = false
        if let cell = tblBoardingPointBus.cellForRow(at: IndexPath(row: 0, section: 0)){
            tblBoardingPointBus.scrollRectToVisible(cell.frame, animated: false)
        }
    }
    
    @IBAction func btnDroppingq(sender: UIButton!) {
        self.btnDropping.layer.backgroundColor = UIColor.clear.cgColor
        UIView.animate(withDuration: 1.0) {
            self.btnDropping.layer.backgroundColor =  UIColor(hex: "6A86FC").cgColor
            self.btnBoarding.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
            self.imgBoarding.backgroundColor = UIColor.gray
            self.btnBoarding.backgroundColor = UIColor.white
            self.btnDropping.setTitleColor(UIColor.white, for: UIControl.State.normal)
        }
        isDroppoingSelected = true
        if let cell = tblBoardingPointBus.cellForRow(at: IndexPath(row: 2, section: 1)){
            tblBoardingPointBus.scrollRectToVisible(cell.frame, animated: false)
        }
    }
        
    @IBAction func proceedButtonClick(_ sender: Any) {
        let vc = PassengerViewController.newInstance
        vc.arrSheetCount = self.selectedSeats
        vc.bus = self.bus
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension BoardingPointViewController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isDroppoingSelected {
            let count = (section == 0) ? 0 : self.droppingPoint!.count + 1
            return count
        }
        else{
            let count = (section == 0) ? self.boardingPoint!.count + 1 : 0
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! BusWithTravelAgencyCell
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BoardingCell", for: indexPath) as! BoardingPointTableViewCell
            let text = isDroppoingSelected ? (self.droppingPoint![indexPath.row-1]) : (self.boardingPoint![indexPath.row-1])
            if isDroppoingSelected == true,text == self.selectedDropingPoint{
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
            else if text == self.selectedBoardingPoint {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
            
            cell.lblPoint.text = text
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row == 0 ) ? 69.0 : 95.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        if isDroppoingSelected {
            self.selectedDropingPoint = self.droppingPoint![indexPath.row-1]
            
        }else{
            self.selectedBoardingPoint = self.boardingPoint![indexPath.row-1]
            self.btnDropping.sendActions(for: .touchUpInside)
        }
    }
}
