//
//  AddEventVC.swift
//  tableView Test for iPresent
//
//  Created by Georg on 21/03/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit
import Firebase
import Photos
import PhotosUI

class AddEventVC: UIViewController {

    private let blurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()
    
    @IBOutlet weak var addEventLbl: UILabel!
    
    @IBOutlet weak var eventNameTF: UITextField!
    @IBOutlet weak var eventDescriptionTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    
    @IBOutlet weak var addEventBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var img: UIImage!
    var imgName = "BackImg2"
    
    let datePicker = UIDatePicker()
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventNameTF.delegate = self
        eventDescriptionTF.delegate = self
        dateTF.delegate = self
        
        
        setupView()
        hideKeyboard()
        createDatePicker()
    }
    
    func setupView() {
        img = UIImage(named: imgName)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
        
        eventNameTF.placeholder = "Event name".localized
        eventDescriptionTF.placeholder = "Description".localized
        dateTF.placeholder = "Date".localized
        
        addEventLbl.text = "Add Event".localized
//        addEventBtn.titleLabel?.text = "Add Event".localized
//        cancelBtn.title(for: .normal) = "Cancel".localized
        addEventBtn.setTitle("Add Event".localized, for: .normal)
        cancelBtn.setTitle("Cancel".localized, for: .normal)
    }

    func createDatePicker() {
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date().addingTimeInterval(60 * 60 * 24 * 366)
        
        dateTF.inputView = datePicker
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        toolbar.setItems([doneButton], animated: true)
        dateTF.inputAccessoryView = toolbar
    }
    
    @objc func pickerDonePressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateTF.text = dateFormatter.string(from: datePicker.date)
        dateTF.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func addEvent() -> Bool {
        if eventNameTF.text != "" && dateTF.text != "" {
            DataService.instance.uploadEvent(uid: user!.uid, title: eventNameTF.text!, description: eventDescriptionTF.text ?? "", date: dateTF.text!) { ( success ) in
                if success {
                    NotificationCenter.default.post(name: Notification.Name(Notifications.eventAdded), object: nil)
                } else {
                    // TODO: SHOW ALERT
                }
            }
            return true
        } else {
            // TODO: SHOW ALERT
            return false
        }
    }
    
    @IBAction func addEventBtnPressed(_ sender: Any) {
        if addEvent() {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension AddEventVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case eventNameTF:
            textField.resignFirstResponder()
            eventDescriptionTF.becomeFirstResponder()
            break
        case eventDescriptionTF:
            textField.resignFirstResponder()
            dateTF.becomeFirstResponder()
            break
        case dateTF:
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

// TODO: show all alerts 
