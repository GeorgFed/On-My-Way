//
//  File.swift
//  tableView Test for iPresent
//
//  Created by Georg on 21/02/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import Foundation

struct UserKeys {
    static let path = "users"
    static let provider = "provider"
    static let phoneNumber = "phoneNumber"
    static let userId = "userId"
    static let name = "name"
    static let birthdate = "birthdate"
    static let profileImg = "profileImgURL"
}

struct URLs {
    static let defaultProfileImg = "https://firebasestorage.googleapis.com/v0/b/ipresent-upd.appspot.com/o/profile_images.jpeg%2Faa6adde0-4d48-454d-9bd9-a66a16559009.jpeg?alt=media&token=18b230be-e847-4c0b-b797-2025744e6909"
}

struct MediaType {
    static let img = "profile_images.jpeg"
}

struct PresentKeys {
    static let path = "presents"
    static let presentName = "present_name"
    static let description = "description"
    static let price = "price"
    static let image = "image"
    static let senderId = "senderId"
    static let uuid = "uuid"
    static let link = "link"
}

struct FriendKeys {
    static let path = "friends"
    static let requests = "requests"
    static let friendUid = "fuid"
}

struct EventKeys {
    static let path = "events"
    static let eventTitle = "event_title"
    static let description = "description"
    static let date = "date"
    static let uuid = "uuid"
    static let senderId = "senderId"
}

struct Notifications {
    static let newUser = "NewUser"
    static let userExists = "UserExists"
    static let presentAdded = "PresentAdded"
    static let presentDeleted = "PresentDeleted"
    static let eventAdded = "EventAdded"
    static let eventDeleted = "EventDeleted"
    static let firstEntry = "FirstEntry"
}

struct UserDefaultsKeys {
    static let authentificationId = "authVerificationID"
}

struct ConnectionKeys {
    static let wifi = "wifi"
    static let cellular = "cellular"
    static let unavailable = "unavailable"
    static let none = "none"
}
