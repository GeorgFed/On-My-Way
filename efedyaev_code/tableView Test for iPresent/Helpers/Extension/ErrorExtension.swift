//
//  ErrorExtension.swift
//  tableView Test for iPresent
//
//  Created by Georg on 28/08/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import Foundation

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
