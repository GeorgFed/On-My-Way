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
    
    var name: String {
        return _name
    }
    
    var birthdate: String {
        return _birthdate
    }
    
    init(name: String, birthdate: String) {
        self._name = name
        self._birthdate = birthdate
    }
}
