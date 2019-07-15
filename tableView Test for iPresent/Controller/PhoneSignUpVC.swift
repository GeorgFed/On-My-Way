//
//  PhoneSignUpVC.swift
//  tableView Test for iPresent
//
//  Created by Georg on 01.11.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit
import Firebase

class PhoneSignUpVC: UIViewController {
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var birthdate: UITextField!
    
    let datePicker = UIDatePicker()
    let segueId = "presentsVCSegueId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.delegate = self
        lastName.delegate = self
        birthdate.delegate = self
        
        firstName.placeholder = "First name".localized
        lastName.placeholder = "Last name".localized
        birthdate.placeholder = "Date of birth".localized
        
        hideKeyboard()
        createDatePicker()
    }

    @IBAction func donePressed(_ sender: Any) {
        DataService.instance.updateDBUser(withUid: (Auth.auth().currentUser?.uid)!, firstName: firstName.text!, lastName: lastName.text!, birthdate: birthdate.text!, updateComplete: { (isUpdated) in
            if isUpdated {
                NotificationCenter.default.post(name: Notification.Name(Notifications.firstEntry), object: nil)
                self.performSegue(withIdentifier: self.segueId, sender: nil)
            } else {
                print("UPDATE ERROR!")
            }
        })
    }
    
    func createDatePicker() {
        birthdate.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        toolbar.setItems([doneButton], animated: true)
        birthdate.inputAccessoryView = toolbar
    }
    
    @objc func pickerDonePressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd MMM yyyy"
        birthdate.text = dateFormatter.string(from: datePicker.date)
        birthdate.resignFirstResponder()
        self.view.endEditing(true)
    }
}

extension PhoneSignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstName {
            textField.resignFirstResponder()
            lastName.becomeFirstResponder()
        } else if textField == lastName {
            textField.resignFirstResponder()
            birthdate.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
