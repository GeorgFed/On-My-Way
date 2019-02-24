//
//  StringExtensions.swift
//  tableView Test for iPresent
//
//  Created by Georg on 08/12/2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit

extension String {
    public var isAlphanumeric: Bool {
        guard !isEmpty else {
            return false
        }
        let allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
        let characterSet = CharacterSet(charactersIn: allowed)
        guard rangeOfCharacter(from: characterSet.inverted) == nil else {
            return false
        }
        return true
    }
}
