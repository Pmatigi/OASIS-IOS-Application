//
//  PassengerViewController.swift
//  OasisBooking
//
//  Created by Neeraj Mishra on 11/02/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit
struct Person {
    var strName: String
    var strContactNo: String
    var strGnder: String
}


class PassengerViewController: UIViewController {
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var pageController: UIPageViewController!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtContactNo: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var ganderPicker: UIPickerView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet var doneBtn: UIBarButtonItem!
    @IBOutlet weak var tblPassanger: UITableView!
    @IBOutlet weak var tblUpperConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnadd: UIButton!
    
    let gradePickerValues = ["Male", "Female", "Others"]
    var arrTravlerData = [""]
    
    var arrSheetCount : [String]?{
        didSet{
            
        }
    }
    
    var bus: Bus?

    
    var arrpassanger: Array<Dictionary<String, Any>> = []{
        didSet{
            self.tblPassanger.delegate = self
            self.tblPassanger.dataSource = self
            self.tblPassanger.reloadData()
        }
    }
    
    
    static var newInstance: PassengerViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "PassengerViewController") as! PassengerViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        txtName.layer.borderWidth = 1.0
        txtName.layer.borderColor = UIColor.lightGray.cgColor
        txtName.layer.cornerRadius = 10.0
        txtName.clipsToBounds = true
        txtName.setLeftPaddingPoints(10.0)
        txtContactNo.layer.borderWidth = 1.0
        txtContactNo.layer.borderColor = UIColor.lightGray.cgColor
        txtContactNo.layer.cornerRadius = 10.0
        txtContactNo.clipsToBounds = true
        txtContactNo.setLeftPaddingPoints(10.0)
        txtGender.layer.borderWidth = 1.0
        txtGender.layer.borderColor = UIColor.lightGray.cgColor
        txtGender.layer.cornerRadius = 10.0
        txtGender.clipsToBounds = true
        txtGender.setLeftPaddingPoints(10.0)
        ganderPicker.dataSource = self
        ganderPicker.delegate = self
        txtContactNo.delegate = self
        txtGender.delegate = self
        txtContactNo.delegate = self
        txtGender.inputView = ganderPicker
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(PassengerViewController.doneClick))
        toolbar.setItems([doneButton, spaceButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        txtGender.inputAccessoryView = toolbar
        toolbar.sizeToFit()
        txtContactNo.inputAccessoryView = toolbar
        self.btnNext.isHidden = true
        print(arrSheetCount?.count ?? 0)
        
    }
    @objc func doneClick() {
        txtContactNo?.resignFirstResponder()
        txtGender?.resignFirstResponder()
    }
    @IBAction func backBtnClick(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backNextClick(sender: UIButton!) {
        //proceed booking

        self.confirmBookingApi { (success,bookingId) in
        if success {
            let alert = UIAlertController(title: "Success!", message: "Your booking is confirm!", preferredStyle: .alert)
            print("Booking is confofrm with booking detais",bookingId)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                let vc = CheckoutViewController.newInstance
//                vc.booking_id = bookingId
//                self.present(vc, animated: true, completion: nil)
//                //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
//            }))
            let vc = CheckoutViewController.newInstance
            vc.booking_id = bookingId
            self.present(vc, animated: true, completion: nil)
        }
      }
    }
    
    fileprivate func clearTextFields() {
        self.txtGender.text = ""
        self.txtName.text = ""
        self.txtContactNo.text = ""
    }
    
    @IBAction func backAddClick(sender: UIButton!) {
        var dict =  Dictionary<String, Any>()
        dict["passenger_name"] = txtName.text
        dict["passenger_phone"] = txtContactNo.text
        dict["passenger_gender"] = txtGender.text
        dict["passenger_email"] = "abc@gmail.com"
        dict["passenger_age"] = "30"


        self.arrpassanger.append(dict)
        clearTextFields()
        
        if self.arrpassanger.count == self.arrSheetCount!.count {
            self.btnadd.isHidden = true
            self.tblUpperConstraint.constant = 30
            self.btnNext.isHidden = false
            return
        }
    }
}



extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
extension PassengerViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtContactNo{
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 10
        }
            return true
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtGender{
            textField.text = gradePickerValues[0]
        }
    }
}

extension PassengerViewController: UIPickerViewDataSource, UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gradePickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gradePickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        let picVal = gradePickerValues[row]
        txtGender.text = picVal
        self.txtGender.resignFirstResponder()
    }
}

extension PassengerViewController :UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrpassanger.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = PassangerTableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "PassangerTableViewCell", for: indexPath) as! PassangerTableViewCell
        let dict = self.arrpassanger[indexPath.row]
        cell.txtName.text = (dict["passenger_name"] as! String) + "(\(dict["passenger_gender"] as! String))"
        cell.txtContactNo.text = (dict["passenger_phone"]) as? String
        cell.txtSeatNum.text = "Seat No : \(self.arrSheetCount?[indexPath.row] ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.arrpassanger.remove(at: indexPath.row)
            self.tblPassanger.reloadData()
            
            if self.arrpassanger.count < self.arrSheetCount!.count {
                self.btnadd.isHidden = false
                self.tblUpperConstraint.constant = 313
                self.btnNext.isHidden = true
            }
        }
    }
}
