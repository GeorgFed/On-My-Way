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
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var tableView: UITableView!

    var friends = [User]()
    var filteredUsers = [User]()
    var presentArray = [Present]()
    var chosen_user: User?
    var status: userStatus?
    var searchActive = false
    var currentText: String?
    override func viewWillAppear(_ animated: Bool) {
        searchBarAppearenceSetup()
        
        if let selectionIndexPath = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if !Reachability.isConnectedToNetwork() {
            tableView.setEmptyView(title: "No internet connection".localized, message: "", alertImage: .noInternet)
            return
        } else {
            tableView.restore()
        }
//        let colors: [UIColor] = [#colorLiteral(red: 0.3647058824, green: 0.5921568627, blue: 0.7568627451, alpha: 1), #colorLiteral(red: 0.4509803922, green: 0.6549019608, blue: 0.8588235294, alpha: 1)]
//        navigationController?.navigationBar.setGradientBackground(colors: colors)
        guard let uid = uid else { return }
        getFollows()
        FriendSystem.instance.addFollowsObserver(uid) {
            self.tableView.reloadData()
        }
        
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
        
        let recommendNavBtn = UIButton(type: .custom)
        recommendNavBtn.setImage(UIImage(named: "friend_recommendation"), for: .normal)
        recommendNavBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 24)
        recommendNavBtn.addTarget(self, action: #selector(showFriendRecommendations), for: .touchUpInside)
        let item = UIBarButtonItem(customView: recommendNavBtn)
        self.navigationItem.setRightBarButton(item, animated: true)
    }
    
    @objc func showFriendRecommendations() {
        self.performSegue(withIdentifier: "recommendationsSegue", sender: self)
    }
    
    func getFilteredUsers(forQuery _query: String) {
        guard let uid = uid else { return }
        FriendSystem.instance.findUsers(uid, forSearchQuery: _query) { (returnedUsers) in
            self.filteredUsers = returnedUsers
            self.tableView.reloadData()
        }
    }
    
    func getFollows() {
        FriendSystem.instance.addFollowsObserver(uid) {
            self.tableView.reloadData()
        }
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.resignFirstResponder()
    }
}

extension SearchVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentText = searchText
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
                if Reachability.isConnectedToNetwork() {
                    if currentText != nil && currentText != "" {
                        tableView.setEmptyView(title: "No search results for this query".localized, message: " ", alertImage: .noResults)
                    }
                }
            } else {
                tableView.restore()
            }
            return self.filteredUsers.count
        } else {
            if FriendSystem.instance.followsList.count == 0 {
                if Reachability.isConnectedToNetwork() {
                    tableView.setEmptyView(title: "No friends added yet".localized, message: "Find people by their name or in recommendations from your contacts list".localized, alertImage: .noFriends)
                }
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
            /*
            DispatchQueue.main.async {
                cell!.imageView!.loadImgWithURLString(urlString: url)
            }
            */
        } else {
            
            // TODO: CHECK BUG AFTER USER Delete
            cell!.textLabel?.text = FriendSystem.instance.followsList[FriendSystem.instance.followsList.index(FriendSystem.instance.followsList.startIndex, offsetBy: indexPath.row)].name
            url = FriendSystem.instance.followsList[FriendSystem.instance.followsList.index(FriendSystem.instance.followsList.startIndex, offsetBy: indexPath.row)].profileImgURL
            
            // TODO: profile image bug
            /*
            DispatchQueue.main.async {
                cell!.imageView!.loadImgWithURLString(urlString: url)
            }
             */
        }
        /*
        DispatchQueue.main.async {
            cell!.imageView!.loadImgWithURLString(urlString: url)
        }
        
        let cellImageLayer: CALayer?  = cell?.imageView!.layer
        cellImageLayer!.cornerRadius = 35
        cellImageLayer!.masksToBounds = true
        */
        cell?.selectionStyle = .default
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
        if segue.identifier == "newUserSegue" {
            let _UserVC = segue.destination as! UserVC
            _UserVC.user = chosen_user
        }
    }
}


// TODO: async / sync + dispatch threads to show images straight ahead
// TODO: clean up code, clear funcs that are not used
// TODO: add right nav bar item "recommendations" -> show contacts friends
// TODO: check the bug when the wrong user is shown
