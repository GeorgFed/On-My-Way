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
    @IBOutlet weak var doneBtn: UIButton!
    
    let datePicker = UIDatePicker()
    let segueId = "presentsVCSegueId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.delegate = self
        lastName.delegate = self
        birthdate.delegate = self
        doneBtn.alpha = 0.75
        doneBtn.layer.cornerRadius = 3
        firstName.placeholder = "First name".localized
        lastName.placeholder = "Last name".localized
        birthdate.placeholder = "Date of birth".localized
        
        hideKeyboard()
        createDatePicker()
    }

    @IBAction func donePressed(_ sender: Any) {
        guard let firstName = firstName.text,
            let lastName = lastName.text,
            let birthdate = birthdate.text,
            firstName.isAlphanumeric, lastName.isAlphanumeric,
            !firstName.isEmpty, !lastName.isEmpty, !birthdate.isEmpty
        else {
            showWrongDataAlert()
            return
        }
        
        DataService.instance.updateDBUser(withUid: (Auth.auth().currentUser?.uid)!, firstName: firstName, lastName: lastName, birthdate: birthdate, updateComplete: { (isUpdated) in
            if isUpdated {
                NotificationCenter.default.post(name: Notification.Name(Notifications.firstEntry), object: nil)
                self.performSegue(withIdentifier: self.segueId, sender: nil)
            } else {
                self.showTryAgainAlert()
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
        doneButton.tintColor = #colorLiteral(red: 0.3647058824, green: 0.5921568627, blue: 0.7568627451, alpha: 1)
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
    
    func showWrongDataAlert() {
        let alertController = UIAlertController(title: "Error".localized, message: "All fields are to be filled".localized, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = #colorLiteral(red: 0.3647058824, green: 0.5921568627, blue: 0.7568627451, alpha: 1)
    }
    
    func showTryAgainAlert() {
        let alertController = UIAlertController(title: "Error".localized, message: "Please try again later".localized, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = #colorLiteral(red: 0.3647058824, green: 0.5921568627, blue: 0.7568627451, alpha: 1)
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
