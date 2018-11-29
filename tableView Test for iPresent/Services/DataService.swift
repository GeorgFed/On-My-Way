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
import FirebaseAuth

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_PRESENTS = DB_BASE.child("users").child("presents")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_PRESENTS: DatabaseReference {
        return _REF_PRESENTS
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func updateDBUser(withUid uid: String, firstName: String, lastName: String, birthdate: String, updateComplete: @escaping (_ status: Bool) -> ()) {
        let fullName = firstName + " " + lastName
        REF_USERS.child(uid).updateChildValues(["userId": uid, "name": fullName, "birthdate": birthdate])
        updateComplete(true)
    }
    
    func getUserInfo(forUid uid: String, handler: @escaping (_ user: User) -> ())  {
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { ( snapshot ) in
            let value = snapshot.value as? NSDictionary
            let fullName = value?["name"] as? String ?? ""
            let birthdate = value?["birthdate"] as? String ?? ""
            var user: User
            user = User(name: fullName, birthdate: birthdate)
            handler(user)
        }
        
    }
    
    func uploadPresent(name: String, description: String, price: String, image: String, senderid: String, sendComplete: @escaping(_ status: Bool) -> ()) {
        REF_USERS.child(senderid).child("presents").childByAutoId().updateChildValues(["present_name":name, "description": description, "price": price, "image": image, "senderId": senderid])
        sendComplete(true)
    }
    
    func getPresents(forUid uid: String, handler: @escaping (_ presents: [Present]) -> ()) {
        var presentArray = [Present]()
        REF_USERS.child(uid).child("presents").observeSingleEvent(of: .value) { (presentSnapshot) in
            guard let presentSnapshot = presentSnapshot.children.allObjects as? [DataSnapshot] else { return }
            print(presentSnapshot)
            
            presentSnapshot.forEach(
                { (dataSnap) in
                    
                    let present_name = dataSnap.childSnapshot(forPath: "present_name").value as? String
                    let descript = dataSnap.childSnapshot(forPath: "description").value as? String
                    let price = dataSnap.childSnapshot(forPath: "price").value as? String
                    let image_name = dataSnap.childSnapshot(forPath: "image").value as? String
                    
                    let present = Present(name: present_name!, price: price!, details: descript!, imageName: image_name!)
                    print(present)
                    presentArray.append(present)
            } )
            
            handler(presentArray)
        }
    }
    
    func getName(forSearchQuery query: String, handler: @escaping(_ nameArray: [User]) -> ()) {
        var userArray = [User]()
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                guard let name = user.childSnapshot(forPath: "name").value as? String else { continue }
                guard let birthdate = user.childSnapshot(forPath: "birthdate").value as? String else { continue }
                
                if query.isAlphanumeric {
                    if name.contains(query) && name != Auth.auth().currentUser?.displayName {
                        let returned_user = User(name: name, birthdate: birthdate)
                        userArray.append(returned_user)
                    }
                }
            }
            handler(userArray)
        }
    }
    
}


extension String {
    public var isAlphanumeric: Bool {
        guard !isEmpty else {
            return false
        }
        let allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
        let characterSet = CharacterSet(charactersIn: allowed)
        guard rangeOfCharacter(from: characterSet.inverted) == nil else {
            return false
        }
        return true
    }
}
