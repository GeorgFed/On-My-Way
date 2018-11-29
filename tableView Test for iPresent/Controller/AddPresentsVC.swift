//
//  AddPresentsVC.swift
//  tableView Test for iPresent
//
//  Created by Georg on 29.10.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit
import Firebase

class AddPresentsVC: UIViewController {
    
    private let blurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()
    
    // MARK: TextField Outlets
    @IBOutlet weak var presentNameTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var linkTF: UITextField!
    
    @IBOutlet weak var baseView: RoundedCorners!
    
    let user = Auth.auth().currentUser
    var imgName = "BackImg2"
    
    var initial_position: CGFloat = 0.0
    var desc_position: CGFloat = 0.0
    var link_price_position: CGFloat = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        initial_position = self.baseView.frame.origin.y
        desc_position = initial_position - 30.0
        link_price_position = desc_position - 30.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentNameTF.delegate = self
        descriptionTF.delegate = self
        priceTF.delegate = self
        linkTF.delegate = self
        
        setUpView()
        hideKeyboard()
    }
    
    func setUpView() {
        // Method #1
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
    }
    
    func add_new_present() {
        // check_input()
        // add present to database
        // add notification
        
        if check_input() {
            self.dismiss(animated: true) {
                // New Present Notification
            }
        }
    }
    
    func check_input() -> Bool {
        if presentNameTF.text != "" && priceTF.text != "" {
            // OK
            DataService.instance.uploadPresent(name: presentNameTF.text!, description: descriptionTF.text ?? "-", price: priceTF.text!, image: imgName, senderid: user!.uid) { (success) in
                if success {
                    NotificationCenter.default.post(name: Notification.Name("PresentAdded"), object: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            return true
        } else {
            // SHOW ALERT
            return false
        }
    }
    
    // MARK: Button Actions
    @IBAction func addBtnPressed(_ sender: Any) {
        add_new_present()
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true) {
            // TODO: No Present Added - No Notification
        }
    }
    
    @IBAction func addPhotoBtnPressed(_ sender: Any) {
        
    }
}

// MARK: TextFieldDelegate
extension AddPresentsVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case presentNameTF:
            textField.resignFirstResponder()
            descriptionTF.becomeFirstResponder()
            break
        case descriptionTF:
            textField.resignFirstResponder()
            linkTF.becomeFirstResponder()
            break
        case linkTF:
            textField.resignFirstResponder()
            priceTF.becomeFirstResponder()
            break
        case priceTF:
            resignFirstResponder()
            textField.endEditing(true)
            break
        default:
            break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 50)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 50)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}

// Method #2
//        let blurView = UIVisualEffectView(frame: UIScreen.main.bounds)
//        blurEffect.setValue(1, forKeyPath: "blurRadius")
//        blurView.effect = blurEffect
//        view.addSubview(blurView)
