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
    @IBOutlet weak var nextBtn: UIButton!
    
    let newUserSegue = "newUserSegueId"
    let userExistsSegue = "TabBarMain"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTF.becomeFirstResponder()
        hideKeyboard()
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        nextBtn.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.nextBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        if codeTF.text != "" {
            PhoneAuthService.instance.regiserUser(verificationCode: codeTF.text!) { (success, error) in
                if success {
                    NotificationCenter.default.addObserver(self,
                                                           selector: #selector(self.showPresentsVC),
                                                           name: NSNotification.Name(Notifications.userExists),
                                                           object: nil)
                    NotificationCenter.default.addObserver(self,
                                                           selector: #selector(self.showRegisterVC),
                                                           name: NSNotification.Name(Notifications.newUser),
                                                           object: nil)
                } else {
                    // MARK: VALIDTION ERROR
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
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let PhoneSignUpVC = storyboard.instantiateViewController(withIdentifier: self.newUserSegue)
        self.show(PhoneSignUpVC, sender: nil)
    }
    
    @objc func showPresentsVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let PresentsVC = storyboard.instantiateViewController(withIdentifier: self.userExistsSegue)
        self.show(PresentsVC, sender: nil)
    }
    
    @IBAction func changePhoneNumPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showNoCodeAlert() {
        let alertController = UIAlertController(title: "Error".localized, message: "Please enter verification code from SMS".localized, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showWrongCodeAlert() {
        let alertController = UIAlertController(title: "Error".localized, message: "Wrong Verification Code".localized, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
