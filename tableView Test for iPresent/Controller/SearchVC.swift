//
//  searchVC.swift
//  tableView Test for iPresent
//
//  Created by Georg on 09.10.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit
import Firebase


class SearchVC: UIViewController {
    // MARK: Outlets
    let searchController = UISearchController(searchResultsController: nil)
    let uid = Auth.auth().currentUser?.uid
    @IBOutlet weak var tableView: UITableView!

    // Variables
    var friends = [User]()
    var filteredUsers = [User]()
    // var allUsers = [User]()
    var presentArray = [Present]()
    var chosen_user: User?
    var status: userStatus?
    var searchActive = false
    
    override func viewWillAppear(_ animated: Bool) {
        searchBarAppearenceSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // getFriends()
        getFollows()
        FriendSystem.instance.addFollowsObserver {
            self.tableView.reloadData()
        }
        // MARK: Delegate setup
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func searchBarAppearenceSetup() {
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
        
        let scb = self.searchController.searchBar
        scb.setTextField(color: UIColor.white)
        scb.setText(color: UIColor.black)
        scb.setPlaceholderText(color: UIColor.lightGray)
        scb.setSearchImage(color: UIColor.lightGray)
        scb.tintColor = UIColor.white
        scb.barTintColor = UIColor.white
        
        scb.searchBarStyle = .default
        self.definesPresentationContext = true
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
        scb.delegate = self
    }
    

    
    // MARK: All users??
    func getFilteredUsers(forQuery _query: String) {
//        DataService.instance.getUsersByName(forSearchQuery: _query, allUsers: all) { (returned_users) in
//            self.users = returned_users
//            self.tableView.reloadData()
//        }
        FriendSystem.instance.findUsers(forSearchQuery: _query) { (returned_users) in
            self.filteredUsers = returned_users
            print(returned_users)
            self.tableView.reloadData()
        }
        print("filtered: \(filteredUsers)")
    }
    
    func getAllUsers() {
        FriendSystem.instance.addUserObserver {
            self.tableView.reloadData()
        }
    }
    
    func getFriends() {
        FriendSystem.instance.addFriendObserver {
           self.tableView.reloadData()
        }
        print(friends)
    }
    
    func getFollows() {
        FriendSystem.instance.addFollowsObserver {
            self.tableView.reloadData()
        }
    }
}

extension SearchVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
//        let searchText = searchController.searchBar.text
//        if searchText != "" {
//            getFilteredUsers(forQuery: searchText!)
//        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        getFilteredUsers(forQuery: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    // MARK: UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchBarAppearenceSetup()
        if searchActive {
            if self.filteredUsers.count == 0 {
                tableView.setEmptyView(title: "No search results for this query", message: " ")
            } else {
                tableView.restore()
            }
            return self.filteredUsers.count
        } else {
            /*
            if FriendSystem.instance.friendList.count == 0 {
                tableView.setEmptyView(title: "You don't have any friends yet.", message: "Your friends will be in here.")
            } else {
                tableView.restore()
            }
            return FriendSystem.instance.friendList.count
             */
            if FriendSystem.instance.followsList.count == 0 {
                tableView.setEmptyView(title: "You don't have any friends yet.", message: "Your friends will be in here.")
            } else {
                tableView.restore()
            }
            return FriendSystem.instance.followsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "user_cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "user_cell")
        }
        if searchActive {
            cell!.textLabel?.text = self.filteredUsers[indexPath.row].name
            let url = self.filteredUsers[indexPath.row].profileImgURL
            cell!.imageView?.loadImgWithURLString(urlString: url)
        } else {
            /*
            cell!.textLabel?.text = FriendSystem.instance.friendList[indexPath.row].name
            let url = FriendSystem.instance.friendList[indexPath.row].profileImgURL
            cell!.imageView?.loadImgWithURLString(urlString: url)
             */
            cell!.textLabel?.text = FriendSystem.instance.followsList[FriendSystem.instance.followsList.index(FriendSystem.instance.followsList.startIndex, offsetBy: indexPath.row)].name
            let url = FriendSystem.instance.followsList[FriendSystem.instance.followsList.index(FriendSystem.instance.followsList.startIndex, offsetBy: indexPath.row)].profileImgURL
            cell!.imageView?.loadImgWithURLString(urlString: url)
        }
        
        if cell!.imageView != nil {
            let cellImageLayer: CALayer?  = cell?.imageView!.layer
            cellImageLayer!.cornerRadius = 35
            cellImageLayer!.masksToBounds = true

        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchActive {
            self.chosen_user = self.filteredUsers[indexPath.row]
        } else {
            // self.chosen_user = FriendSystem.instance.friendList[indexPath.row]
            self.chosen_user = FriendSystem.instance.followsList[FriendSystem.instance.followsList.index(FriendSystem.instance.followsList.startIndex, offsetBy: indexPath.row)]
        }
        // newUserSegue
        // self.performSegue(withIdentifier: "user_info_segue", sender: self)
        self.performSegue(withIdentifier: "newUserSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let _userInfoVC = segue.destination as! UserInfoVC
//        _userInfoVC.user = chosen_user
        let _UserVC = segue.destination as! UserVC
        _UserVC.user = chosen_user
    }
}
