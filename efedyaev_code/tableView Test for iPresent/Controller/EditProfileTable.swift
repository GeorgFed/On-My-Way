//
//  EditProfileTable.swift
//  tableView Test for iPresent
//
//  Created by Georg on 19.10.2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit
import Photos
import Firebase

class EditProfileTable: UITableViewController {

    var picker: ImagePicker! = nil
    let datePicker = UIDatePicker()
    
    var currentURL: String?
    var currentUserImage: UIImage?
    var newImage: UIImage?
    var lastName: String?
    var firstName: String?
    var birthdate: String?
    var userid: String?
    var date: String?
    
    @IBOutlet weak var titleItem: UIBarButtonItem!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var birthdateTF: UITextField!
    
    @IBOutlet weak var birthdateTitle: UILabel!
    @IBOutlet weak var lastNameTitle: UILabel!
    @IBOutlet weak var firstNameTitle: UILabel!
    
    @IBOutlet weak var SignOutOutlet: UILabel!
    @IBOutlet weak var DeleteAccountOutlet: UILabel!
    
    @IBOutlet weak var editProfileItem: UIBarButtonItem!
    @IBOutlet weak var saveItem: UIBarButtonItem!
    @IBOutlet weak var cancelItem: UIBarButtonItem!
    @IBOutlet weak var changeProfilePicture: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.userImage.layer.cornerRadius = userImage.frame.height * 0.5
        self.userImage.clipsToBounds = true
        
        titleItem.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 18)!], for: UIControl.State.normal)
        
        guard userid != nil else { return }
        
        if currentUserImage == nil { currentUserImage = UIImage(named: "") }
        
        DataService.instance.getUserInfo(forUid: userid!) { (user) in
            print("here")
            self.birthdate = user.birthdate
            self.date = user.birthdate
            self.updateValues()
        }
        
        if userid != nil {
            DataService.instance.getUserInfo(forUid: userid!) { (user) in
                print("here")
                self.birthdate = user.birthdate
                self.updateValues()
            }
        }
        
        updateValues()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.tableView.reloadData()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeImage(tapGestureRecognizer:)))
        userImage.isUserInteractionEnabled = true
        tapGestureRecognizer.cancelsTouchesInView = false
        userImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func changeImage(tapGestureRecognizer: UITapGestureRecognizer) {
        self.picker.present(from: self.view)
    }
    
    func updateValues() {
        if currentURL != nil {
            userImage.loadImgWithURLString(urlString: currentURL!)
        } else {
            userImage.image = UIImage(named: "DefaultBlueFilled")
        }
        
        firstNameTF.text = firstName
        lastNameTF.text = lastName
        birthdateTF.text = birthdate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        birthdateTF.delegate = self
        
        firstNameTitle.text = "First name".localized
        lastNameTitle.text = "Last name".localized
        birthdateTitle.text = "Birthdate".localized
        
        SignOutOutlet.text = "Sign Out".localized
        DeleteAccountOutlet.text = "Delete Account".localized
        editProfileItem.title = "Edit Profile".localized
        cancelItem.title = "Cancel".localized
        saveItem.title = "Save".localized
        changeProfilePicture.text = "Change profile picture".localized
        
        self.picker = ImagePicker(presentationController: self, delegate: self)
        hideKeyboard()
        createDatePicker()
    }

    func createDatePicker() {
        birthdateTF.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        doneButton.tintColor = #colorLiteral(red: 0.3647058824, green: 0.5921568627, blue: 0.7568627451, alpha: 1)
        toolbar.setItems([doneButton], animated: true)
        birthdateTF.inputAccessoryView = toolbar
    }
    
    @objc func pickerDonePressed(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.locale = Locale.autoupdatingCurrent
        
        let uniFormatter = DateFormatter()
        uniFormatter.dateStyle = .medium
        uniFormatter.timeStyle = .none
        uniFormatter.dateFormat = "dd-MM-yyyy"
        uniFormatter.locale = Locale(identifier: "en_US")
        
        date = uniFormatter.string(from: datePicker.date)
        birthdateTF.text = dateFormatter.string(from: datePicker.date)
        birthdateTF.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 140
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        updateProfile()
    }
    
    func updateProfile() {
        print(firstNameTF.text, lastNameTF.text, date)
        guard let firstName = firstNameTF.text,
            let lastName = lastNameTF.text,
            let birthdate = date,
            firstName.isAlphanumeric, lastName.isAlphanumeric,
            !firstName.isEmpty, !lastName.isEmpty, !birthdate.isEmpty
        else {
            showWrongDataAlert()
            return
        }
        let vSpinner = showSpinner(onView: self.view, red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        DataService.instance.updateDBUser(withUid: (Auth.auth().currentUser?.uid)!, firstName: firstName, lastName: lastName, birthdate: birthdate, updateComplete: { (isUpdated) in
            self.removeSpinner(vSpinner: vSpinner)
            if isUpdated {
                // MARK: - Setup Notification
                NotificationCenter.default.post(name: Notification.Name("UpdateProfileDetails"), object: nil)
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showTryAgainAlert()
                print("UPDATE ERROR!")
            }
        })
        
        if newImage != nil {
            // MARK: - Setup Notification
            DataService.instance.addUserImg(forUid: userid!, img: newImage!) { (success) in
                if success {
                    NotificationCenter.default.post(name: Notification.Name("UpdatePhoto"), object: nil)
                } else {
                    print("photo error")
                }
            }
        }
    }
    
    func showWrongDataAlert() {
       let alertController = UIAlertController(title: "Error".localized, message: "All fields are to be filled".localized, preferredStyle: .alert)
       let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
       alertController.addAction(defaultAction)
       self.present(alertController, animated: true, completion: nil)
       alertController.view.tintColor = #colorLiteral(red: 0.3647058824, green: 0.5921568627, blue: 0.7568627451, alpha: 1)
    }
    
    func showTryAgainAlert() {
        let alertController = UIAlertController(title: "Error".localized, message: "Please try again later".localized, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = #colorLiteral(red: 0.3647058824, green: 0.5921568627, blue: 0.7568627451, alpha: 1)
    }
    
    @objc func showSignOutAlert() {
        let alert = UIAlertController(title: "Sign out".localized, message: "Are you sure you want to sign out?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .destructive, handler: { [] (_) in
            _ = self.navigationController?.popViewController(animated: true)
            self.signOut() 
        }))
        alert.addAction(UIAlertAction(title: "No".localized, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let PhoneSignInVC = storyboard.instantiateViewController(withIdentifier: "PhoneSignInVC")
            self.present(PhoneSignInVC, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func showDeleteAlert() {
            let alert = UIAlertController(title: "Delete Account".localized, message: "Are you sure you want to delete your account?".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes".localized, style: .destructive, handler: { [] (_) in
                _ = self.navigationController?.popViewController(animated: true)
                self.deleteAccount()
            }))
            alert.addAction(UIAlertAction(title: "No".localized, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    
    func deleteAccount() {
        guard let uid = userid else { return }
        DataService.instance.deleteUser(uid: uid)
        signOut()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section != 2 {
            return nil
        } else {
            return indexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                showSignOutAlert()
            } else {
                showDeleteAlert()
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionName: String
        switch section {
            case 1:
                sectionName = "Personal info".localized
            case 2:
                sectionName = "Account".localized
            default:
                sectionName = ""
        }
        return sectionName
    }
}

extension EditProfileTable: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTF {
            textField.resignFirstResponder()
            lastNameTF.becomeFirstResponder()
        } else if textField == lastNameTF {
            textField.resignFirstResponder()
            birthdateTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}


extension EditProfileTable: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.newImage = image
        self.userImage.image = image
    }
}
