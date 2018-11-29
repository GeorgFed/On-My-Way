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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTF.becomeFirstResponder()
        hideKeyboard()
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        if codeTF.text != "" {
            PhoneAuthService.instance.regiserUser(verificationCode: codeTF.text!) { (success, error) in
                if success {
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let PhoneSignUpVC = storyboard.instantiateViewController(withIdentifier: self.newUserSegue)
                    self.show(PhoneSignUpVC, sender: nil)
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
