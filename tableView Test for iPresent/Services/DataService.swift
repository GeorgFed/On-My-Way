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
    
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func updateDBUser(withUid uid: String, firstName: String, lastName: String, birthdate: String, updateComplete: @escaping (_ status: Bool) -> ()) {
        let fullName = firstName + " " + lastName
        let default_img = UIImage(named: "defaultProfilePicture")
        REF_USERS.child(uid).updateChildValues(["userId": uid, "name": fullName, "birthdate": birthdate])
        addUserImg(forUid: uid, img: default_img!)
        updateComplete(true)
    }
    
    func addUserImg(forUid uid: String, img: UIImage) {
        uploadMedia(img: img) { (url) in
            print(url)
            guard let url = url else { return }
            let ref = self.REF_USERS.child(uid)
            let key = "profileImgURL"
            // let img_child = "\(uid).jpeg"
            ref.updateChildValues([key: url])
        }
    }
    
    func getUserImg(forUid uid: String, handler: @escaping (_ data: Data?) -> ()) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { ( snap ) in
            print(snap)
            let value = snap.value as? NSDictionary
            guard let imageUrl = value?["profileImgURL"] as? String else { return }
            print(imageUrl)
            let storage = Storage.storage()
            _ = storage.reference()
            let ref = storage.reference(forURL: imageUrl)
            ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if error != nil {
                    print(error?.localizedDescription)
                    return
                } else {
                    handler(data!)
                }
            }
        }
    }
    
    func uploadMedia(img: UIImage, handler: @escaping (_ url: String?) -> Void) {
        let uuid = NSUUID().uuidString.lowercased()
        let storageRef = STORAGE_REF.child("profile_images.jpeg").child("\(uuid).jpeg")
        
        if let uploadData = img.jpegData(compressionQuality: 0.5) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    handler(nil)
                } else {
                    storageRef.downloadURL(completion: { (url, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        print("here")
                        handler(url?.absoluteString)
                    })
                }
            }
        }
    }
        
    // MARK: Photos
    /*
    func addUserPhoto(forUid uid: String, image: UIImage, updateComplete: @escaping (_ status: Bool) -> ()) {
        let profileImgStorage = STORAGE_REF.child("profile_images").child("\(uid).png")
        if let uploadData = image.jpegData(compressionQuality: 0.5) {
            profileImgStorage.putData(uploadData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                metadata?.storageReference?.downloadURL(completion: { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    self.REF_USERS.child(uid).updateChildValues(["profileImg": url ?? "defaultProfileImg"])
                })
            }
        }
    }
    
    func getUserPhoto(forUid uid: String, handler: @escaping(_ data: Data) -> ()) {
        let ref = REF_USERS.child(uid)
        ref.child("profileImg").observe(.value, with: {(snap: DataSnapshot) in
            let imageUrl = snap.value
            
            let storage = Storage.storage()
            _ = storage.reference()
            let ref = storage.reference(forURL: imageUrl as! String)
            ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if error != nil {
                    print(error)
                    return
                } else {
                    handler(data!)
                }
            }
        })
    }
    */
    
    func getUserInfo(forUid uid: String, handler: @escaping (_ user: User) -> ())  {
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { ( snapshot ) in
            let value = snapshot.value as? NSDictionary
            let fullName = value?["name"] as? String ?? ""
            let birthdate = value?["birthdate"] as? String ?? ""
            let uid = value?["userId"] as? String ?? ""
            let profileImgURL = value?["profileImgURL"] as? String ?? ""
            var user: User
            user = User(name: fullName, birthdate: birthdate, uid: uid, profileImgURL: profileImgURL)
            handler(user)
        }
        
    }
    
    func uploadPresent(name: String, description: String, price: String, image: String, senderid: String, sendComplete: @escaping(_ status: Bool) -> ()) {
        let ref = REF_USERS.child(senderid).child("presents").childByAutoId()
        let key = ref.key
        
        ref.updateChildValues(["present_name":name, "description": description, "price": price, "image": image, "senderId": senderid, "uuid": key!])
        sendComplete(true)
    }
    
    func getPresents(forUid uid: String, handler: @escaping (_ presents: [Present]) -> ()) {
        var presentArray = [Present]()
        REF_USERS.child(uid).child("presents").observeSingleEvent(of: .value) { (presentSnapshot) in
            guard let presentSnapshot = presentSnapshot.children.allObjects as? [DataSnapshot] else { return }
            // print(presentSnapshot)
            
            presentSnapshot.forEach(
                { (dataSnap) in
                    
                    let present_name = dataSnap.childSnapshot(forPath: "present_name").value as? String
                    let descript = dataSnap.childSnapshot(forPath: "description").value as? String
                    let price = dataSnap.childSnapshot(forPath: "price").value as? String
                    let image_name = dataSnap.childSnapshot(forPath: "image").value as? String
                    let uuid = dataSnap.childSnapshot(forPath: "uuid").value as? String
                    
                    let present = Present(name: present_name!, price: price!, details: descript!, imageName: image_name!, uuid: uuid ?? "")
                    //print(present)
                    presentArray.append(present)
            } )
            
            handler(presentArray)
        }
    }
    
    func removePresent(uid: String, uuid: String, deleted: @escaping(_ success: Bool) -> ()) {
        let ref = REF_USERS.child(uid).child("presents").child(uuid)
        ref.removeValue { (error, _) in
            if let error = error {
                print(error)
                deleted(false)
            } else {
                deleted(true)
            }
        }
    }
    
    func getName(forSearchQuery query: String, handler: @escaping(_ nameArray: [User]) -> ()) {
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
                    userArray.append(returned_user)
                }
            }
            handler(userArray)
        }
    }
    
}
