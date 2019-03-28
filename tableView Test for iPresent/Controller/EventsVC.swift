//
//  EventsVC.swift
//  tableView Test for iPresent
//
//  Created by Georg on 17/03/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit
import Firebase
import Contacts
import ContactsUI
import PhoneNumberKit

class EventsVC: UIViewController {

    let uid = Auth.auth().currentUser?.uid
    let keys = [
        CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
        CNContactPhoneNumbersKey,
        CNContactEmailAddressesKey
        ] as [Any]
    
    var store = CNContactStore()
    var contacts = [CNContact]()
    var phoneNumbers = [String]()
    var filteredNumbers = [String]()
    
    var friendsIDs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // findFriends()
        /*
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(findFriends),
                                               name: NSNotification.Name(Notifications.firstEntry),
                                               object: nil)
         */
    }
    
    /*
    func getFriends() {
        DataService.instance.getUserFriends(forUid: uid!) { ( returnedArray ) in
            self.friendsIDs = returnedArray
        }
    }
    
    func difference(between first: [String], and second: [String]) -> [String] {
        let thisSet = Set(first)
        let otherSet = Set(second)
        return Array(thisSet.symmetricDifference(otherSet))
    }
    
    @objc func findFriends() {
        print("MARK 1")
        guard uid != nil else { return }
        getFriends()
        ContactsService.instance.getPhoneNumbers(on: self) { (query, success) in
            if success {
                DataService.instance.getUsersByPhoneNumber(phoneNumbers: query) { (returnedUIDs) in
                    print("MARK 2")
                    let uids = self.difference(between: returnedUIDs, and: self.friendsIDs)
                    print(uids)
                    if uids.isEmpty { return }
                    DataService.instance.addUserFriend(forUid: self.uid!, friendsUids: uids, success: { (success) in
                        if (!success) {
                            print("unable to upload friends")
                            return
                        }
                        print("MARK 3")
                        return
                    })
                }
            } else {
                print("error with downloading contacts")
            }
        }
        
    }
    */
    
    
}
