//
//  FriendsDataExtension.swift
//  tableView Test for iPresent
//
//  Created by Georg on 23/03/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

extension DataService {
    
    func addUserFriend(forUid uid: String, friendsUids fuids: [String], success: @escaping(_ status: Bool) -> ()) {
        let ref = self.REF_USERS.child(uid).child(FriendKeys.path).childByAutoId()
        for fuid in fuids {
            ref.updateChildValues([FriendKeys.friendUid : fuid])
        }
        success(true)
    }
    
    func getUserFriends(forUid uid: String, handler: @escaping (_ presents: [String]) -> ()) {
        let ref = self.REF_USERS.child(uid).child(FriendKeys.path)
        var fuidArray = [String]()
        ref.observe(.value) { (friendSnapshot) in
            guard let friendSnapshot = friendSnapshot.children.allObjects as? [DataSnapshot] else { return }
            friendSnapshot.forEach({ (dataSnap) in
                let fuid = dataSnap.childSnapshot(forPath: FriendKeys.friendUid).value as? String
                fuidArray.append(fuid!)
            })
        }
        handler(fuidArray)
    }
}
