//
//  searchVC.swift
//  tableView Test for iPresent
//
//  Created by Georg on 09.10.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    // MARK: Outlets
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tableView: UITableView!

    // Variables
    var phoneNumbers = [String]()
    var users = [User]()
    var init_query = " "
    var presentArray = [Present]()
    var chosen_user: User?
    
    override func viewWillAppear(_ animated: Bool) {
        //get_users(forQuery: init_query)
        getUsersWithPhoneNumbers(query: phoneNumbers)
        searchBarAppearenceSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    // MARK: All users??
    func get_users(forQuery _query: String) {
        DataService.instance.getUsersByName(forSearchQuery: _query) { (returned_users) in
            self.users = returned_users
            self.tableView.reloadData()
        }
    }
    
    func getUsersWithPhoneNumbers(query: [String]) {
        DataService.instance.getUsersByPhoneNumber(phoneNumbers: query) { (returnedUsers) in
            self.users = returnedUsers
            self.tableView.reloadData()
        }
    }
}

extension SearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        if searchText!.isAlphanumeric { self.init_query = searchText! }
        get_users(forQuery: self.init_query)
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    // MARK: UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchBarAppearenceSetup()
        if self.users.count == 0 {
            tableView.setEmptyView(title: "You don't have any friends yet.", message: "Your friends will be in here.")
        } else {
            tableView.restore()
        }
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "user_cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "user_cell")
        }
        cell!.textLabel?.text = self.users[indexPath.row].name
        let url = self.users[indexPath.row].profileImgURL
        cell!.imageView?.loadImgWithURLString(urlString: url)
        if cell!.imageView != nil {
            let cellImageLayer: CALayer?  = cell?.imageView!.layer
            cellImageLayer!.cornerRadius = 35
            cellImageLayer!.masksToBounds = true

        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chosen_user = self.users[indexPath.row]
        self.performSegue(withIdentifier: "user_info_segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let _userInfoVC = segue.destination as! UserInfoVC
        _userInfoVC.user = chosen_user
    }
}
