//
//  ProfileSettingsVC.swift
//  tableView Test for iPresent
//
//  Created by Georg on 01.11.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit
import Firebase
import Photos

class ProfileSettingsVC: UIViewController {

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var fullNameTxt: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addEventBtn: UIButton!
    
    let userid = Auth.auth().currentUser?.uid
    let picker = UIImagePickerController()
    let user = Auth.auth().currentUser
    
    var profileImgURL = "defaultProfilePicture"
    var events = [Event]()
    
    override func viewWillAppear(_ animated: Bool) {
        getEvents()
        setUpView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.picker.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeImage(tapGestureRecognizer:)))
        userImg.isUserInteractionEnabled = true
        userImg.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: PHOTO ACCESS PERMISSION
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized: self.present(self.picker, animated: true, completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (newStatus) in print("status is \(newStatus)"); if newStatus == PHAuthorizationStatus.authorized { self.present(self.picker, animated: true, completion: nil) }})
                case .restricted: print("User do not have access to photo album.")
                case .denied: print("User has denied the permission.")
        }
    }
            
    @objc func changeImage(tapGestureRecognizer: UITapGestureRecognizer) {
        self.picker.sourceType = .photoLibrary
        self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.picker.allowsEditing = true
        checkPermission()
    }
    
    func setUpView() {
        // navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "sign-out slice"), style: .plain, target: self, action: #selector(showSignOutAlert))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "More PDF"), style: .plain, target: self, action: #selector(moreTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        let userKey = "mainUser"
        if let username = mainUserNameCache.object(forKey: userKey as NSString) {
            self.fullNameTxt.text = username as String
        }
        if let photourl = mainUserPhotoURLCache.object(forKey: userKey as NSString) {
            self.userImg.loadImgWithURLString(urlString: (photourl as NSString) as String)
        }
        if userid == nil {
            fullNameTxt.text = "Test Test"
        } else {
            DataService.instance.getUserInfo(forUid: userid!) { (user) in
                self.fullNameTxt.text = user.name
                self.profileImgURL = user.profileImgURL
            }
        }
        userImg.layer.cornerRadius = userImg.frame.height / 2
        userImg.clipsToBounds = true
        addEventBtn.setTitle("Add Event".localized, for: .normal)
    }
    
    @objc func moreTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Sign Out".localized, style: .default , handler:{ (UIAlertAction)in
            self.showSignOutAlert()
        }))
        
        alert.addAction(UIAlertAction(title: "Delete Account".localized, style: .destructive , handler:{ (UIAlertAction)in
            self.showDeleteAlert()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss".localized, style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: nil)
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
    
    @objc func getEvents() {
        DataService.instance.getEvents(forUid: user!.uid) { ( returnedEvents ) in
            self.events = returnedEvents.sorted(by: { (one, two) -> Bool in
                one.convertedDate < two.convertedDate
            })
            self.tableView.reloadData()
        }
    }
    
    func deleteAccount() {
        user?.delete(completion: { (error) in
            if let error = error {
                print(error)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let PhoneSignInVC = storyboard.instantiateViewController(withIdentifier: "PhoneSignInVC")
                //self.show(PhoneSignInVC, sender: nil)
                self.present(PhoneSignInVC, animated: true, completion: nil)
            }
        })
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
            //self.show(PhoneSignInVC, sender: nil)
            self.present(PhoneSignInVC, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let PhoneSignInVC = storyboard.instantiateViewController(withIdentifier: "PhoneSignInVC")
            //self.show(PhoneSignInVC, sender: nil)
            self.present(PhoneSignInVC, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func addEventBtnPressed(_ sender: Any) {
        let _addEventVC = AddEventVC()
        _addEventVC.modalPresentationStyle = .custom
        present(_addEventVC, animated: true, completion: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getEvents),
                                               name: NSNotification.Name(Notifications.eventAdded),
                                               object: nil)
    }
}

// TODO: CHANGE TABLE VIEW
extension ProfileSettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventCell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        cell.name.text = events[indexPath.row].title
        cell.details.text = events[indexPath.row].description
        cell.day.text = String(events[indexPath.row].date.prefix(2))
        cell.month.text = String(events[indexPath.row].date.dropFirst(3).prefix(3))
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            DataService.instance.removeEvents(uid: userid!, uuid: events[indexPath.row].uuid) { ( success ) in
                if success {
                    self.getEvents()
                }
            }
        }
    }
    
}

extension ProfileSettingsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedPickerImg: UIImage?
        if let editedImg = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedPickerImg = editedImg
        } else if let originalImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedPickerImg = originalImg
        }
        
        userImg.layer.cornerRadius = userImg.frame.height * 0.5
        userImg.clipsToBounds = true
        
        if let selectedImg = selectedPickerImg {
            self.userImg.image = selectedImg
            DataService.instance.addUserImg(forUid: userid!, img: selectedImg)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
