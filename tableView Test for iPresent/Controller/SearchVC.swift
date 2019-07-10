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
    
    let searchController = UISearchController(searchResultsController: nil)
    let uid = Auth.auth().currentUser!.uid
    
    @IBOutlet weak var tableView: UITableView!

    var friends = [User]()
    var filteredUsers = [User]()
    var presentArray = [Present]()
    var chosen_user: User?
    var status: userStatus?
    var searchActive = false
    
    override func viewWillAppear(_ animated: Bool) {
        searchBarAppearenceSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFollows()
        FriendSystem.instance.addFollowsObserver(uid) {
            self.tableView.reloadData()
        }
        
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
    
    func getFilteredUsers(forQuery _query: String) {
        FriendSystem.instance.findUsers(uid, forSearchQuery: _query) { (returnedUsers) in
            self.filteredUsers = returnedUsers
            self.tableView.reloadData()
        }
    }
    
    func getFollows() {
        FriendSystem.instance.addFollowsObserver(uid) {
            self.tableView.reloadData()
        }
    }
}

extension SearchVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchBarAppearenceSetup()
        if searchActive {
            if self.filteredUsers.count == 0 {
                tableView.setEmptyView(title: "No search results for this query".localized, message: " ")
            } else {
                tableView.restore()
            }
            return self.filteredUsers.count
        } else {
            if FriendSystem.instance.followsList.count == 0 {
                tableView.setEmptyView(title: "You don't have any friends yet.".localized, message: "Your friends will be in here.".localized)
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
        var url: String!
        if searchActive {
            cell!.textLabel?.text = self.filteredUsers[indexPath.row].name
            url = self.filteredUsers[indexPath.row].profileImgURL
            DispatchQueue.main.async {
                cell!.imageView!.loadImgWithURLString(urlString: url)
            }
        } else {
            cell!.textLabel?.text = FriendSystem.instance.followsList[FriendSystem.instance.followsList.index(FriendSystem.instance.followsList.startIndex, offsetBy: indexPath.row)].name
            url = FriendSystem.instance.followsList[FriendSystem.instance.followsList.index(FriendSystem.instance.followsList.startIndex, offsetBy: indexPath.row)].profileImgURL
            DispatchQueue.main.async {
                cell!.imageView!.loadImgWithURLString(urlString: url)
            }
        }
        
        DispatchQueue.main.async {
            cell!.imageView!.loadImgWithURLString(urlString: url)
        }
        
        let cellImageLayer: CALayer?  = cell?.imageView!.layer
        cellImageLayer!.cornerRadius = 35
        cellImageLayer!.masksToBounds = true
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchActive {
            self.chosen_user = self.filteredUsers[indexPath.row]
        } else {
            self.chosen_user = FriendSystem.instance.followsList[FriendSystem.instance.followsList.index(FriendSystem.instance.followsList.startIndex, offsetBy: indexPath.row)]
        }
        self.performSegue(withIdentifier: "newUserSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let _UserVC = segue.destination as! UserVC
        _UserVC.user = chosen_user
    }
}


// TODO: async / sync + dispatch threads to show images straight ahead
// TODO: clean up code, clear funcs that are not used
// TODO: add right nav bar item "recommendations" -> show contacts friends
// TODO: check the bug when the wrong user is shown
