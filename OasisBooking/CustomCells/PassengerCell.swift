//
//  PassengerCell.swift
//  OasisBooking
//
//  Created by Neeraj Mishra on 11/02/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit


protocol PassengerCellProtocol: class {
    func dismissKeyBoard(_ cell: PassengerCell)
}

class PassengerCell: UICollectionViewCell {
    
    @IBOutlet weak var pageController: UIPageViewController!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtContactNo: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var ganderPicker: UIPickerView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet var doneBtn: UIBarButtonItem!
    
    let gradePickerValues = ["Male", "Female", "Others"]
    
    weak var delegate: PassengerCellProtocol?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ganderPicker.dataSource = self
        ganderPicker.delegate = self
        txtContactNo.delegate = self
        txtGender.delegate = self
        txtContactNo.delegate = self
        txtGender.inputView = ganderPicker
        txtGender.inputAccessoryView = toolbar
        doneBtn = UIBarButtonItem(title: nil, style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneClicked(sender:)))
        toolbar.sizeToFit()
        txtContactNo.inputAccessoryView = toolbar
    }
    
    @objc func doneClicked(sender: UIBarButtonItem) {
        self.txtName.resignFirstResponder()
       txtContactNo.resignFirstResponder()
       txtGender.resignFirstResponder()
       self.endEditing(true)
       delegate?.dismissKeyBoard(self)
    }    
}

extension PassengerCell : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

extension PassengerCell: UIPickerViewDataSource, UIPickerViewDelegate
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
