//
//  PhoneAuthService.swift
//  iPresent prot. auth
//
//  Created by Georg on 30.10.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class PhoneAuthService {
    static let instance = PhoneAuthService()
    
    func regiserUser(verificationCode: String, userCreationComplete: @escaping(_ status: Bool, _ error: Error?) -> ()) {
        let verificationID = UserDefaults.standard.string(forKey: UserDefaultsKeys.authentificationId)
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: verificationCode)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            guard let user = authResult?.user else {
                userCreationComplete(false, error)
                return
            }
            var query = [String]()
            query.append(user.phoneNumber!)
            DataService.instance.getUsersByPhoneNumber(phoneNumbers: query) { (returnedUsers) in
                if returnedUsers.count == 0 {
                    print("found user wtf\n")
                    NotificationCenter.default.post(name: Notification.Name(Notifications.newUser), object: nil)
                } else {
                    NotificationCenter.default.post(name: Notification.Name(Notifications.userExists), object: nil)
                }
            }
            let userData = [UserKeys.provider : user.providerID, UserKeys.phoneNumber : user.phoneNumber]
            DataService.instance.createDBUser(uid: user.uid, userData: userData as Dictionary<String, Any>)
            userCreationComplete(true, nil)
        }
    }
}
