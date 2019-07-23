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
    @IBOutlet weak var receiveCodeBtn: GradientButton!
    
    let segueId = "ShowPhoneVerifyVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receiveCodeBtn.alpha = 0.75
        phoneNumber.becomeFirstResponder()
        hideKeyboard()
    }
    
    @IBAction func receiveCodePressed(_ sender: Any) {
        receiveCodeBtn.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.receiveCodeBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        if phoneNumber.text != "" && phoneNumber.isValidNumber {
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
                UserDefaults.standard.set(verify, forKey: UserDefaultsKeys.authentificationId)
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
        let alertController = UIAlertController(title: "Error".localized, message: "Please enter your phone number".localized, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = #colorLiteral(red: 0.3647058824, green: 0.5921568627, blue: 0.7568627451, alpha: 1)
    }
}

extension PhoneSignInVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


