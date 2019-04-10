//
//  User.swift
//  tableView Test for iPresent
//
//  Created by Georg on 09.10.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import Foundation

class User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    private var _name: String
    private var _birthdate: String
    private var _uid: String
    private var _profileImgURL: String
    
    var name: String {
        return _name
    }
    
    var birthdate: String {
        return _birthdate
    }
    
    var uid: String {
        return _uid
    }
    
    var profileImgURL: String {
        return _profileImgURL
    }
    
    init(name: String, birthdate: String, uid: String, profileImgURL: String) {
        self._name = name
        self._birthdate = birthdate
        self._uid = uid
        self._profileImgURL = profileImgURL
    }
}

extension User {
    public enum userStatus {
        case friend
        case requested
        case sentRequest
        case neutral
    }
    
    public func getStatus(user: User, friendArray: [User], requestedUsers: [User], requestsFromUsers: [User]) -> userStatus {
        if friendArray.contains(user) {
            return .friend
        } else if requestedUsers.contains(user) {
            return .requested
        } else if requestsFromUsers.contains(user) {
            return .sentRequest
        } else {
            return .neutral
        }
    }
}
