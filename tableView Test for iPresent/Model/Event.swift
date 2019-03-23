//
//  Event.swift
//  Feature Test for iPresent
//
//  Created by Georg on 20/12/2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit

class Event {
    var _user: [User]
    var _title: String
    var _description: String
    var _date: String
    var _collection: [Present]

    var user: [User] {
        return _user
    }
    
    var title: String {
        return _title
    }
    
    var description: String {
        return _description
    }
    
    var date: String {
        return _date
    }
    
    var collection: [Present] {
        return _collection
    }
    
    
    init(user: [User], title: String, description: String, date: String, collection: [Present]) {
        self._user = user
        self._title = title
        self._description = description
        self._date = date
        self._collection = collection
    }
}
