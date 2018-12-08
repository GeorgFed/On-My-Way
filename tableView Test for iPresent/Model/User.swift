//
//  User.swift
//  tableView Test for iPresent
//
//  Created by Georg on 09.10.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import Foundation

class User {
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
