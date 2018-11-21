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
    var users = [User]()
    var init_query = "."
    var presentArray = [Present]()
    var chosen_user: User?
    
    override func viewWillAppear(_ animated: Bool) {
        get_users(forQuery: init_query)
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
    
    // MARK: Additional Request for test
    func getPresents() {
        DataService.instance.getPresent(forUid: "666") { (returnedArray) in
            self.presentArray = returnedArray
        }
    }
    
    // MARK: DataService user request
    func get_users(forQuery _query: String) {
        DataService.instance.getName(forSearchQuery: _query) {
            ( returned_users ) in
            self.users = returned_users
            self.tableView.reloadData()
        }
    }
}

extension SearchVC: UISearchResultsUpdating {
    
    // MARK: UISearchBarDelegate
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchText.isAlphanumeric { self.init_query = searchText }
//        else { self.init_query = "." }
//
//        get_users(forQuery: self.init_query)
//    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        if searchText == nil {
            get_users(forQuery: self.init_query)
            return
        }
        
        if searchText!.isAlphanumeric { self.init_query = searchText!}
        else { self.init_query = "." }
        
        get_users(forQuery: self.init_query)
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "user_cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "user_cell")
        }
        
        cell!.textLabel?.text = self.users[indexPath.row].name
        cell!.detailTextLabel?.text = self.users[indexPath.row].birthdate
        
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

// MARK: .isAlphanumeric
extension String {
    public var isAlphanumeric: Bool {
        guard !isEmpty else {
            return false
        }
        let allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
        let characterSet = CharacterSet(charactersIn: allowed)
        guard rangeOfCharacter(from: characterSet.inverted) == nil else {
            return false
        }
        return true
    }
}
