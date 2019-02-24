//
//  UserDataExtension.swift
//  tableView Test for iPresent
//
//  Created by Georg on 21/02/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

extension DataService {
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func updateDBUser(withUid uid: String, firstName: String, lastName: String, birthdate: String, updateComplete: @escaping (_ status: Bool) -> ()) {
        let fullName = firstName + " " + lastName
        self.REF_USERS.child(uid).updateChildValues([UserKeys.userId: uid,
                                                     UserKeys.name: fullName,
                                                     UserKeys.birthdate: birthdate,
                                                     UserKeys.profileImg:URLs.defaultProfileImg])
        updateComplete(true)
    }
    
    func getUserInfo(forUid uid: String, handler: @escaping (_ user: User) -> ())  {
        self.REF_USERS.child(uid).observeSingleEvent(of: .value) { ( snapshot ) in
            let value = snapshot.value as? NSDictionary
            let fullName = value?[UserKeys.name] as? String ?? ""
            let birthdate = value?[UserKeys.birthdate] as? String ?? ""
            let uid = value?[UserKeys.userId] as? String ?? ""
            let profileImgURL = value?[UserKeys.profileImg] as? String ?? ""
            let user = User(name: fullName, birthdate: birthdate, uid: uid, profileImgURL: profileImgURL)
            handler(user)
        }
    }
    
    func addUserImg(forUid uid: String, img: UIImage) {
        DataService.instance.uploadMedia(img: img, imgType: MediaType.img) { (url) in
            guard let url = url else { return }
            let ref = self.REF_USERS.child(uid)
            ref.updateChildValues([UserKeys.profileImg : url])
        }
    }
    
}
