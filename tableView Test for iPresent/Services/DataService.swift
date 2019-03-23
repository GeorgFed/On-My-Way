//
//  DataService.swift
//  tableView Test for iPresent
//
//  Created by Georg on 09.10.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

let DB_BASE = Database.database().reference()
let STORAGE_REF = Storage.storage().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    func getUsersByName(forSearchQuery query: String, handler: @escaping(_ nameArray: [User]) -> ()) {
        var userArray = [User]()
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                guard let name = user.childSnapshot(forPath: "name").value as? String else { continue }
                guard let birthdate = user.childSnapshot(forPath: "birthdate").value as? String else { continue }
                guard let uid = user.childSnapshot(forPath: "userId").value as? String else { continue }
                let profileImgURL = user.childSnapshot(forPath: "profileImgURL").value as? String ?? "defaultProfileImg"
                if query.isAlphanumeric {
                    if name.contains(query) && name != Auth.auth().currentUser?.displayName {
                        let returned_user = User(name: name, birthdate: birthdate, uid: uid, profileImgURL: profileImgURL)
                        userArray.append(returned_user)
                    }
                }
            }
            handler(userArray)
        }
    }
    
    func getUsersByPhoneNumber(phoneNumbers query: [String], handler: @escaping(_ nameArray: [User]) -> ()) {
        var userArray = [User]()
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                guard let phoneNum = user.childSnapshot(forPath: "phoneNumber").value as? String else { continue }
                if query.contains(phoneNum) {
                    guard let name = user.childSnapshot(forPath: "name").value as? String else { continue }
                    guard let birthdate = user.childSnapshot(forPath: "birthdate").value as? String else { continue }
                    guard let uid = user.childSnapshot(forPath: "userId").value as? String else { continue }
                    let profileImgURL = user.childSnapshot(forPath: "profileImgURL").value as? String ?? "defaultProfileImg"
                    
                    let returned_user = User(name: name, birthdate: birthdate, uid: uid, profileImgURL: profileImgURL)
                    print("User found with phone number:\(name)!!")
                    userArray.append(returned_user)
                }
            }
            handler(userArray)
        }
    }
    
    func uploadMedia(img: UIImage, imgType: String, handler: @escaping (_ url: String?) -> Void) {
        let uuid = NSUUID().uuidString.lowercased()
        let storageRef = STORAGE_REF.child(imgType).child("\(uuid).jpeg")
        
        if let uploadData = img.jpegData(compressionQuality: 0.5) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    handler(nil)
                } else {
                    storageRef.downloadURL(completion: { (url, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        handler(url?.absoluteString)
                    })
                }
            }
        }
    }
}
