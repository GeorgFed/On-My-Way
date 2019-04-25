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
    var chosen_user: User?
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(findFriends),
                                               name: NSNotification.Name(Notifications.firstEntry),
                                               object: nil)
         getFriends()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // findFriends()
        tableView.delegate = self
        tableView.dataSource = self
//        FriendSystem.instance.addFriendObserver {
//            print("observer updated")
//            self.getEvents()
//        }
        FriendSystem.instance.addFollowsObserver {
            self.getEvents()
        }
    }
    
    func getFriends() {
//        FriendSystem.instance.addFriendObserver { }
        FriendSystem.instance.addFollowsObserver { }
        print("observer added")
    }
    
    func getEvents() {
        print("MY dear dear friends \(FriendSystem.instance.friendList)")
        for friend in FriendSystem.instance.friendList {
            print("this is my friend ", friend.name)
            DataService.instance.getEvents(forUid: friend.uid) { ( returnedEvents ) in
                print("uid for friend - \(friend.uid)")
                print(returnedEvents)
                self.events.append(contentsOf: returnedEvents)
                print(self.events)
                for event in returnedEvents {
                    self.friendForEvent[event] = friend
                    print("event\(event) -> friend \(friend)")
                }
                self.tableView.reloadData()
            }
        }
        print("sooo", events)
        self.tableView.reloadData()
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
            cell.configureCollectionCell(f: friendForEvent[events[indexPath.section]]!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 64.0
        case 1:
            return 44.0
        default:
            return 340.0
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row > 0 {
            return nil
        }
        return indexPath
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight: CGFloat
        headerHeight = CGFloat.leastNonzeroMagnitude
        return headerHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let footerHeight: CGFloat
        footerHeight = 8.0
        return footerHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            // user_segue
            self.chosen_user = friendForEvent[events[indexPath.section]]!
            // self.performSegue(withIdentifier: "user_segue", sender: self)
            // segueForUser
            self.performSegue(withIdentifier: "segueForUser", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard chosen_user != nil else { return }
//        let _userInfoVC = segue.destination as! UserInfoVC
//        _userInfoVC.user = chosen_user
        let _UserVC = segue.destination as! UserVC
        _UserVC.user = chosen_user
    }
}
