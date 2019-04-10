//
//  EventDataExtension.swift
//  tableView Test for iPresent
//
//  Created by Georg on 23/03/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

extension DataService {
    func uploadEvent(uid: String, title: String, description: String, date: String, success: @escaping(_ status: Bool) -> ()) {
        let ref = REF_USERS.child(uid).child(EventKeys.path).childByAutoId()
        guard let key = ref.key else { return }
        ref.updateChildValues([EventKeys.eventTitle: title,
                               EventKeys.description: description,
                               EventKeys.date: date,
                               EventKeys.uuid: key,
                               EventKeys.senderId: uid])
        success(true)
    }
    
    func getEvents(forUid uid: String,
                   handler: @escaping (_ events: [Event]) -> ()) {
        let ref = REF_USERS.child(uid).child(EventKeys.path)
        var eventArray = [Event]()
        ref.observeSingleEvent(of: .value) { (eventSnapshot) in
            guard let eventSnapshot = eventSnapshot.children.allObjects as? [DataSnapshot] else { return }
            print(eventSnapshot)
            eventSnapshot.forEach({ ( dataSnap ) in
                let title = dataSnap.childSnapshot(forPath: EventKeys.eventTitle).value as? String
                let description = dataSnap.childSnapshot(forPath: EventKeys.description).value as? String
                let date = dataSnap.childSnapshot(forPath: EventKeys.date).value as? String
                let uuid = dataSnap.childSnapshot(forPath: EventKeys.uuid).value as? String
                let event = Event(uuid: uuid!, title: title!, description: description ?? "", date: date!, senderId: uid)
                eventArray.append(event)
            })
            handler(eventArray)
        }
    }
    
    func removeEvents(uid: String, uuid: String, deleted: @escaping(_ success: Bool) -> ()) {
        let ref = REF_USERS.child(uid).child(EventKeys.path).child(uuid)
        ref.removeValue { (error, _) in
            if let error = error {
                print(error)
                deleted(false)
            } else {
                deleted(true)
            }
        }
    }
}
