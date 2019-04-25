//
//  UserVC.swift
//  tableView Test for iPresent
//
//  Created by Georg on 16/04/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

class UserVC: UITableViewController {

    var user: User?
    var status: userStatus?
    var following: Bool!
    var presentArray = [Present]()
    var requestArray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FriendSystem.instance.followsList.contains(user!) {
            following = true
        } else {
            following = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        getPresents()
        getFollowing()
    }
    
    func getPresents() {
        DataService.instance.getPresents(forUid: user?.uid ?? "") { ( returnedArray ) in
            self.presentArray = returnedArray
            self.tableView.reloadData()
        }
    }
    
    func getFollowing() {
        FriendSystem.instance.addFollowsObserver {
            self.tableView.reloadData()
        }
        FriendSystem.instance.addFollowsObserver {
            if FriendSystem.instance.followsList.contains(self.user!) {
                self.following = true
            } else {
                self.following = false
            }
        }
        
        if FriendSystem.instance.followsList.contains(user!) {
            following = true
        } else {
            following = false
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell: UserNameCell! = tableView.dequeueReusableCell(withIdentifier: "userNameCell", for: indexPath) as? UserNameCell
            cell.configure(name: user!.name, uStatus: following ? "You are following this user".localized:"You are not following this user".localized, imageUrl: user!.profileImgURL)
            return cell
        case 1:
            let cell: UserPresentsCollection! = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as? UserPresentsCollection
            cell.configure(presents: presentArray)
            return cell
        default:
            let cell: UserActionButtonCell! = tableView.dequeueReusableCell(withIdentifier: "actionButton", for: indexPath) as? UserActionButtonCell
            cell.configure(title: following ? "Unfollow".localized : "Follow".localized)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if !following {
                FriendSystem.instance.followUser(user!.uid)
                self.tableView.reloadData()
                following = true
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 96.0
        case 1:
            return 340.0
        default:
            return 44.0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight: CGFloat
        headerHeight = CGFloat.leastNonzeroMagnitude
        return headerHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let footerHeight: CGFloat
        footerHeight = 16.0
        return footerHeight
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section < 2 {
            return nil
        }
        return indexPath
    }
}
