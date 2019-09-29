//
//  TestDataService.swift
//  tableView Test for iPresent
//
//  Created by Georg on 22.11.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import Foundation

let userDataBase = [
    User.init(name: "John Brown", birthdate: "12.02.03", uid: "123", profileImgURL: ""),
    User.init(name: "Eva White", birthdate: "15.01.98", uid: "123", profileImgURL: ""),
    User.init(name: "Steve Brown", birthdate: "29.05.81", uid: "123", profileImgURL: ""),
]

let presentDataBase = [
    Present.init(name: "iPhone 6", price: "900 $", details: "Space Gray", imageName: "backImg1", uuid: "1", link: ""),
    Present.init(name: "Macbook Pro", price: "1200 $", details: "Space Gray", imageName: "BackImg2", uuid: "1", link: ""),
    Present.init(name: "AirPods", price: "500 $", details: " - ", imageName: "BackImg2", uuid: "1", link: ""),
    Present.init(name: "Go Pro Hero 6", price: "500 $", details: "Black", imageName: "backImg1", uuid: "1", link: ""),
    Present.init(name: "Macbook Pro", price: "900 $", details: "Silver", imageName: "backImg1", uuid: "1", link: ""),
    Present.init(name: "AirPods", price: "500 $", details: " - ", imageName: "BackImg2", uuid: "1", link: ""),
    Present.init(name: "Macbook Pro", price: "900 $", details: "Silver", imageName: "BackImg2", uuid: "1", link: ""),
    Present.init(name: "AirPods", price: "500 $", details: " - ", imageName: "backImg1", uuid: "1", link: "")
]

class TestDataService {
    static let instance = TestDataService()
    
    func getName(forSearchQuery query: String, handler: @escaping(_ nameArray: [User]) -> ()) {
        var nameArray = [User]()
        
        for user in userDataBase {
            if user.name.contains(query) || query == "." {
                nameArray.append(user)
            }
        }
        handler(nameArray)
    }
    
    func getPresent(forUid uid: String, handler: @escaping(_ presentArray: [Present]) -> ()) {
        var presentArray = [Present]()
        
        for present in presentDataBase {
            presentArray.append(present)
        }
        handler(presentArray)
    }
}
