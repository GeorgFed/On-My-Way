//
//  DeleteService.swift
//  tableView Test for iPresent
//
//  Created by Georg on 27/08/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import Foundation

extension DataService {
    func deleteUser(uid: String) {
        self.REF_USERS.child(uid).updateChildValues([UserKeys.name: "Deleted User".localized,
                                                     UserKeys.birthdate: "Deleted",
                                                     UserKeys.phoneNumber: "-1",
                                                     UserKeys.profileImg:URLs.defaultProfileImg])
        
        let refE = REF_USERS.child(uid).child(EventKeys.path)
        refE.removeValue { (error, _) in
            if let error = error {
                print(error)
            } else {
                print("success")
            }
        }
        
        let refP = REF_USERS.child(uid).child(PresentKeys.path)
        refP.removeValue { (error, _) in
            if let error = error {
                print(error)
            } else {
                print("success")
            }
        }
        
        let refFollowing = REF_USERS.child(uid).child("following")
        refFollowing.removeValue { (error, _) in
            if let error = error {
                print(error)
            } else {
                print("success")
            }
        }
        
        let refFollowers = REF_USERS.child(uid).child("followers")
        refFollowers.removeValue { (error, _) in
            if let error = error {
                print(error)
            } else {
                print("success")
            }
        }
    }
}
