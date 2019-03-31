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

    @IBOutlet weak var tableView: UITableView!
    
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
    var events = [Event]()
    var friendForEvent = [Event : User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // findFriends()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(findFriends),
                                               name: NSNotification.Name(Notifications.firstEntry),
                                               object: nil)
        getFriends()
    }
    
    func getFriends() {
        FriendSystem.instance.addFriendObserver {
            self.getEvents()
            self.tableView.reloadData()
        }
    }
    
    func getEvents() {
        for friend in FriendSystem.instance.friendList {
            DataService.instance.getEvents(forUid: friend.uid) { ( returnedEvents ) in
                self.events.append(contentsOf: returnedEvents)
                for event in returnedEvents {
                    self.friendForEvent[event] = friend
                }
            }
        }
    }
    
    @objc func findFriends() {
        guard uid != nil else { return }
        ContactsService.instance.getPhoneNumbers(on: self) { (query, succes) in
            self.phoneNumberSearch(query: query)
        }
    }
    
    func phoneNumberSearch(query: [String]) {
        for number in query {
            FriendSystem.instance.findUsers(byPhoneNumber: number) { ( returnedUsers ) in
                for user in returnedUsers {
                    let fuid = user.uid
                    FriendSystem.instance.sendRequestToUser(fuid)
                }
            }
        }
    }
}

extension EventsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: EventHeaderCell! = tableView.dequeueReusableCell(withIdentifier: "EventHeaderCell") as? EventHeaderCell
            cell.configureCell(date: events[indexPath.section].date, fname: friendForEvent[events[indexPath.section]]!.name, imgURL: friendForEvent[events[indexPath.section]]!.profileImgURL)
            return cell
        case 1:
            let cell: EventTitleCell! = tableView.dequeueReusableCell(withIdentifier: "EventTitleCell") as? EventTitleCell
            cell.configureCell(title: events[indexPath.section].title)
            return cell
        default:
            let cell: PresentCollectionCell! = tableView.dequeueReusableCell(withIdentifier: "PresentCollectionCell") as? PresentCollectionCell
            return cell
        }
        
    }
}
