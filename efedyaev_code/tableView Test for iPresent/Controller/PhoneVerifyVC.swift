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
    @IBOutlet weak var separator: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.alpha = 0.75
        separator.activateField(leftColor: #colorLiteral(red: 1, green: 0.4274509804, blue: 0.5764705882, alpha: 1), rightColor: #colorLiteral(red: 0.9411764706, green: 0.5019607843, blue: 0.5098039216, alpha: 1))
        codeTF.becomeFirstResponder()
        codeTF.placeholder = "SMS code".localized
        hideKeyboard()
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        nextBtn.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.nextBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        guard let code = codeTF.text else {
            codeTF.resignFirstResponder()
            showNoCodeAlert()
            return
        }
        let vSpinner = showSpinner(onView: self.view, red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        PhoneAuthService.instance.regiserUser(verificationCode: code) { (success, error) in
            self.removeSpinner(vSpinner: vSpinner)
            if success {
                print("successfully registered user!! adds obsevers on user type")
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(self.showPresentsVC),
                                                       name: NSNotification.Name(Notifications.userExists),
                                                       object: nil)
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(self.showRegisterVC),
                                                       name: NSNotification.Name(Notifications.newUser),
                                                       object: nil)
            } else {
                self.showWrongCodeAlert()
            }
        }
    }
    
    @objc func showRegisterVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let PhoneSignUpVC = storyboard.instantiateViewController(withIdentifier: self.newUserSegue)
        PhoneSignUpVC.modalPresentationStyle = .fullScreen
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
        alertController.view.tintColor = #colorLiteral(red: 0.3647058824, green: 0.5921568627, blue: 0.7568627451, alpha: 1)
    }
    
    func showWrongCodeAlert() {
        let alertController = UIAlertController(title: "Error".localized, message: "Wrong Verification Code".localized, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = #colorLiteral(red: 0.3647058824, green: 0.5921568627, blue: 0.7568627451, alpha: 1)
    }
}
