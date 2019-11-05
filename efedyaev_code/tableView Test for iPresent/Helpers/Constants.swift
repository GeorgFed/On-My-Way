//
//  File.swift
//  tableView Test for iPresent
//
//  Created by Georg on 21/02/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

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

struct CurrencyKeys {
    static let dollar = "$"
    static let pound = "£"
    static let mxn = "MXN "
    static let euro = "€"
    static let ruble = "₽"
    static let franc = "CHR "
}

struct ColorKeys {
    static let blue = #colorLiteral(red: 0.4509803922, green: 0.6549019608, blue: 0.8588235294, alpha: 1)
    static let red = #colorLiteral(red: 0.8823529412, green: 0.2901960784, blue: 0.5647058824, alpha: 1)
    static let orange = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.2745098039, alpha: 1)
}

struct ProfileImageKeys {
    static let blueFill = #imageLiteral(resourceName: "DefaultBlueFilled")
    static let redFill = #imageLiteral(resourceName: "DefaultPinkFilled")
    static let orangeFill = #imageLiteral(resourceName: "DefaultOrangeFilled")
    static let blue = #imageLiteral(resourceName: "DefaultBlueUnfilled")
    static let red = #imageLiteral(resourceName: "DefaultPinkUnfilled")
    static let orange = #imageLiteral(resourceName: "DefaultOrangeUnfilled")
}

struct PresentImageKeys {
    static let blue = #imageLiteral(resourceName: "BluePresent")
    static let red = #imageLiteral(resourceName: "RedPresent")
    static let yellow = #imageLiteral(resourceName: "YellowPresent")
}

struct Restrictions {
    static let nameLength = 18
    static let eventNameLength = 28
    static let presentNameLength = 40
    static let presentDetailsLength = 60
}
