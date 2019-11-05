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
            print("should sign in")
            guard let user = authResult?.user else {
                userCreationComplete(false, error)
                return
            }
            
            guard let phoneNumber = user.phoneNumber else { return }
            print(phoneNumber)
            DataService.instance.checkPhoneNumber(phoneNumber: phoneNumber, handler: { (exists) in
                if exists {
                    print("exists!!!!!!")
                    NotificationCenter.default.post(name: Notification.Name(Notifications.userExists), object: nil)
                } else {
                    print("This is a new user!!!!")
                     NotificationCenter.default.post(name: Notification.Name(Notifications.newUser), object: nil)
                }
            })
            let userData = [UserKeys.provider : user.providerID, UserKeys.phoneNumber : user.phoneNumber]
            print("should go to create user")
            DataService.instance.createDBUser(uid: user.uid, userData: userData as Dictionary<String, Any>)
            userCreationComplete(true, nil)
        }
    }
}
