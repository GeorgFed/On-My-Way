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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: searchContoller setup
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Friends"
        self.searchController.searchBar.barStyle = .blackOpaque
        self.searchController.searchResultsUpdater = self
        
        UISearchBar.appearance().barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        UISearchBar.appearance().tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.definesPresentationContext = true
        self.navigationItem.searchController = searchController
        
        // MARK: Delegate setup
        tableView.delegate = self
        tableView.dataSource = self
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
        if searchText == nil {
            get_users(forQuery: self.init_query)
            return
        }
        
        if searchText!.isAlphanumeric { self.init_query = searchText! }
        else { self.init_query = " " }
        
        get_users(forQuery: self.init_query)
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    // MARK: UITableViewDelegate, UITableViewDataSource
    // TODO: EDIT APPEANCE, ADD PHOTOS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "user_cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "user_cell")
        }
        cell!.textLabel?.text = self.users[indexPath.row].name
        cell!.detailTextLabel?.text = String(self.users[indexPath.row].birthdate.prefix(6)) // String(str[..<index])
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
