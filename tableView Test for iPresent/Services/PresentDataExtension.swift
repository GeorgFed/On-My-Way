//
//  PresentDataExtension.swift
//  tableView Test for iPresent
//
//  Created by Georg on 21/02/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

extension DataService {
    func uploadPresent(name: String, description: String, price: String, image: String, senderid: String, link: String, sendComplete: @escaping(_ status: Bool) -> ()) {
        let ref = REF_USERS.child(senderid).child(PresentKeys.path).childByAutoId()
        guard let key = ref.key else { return }
        ref.updateChildValues([PresentKeys.presentName:name,
                               PresentKeys.description: description,
                               PresentKeys.price: price,
                               PresentKeys.image: image,
                               PresentKeys.senderId: senderid,
                               PresentKeys.uuid: key,
                               PresentKeys.link: link])
        sendComplete(true)
    }
    
    func getPresents(forUid uid: String, handler: @escaping (_ presents: [Present]) -> ()) {
        let ref = REF_USERS.child(uid).child(PresentKeys.path)
        var presentArray = [Present]()
        ref.observeSingleEvent(of: .value) { (presentSnapshot) in
            guard let presentSnapshot = presentSnapshot.children.allObjects as? [DataSnapshot] else { return }
            presentSnapshot.forEach(
                { (dataSnap) in
                    let present_name = dataSnap.childSnapshot(forPath: PresentKeys.presentName).value as? String
                    let descript = dataSnap.childSnapshot(forPath: PresentKeys.description).value as? String
                    let price = dataSnap.childSnapshot(forPath: PresentKeys.price).value as? String
                    let image_name = dataSnap.childSnapshot(forPath: PresentKeys.image).value as? String
                    let uuid = dataSnap.childSnapshot(forPath: PresentKeys.uuid).value as? String
                    let link = dataSnap.childSnapshot(forPath: PresentKeys.link).value as? String
                    let present = Present(name: present_name!, price: price!, details: descript!, imageName: image_name!, uuid: uuid ?? "", link: link ?? "")
                    presentArray.append(present)
            } )
            handler(presentArray)
        }
    }
    
    func removePresent(uid: String, uuid: String, deleted: @escaping(_ success: Bool) -> ()) {
        let ref = REF_USERS.child(uid).child(PresentKeys.path).child(uuid)
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
