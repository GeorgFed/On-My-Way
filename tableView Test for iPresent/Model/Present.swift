//
//  Present.swift
//  tableView Test for iPresent
//
//  Created by Georg on 21.10.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import Foundation

class Present {
    private var _name: String
    private var _price: String
    private var _details: String
    private var _imageName: String
    
    var name: String {
        return _name
    }
    var price: String {
        return _price
    }
    var details: String {
        return _details
    }
    
    var imageName: String {
        return _imageName
    }
    
    init(name: String, price: String, details: String, imageName: String) {
        self._name = name
        self._price = price
        self._details = details
        self._imageName = imageName
    }
}
