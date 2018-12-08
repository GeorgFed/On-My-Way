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
    
    let userid = Auth.auth().currentUser?.uid
    let profile_settings = ["Personal Information", "Friend Request", "About", "Sign Out"]
    let picker = UIImagePickerController()
    
    let user = Auth.auth().currentUser
    var profileImgURL = "defaultProfilePicture"
    
    override func viewWillAppear(_ animated: Bool) {
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
        if userid == nil {
            fullNameTxt.text = "George Test"
        } else {
            DataService.instance.getUserInfo(forUid: userid!) { (user) in
                self.fullNameTxt.text = user.name
                self.profileImgURL = user.profileImgURL
            }
            
            DataService.instance.getUserImg(forUid: userid!) { ( data ) in
                if data != nil {
                    self.userImg.image = UIImage(data: data!)
                } else {
                    self.userImg.image = UIImage(named: "defaultProfilePicture")
                    print("error!")
                }
            }
            
//            if self.profileImgURL == "defaultProfilePicture" {
//                self.userImg.image = UIImage(named: "defaultProfilePicture")
//            } else {
//                DataService.instance.getUserImg(forUid: userid!) { ( data ) in
//                    if data != nil {
//                        self.userImg.image = UIImage(data: data!)
//                    } else {
//                        self.userImg.image = UIImage(named: "defaultProfilePicture")
//                        print("error!")
//                    }
//                }
//            }
            // MARK: Photos
//            if profileImgURL == "defaultProfilePicture" || profileImgURL == nil {
//                self.userImg.image = UIImage(named: "defaultProfilePicture")
//            } else {
//                DataService.instance.getUserPhoto(forUid: userid!) { (data) in
//                    self.userImg.image = UIImage(data: data)
//                }
//            }
//            self.userImg.image = UIImage(named: "defaultProfilePicture")
        }
        userImg.layer.cornerRadius = userImg.frame.height / 2
        userImg.clipsToBounds = true
        
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileSettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "_settings")
        if cell == nil {
            if indexPath.row == 3 {
                cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "_signout")
                cell?.textLabel?.textColor = #colorLiteral(red: 0.8078431373, green: 0.3294117647, blue: 0.2392156863, alpha: 1)
            } else {
                cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "_settings")
                cell?.accessoryType = .disclosureIndicator
            }
        }
        
        cell!.textLabel?.text = self.profile_settings[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let PhoneSignInVC = storyboard.instantiateViewController(withIdentifier: "PhoneSignInVC")
                self.show(PhoneSignInVC, sender: nil)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
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
            // MARK: Photos
//            DataService.instance.addUserPhoto(forUid: userid!, image: selectedImg) { (success) in
//                if success {
//                    print("Complete")
//                }
//            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled")
        self.dismiss(animated: true, completion: nil)
    }
}
