//
//  FriendSystem.swift
//  tableView Test for iPresent
//
//  Created by Georg on 17/03/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class FriendSystem {
    
    static let instance = FriendSystem()
    
    // MARK: - Firebase references
    /* The base Firebase reference */
    let BASE_REF = Database.database().reference()
    /* The user Firebase reference */
    let USER_REF = Database.database().reference().child(UserKeys.path)
    
    // MARK: - Search Implementation
    func findUsers(_ currentUserID: String, forSearchQuery query: String, handler: @escaping(_ nameArray: [User]) -> ()) {
        var userArray = [User]()
        if query == "" { return }
        USER_REF.queryOrdered(byChild: UserKeys.name).queryStarting(atValue: query).queryEnding(atValue: query + "\u{f8ff}").observeSingleEvent(of: .value) { (snapshot) in
            guard let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            for snap in userSnapshot {
                let value = snap.value as? NSDictionary
                let uid = value?[UserKeys.userId] as? String ?? ""
                let fullName = value?[UserKeys.name] as? String ?? ""
                let birthdate = value?[UserKeys.birthdate] as? String ?? ""
                let profileImgURL = value?[UserKeys.profileImg] as? String ?? ""
                let user = User(name: fullName, birthdate: birthdate, uid: uid, profileImgURL: profileImgURL)
                if uid != currentUserID {
                    userArray.append(user)
                }
            }
            handler(userArray)
        }
    }
    
    func findUsers(_ currentUserID: String, byPhoneNumber phone: String, handler: @escaping(_ nameArray: [User]) -> ()) {
        var userArray = [User]()
        USER_REF.queryOrdered(byChild: UserKeys.phoneNumber).queryEqual(toValue: phone).observeSingleEvent(of: .value) { (snapshot) in
            guard let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
    
            if userSnapshot.count > 0 {
                print(userSnapshot)
            }
            for snap in userSnapshot {
                let value = snap.value as? NSDictionary
                let uid = value?[UserKeys.userId] as? String ?? ""
                let fullName = value?[UserKeys.name] as? String ?? ""
                let birthdate = value?[UserKeys.birthdate] as? String ?? ""
                let profileImgURL = value?[UserKeys.profileImg] as? String ?? ""
                let user = User(name: fullName, birthdate: birthdate, uid: uid, profileImgURL: profileImgURL)
                // print("\(fullName) -- \(self.CURRENT_USER_ID)")
                if uid != currentUserID {
                    userArray.append(user)
                }
            }
            handler(userArray)
        }
    }
    
    func getUser(_ userID: String, handler: @escaping (User) -> Void) {
        USER_REF.child(userID).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let fullName = value?[UserKeys.name] as? String ?? ""
            let birthdate = value?[UserKeys.birthdate] as? String ?? ""
            let uid = value?[UserKeys.userId] as? String ?? ""
            let profileImgURL = value?[UserKeys.profileImg] as? String ?? ""
            let user = User(name: fullName, birthdate: birthdate, uid: uid, profileImgURL: profileImgURL)
             handler(user)
        })
    }

    
    func followUser(_ currentUserID: String!, _ userID: String!) {
        let currentUserRef = USER_REF.child(currentUserID)
        currentUserRef.child("following").child(userID).setValue(true)
        USER_REF.child(userID).child("followers").child(currentUserID).setValue(true)
    }
    
    func unfollowUser(_ currentUserID: String!, _ userID: String!) {
        let currentUserRef = USER_REF.child(currentUserID)
        currentUserRef.child("following").child(userID).removeValue()
        USER_REF.child(userID).child("followers").child(currentUserID).removeValue()
    }
    
    //var followsList = [User]()
    var followsList = Set<User>()
    func addFollowsObserver(_ currentUserID: String?, _ update: @escaping () -> Void) {
        guard currentUserID != nil else { return }
        let currentUserFollowsRef = USER_REF.child(currentUserID!).child("following")
        currentUserFollowsRef.observe(DataEventType.value, with: { (snapshot) in
            self.followsList.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let id = child.key
                self.getUser(id, handler: { (user) in
                    self.followsList.insert(user)
                    update()
                })
            }
            if snapshot.childrenCount == 0 {
                update()
            }
        })
    }
    
    func removeFollowsObserver(_ currentUserID: String!) {
        let currentUserFollowsRef = USER_REF.child(currentUserID).child("following")
        currentUserFollowsRef.removeAllObservers()
    }
}

// TODO: clear the unused functions, clean up required functions
// TODO: use multithreading correctly

