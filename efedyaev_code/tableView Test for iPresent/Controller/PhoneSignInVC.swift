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
    
    @IBOutlet weak var separator: UIView!
    let segueId = "ShowPhoneVerifyVC"
    let phoneNumberKit = PhoneNumberKit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receiveCodeBtn.alpha = 0.75
        separator.activateField(leftColor: #colorLiteral(red: 0.568627451, green: 0.6549019608, blue: 1, alpha: 1), rightColor: #colorLiteral(red: 0.4745098039, green: 0.7764705882, blue: 0.9882352941, alpha: 1))
        phoneNumber.becomeFirstResponder()
        phoneNumber.isPartialFormatterEnabled = true
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
            if phoneNumber.text!.first != "+" {
                phoneNumber.text!.insert("+", at: phoneNumber.text!.startIndex)
            }
            if phoneNumber.text!.last == " " {
                phoneNumber.text! = String(phoneNumber.text!.dropLast())
            }
            print("is going to authentificate")
            authenticate(phone_number: phoneNumber.text!)
        } else {
            showEnterPhoneNumberAlert()
        }
    }
    
    // MARK: Send Code
    func authenticate(phone_number: String) {
        let vSpinner = showSpinner(onView: self.view, red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        PhoneAuthProvider.provider().verifyPhoneNumber(phone_number, uiDelegate: nil) { (verify, error) in
            self.removeSpinner(vSpinner: vSpinner)
            if let error = error {
                // TODO: Add Unknown Error
                // check for too many requests
                if error.code == 17010 && error.domain == "FIRAuthErrorDomain" {
                    self.showAtemptsErrorAlert()
                } else if !Reachability.isConnectedToNetwork() {
                    self.showNoInternetErrorAlert()
                } else {
                    print("FATAL ERROR: \(error.localizedDescription)")
                    self.showUnknownErrorAlert()
                }
                print(error)
                return
            } else {
                print("should show verify vc")
                print(verify)
                UserDefaults.standard.set(verify, forKey: UserDefaultsKeys.authentificationId)
                self.showVerifyVC()
            }
        }
    }
    
    // MARK: Show Next VC
    func showVerifyVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let PhoneVerifyVC = storyboard.instantiateViewController(withIdentifier: segueId)
        PhoneVerifyVC.modalPresentationStyle = .fullScreen
        self.show(PhoneVerifyVC, sender: nil)
    }
    
    func showEnterPhoneNumberAlert() {
        let alertController = UIAlertController(title: "Error".localized, message: "Please enter your phone number".localized, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = #colorLiteral(red: 0.3647058824, green: 0.5921568627, blue: 0.7568627451, alpha: 1)
    }
    
    func showAtemptsErrorAlert() {
        let alertController = UIAlertController(title: "Error".localized, message: "Too many requests. Try again later.".localized, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = #colorLiteral(red: 0.3647058824, green: 0.5921568627, blue: 0.7568627451, alpha: 1)
    }
    
    func showUnknownErrorAlert() {
        let alertController = UIAlertController(title: "Error".localized, message: "Unknown error. Try again later.".localized, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = #colorLiteral(red: 0.3647058824, green: 0.5921568627, blue: 0.7568627451, alpha: 1)
    }
    
    func showNoInternetErrorAlert() {
        let alertController = UIAlertController(title: "Error".localized, message: "No internet connection".localized, preferredStyle: .alert)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField.text != nil else { return }
        if textField.text!.count > 1 && textField.text?.first != "+" {
            textField.text?.insert("+", at: textField.text!.startIndex)
        }
        if textField.text!.last == " " {
            textField.text! = String(textField.text!.dropLast())
        }
    }
}


