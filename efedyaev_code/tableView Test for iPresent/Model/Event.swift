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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(_uuid)
    }
    
    var day: String {
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale.autoupdatingCurrent
        dayFormatter.dateFormat = "dd"
        let day = dayFormatter.string(from: convertedDate)
        return day
    }
    
    var month: String {
        let monthFormatter = DateFormatter()
        monthFormatter.locale = Locale.autoupdatingCurrent
        monthFormatter.dateFormat = "MMM"
        let month = monthFormatter.string(from: convertedDate)
        return month
    }
    
    var convertedDate: Date {
        /*
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        guard let date = dateFormatter.date(from: _date) else {
            print(_date)
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        */
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US")
        inputFormatter.dateFormat = "dd-MM-yyyy"
        guard let inputDate = inputFormatter.date(from: _date) else {
            print(_date)
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale.autoupdatingCurrent
        outputFormatter.dateFormat = "dd MMM yyyy"
        let outputDate = outputFormatter.string(from: inputDate)
        guard let date = outputFormatter.date(from: outputDate) else {
            print(outputDate)
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        
//        dateFormatter.locale = Locale.autoupdatingCurrent
//        dateFormatter.dateFormat = "dd MMM yyyy"
        print(date)
       /*
        
        guard let date = dateFormatter.date(from: _date) else {
            print(_date)
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
         */
        return date
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
