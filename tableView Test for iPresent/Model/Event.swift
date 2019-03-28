//
//  Event.swift
//  Feature Test for iPresent
//
//  Created by Georg on 20/12/2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit

class Event {
    var _uuid: String
    var _senderId: String
    var _title: String
    var _description: String
    var _date: String

    var senderId: String {
        return _senderId
    }
    
    var uuid: String {
        return _uuid
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
    
    init(uuid: String, title: String, description: String, date: String, senderId: String) {
        self._uuid = uuid
        self._title = title
        self._description = description
        self._date = date
        self._senderId = senderId
    }
}
