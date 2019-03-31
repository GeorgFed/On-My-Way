//
//  Event.swift
//  Feature Test for iPresent
//
//  Created by Georg on 20/12/2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit

class Event: Hashable {
    private var _uuid: String
    private var _senderId: String
    private var _title: String
    private var _description: String
    private var _date: String

    var hashValue: Int {
        return uuid.hashValue
    }
    
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
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
