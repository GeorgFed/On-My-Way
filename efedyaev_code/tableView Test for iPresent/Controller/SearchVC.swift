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
        super.viewWillAppear(animated)
        searchBarAppearenceSetup()
        if let selectionIndexPath = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        handleConnection()
        
        if !Reachability.isConnectedToNetwork() {
            tableView.setEmptyView(title: "No internet connection".localized, message: "", alertImage: .noInternet)
            return
        } else {
            tableView.restore()
        }
        
        guard let uid = uid else { return }
        getFollows()
        FriendSystem.instance.addFollowsObserver(uid) {
            self.tableView.reloadData()
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func searchBarAppearenceSetup() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = #colorLiteral(red: 0.4509803922, green: 0.6549019608, blue: 0.8588235294, alpha: 1)
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
            self.searchController.obscuresBackgroundDuringPresentation = false
            let scb = self.searchController.searchBar
            let searchField = scb.searchTextField
            UITextField.appearance(whenContainedInInstancesOf: [type(of: searchController.searchBar)]).tintColor = .darkGray
            searchField.backgroundColor = .white
            scb.tintColor = UIColor.white
            scb.barTintColor = UIColor.darkGray
            searchController.searchResultsUpdater = self
            scb.isTranslucent = false
            scb.delegate = self
            definesPresentationContext = true
            self.navigationItem.searchController = searchController
            scb.setClearButton(color: .lightGray)
            scb.setPlaceholderText(color: .lightGray)
            scb.setSearchImage(color: .lightGray)
            scb.setText(color: .black)
        } else {
            self.searchController.obscuresBackgroundDuringPresentation = false
            self.searchController.searchResultsUpdater = self
            let scb = self.searchController.searchBar
            // scb.setTextField(color: UIColor.white)
            scb.setText(color: UIColor.black)
            scb.setPlaceholderText(color: UIColor.lightGray)
            scb.setSearchImage(color: UIColor.lightGray)
            scb.tintColor = UIColor.white
            scb.barTintColor = UIColor.white
            scb.isTranslucent = false
            self.definesPresentationContext = true
            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = true
            scb.delegate = self
            
            if let textfield = scb.value(forKey: "searchField") as? UITextField {
                textfield.textColor = UIColor.darkGray
                textfield.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
                
            scb.isTranslucent = true
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
        }
        
        
        
        let recommendNavBtn = UIButton(type: .custom)
        // recommendNavBtn.setImage(UIImage(named: "friend_recommendation"), for: .normal)
        recommendNavBtn.setImage(UIImage(named: "Suggestions"), for: .normal)
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
    }
    
    func handleConnection() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkRestored), name: Notification.Name(ConnectionKeys.cellular), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(networkRestored), name: Notification.Name(ConnectionKeys.wifi), object: nil)
    }
    
    @objc func networkRestored() {
        print("Network restored")
        getFollows()
        tableView.reloadData()
        tableView.restore()
    }
}

extension SearchVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        tableView.backgroundColor = .white
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
            print("Search is active")
            print(indexPath.row)
            print(self.filteredUsers[indexPath.row].name)
            cell!.textLabel?.text = self.filteredUsers[indexPath.row].name
            url = self.filteredUsers[indexPath.row].profileImgURL
            /*
            DispatchQueue.main.async {
                cell!.imageView!.loadImgWithURLString(urlString: url)
            }
            */
        } else {
            // TODO: CHECK BUG AFTER USER Delete
            print("Search is inactive")
            print(indexPath.row)
        print(FriendSystem.instance.followsList[FriendSystem.instance.followsList.index(FriendSystem.instance.followsList.startIndex, offsetBy: indexPath.row)].name)
            
            print(FriendSystem.instance.followsList)
            
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
            print("chose user from search")
            print(indexPath.row)
            print(self.chosen_user)
        } else {
            self.chosen_user = FriendSystem.instance.followsList[FriendSystem.instance.followsList.index(FriendSystem.instance.followsList.startIndex, offsetBy: indexPath.row)]
            print("chose user from follows")
            print(indexPath.row)
            print(self.chosen_user)
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

extension UINavigationController {
   open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
   }
}

/*
extension UITabBarController {
   open override var childForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
}

extension UINavigationController {
   open override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
}
*/
// TODO: async / sync + dispatch threads to show images straight ahead
// TODO: clean up code, clear funcs that are not used
// TODO: add right nav bar item "recommendations" -> show contacts friends
// TODO: check the bug when the wrong user is shown
