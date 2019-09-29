//
//  AddPresentsVC.swift
//  tableView Test for iPresent
//
//  Created by Georg on 29.10.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit
import Firebase
import Photos
import PhotosUI

class AddPresentsVC: UIViewController {
    
    private let blurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()
    
    @IBOutlet weak var presentBG: UIImageView!
    @IBOutlet weak var addPresentLbl: UILabel!
    @IBOutlet weak var addPresentBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    // MARK: TextField Outlets
    @IBOutlet weak var presentNameTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var linkTF: UITextField!
    
    @IBOutlet weak var baseView: RoundedCorners!
    
    let picker = UIImagePickerController()
    let user = Auth.auth().currentUser
    var img: UIImage!
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
        
        // self.presentBG.image = UIImage(named: "fab")
        
        presentNameTF.delegate = self
        descriptionTF.delegate = self
        priceTF.delegate = self
        linkTF.delegate = self
        
        presentNameTF.autocorrectionType = .no
        descriptionTF.autocorrectionType = .no
        priceTF.autocorrectionType = .no
        linkTF.autocorrectionType = .no

        self.picker.delegate = self
        
        setUpView()
        hideKeyboard()
    }
    
    func setUpView() {
        img = UIImage(named: imgName)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
        
        presentNameTF.placeholder = "Present name*".localized
        descriptionTF.placeholder = "Description".localized
        linkTF.placeholder = "Link".localized
        priceTF.placeholder = "Price*".localized
        addPresentLbl.text = "Add Present".localized
        addPresentBtn.setTitle("Add Present".localized, for: .normal)
        cancelBtn.setTitle("Cancel".localized, for: .normal)
    }
    
    // MARK: PHOTO ACCESS PERMISSION
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized: self.present(self.picker, animated: true, completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (newStatus) in print("status is \(newStatus)"); if newStatus == PHAuthorizationStatus.authorized { self.present(self.picker, animated: true, completion: nil) }})
        case .restricted: print("User does not have access to photo album.")
        case .denied: print("User has denied the permission.")
        }
    }
    
    func changeImage() {
        self.picker.sourceType = .photoLibrary
        self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.picker.allowsEditing = true
        checkPermission()
        
    }
    
    func add_new_present() {
        if check_input() {
            self.dismiss(animated: true)
        }
    }
    
    func check_input() -> Bool {
        var outcome = false
        guard let presentName = presentNameTF.text,
            var price = priceTF.text,
            let link = linkTF.text,
            !presentName.isEmpty, !price.isEmpty
        else {
            showWrongDataAlert()
            return outcome
        }
        
        if price.last != "$" || price.last != "₽" {
            price.append("$".localized)
        }
        
        DataService.instance.uploadMedia(img: img, imgType: MediaType.img) { ( url ) in
            DataService.instance.uploadPresent(name: presentName, description: self.descriptionTF.text ?? " ", price: price, image: url!, senderid: self.user!.uid, link: link) { (success) in
                outcome = success
                if success {
                    NotificationCenter.default.post(name: Notification.Name(Notifications.presentAdded), object: nil)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showTryAgainAlert()
                }
            }
        }
        return outcome
    }

    @IBAction func addBtnPressed(_ sender: Any) {
        add_new_present()
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addPhotoBtnPressed(_ sender: Any) {
        changeImage()
    }
    
    func showWrongDataAlert() {
        let alertController = UIAlertController(title: "Error".localized, message: "All fields are to be filled".localized, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = #colorLiteral(red: 0.3647058824, green: 0.5921568627, blue: 0.7568627451, alpha: 1)
    }
    
    func showTryAgainAlert() {
        let alertController = UIAlertController(title: "Error".localized, message: "Please  try again later".localized, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = #colorLiteral(red: 0.3647058824, green: 0.5921568627, blue: 0.7568627451, alpha: 1)
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

extension AddPresentsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedPickerImg: UIImage?
        if let editedImg = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedPickerImg = editedImg
        } else if let originalImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedPickerImg = originalImg
        }
        
        if let selectedImg = selectedPickerImg {
            print(selectedImg)
            self.img = selectedImg
            self.presentBG.contentMode = .scaleAspectFill
            self.presentBG.image = self.img
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled")
        self.dismiss(animated: true, completion: nil)
    }
}
