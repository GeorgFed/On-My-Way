//
//  PhoneVerifyVC.swift
//  tableView Test for iPresent
//
//  Created by Georg on 01.11.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit

class PhoneVerifyVC: UIViewController {
    
    @IBOutlet weak var codeTF: UITextField!
    
    let newUserSegue = "newUserSegueId"
    let userExistsSegue = "presentsVCSegueId"
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTF.becomeFirstResponder()
        hideKeyboard()
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        if codeTF.text != "" {
            PhoneAuthService.instance.regiserUser(verificationCode: codeTF.text!) { (success, error) in
                if success {
                    // UserExists
                    NotificationCenter.default.addObserver(self, selector: #selector(self.showPresentsVC), name: NSNotification.Name("UserExists"), object: nil)
                    
                    // NewUser
                    NotificationCenter.default.addObserver(self, selector: #selector(self.showRegisterVC), name: NSNotification.Name("NewUser"), object: nil)
                    
                    /*
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let PhoneSignUpVC = storyboard.instantiateViewController(withIdentifier: self.newUserSegue)
                    self.show(PhoneSignUpVC, sender: nil)
                    */
                } else {
                    print("Validation Error")
                    self.showWrongCodeAlert()
                }
            }
        } else {
            codeTF.resignFirstResponder()
            showNoCodeAlert()
        }
    }
    
    @objc func showRegisterVC() {
        print("Register Segue")
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let PhoneSignUpVC = storyboard.instantiateViewController(withIdentifier: self.newUserSegue)
        self.show(PhoneSignUpVC, sender: nil)
    }
    
    @objc func showPresentsVC() {
        print("Presents Segue")
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let PresentsVC = storyboard.instantiateViewController(withIdentifier: self.userExistsSegue)
        self.show(PresentsVC, sender: nil)
    }
    
    @IBAction func changePhoneNumPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showNoCodeAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please enter verification code from SMS", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showWrongCodeAlert() {
        let alertController = UIAlertController(title: "Error", message: "Wrong Verification Code", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
