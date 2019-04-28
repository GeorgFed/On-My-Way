//
//  ArrayExtension.swift
//  tableView Test for iPresent
//
//  Created by Georg on 28/04/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import Foundation

extension Array {
    
    func mapToSet<T: Hashable>(_ transform: (Element) -> T) -> Set<T> {
        var result = Set<T>()
        for item in self {
            result.insert(transform(item))
        }
        return result
    }
    
}
