//
//  PhoneSignInVC.swift
//  tableView Test for iPresent
//
//  Created by Georg on 01.11.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import PhoneNumberKit

class PhoneSignInVC: UIViewController {

    @IBOutlet weak var phoneNumber: PhoneNumberTextField!
    
    let segueId = "ShowPhoneVerifyVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumber.becomeFirstResponder()
        hideKeyboard()
    }
    
    @IBAction func receiveCodePressed(_ sender: Any) {
        if phoneNumber.text != "" {
            authenticate(phone_number: phoneNumber.text!)
        } else {
            showEnterPhoneNumberAlert()
        }
    }
    
    // MARK: Send Code
    func authenticate(phone_number: String) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phone_number, uiDelegate: nil) { (verify, error) in
            if let error = error {
                print(error)
                return
            } else {
                UserDefaults.standard.set(verify, forKey: "authVerificationID")
                self.showVerifyVC()
            }
        }
    }
    
    // MARK: Show Next VC
    func showVerifyVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let PhoneVerifyVC = storyboard.instantiateViewController(withIdentifier: segueId)
        self.show(PhoneVerifyVC, sender: nil)
    }
    
    func showEnterPhoneNumberAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please enter your phone number", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension PhoneSignInVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


