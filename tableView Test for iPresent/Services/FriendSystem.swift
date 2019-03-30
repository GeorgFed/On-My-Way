//
//  DataController.swift
//  FirebaseFriendRequest
//
//  Created by Kiran Kunigiri on 7/10/16.
//  Copyright © 2016 Kiran. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class FriendSystem {
    
    static let instance = FriendSystem()
    
    // MARK: - Firebase references
    /** The base Firebase reference */
    let BASE_REF = Database.database().reference()
    /* The user Firebase reference */
    let USER_REF = Database.database().reference().child(UserKeys.path)
    
    /** The Firebase reference to the current user tree */
    var CURRENT_USER_REF: DatabaseReference {
        let id = Auth.auth().currentUser!.uid
        return USER_REF.child("\(id)")
    }
    
    /** The Firebase reference to the current user's friend tree */
    var CURRENT_USER_FRIENDS_REF: DatabaseReference {
        return CURRENT_USER_REF.child("friends")
    }
    
    /** The Firebase reference to the current user's friend request tree */
    var CURRENT_USER_REQUESTS_REF: DatabaseReference {
        return CURRENT_USER_REF.child(FriendKeys.requests)
    }
    
    /** The current user's id */
    var CURRENT_USER_ID: String {
        let id = Auth.auth().currentUser!.uid
        return id
    }
    
    // MARK: - Search Implementation
    func findUsers(forSearchQuery query: String, handler: @escaping(_ nameArray: [User]) -> ()) {
        var userArray = [User]()
        USER_REF.queryOrdered(byChild: UserKeys.name).queryStarting(atValue: query).queryEnding(atValue: query + "\u{f8ff}").observeSingleEvent(of: .value) { (snapshot) in
            guard let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            for snap in userSnapshot {
                let value = snap.value as? NSDictionary
                let uid = value?[UserKeys.userId] as? String ?? ""
                let fullName = value?[UserKeys.name] as? String ?? ""
                let birthdate = value?[UserKeys.birthdate] as? String ?? ""
                let profileImgURL = value?[UserKeys.profileImg] as? String ?? ""
                let user = User(name: fullName, birthdate: birthdate, uid: uid, profileImgURL: profileImgURL)
                // print("\(fullName) -- \(self.CURRENT_USER_ID)")
                if uid != self.CURRENT_USER_ID {
                    userArray.append(user)
                }
            }
            handler(userArray)
        }
    }
    
    func findUsers(byPhoneNumber phone: String, handler: @escaping(_ nameArray: [User]) -> ()) {
        var userArray = [User]()
        USER_REF.queryOrdered(byChild: UserKeys.phoneNumber).queryEqual(toValue: phone).observeSingleEvent(of: .value) { (snapshot) in
            guard let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            for snap in userSnapshot {
                let value = snap.value as? NSDictionary
                let uid = value?[UserKeys.userId] as? String ?? ""
                let fullName = value?[UserKeys.name] as? String ?? ""
                let birthdate = value?[UserKeys.birthdate] as? String ?? ""
                let profileImgURL = value?[UserKeys.profileImg] as? String ?? ""
                let user = User(name: fullName, birthdate: birthdate, uid: uid, profileImgURL: profileImgURL)
                // print("\(fullName) -- \(self.CURRENT_USER_ID)")
                if uid != self.CURRENT_USER_ID {
                    userArray.append(user)
                }
            }
            handler(userArray)
        }
    }
    
    // MARK: - Get User
    
    func getCurrentUser(_ handler: @escaping (User) -> Void) {
        CURRENT_USER_REF.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let fullName = value?[UserKeys.name] as? String ?? ""
            let birthdate = value?[UserKeys.birthdate] as? String ?? ""
            let uid = value?[UserKeys.userId] as? String ?? ""
            let profileImgURL = value?[UserKeys.profileImg] as? String ?? ""
            let user = User(name: fullName, birthdate: birthdate, uid: uid, profileImgURL: profileImgURL)
            handler(user)
        })
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
    
    // MARK: - Request System Functions
    
    /** Sends a friend request to the user with the specified id */
    func sendRequestToUser(_ userID: String) {
        USER_REF.child(userID).child(FriendKeys.requests).child(CURRENT_USER_ID).setValue(true)
    }
    
    /** Unfriends the user with the specified id */
    func removeFriend(_ userID: String) {
        CURRENT_USER_REF.child(FriendKeys.path).child(userID).removeValue()
        USER_REF.child(userID).child(FriendKeys.path).child(CURRENT_USER_ID).removeValue()
    }
    
    /** Accepts a friend request from the user with the specified id */
    func acceptFriendRequest(_ userID: String) {
        CURRENT_USER_REF.child(FriendKeys.requests).child(userID).removeValue()
        CURRENT_USER_REF.child(FriendKeys.path).child(userID).setValue(true)
        USER_REF.child(userID).child(FriendKeys.path).child(CURRENT_USER_ID).setValue(true)
        USER_REF.child(userID).child(FriendKeys.requests).child(CURRENT_USER_ID).removeValue()
    }
    
    
    
    // MARK: - All users
    /** The list of all users */
    var userList = [User]()
    /** Adds a user observer. The completion function will run every time this list changes, allowing you  
     to update your UI. */
    func addUserObserver(_ update: @escaping () -> Void) {
        FriendSystem.instance.USER_REF.observe(DataEventType.value, with: { (snapshot) in
            self.userList.removeAll()
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                let value = snap.value as? NSDictionary
                let uid = value?[UserKeys.userId] as? String ?? ""
                if uid != self.CURRENT_USER_ID {
                    let fullName = value?[UserKeys.name] as? String ?? ""
                    let birthdate = value?[UserKeys.birthdate] as? String ?? ""
                    let profileImgURL = value?[UserKeys.profileImg] as? String ?? ""
                    let user = User(name: fullName, birthdate: birthdate, uid: uid, profileImgURL: profileImgURL)
                    print("user \(fullName) with uid \(uid) appended to userList")
                    print(user.name)
                    self.userList.append(user)
                }
            }
            update()
        })
    }
    /** Removes the user observer. This should be done when leaving the view that uses the observer. */
    func removeUserObserver() {
        USER_REF.removeAllObservers()
    }
    
    
    
    // MARK: - All friends
    /** The list of all friends of the current user. */
    var friendList = [User]()
    /** Adds a friend observer. The completion function will run every time this list changes, allowing you
     to update your UI. */
    func addFriendObserver(_ update: @escaping () -> Void) {
        CURRENT_USER_FRIENDS_REF.observe(DataEventType.value, with: { (snapshot) in
            print(snapshot)
            self.friendList.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let id = child.key
                print(id)
                self.getUser(id, handler: { (user) in
                    self.friendList.append(user)
                    update()
                })
            }
            // If there are no children, run completion here instead
            if snapshot.childrenCount == 0 {
                update()
            }
        })
    }
    /** Removes the friend observer. This should be done when leaving the view that uses the observer. */
    func removeFriendObserver() {
        CURRENT_USER_FRIENDS_REF.removeAllObservers()
    }
    
    
    
    // MARK: - All requests
    /** The list of all friend requests the current user has. */
    var requestList = [User]()
    /** Adds a friend request observer. The completion function will run every time this list changes, allowing you
     to update your UI. */
    func addRequestObserver(_ update: @escaping () -> Void) {
        CURRENT_USER_REQUESTS_REF.observe(DataEventType.value, with: { (snapshot) in
            self.requestList.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let id = child.key
                self.getUser(id, handler: { (user) in
                    self.requestList.append(user)
                    update()
                })
            }
            // If there are no children, run completion here instead
            if snapshot.childrenCount == 0 {
                update()
            }
        })
    }
    /** Removes the friend request observer. This should be done when leaving the view that uses the observer. */
    func removeRequestObserver() {
        CURRENT_USER_REQUESTS_REF.removeAllObservers()
    }
    
}



