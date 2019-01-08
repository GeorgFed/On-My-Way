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
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: verificationCode)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            guard let user = authResult?.user else {
                userCreationComplete(false, error)
                return
            }
            print(user)
            var query = [String]()
            query.append(user.phoneNumber!)
            
            DataService.instance.getUsersByPhoneNumber(phoneNumbers: query) { (returnedUsers) in
                print(returnedUsers.count)
                if returnedUsers.count == 0 {
                    
                    NotificationCenter.default.post(name: Notification.Name("NewUser"), object: nil)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("UserExists"), object: nil)
                }
            }
            
            let userData = ["provider" : user.providerID, "phoneNumber" : user.phoneNumber]
            DataService.instance.createDBUser(uid: user.uid, userData: userData)
            userCreationComplete(true, nil)
        }
    }
}
