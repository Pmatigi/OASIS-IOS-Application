//
//  BusBookingViewController.swift
//  OasisBooking
//
//  Created by Neeraj Mishra on 25/01/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit
//import DateScrollPicker
import Presentr
import MBProgressHUD

class BusBookingViewController: UIViewController {
    @IBOutlet weak var dateScrollPicker: DateScrollPicker!
    @IBOutlet weak var lblCurrentDate: UILabel!
    @IBOutlet weak var txtBusFrom: UITextField!
    @IBOutlet weak var txtBusTo: UITextField!
    
    var currentTextField = UITextField()
    var source = City()
    var destination = City()
    var selectedDate = String()
    static var selectedDateForBooking = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupScrollPicker1()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lblCurrentDate.text = Date().format(dateFormat: "EEEE, dd MMMM yyyy")
        selectedDate = Date().format(dateFormat: "dd-MM-yyyy")
        BusBookingViewController.selectedDateForBooking = Date().format(dateFormat: "yyyy-MM-dd")
        dateScrollPicker.selectToday()
       // dateScrollPicker.collectionView.reloadData()
    }
    
    fileprivate func swap() {
        if txtBusFrom.text != "" && txtBusTo.text != ""
        {
            let swapSource = self.destination
            let swapDestination = self.source
            
            let swaprValueFrom = swapSource.cityName
            let swaprValueTo = swapDestination.cityName
            let swapIdFrom = swapSource.cityId
            let swapIdTo = swapDestination.cityId
            
            self.source = swapSource
            self.destination = swapDestination
                    
            self.txtBusFrom.text = swaprValueFrom
            self.txtBusTo.text = swaprValueTo
            print("swapped")
        }else{
            let alert = UIAlertController(title: "Alert", message: "Start and End point not selected, please select", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func sawpeBtnClick(sender: UIButton!) {
        swap()
    }
    
    @IBAction func nextBtnClick(sender: UIButton!) {
        if txtBusFrom.text == "" || txtBusTo.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Start and End point not selected, please select", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else if self.source.cityId == self.destination.cityId {
            let alert = UIAlertController(title: "Alert", message: "Start and End point can not be same, please select different", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            self.SearcbBusApi()
        }
    }
    
}

// HANDLERS

extension BusBookingViewController {
    
    @objc func didPressTodayButton(_ sender: UIButton) {
        goToday()
    }
}

// VIEW

extension BusBookingViewController: DateScrollPickerDelegate, DateScrollPickerDataSource {
    
    private func setupScrollPicker1() {
        var format = DateScrollPickerFormat()
        format.days = 5
        format.topDateFormat = "MMM"
        format.bottomDateFormat = "EEEE"
        format.topTextColor = UIColor.white.withAlphaComponent(0.9)
        format.mediumTextColor = UIColor.white.withAlphaComponent(0.9)
        format.bottomTextColor = UIColor.white.withAlphaComponent(0.9)
        format.topFont = UIFont(name: "Volte-Regular2", size: 16)!
        format.bottomFont = UIFont(name: "Volte-Regular2", size: 10)!
        format.dayBackgroundColor = UIColor(hex: "aa9dec")//UIColor.black.withAlphaComponent(0.8)
        format.dayBackgroundSelectedColor = UIColor(hex: "00bfff")
        format.separatorTopTextColor = UIColor.white.withAlphaComponent(0.9)
        format.separatorTopTextColor = UIColor.white.withAlphaComponent(0.9)
        format.separatorBottomTextColor = UIColor.white.withAlphaComponent(0.9)
        format.separatorBackgroundColor =
            UIColor(hex:"aa9dec")//UIColor.white.withAlphaComponent(0.3)
        format.dayBackgroundDisabledColor = .lightGray
        format.separatorTopFont = UIFont(name: "Volte-Regular3", size: 12)!
        format.separatorBottomFont = UIFont(name: "Volte-Regular2", size: 12)!
        
        // format.separatorEnabled = true
        dateScrollPicker.format = format
        dateScrollPicker.delegate = self
        dateScrollPicker.dataSource = self
    }
    
    private func goToday() {
        self.setupScrollPicker1()
    }
    
    func dateScrollPicker(_ dateScrollPicker: DateScrollPicker, didSelectDate date: Date) {
        if date >= Date.today(){
            lblCurrentDate.text = date.format(dateFormat: "EEEE, dd MMMM yyyy")
            selectedDate = date.format(dateFormat: "dd-MM-yyyy")
            BusBookingViewController.selectedDateForBooking = date.format(dateFormat: "yyyy-MM-dd")
            
        }
    }
    /*
     func dateScrollPicker(_ dateScrollPicker: DateScrollPicker, mediumAttributedStringByDate date: Date) -> NSAttributedString? {
     if dateScrollPicker === dateScrollPicker {
     let attributes1 = [NSAttributedString.Key.font: UIFont(name: "Volte-Regular3", size: 36)!]
     let attributes2 = [NSAttributedString.Key.font: UIFont(name: "Volte-Regular2", size: 10)!]
     let attributed = NSMutableAttributedString(string: date.format(dateFormat: "dd EEE").uppercased())
     attributed.addAttributes(attributes1, range: NSRange(location: 0, length: 2))
     attributed.addAttributes(attributes2, range: NSRange(location: 2, length: 4))
     return attributed
     } else {
     return nil
     }
     }*/
    
    func dateScrollPicker(_ dateScrollPicker: DateScrollPicker, dataAttributedStringByDate date: Date) -> NSAttributedString? {
        if dateScrollPicker === dateScrollPicker {
            let attributes = [NSAttributedString.Key.font: UIFont(name: "Volte-Regular2", size: 10)!, NSAttributedString.Key.foregroundColor: UIColor.white]
            return Date.today() == date ? NSAttributedString(string: "Today", attributes: attributes) : nil
        } else {
            return nil
        }
    }
    
    func dateScrollPicker(_ dateScrollPicker: DateScrollPicker, dotColorByDate date: Date) -> UIColor? {
        if Date.today() == date { return .yellow }
        if Date.today().addDays(1) == date { return UIColor(hex: "00FF1A") }
        if Date.today().addDays(-1) == date { return UIColor(hex: "00FF1A") }
        return UIColor.white.withAlphaComponent(0.9)
    }
}


//Extesnion UITextfield datasource and delegates

extension BusBookingViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        self.view.endEditing(true)
        textField.resignFirstResponder()
        let vc = SuggestionsViewController.newInstance
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        //customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}




extension BusBookingViewController : SuggestionDelegate {
    func suggestedCityName(data: City) {
        if currentTextField == txtBusTo {
            txtBusTo.text = data.cityName
            self.destination = data
        }
        else{
            txtBusFrom.text = data.cityName
            self.source = data
            //destination.cityName = data.cityName
            //destination.cityId = data.cityId
        }
    }
}

